function map_state_change(x,y,flag1,flag2) %����ֵ
%%%%%%%%%%��ͼָ��λ����λ%%%%%%
global map

temp1 = [];
temp2 = [];
temp3 = [];
temp4 = [];
temp5 = [];
temp6 = [];

len_x = length(x);
if 0 ~= len_x   %����Ϊ0������x,y��λ��Ϊָ����־
    
    for i = 1: len_x
        map(x(i),y(i)) = flag1;
    end
    
else            %��Ϊ0����ָ��λ����Ϊָ����־
    
    [i1,j1] = find(flag1 == map);%դ���ͼ�ϰ��� ����ֵ
    n = length(j1);
    for i = 1:n %��ͼ��ֵ
        map(i1(i),j1(i)) = flag2;
    end
end
end