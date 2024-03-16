function [obs_out] = baye_c(x,y,x_obs_in,y_obs_in)
%%%%%%%%%%%%%%%%%%%%%%ģ�����Ų�ȷ���ԣ���̽�����Χ���ɿ���������%%%%%%
%%%%%%%%%%%%%%%
%%% x,y ����
%%% x_obs_in,y_obs_in �ϰ�������
%%%%%%%%%%%%%%%
global max__probe_distance
obs_out = [];
len_obs = length(x_obs_in);

dtP = 2;  %���
p_occ = 0.9; %����
beam_range = max__probe_distance; %�������̽��
beam_width_2 = .5; %���������һ��

for kk=1:len_obs
Ps = sqrt((x_obs_in(kk) - x).^2 + (y_obs_in(kk) - y).^2);  %̽������
beam_theta =  atan2d((y_obs_in(kk) - y), (x_obs_in(kk)- x));  %̽���Ƕ�
angle_range_ub = beam_theta + beam_width_2; %����������ֵ
angle_range_lb = beam_theta - beam_width_2; %����������ֵ
%%
i_lb = x_obs_in(kk) - dtP-.3;
i_ub = x_obs_in(kk) + dtP-.3;
j_lb = y_obs_in(kk) - dtP-.3;
j_ub = y_obs_in(kk) + dtP-.3;
if i_lb > i_ub
    temp = i_lb;
    i_lb = i_ub;
    i_ub = temp;
end
if j_lb > j_ub
    temp = j_lb;
    j_lb = j_ub;
    j_ub = temp;
end
ran1 = unifrnd(.35,.5);

for i = i_lb:ran1:i_ub
    ran2 = unifrnd(.35,.5);
    for j = j_lb:ran2:j_ub
        x_r = i   ;
        y_r = j   ;
%         x_r = x_uuv + x;
%         y_r = y_uuv + y;
         % ����դ�����ĵ㵽ԭ��ľ���ͽǶ�
        distance = sqrt((x_r - x)^2 + (y_r - y)^2); %�������
        angle = atan2d((y_r - y), (x_r - x)); %����Ƕ�

          if (angle >= angle_range_lb && angle <= angle_range_ub && distance <= beam_range)
                if ( distance > Ps - dtP && distance < Ps + dtP)        %2��
                   obs_out = [obs_out;[x_r,y_r]];
                end
          end
          
   end
end
end