function coordinates = reverse_Rasterize(x,y)
%%%%%%%%%%%%%%%%%%%
% դ��ת�������ϵ
%��x��y��դ������
%%%%%%%%%%%%%%%%%%
global map map_center %��ͼ����  ��ͼ����
M = size(map,1);
N = size(map,2);
a=[x-(M+1)/2;y-( N+1)/2;];
coordinates = floor(map_center) + [x-(M+1)/2;y-( N+1)/2;]; 
