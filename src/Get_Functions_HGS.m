function fobj = Get_Functions_HGS(F)

switch F
    case 'F1'
        fobj = @F1;
end

end

% F1
%%%%%%%%%%%%%%%%%%%%%%%%%%%适应度函数%%%%%%%%%%%%%%%%%%%
function o = F1(x)
%x 1-5 长度 ；6-10 航向角
global R_path_piont R_path_piont_heading map  Reference_point flag_predict%全局向量声明

[r_path_piont,~] = Rasterize_1(R_path_piont(1),R_path_piont(2),1,0); 
d_exp = 10; % 期望距离
R = 9; % 回转半径
% alpha = pi/5; %36°
alpha = 0.5419; %22°
len = size(x,2)/2;
% alpha = 0.2; %11.4592° 5m

%%%%%%%%%%%%%%%%%%%%%%%%%
% 解算‘路径点’栅格化的坐标
for c1=1:len
    if 1 == c1
        next_path_x(c1) = r_path_piont(1)+x(1)*cos(x(c1+len)); %x2=x1+lcos(theta)
        next_path_y(c1) = r_path_piont(2)+x(1)*sin(x(c1+len)); %y2=y1+lsin(theta)
    else
        next_path_x(c1) = next_path_x(c1-1)+x(c1)*cos(x(c1+len));
        next_path_y(c1) = next_path_y(c1-1)+x(c1)*sin(x(c1+len)); 
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 解算 ‘采样点’ 栅格坐标 每两个路径点间采样均匀3个点

for c5=1:len
    if 1 == c5
    	sampling_point_1x(c5) = (next_path_x(c5)+r_path_piont(1))/2;
        sampling_point_1y(c5) = (next_path_y(c5)+r_path_piont(2))/2;
    else
        sampling_point_1x(c5) = (next_path_x(c5)+next_path_x(c5-1))/2;
        sampling_point_1y(c5) = (next_path_y(c5)+next_path_y(c5-1))/2;
    end
end

for c6=1:len
    if 1 == c6
    	sampling_point_2x(c6) = (sampling_point_1x(c6)+r_path_piont(1))/2;
        sampling_point_2y(c6) = (sampling_point_1y(c6)+r_path_piont(2))/2;
    else
        sampling_point_2x(c6) = (sampling_point_1x(c6)+next_path_x(c6-1))/2;
        sampling_point_2y(c6) = (sampling_point_1y(c6)+next_path_y(c6-1))/2;
    end
end

for c7=1:len
        sampling_point_3x(c7) = (sampling_point_1x(c7)+next_path_x(c7))/2;
        sampling_point_3y(c7) = (sampling_point_1y(c7)+next_path_y(c7))/2;
end
sampling_point_x = [sampling_point_1x sampling_point_2x sampling_point_3x];
sampling_point_y = [sampling_point_1y sampling_point_2y sampling_point_3y];
len_sample = length(sampling_point_y);

if flag_predict == 0
    [i,j] = find(map==1);%栅格地图障碍物 索引值
else
    [i,j] = find(map==5);
end
n = size(i,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%解算路径点到每个障碍栅格的距离 
s = struct;
s.dist1 = []; s.dist2 = []; s.dist3 = []; s.dist4 = [];
s.dist5 = []; s.dist6 = []; s.dist7 = []; s.dist8 = [];
fileds = fieldnames(s);
for c2=1:len
    s.(fileds{c2}) = sqrt((next_path_x(c2)-i).^2+(next_path_y(c2)-j).^2);
end

for c3=1:len
    min_dist(c3) = min(s.(fileds{c3}));  
end

theata = 10; % 
obj1 = (1*exp(-(min_dist-d_exp).^2./(2.*theata.^2))) .* [1.5 0.85 0.85 0.85]; %各点所占的权重
o1 = sum(obj1);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%解算采样点与障碍的距离
sample = struct;
sample.dist1 = []; sample.dist2 = []; sample.dist3 = []; sample.dist4 = [];
sample.dist5 = []; sample.dist6 = []; sample.dist7 = []; sample.dist8 = [];
sample.dist9 = []; sample.dist10 = []; sample.dist11 = []; sample.dist12 = [];
sample.dist13 = []; sample.dist14 = []; sample.dist15 = []; sample.dist16 = [];
fileds = fieldnames(sample);
for c8=1:len_sample
    sample.(fileds{c8}) = sqrt((sampling_point_x(c8)-i).^2+(sampling_point_y(c8)-j).^2);
end

for c9=1:len_sample
    if flag_predict == 0
    min_dist(c9) = min(sample.(fileds{c9})); 
    else
    min_dist(c9) = min(sample.(fileds{c9})); 
    end
end

idx_sample_point = find(min_dist>(d_exp-1));
obj4(idx_sample_point) = 1;
o4 = sum(obj4);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%解算两段路径的航向角差值 
% if 0 == flag_predict
for c4=1:len
    if 1 == c4
        delta_theta(c4) = abs(x(len+c4)-R_path_piont_heading); 
    else
        delta_theta(c4) = abs(x(len+c4)-x(len+c4-1)); 
    end
    
end

for jj=1:len
    if delta_theta(jj) > pi
       delta_theta(jj) = 2*pi - delta_theta(jj);
    end
end

for ii=1:len
    if  0<=delta_theta(ii) && delta_theta(ii)<=alpha
        obj2(ii) = 1;
    else
        obj2(ii) = -5;    
    end
end

o2 = sum(obj2);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%参考点与路径点距离  共1个
% theata_o3 = 15; % 调节直角时，10->15
% dist_pathend_obstacle_end = sqrt(( next_path_x(end) - Reference_point(1) ).^2+( next_path_y(end) - Reference_point(2) ).^2);
% obj3 = 1*exp(-(dist_pathend_obstacle_end-d_exp).^2./(2.*theata_o3.^2));
% o3 = sum(obj3);
obj3 = 0;
%路径点是否在安全的区域（声呐已经探测并确定为无障碍物区域）
[xxx,yyy] = find(2 == map);
exist2 = [];
for index=1:length(next_path_x)
    exist1 = find(abs(next_path_x(index) - xxx)<=1);
    if 0 == isempty(exist1)
        exist2 = find(abs(next_path_y(index) - yyy(exist1))<=1);
    end
    if 0 == isempty(exist2)
        obj3(index) = 1;
    else
        obj3(index) = -5;
    end
end
o3 = sum(obj3);

%%%目标函数 *距离   *航向角变化   *参考点（最远障碍）距离    *避碰 
w1=7;    
w2=18;%14
if 1==flag_predict
w3=0; %
else
w3=14; %
end
w4=20;%20

% obj = w1*o1+w2*o2+w3*o3*(~flag_predict)+w4*o4;
obj = w1*o1+w2*o2+w3*o3+w4*o4;
o = -obj;

end