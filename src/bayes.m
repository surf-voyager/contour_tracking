function [mapmapmap,new_wall_point_e2o]=bayes(idx_x,idx_y,flag_updata,flag_shift)
%%%%%%%%%%%%%%%%%%%%%%ԭ����δ�������Ÿ���ģ��%%%%%%%%%%%%%%%%%
global map
inn = 0;%�ֶ����ƻ�ͼ
% idx_x=̽���դ��x���� 
% idx_y=̽���դ��y���� 
% flag_updata = [UUVդ��x���� UUVդ��y���� �Ƿ�̽�⵽������̽�⵽Ϊ1������Ϊ0]
% flag_shift = [������դ��x���� ������դ��y���� ��־] ���ƶ���־���ƶ�Ϊ1�������Ŷ��޹أ����ùܡ�
%%%%%%%%%%%
% ɨ��ĳһС��󣬸�С��ı�ռ�ݸ���Ϊ0.9 hit_occupation�����еĸ���Ϊ0.1 hit_empty��
% û��ɨ��ĳһС��ʱ��ռ�ݵĸ���Ϊ0.2 miss_occupation�����еĸ���Ϊ0.8 miss_empty�����⼸������Ϊ����ֵ��
% global map_center
persistent map_Degree_of_confidence;  
if isempty(map_Degree_of_confidence)
    map_Degree_of_confidence = zeros(size(map,1),size(map,2));
end
% mymap = [1 1 1; 0 0 0; 1 1 0; 1 0 1;0 1 1;1 0 0;.5 .5 .5;1 0 1]; 
new_wall_point_e2o = 0;
new_wall_point_o2e = 0;
threshold = 4.5921;
threshold_l = -4.5921;
hit_occupation = 0.9;
hit_empty = 0.1;
miss_occupation = 0.2;
miss_empty = 0.8;

mapmapmap = zeros(size(map,1),size(map,2));
%% ���map
if -99999 == idx_x && -99999 == idx_y && ...
        -99999 == flag_updata(1)&& -99999 == flag_updata(2)&&-99999 == flag_updata(3)&&...
        -99999 == flag_shift(1)&&-99999 == flag_shift(2)&&-99999 == flag_shift(3)
    [xxx,yyy] = find(map_Degree_of_confidence >= threshold);
    [xxxx,yyyy] = find(map_Degree_of_confidence <= threshold_l);
    
    for count = 1:length(xxx)
        mapmapmap(xxx(count),yyy(count)) = 1;
    end
    
    for count_11 = 1:length(xxxx)
        mapmapmap(xxxx(count_11),yyyy(count_11)) = 2;
    end    
    
   %%%%%%%%%%%%%%%%%%%%%%%%%%
if 1 == inn
% if 1 
    mappp = 1-1./(1+exp(map_Degree_of_confidence));
% mappp(155,155) = 1;
    figure(6)

    pcolor(mappp');
    colorbar;
% colormap(flipud(jet));
    colormap(othercolor('BuGy_8')); 
% colormap(jet);
%     set(gca, 'LineStyle','none'); 
    hold on
    plot((size(map,1)+1)/2,(size(map,1)+1)/2,'g+');
    axis([1 size(map,1) 1 size(map,2)]);
    set(gca,'xtick', [1 50 100 150 200 250 300]);
%     set(gca,'xticklabel', [floor(flag_shift(1)-(size(map,1)+1)/2):50:floor(flag_shift(1)+(size(map,1)+1)/2)]);
    set(gca,'ytick', [1 50 100 150 200 250 300]);
%     set(gca,'yticklabel', [floor(flag_shift(2)-(size(map,1)+1)/2):50:floor(flag_shift(2)+(size(map,1)+1)/2)]);
    xlabel('�����ף�');
    ylabel('�����ף�');
%     set (gcf,'Position', [20 1 1000 1000]) ;
    hold off
end 
   %%%%%%%%%%%%%%%%%%%%%%%%%%    
    
	return; 
end


%%  ��ͼ�ƶ�
flag_shift3 = flag_shift(3);
if 1 == flag_shift3  %%��ͼ�ƶ�
    
    [idx,~] = Rasterize_1( flag_shift(1), flag_shift(2),1,0);
    p = idx(1);%դ���ͼ���ĵ��� ����ֵ
    q = idx(2);%դ���ͼ���ĵ��� ����ֵ
    [Degree_of_confidence] = unique(map_Degree_of_confidence);
    temp_idx = find(Degree_of_confidence == 0);
    Degree_of_confidence(temp_idx) = [];
    length_Degree_of_confidence = length(Degree_of_confidence);
    M = size(map_Degree_of_confidence,1);
    N = size(map_Degree_of_confidence,2);

% [idx,~] = Rasterize_1(map_center(1),map_center(2),1,0); %դ���ͼ���ĵ��� ������ֵ
% p = idx(1);%դ���ͼ���ĵ��� ����ֵ
% q = idx(2);%դ���ͼ���ĵ��� ����ֵ
for count_1 = 1:length_Degree_of_confidence
    [s(count_1).i,s(count_1).j] = find(Degree_of_confidence(count_1) == map_Degree_of_confidence);%դ���ͼ�ϰ��� ����ֵ
  
    s(count_1).ii = s(count_1).i-(p-(M+1)/2); %�ɵ��µ�����ֵ
    s(count_1).jj = s(count_1).j-(q-(N+1)/2); %�ɵ��µ�����ֵ

    s(count_1).len  = length(s(count_1).ii);
end

map_Degree_of_confidence(:,:) = 0;%��ͼ���
for count_2 = 1:length_Degree_of_confidence

for count_3 = 1:s(count_2).len %��ͼ��ֵ

    if (1<=s(count_2).ii(count_3) && s(count_2).ii(count_3)<= M) && (1<=s(count_2).jj(count_3) && s(count_2).jj(count_3)<=M) %�ж������µ�դ���ͼ��
        map_Degree_of_confidence(s(count_2).ii(count_3),s(count_2).jj(count_3)) = Degree_of_confidence(count_2);
    end
end

end
return ;

end

%% ��ͼ����
x = flag_updata(1);  %%uuvդ������
y = flag_updata(2); 
h = flag_updata(4); 
flag1 = flag_updata(3); %flag_updata = [UUVդ��x����/ UUVդ��y����/ �Ƿ�̽�⵽������̽�⵽Ϊ1������Ϊ0/ UUV����]

[ln_p] = multi_sonar_zonal_model( idx_x,idx_y , flag1 , x,y,h);

% [len_ln_p,wide_ln_p] = size(ln_p);
% L = map_Degree_of_confidence(x+1:x+len_ln_p,y+1:y+wide_ln_p)+ln_p;
L = map_Degree_of_confidence+ln_p;
% if L >= threshold & map_Degree_of_confidence(idx_x,idx_y) <threshold  %%������ ȷ��Ϊ������դ��
% 	 new_wall_point_e2o = 1 + new_wall_point_e2o;
% end
% map_Degree_of_confidence(x+1:x+len_ln_p,y+1:y+wide_ln_p) = L;
map_Degree_of_confidence = L;

end