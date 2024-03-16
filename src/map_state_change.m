function map_state_change(x,y,flag1,flag2) %索引值
%%%%%%%%%%地图指定位置置位%%%%%%
global map

temp1 = [];
temp2 = [];
temp3 = [];
temp4 = [];
temp5 = [];
temp6 = [];

len_x = length(x);
if 0 ~= len_x   %若不为0，将（x,y）位置为指定标志
    
    for i = 1: len_x
        map(x(i),y(i)) = flag1;
    end
    
else            %若为0，将指定位置置为指定标志
    
    [i1,j1] = find(flag1 == map);%栅格地图障碍物 索引值
    n = length(j1);
    for i = 1:n %地图赋值
        map(i1(i),j1(i)) = flag2;
    end
end
end