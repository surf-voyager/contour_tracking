function map_updata_1(new_center_x,new_center_y) %新的中心坐标
%%%%%%%%%栅格地图移动%%%%%%%%%%%%%
global map map_center
M = size(map,1);
N = size(map,2);

[idx,~] = Rasterize_1(new_center_x,new_center_y,1,0); %栅格地图中心的行 列索引值
p = idx(1);%栅格地图中心的行 索引值
q = idx(2);%栅格地图中心的列 索引值

[i1,j1] = find(1 == map);%栅格地图障碍物 索引值
[i2,j2] = find(2 == map);%栅格地图障碍物 索引值
[i3,j3] = find(3 == map);%栅格地图障碍物 索引值
[i4,j4] = find(4 == map);%栅格地图障碍物 索引值
[i5,j5] = find(5 == map);%栅格地图障碍物 索引值
[i6,j6] = find(6 == map);%栅格地图障碍物 索引值

ni1 = i1-(p-(M+1)/2); %旧到新的索引值
nj1 = j1-(q-(N+1)/2); %旧到新的索引值

ni2 = i2-(p-(M+1)/2); %旧到新的索引值
nj2 = j2-(q-(N+1)/2); %旧到新的索引值

ni3 = i3-(p-(M+1)/2); %旧到新的索引值
nj3 = j3-(q-(N+1)/2); %旧到新的索引值

ni4 = i4-(p-(M+1)/2); %旧到新的索引值
nj4 = j4-(q-(N+1)/2); %旧到新的索引值

ni5 = i5-(p-(M+1)/2); %旧到新的索引值
nj5 = j5-(q-(N+1)/2); %旧到新的索引值

ni6 = i6-(p-(M+1)/2); %旧到新的索引值
nj6 = j6-(q-(N+1)/2); %旧到新的索引值

n1 = length(nj1);
n2 = length(nj2);
n3 = length(nj3);
n4 = length(nj4);
n5 = length(nj5);
n6 = length(nj6);

map(:,:) = 0;%地图清空

for i = 1:n1 %地图赋值
    if (1<=ni1(i) && ni1(i)<= M) && (1<=nj1(i) && nj1(i)<=M) %判断属于新的栅格地图上
        map(ni1(i),nj1(i)) = 1;
    end
end

for i = 1:n2 %地图赋值
    if (1<=ni2(i) && ni2(i)<= M) && (1<=nj2(i) && nj2(i)<=M) %判断属于新的栅格地图上
        map(ni2(i),nj2(i)) = 2;
    end
end

for i = 1:n3 %地图赋值
    if (1<=ni3(i) && ni3(i)<= M) && (1<=nj3(i) && nj3(i)<=M) %判断属于新的栅格地图上
        map(ni3(i),nj3(i)) = 3;
    end
end

for i = 1:n4 %地图赋值
    if (1<=ni4(i) && ni4(i)<= M) && (1<=nj4(i) && nj4(i)<=M) %判断属于新的栅格地图上
        map(ni4(i),nj4(i)) = 4;
    end
end

for i = 1:n5 %地图赋值
    if (1<=ni5(i) && ni5(i)<= M) && (1<=nj5(i) && nj5(i)<=M) %判断属于新的栅格地图上
        map(ni5(i),nj5(i)) = 5;
    end
end

for i = 1:n6 %地图赋值
    if (1<=ni6(i) && ni6(i)<= M) && (1<=nj6(i) && nj6(i)<=M) %判断属于新的栅格地图上
        map(ni6(i),nj6(i)) = 6;
    end
end

map_center = [new_center_x;new_center_y];

end