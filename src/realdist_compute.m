function min_dist = realdist_compute(x,y)
global map 
%%%%%找到轮廓点
[i1,j1] = find (1 == map);
[i5,j5] = find (5 == map);
i=[i1;i5];
j=[j1;j5];

len_i = length(i);
temp_dist = zeros(1,len_i);
%%%%%%计算距离
for c1 = 1:len_i
    temp_dist(c1) = sqrt((i(c1)-x).^2+(j(c1)-y).^2);
end
%%%%%将最小距离视为UUV与轮廓距离
    min_dist = min(temp_dist);  
