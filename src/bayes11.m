function [mapmapmap,new_wall_point_e2o]=bayes11(idx_x,idx_y,flag_updata,flag_shift)
%%%%%%%%%%%%含有声呐概率模型%%%%%%%%%%%%%%%%%%555
global map max__probe_distance
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
    [xxx,yyy] = find(map_Degree_of_confidence >= threshold);  %视为障碍
    [xxxx,yyyy] = find(map_Degree_of_confidence <= threshold_l);  %视为空闲
    
    for count = 1:length(xxx)
        mapmapmap(xxx(count),yyy(count)) = 1;  %障碍标1
    end
    
    for count_11 = 1:length(xxxx)
        mapmapmap(xxxx(count_11),yyyy(count_11)) = 2;  %空闲标2
    end    
       
	return; 
end

%%  地图移动
flag_shift3 = flag_shift(3);    %地图移动标志
if 1 == flag_shift3  %%地图移动
    
    [idx,~] = Rasterize_1( flag_shift(1), flag_shift(2),1,0);  %求栅格地图坐标系下的坐标
    p = idx(1);%栅格地图中心的行 索引值
    q = idx(2);%栅格地图中心的列 索引值
    [Degree_of_confidence] = unique(map_Degree_of_confidence);
    temp_idx = find(Degree_of_confidence == 0);
    Degree_of_confidence(temp_idx) = [];
    length_Degree_of_confidence = length(Degree_of_confidence);
    M = size(map_Degree_of_confidence,1);
    N = size(map_Degree_of_confidence,2);

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

    if 1 == inn  %画图需手动打开
        mappp = 1-1./(1+exp(map_Degree_of_confidence));

        figure(99)
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
        set(gca,'xticklabel', [floor(flag_shift(1)-(size(map,1)+1)/2):50:floor(flag_shift(1)+(size(map,1)+1)/2)]);
        set(gca,'ytick', [1 50 100 150 200 250 300]);
        set(gca,'yticklabel', [floor(flag_shift(2)-(size(map,1)+1)/2):50:floor(flag_shift(2)+(size(map,1)+1)/2)]);
        xlabel('北向（米）');
        ylabel('东向（米）');
%     set (gcf,'Position', [20 1 1000 1000]) ;
        hold off
    end

return ;

end

%% 地图更新

x = flag_updata(1);  %%uuv坐标
y = flag_updata(2); 
flag1 = flag_updata(3); %探测到障碍为1

if 1 == flag1
i_lb = idx_x - 2;
i_ub = idx_x + 2;
j_lb = idx_y - 2;
j_ub = idx_y + 2;
if i_lb > i_ub
    temp = i_lb;
    i_lb = i_ub;
    i_ub = temp;
end
if j_lb > j_ub
    temp = j_lb;
    j_lb = j_ub;
    j_ub = temp;
end

Ps = sqrt((idx_x - x)^2 + (idx_y - y)^2);  %探测点距离
dtP = 2;  %误差
p_occ = 0.9; %概率

beam_theta =  atan2d((idx_y - y), (idx_x - x));  %探测点角度
beam_width_2 = .5; %单波束宽度一半
angle_range_ub = beam_theta + beam_width_2; %单波束左阈值
angle_range_lb = beam_theta - beam_width_2; %单波束右阈值
beam_range = max__probe_distance; %声呐最大探测

%%
ppp = [];   %栅格位置
pp = [];    %栅格置信度

for i = i_lb:.3:i_ub
    for j = j_lb:.3:j_ub
        x_r = i   ;
        y_r = j   ;
         % 计算栅格中心点到原点的距离和角度
        distance = sqrt((x_r - x)^2 + (y_r - y)^2); %检查点距离
        angle = atan2d((y_r - y), (x_r - x)); %检查点角度

          if (angle >= angle_range_lb && angle <= angle_range_ub && distance <= beam_range) %声呐单波束覆盖范围
                if ( distance > Ps - dtP && distance < Ps + dtP)        %2区
                    p(floor(x_r),floor(y_r)) = (1 - 0.5*(((abs(distance - Ps))/dtP) * ((abs(angle - beam_theta)/beam_width_2))))*p_occ; %概率
                    pp =[pp;log( p(floor(x_r),floor(y_r))/(1-p(floor(x_r),floor(y_r))))];%概率转换成可以直接相加的置信度形式
                    ppp = [ppp;[floor(x_r),floor(y_r)]]; %该点的栅格位置
                end
          end
          
   end
end
storep = [];
storepp = [];

if isempty(pp)
    pp = log(hit_occupation)/(hit_empty);
    ppp = [ppp;[idx_x,idx_y]];
end

for i = 0:100 %去掉重复的，挑概率最大的留下
    aa = find(ppp(1,1) == ppp(:,1)); %找到与第一行第一列元素相同的 a
    bb = find(ppp(1,2) == ppp(aa,2)); %找到与找到与第一行元素相同的 b
    [val,index]=max(pp(aa(bb))); %找到 b 中概率最大的
    storep = [storep;val]; 
    storepp = [storepp;ppp(index,:)];
    pp((aa(bb))) = [];
    ppp((aa(bb)),:) = [];
    if isempty(pp) %空了就找完了
        break;
    end
end
row = size(map,1);
% column = size(map,2);
r = size(storepp,1);
for r1=1:r 
    L4 = map_Degree_of_confidence((storepp(r1,2)-1)*row+storepp(r1,1)) + storep(r1);
    if(L4 >= threshold && map_Degree_of_confidence((storepp(r1,2)-1)*row+storepp(r1,1)) <threshold)
        new_wall_point_e2o = 1  + new_wall_point_e2o;
    end
end
for r1=1:r 
    map_Degree_of_confidence((storepp(r1,2)-1)*row+storepp(r1,1)) = storep(r1) + map_Degree_of_confidence((storepp(r1,2)-1)*row+storepp(r1,1));
end

end
%%
ind4 = [];
vPts = bresenham_2d([x,y],[idx_x,idx_y]);   %空闲区域更新（1区）

if 1 == flag1
l_v = size(vPts,1);
for i_l_v=1:l_v
    ind1 = vPts(i_l_v,:) == storepp;
    ind2 = ind1(:,1) + ind1(:,2);
    ind3 = find(ind2 == 2);
    if 0 == isempty(ind3)
        ind4 = [ind4;i_l_v];
    end
end
    vPts(ind4,:) = [];
end
    
n_l_v = size(vPts,1);
for count1 = 1:n_l_v
    L2 = map_Degree_of_confidence(vPts(count1,1),vPts(count1,2))+log(miss_occupation/miss_empty);
    map_Degree_of_confidence(vPts(count1,1),vPts(count1,2)) = L2;

    L3 = map_Degree_of_confidence(x,y)+log(miss_occupation/miss_empty);
    map_Degree_of_confidence(x,y) = L3;   
end

end