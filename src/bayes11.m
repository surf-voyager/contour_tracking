function [mapmapmap,new_wall_point_e2o]=bayes11(idx_x,idx_y,flag_updata,flag_shift)
%%%%%%%%%%%%�������Ÿ���ģ��%%%%%%%%%%%%%%%%%%555
global map max__probe_distance
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
    [xxx,yyy] = find(map_Degree_of_confidence >= threshold);  %��Ϊ�ϰ�
    [xxxx,yyyy] = find(map_Degree_of_confidence <= threshold_l);  %��Ϊ����
    
    for count = 1:length(xxx)
        mapmapmap(xxx(count),yyy(count)) = 1;  %�ϰ���1
    end
    
    for count_11 = 1:length(xxxx)
        mapmapmap(xxxx(count_11),yyyy(count_11)) = 2;  %���б�2
    end    
       
	return; 
end

%%  ��ͼ�ƶ�
flag_shift3 = flag_shift(3);    %��ͼ�ƶ���־
if 1 == flag_shift3  %%��ͼ�ƶ�
    
    [idx,~] = Rasterize_1( flag_shift(1), flag_shift(2),1,0);  %��դ���ͼ����ϵ�µ�����
    p = idx(1);%դ���ͼ���ĵ��� ����ֵ
    q = idx(2);%դ���ͼ���ĵ��� ����ֵ
    [Degree_of_confidence] = unique(map_Degree_of_confidence);
    temp_idx = find(Degree_of_confidence == 0);
    Degree_of_confidence(temp_idx) = [];
    length_Degree_of_confidence = length(Degree_of_confidence);
    M = size(map_Degree_of_confidence,1);
    N = size(map_Degree_of_confidence,2);

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

    if 1 == inn  %��ͼ���ֶ���
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
        xlabel('�����ף�');
        ylabel('�����ף�');
%     set (gcf,'Position', [20 1 1000 1000]) ;
        hold off
    end

return ;

end

%% ��ͼ����

x = flag_updata(1);  %%uuv����
y = flag_updata(2); 
flag1 = flag_updata(3); %̽�⵽�ϰ�Ϊ1

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

Ps = sqrt((idx_x - x)^2 + (idx_y - y)^2);  %̽������
dtP = 2;  %���
p_occ = 0.9; %����

beam_theta =  atan2d((idx_y - y), (idx_x - x));  %̽���Ƕ�
beam_width_2 = .5; %���������һ��
angle_range_ub = beam_theta + beam_width_2; %����������ֵ
angle_range_lb = beam_theta - beam_width_2; %����������ֵ
beam_range = max__probe_distance; %�������̽��

%%
ppp = [];   %դ��λ��
pp = [];    %դ�����Ŷ�

for i = i_lb:.3:i_ub
    for j = j_lb:.3:j_ub
        x_r = i   ;
        y_r = j   ;
         % ����դ�����ĵ㵽ԭ��ľ���ͽǶ�
        distance = sqrt((x_r - x)^2 + (y_r - y)^2); %�������
        angle = atan2d((y_r - y), (x_r - x)); %����Ƕ�

          if (angle >= angle_range_lb && angle <= angle_range_ub && distance <= beam_range) %���ŵ��������Ƿ�Χ
                if ( distance > Ps - dtP && distance < Ps + dtP)        %2��
                    p(floor(x_r),floor(y_r)) = (1 - 0.5*(((abs(distance - Ps))/dtP) * ((abs(angle - beam_theta)/beam_width_2))))*p_occ; %����
                    pp =[pp;log( p(floor(x_r),floor(y_r))/(1-p(floor(x_r),floor(y_r))))];%����ת���ɿ���ֱ����ӵ����Ŷ���ʽ
                    ppp = [ppp;[floor(x_r),floor(y_r)]]; %�õ��դ��λ��
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

for i = 0:100 %ȥ���ظ��ģ���������������
    aa = find(ppp(1,1) == ppp(:,1)); %�ҵ����һ�е�һ��Ԫ����ͬ�� a
    bb = find(ppp(1,2) == ppp(aa,2)); %�ҵ����ҵ����һ��Ԫ����ͬ�� b
    [val,index]=max(pp(aa(bb))); %�ҵ� b �и�������
    storep = [storep;val]; 
    storepp = [storepp;ppp(index,:)];
    pp((aa(bb))) = [];
    ppp((aa(bb)),:) = [];
    if isempty(pp) %���˾�������
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
vPts = bresenham_2d([x,y],[idx_x,idx_y]);   %����������£�1����

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