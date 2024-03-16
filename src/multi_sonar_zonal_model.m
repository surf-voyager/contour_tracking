function [pp] = multi_sonar_zonal_model(Ps,theta,f1,x_uuv,y_uuv,h_uuv)
global map
%
% beam_theta      %̽���Ƕ�  
% Ps              %̽������  
% pp              %log(miss_occupation/miss_empty)  log(hit_occupation/hit_empty)
[map_width,map_height]= size(map);

beam_theta = h_uuv + theta; %�������ϵ�µ�̽���
if beam_theta > pi
    beam_theta = beam_theta - 2*pi;
elseif beam_theta < -pi
    beam_theta = beam_theta + 2*pi;
end
%% ��ʼ����ͼ
cell_size = 1;
p = zeros(map_width,map_height);
pp = zeros(map_width,map_height);

%% �趨��ʼ��ռ�С�ռ�к�δ֪״̬�ĳ�ʼ�����̶�
p_occ = 0.9;  % ռ��״̬�ĳ�ʼ����
p_free = 0.2;  % ��ռ��״̬�ĳ�ʼ����
p_unknown = 0.5;  % δ֪״̬�ĳ�ʼ����

%% �������һ����������������
dtP = 2;                %������
beam_range = 60;        %�������̽�����  ��ֵ
beam_width_2 = .5;      %���������ǵ�һ��

i_lb = -x_uuv ;
i_ub =  map_width - x_uuv;
j_lb = -y_uuv;
j_ub =  map_height - y_uuv;
angle_range_ub = beam_theta + beam_width_2;
angle_range_lb = beam_theta - beam_width_2;
%% ���ɵ����������ڵ�դ���ͼ
% ����ÿ��դ���ռ�и���

for i = i_lb:.3:i_ub
    for j = j_lb:.3:j_ub

        x = j * cell_size ;
        y = i * cell_size ;
        x_r = x_uuv + x;
        y_r = y_uuv + y;
         % ����դ�����ĵ㵽ԭ��ľ���ͽǶ�
        distance = sqrt(x^2 + y^2);
        angle = atan2d(y, x);      

          if (angle >= angle_range_lb && angle <= angle_range_ub && distance <= beam_range)
              if 1 ==f1
                if ( distance > Ps - dtP && distance < Ps + dtP)        %2��
                    p(ceil(x_r),ceil(y_r)) = (1 - 0.5*(((abs(distance - Ps))/dtP) * ((abs(angle - beam_theta)/beam_width_2))))*p_occ;
                    pp(ceil(x_r),ceil(y_r)) =log( p(ceil(x_r),ceil(y_r))/(1-p(ceil(x_r),ceil(y_r))));
                elseif(0 <= distance && distance <= Ps - dtP)           %1��
                    p(ceil(x_r),ceil(y_r)) = p_free;
                    pp(ceil(x_r),ceil(y_r)) = log( p(ceil(x_r),ceil(y_r))/(1-p(ceil(x_r),ceil(y_r))));
                elseif(distance >= Ps + dtP && distance < beam_range)  %3��
                    p(ceil(x_r),ceil(y_r)) = p_unknown;
                    pp(ceil(x_r),ceil(y_r)) = log( p(ceil(x_r),ceil(y_r))/(1-p(ceil(x_r),ceil(y_r))));
                end
              else
                  p(ceil(x_r),ceil(y_r)) = p_free;
                  pp(ceil(x_r),ceil(y_r)) = log( p(ceil(x_r),ceil(y_r))/(1-p(ceil(x_r),ceil(y_r))));   
              end
         end
   end
end

% %% ��ʾդ���ͼ����ռ�и���
% inn = 0;
% if 1 == inn
if 1
figure(5);
mappp = 1-1./(1+exp(pp'));
pcolor(mappp);
% surf(mappp);
colormap(othercolor('BuGy_8')); 
colorbar;
end
% xlabel('����X���ף�');
% ylabel('����Y���ף�');
% zlabel('ռ�ø���');

end