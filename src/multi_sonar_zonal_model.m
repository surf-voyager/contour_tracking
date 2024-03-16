function [pp] = multi_sonar_zonal_model(Ps,theta,f1,x_uuv,y_uuv,h_uuv)
global map
%
% beam_theta      %探测点角度  
% Ps              %探测点距离  
% pp              %log(miss_occupation/miss_empty)  log(hit_occupation/hit_empty)
[map_width,map_height]= size(map);

beam_theta = h_uuv + theta; %大地坐标系下的探测角
if beam_theta > pi
    beam_theta = beam_theta - 2*pi;
elseif beam_theta < -pi
    beam_theta = beam_theta + 2*pi;
end
%% 初始化地图
cell_size = 1;
p = zeros(map_width,map_height);
pp = zeros(map_width,map_height);

%% 设定初始非占有、占有和未知状态的初始度量程度
p_occ = 0.9;  % 占有状态的初始概率
p_free = 0.2;  % 非占有状态的初始概率
p_unknown = 0.5;  % 未知状态的初始概率

%% 随机生成一个单波束覆盖区域
dtP = 2;                %误差估计
beam_range = 60;        %声呐最大探测距离  定值
beam_width_2 = .5;      %单波束开角的一半

i_lb = -x_uuv ;
i_ub =  map_width - x_uuv;
j_lb = -y_uuv;
j_ub =  map_height - y_uuv;
angle_range_ub = beam_theta + beam_width_2;
angle_range_lb = beam_theta - beam_width_2;
%% 生成单波束区域内的栅格地图
% 计算每个栅格的占有概率

for i = i_lb:.3:i_ub
    for j = j_lb:.3:j_ub

        x = j * cell_size ;
        y = i * cell_size ;
        x_r = x_uuv + x;
        y_r = y_uuv + y;
         % 计算栅格中心点到原点的距离和角度
        distance = sqrt(x^2 + y^2);
        angle = atan2d(y, x);      

          if (angle >= angle_range_lb && angle <= angle_range_ub && distance <= beam_range)
              if 1 ==f1
                if ( distance > Ps - dtP && distance < Ps + dtP)        %2区
                    p(ceil(x_r),ceil(y_r)) = (1 - 0.5*(((abs(distance - Ps))/dtP) * ((abs(angle - beam_theta)/beam_width_2))))*p_occ;
                    pp(ceil(x_r),ceil(y_r)) =log( p(ceil(x_r),ceil(y_r))/(1-p(ceil(x_r),ceil(y_r))));
                elseif(0 <= distance && distance <= Ps - dtP)           %1区
                    p(ceil(x_r),ceil(y_r)) = p_free;
                    pp(ceil(x_r),ceil(y_r)) = log( p(ceil(x_r),ceil(y_r))/(1-p(ceil(x_r),ceil(y_r))));
                elseif(distance >= Ps + dtP && distance < beam_range)  %3区
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

% %% 显示栅格地图及其占有概率
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
% xlabel('北向X（米）');
% ylabel('东向Y（米）');
% zlabel('占用概率');

end