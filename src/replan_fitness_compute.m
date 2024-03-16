function [sequence] = replan_fitness_compute(last_path_point,all_plan_points_heading) 
%% 构造虚拟路径点，计算是否重规划
global map
a1 = 10;            %%路径段长度
count1 = 4;         %%4段
count2 = size(last_path_point,2) / 2;
d_exp = 10;         %%期望距离
alpha = 0.5419;     %%最大回转角
flag = 0;           %查找标志，找到置1
k = 0;              %计数变量

%%%%找到地图中的轮廓点%%
[i1,j1] = find (1 == map);
[i5,j5] = find (5 == map);

i=[i1;i5];
j=[j1;j5];
%%%%%%%%%%%%
for c4 = 1:count2  %评价每个路径点

[r_path_piont,~] = Rasterize_1(last_path_point(end-(c4*2-1)),last_path_point(end-(c4*2-2)),1,0); %%进行评价的路径点的栅格坐标
for c1=1:count1 %构造虚拟路径点
    if 1 == c1
        next_path_x(c1) = r_path_piont(1)+a1*cos(alpha+all_plan_points_heading(count2-c4+1)); %x2=x1+lcos(theta)
        next_path_y(c1) = r_path_piont(2)+a1*sin(alpha+all_plan_points_heading(count2-c4+1)); %y2=y1+lsin(theta)
    else
        next_path_x(c1) = next_path_x(c1-1)+a1*cos(c1*alpha+all_plan_points_heading(count2-c4+1));
        next_path_y(c1) = next_path_y(c1-1)+a1*sin(c1*alpha+all_plan_points_heading(count2-c4+1)); 
    end
    
end
%%%%%%%%%%计算虚拟路径点与轮廓距离
s = struct;
s.dist1 = []; s.dist2 = []; s.dist3 = []; s.dist4 = [];
s.dist5 = []; s.dist6 = []; s.dist7 = []; s.dist8 = [];
fileds = fieldnames(s);
for c2=1:count1 %%%计算
    s.(fileds{c2}) = sqrt((next_path_x(c2)-i).^2+(next_path_y(c2)-j).^2);
end

for c3=1:count1  %%找最小
    min_dist_path(c3) = min(s.(fileds{c3}));  
end
%%%%%%%%%%%%%%

%%%%% 解算 ‘采样点’ 栅格坐标， 每两个路径点间采样均匀3个点
for c5=1:count1
    if 1 == c5
    	sampling_point_1x(c5) = (next_path_x(c5)+r_path_piont(1))/2;
        sampling_point_1y(c5) = (next_path_y(c5)+r_path_piont(2))/2;
    else
        sampling_point_1x(c5) = (next_path_x(c5)+next_path_x(c5-1))/2;
        sampling_point_1y(c5) = (next_path_y(c5)+next_path_y(c5-1))/2;
    end
end

for c6=1:count1
    if 1 == c6
    	sampling_point_2x(c6) = (sampling_point_1x(c6)+r_path_piont(1))/2;
        sampling_point_2y(c6) = (sampling_point_1y(c6)+r_path_piont(2))/2;
    else
        sampling_point_2x(c6) = (sampling_point_1x(c6)+next_path_x(c6-1))/2;
        sampling_point_2y(c6) = (sampling_point_1y(c6)+next_path_y(c6-1))/2;
    end
end

for c7=1:count1
        sampling_point_3x(c7) = (sampling_point_1x(c7)+next_path_x(c7))/2;
        sampling_point_3y(c7) = (sampling_point_1y(c7)+next_path_y(c7))/2;
end
sampling_point_x = [sampling_point_1x sampling_point_2x sampling_point_3x];
sampling_point_y = [sampling_point_1y sampling_point_2y sampling_point_3y];
len_sample = length(sampling_point_y);
%%%%%

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
    min_dist_sample(c9) = min(sample.(fileds{c9})); 
end

if min_dist_path > d_exp %%判断路径点是否安全，安全就退出
    if min_dist_sample > d_exp-1
        flag = 1;
        break;
    end
else
    
    k=k+1;
end

end

if  1 == flag
    sequence = count2 + 1 -c4;
else
    sequence = 0;
end

end