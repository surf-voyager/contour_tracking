function [Idx,new_o_point]= Rasterize_1(x,y,flag1,flag2,flag3) % x =1*n y =1*n 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%�������ת��Ϊդ������
%%%%(x,y)��ת�����꣬flag1 �Ƿ񴫻������꣬flag2 �Ƿ񽫶�Ӧդ��������λ, flag3 bayes�������
%%%%Idx դ������ֵ,new_o_pointդ���ͼ����������������
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global map map_center 

new_o_point = 0;
temp_new_o_point = 0;

M = size(map,1);
N = size(map,2);
n = size(x,2);
Idx = [];
%��������ֵ Lg=1ʡ��δд
idx = [floor(x);floor(y)] - floor(map_center) + [(M+1)/2;( N+1)/2;]; %idx=2*n example[1 2 3 4;2 3 4 5]��>(1,2) (2,3) (3,4) (4,5)

if 1==flag1 %��������ֵ
    Idx = idx;
end

switch flag2
    case 1

        for i = 1:n
            [~,new_o_point] = bayes11(idx(1,i),idx(2,i),flag3,[0 0 0]);
            temp_new_o_point = temp_new_o_point + new_o_point; 
        end
        new_o_point = temp_new_o_point;
            [map_o,~] = bayes11(-99999,-99999,[-99999 -99999 -99999],[-99999 -99999 -99999]);
            map = map_o ;
    %%%%%%%%

    case 2
        for i = 1:n
            map(idx(1,i),idx(2,i)) = 2;
        end  
        
    case 3
        for i = 1:n
            map(idx(1,i),idx(2,i)) = 3;
        end   
        
    case 4
        for i = 1:n
            map(idx(1,i),idx(2,i)) = 4;
        end      
        
    case 5
        for i = 1:n
            map(idx(1,i),idx(2,i)) = 5;
        end 
        
    case 6
        for i = 1:n
            map(idx(1,i),idx(2,i)) = 6;
        end  
     case 7
        for i = 1:n
            map(idx(1,i),idx(2,i)) = 7;
        end  
end

end