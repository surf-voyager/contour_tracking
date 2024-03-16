function [mapmapmap,new_wall_point_e2o]=bayes(idx_x,idx_y,flag_updata,flag_shift)
%%%%%%%%%%%%%%%%%%%%%%原——未加入声呐概率模型%%%%%%%%%%%%%%%%%
global map
inn = 0;%手动控制画图
% idx_x=探测点栅格x坐标 
% idx_y=探测点栅格y坐标 
% flag_updata = [UUV栅格x坐标 UUV栅格y坐标 是否探测到轮廓，探测到为1，否则为0]
% flag_shift = [新中心栅格x坐标 新中心栅格y坐标 标志] 表移动标志，移动为1，与置信度无关，不用管。
%%%%%%%%%%%
% 扫到某一小格后，该小格的被占据概率为0.9 hit_occupation，空闲的概率为0.1 hit_empty；
% 没有扫到某一小格时，占据的概率为0.2 miss_occupation，空闲的概率为0.8 miss_empty。（这几个数字为假设值）
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
%% 输出map
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
    xlabel('北向（米）');
    ylabel('东向（米）');
%     set (gcf,'Position', [20 1 1000 1000]) ;
    hold off
end 
   %%%%%%%%%%%%%%%%%%%%%%%%%%    
    
	return; 
end


%%  地图移动
flag_shift3 = flag_shift(3);
if 1 == flag_shift3  %%地图移动
    
    [idx,~] = Rasterize_1( flag_shift(1), flag_shift(2),1,0);
    p = idx(1);%栅格地图中心的行 索引值
    q = idx(2);%栅格地图中心的列 索引值
    [Degree_of_confidence] = unique(map_Degree_of_confidence);
    temp_idx = find(Degree_of_confidence == 0);
    Degree_of_confidence(temp_idx) = [];
    length_Degree_of_confidence = length(Degree_of_confidence);
    M = size(map_Degree_of_confidence,1);
    N = size(map_Degree_of_confidence,2);

% [idx,~] = Rasterize_1(map_center(1),map_center(2),1,0); %栅格地图中心的行 列索引值
% p = idx(1);%栅格地图中心的行 索引值
% q = idx(2);%栅格地图中心的列 索引值
for count_1 = 1:length_Degree_of_confidence
    [s(count_1).i,s(count_1).j] = find(Degree_of_confidence(count_1) == map_Degree_of_confidence);%栅格地图障碍物 索引值
  
    s(count_1).ii = s(count_1).i-(p-(M+1)/2); %旧到新的索引值
    s(count_1).jj = s(count_1).j-(q-(N+1)/2); %旧到新的索引值

    s(count_1).len  = length(s(count_1).ii);
end

map_Degree_of_confidence(:,:) = 0;%地图清空
for count_2 = 1:length_Degree_of_confidence

for count_3 = 1:s(count_2).len %地图赋值

    if (1<=s(count_2).ii(count_3) && s(count_2).ii(count_3)<= M) && (1<=s(count_2).jj(count_3) && s(count_2).jj(count_3)<=M) %判断属于新的栅格地图上
        map_Degree_of_confidence(s(count_2).ii(count_3),s(count_2).jj(count_3)) = Degree_of_confidence(count_2);
    end
end

end
return ;

end

%% 地图更新
x = flag_updata(1);  %%uuv栅格坐标
y = flag_updata(2); 
h = flag_updata(4); 
flag1 = flag_updata(3); %flag_updata = [UUV栅格x坐标/ UUV栅格y坐标/ 是否探测到轮廓，探测到为1，否则为0/ UUV航向]

[ln_p] = multi_sonar_zonal_model( idx_x,idx_y , flag1 , x,y,h);

% [len_ln_p,wide_ln_p] = size(ln_p);
% L = map_Degree_of_confidence(x+1:x+len_ln_p,y+1:y+wide_ln_p)+ln_p;
L = map_Degree_of_confidence+ln_p;
% if L >= threshold & map_Degree_of_confidence(idx_x,idx_y) <threshold  %%新增的 确认为轮廓点栅格
% 	 new_wall_point_e2o = 1 + new_wall_point_e2o;
% end
% map_Degree_of_confidence(x+1:x+len_ln_p,y+1:y+wide_ln_p) = L;
map_Degree_of_confidence = L;

end