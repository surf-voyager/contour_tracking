%% 轮廓跟踪  X为横坐标，Y为纵坐标
clear all;                                                %清空所有变量
close all;                                                %清空所有图形
clc;                                                      %清屏
set(0,'defaultfigurecolor','w') ;       %绘图背景设置为白色
% dbstop if all error;                  %发生错误时，程序停止在错误处
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%1 未跟踪 2正在跟踪 3待跟踪 4已跟踪 5预测边界
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 全局变量初始化
global D2R R2D T  R_path_piont R_path_piont_heading map  map_center  flag_predict   drMax thrustMax max__probe_distance
D2R                     = pi/180;
R2D                     = 180/pi;
T                       = 0.5;                       %采样时间
thrustMax      = 2200;                          %主推进器最大推力限值,N
drMax          = 30*D2R;                        %垂直舵角

flag_predict   = 0;                    %预测标志
max__probe_distance     = 60;                        %声呐最大探测距离
map                     = zeros(2*max__probe_distance+31,2*max__probe_distance+31);            %栅格地图初始化
flag_map = input('请输入地图编号','s');
flag_map = str2num(flag_map);
% flag_map = 5;
% % map_center 第一个点坐标  R_path_piont第三个点的坐标和航向（第二段航迹与北向夹角）
if 1 == flag_map %% 港池
    map_center              = [435;91];%港池%[420;90];%港池%[140;460];%大福岛 %[100;230];% [100;230];%                 %栅格地图中心坐标（此值为大地坐标系下的坐标）
    R_path_piont            = [445,98];%港池%[437,98];%港池%[145,460];%大福岛%[120,230];%[120,230];%    %当前跟踪的路径点的‘笛卡尔坐标’ 最后一个待跟踪的点 在规划时作为参考点R=reference
    R_path_piont_heading    = 34.5*D2R; %港池%0;%大福岛%0;%  0;%                        %当前跟踪的路径点的规划航向角
elseif 2 == flag_map %% 大福岛
    map_center              = [140;440];%大福岛 %[420;90];%港池%[424;107];%港池%[100;230];% [100;230];%                 %栅格地图中心坐标（此值为大地坐标系下的坐标）
    R_path_piont            = [150,440];%大福岛%[437,98];%港池%[428,111];%港池%[120,230];%[120,230];%    %当前跟踪的路径点的‘笛卡尔坐标’ 最后一个待跟踪的点 在规划时作为参考点R=reference
    R_path_piont_heading    = 0;%大福岛%34.5*D2R; %港池%0;%  0;%                        %当前跟踪的路径点的规划航向角
elseif 3 == flag_map %% 复杂地形
     map_center              = [0;140];
     R_path_piont            = [10,143];
     R_path_piont_heading    = 0.2353;
elseif 4 == flag_map %% 凸地形    
     map_center              = [202;203];
     R_path_piont            = [204,215];
     R_path_piont_heading    = 80*D2R;
elseif 5 == flag_map %% 凹地形    
     map_center              = [210;102];
     R_path_piont            = [213,92];
     R_path_piont_heading    = -1.29;
end

%% 变量容器初始化
xx = [];                                        %uuv的x坐标
yy = [];                                        %uuv的y坐标
hh = [];                                        %uuv的航向
mDy = [];                                       %声呐探测信息的x坐标
mDx = [];                                       %声呐探测信息的y坐标

Fitness = [];                                   %路径规划的评价值
pppp = [];                                      %路径规划的结果
mmin_dist = [];                                 %UUV与轮廓实时距离
m_path_point = [];                              %已跟踪的路径点
%% 变量初始化
u_com               =2;     %指令纵向速度（航速）
v_com               =0;     %指令横向速度（航速）
h_com               =0;     %指令艏向角
u                   =0;     %实际纵向速度（航速）
v                   =0;     %实际横向速度
r                   =0;     %实际偏转角速度

%   x_uuv y_uuv第一个点  path_point_current第二个点  path_point_plan第三个点
if 1 == flag_map %% 港池
   h                   =35*D2R;                 %实际艏向角
   x_uuv               =435;                    %实际x位置‘笛卡尔坐标’
   y_uuv               =91;                     %实际y位置
   path_point_current  = [440,94];              %当前跟踪的路径点‘笛卡尔坐标’
   path_point_plan     = [445,98];              %当前跟踪的后一个路径点‘笛卡尔坐标’
   y_destination       = 153;                   %结束点y坐标
elseif 2 == flag_map  %% 大福岛
   h                   =0;
   x_uuv               =140;
   y_uuv               =440;
   path_point_current  = [145,440];
   path_point_plan     = [150,440];
   y_destination       =440;
elseif 3 == flag_map   %% 复杂地形
   h                   =0.1923;
   x_uuv               =0;
   y_uuv               =140;
   path_point_current  = [5,141];
   path_point_plan     = [10,143];
   y_destination       =98;  
elseif 4 == flag_map   %%凸地形
   h                   =80*D2R;
   x_uuv               =202;
   y_uuv               =203;
   path_point_current  = [203,209];
   path_point_plan     = [204,215];
   y_destination       =203;  
elseif 5 == flag_map   %% 凹地形
   h                   =-1.4;
   x_uuv               =210;
   y_uuv               =102;
   path_point_current  = [211,98];
   path_point_plan     = [213,92];
   y_destination       =34;  
end

x_destination       =-200;              %结束点初始值，随便设置，但是要距离初始点远一些，

%%%%%%%%% 执行机构及PID
thrustReal =0;                                            %主推进器实际推力
thrustCmd  =0;                                            %主推进器指令推力

drReal     =0;                                            %方向舵实际舵角
drCmd      =0;                                            %方向舵指令舵角

Eh         =0;                                            %航向控制误差
EhLast     =0;                                            %航向控制上一时刻误差
EhDot      =0;                                            %航向控制误差积分
EhTotal    =0;                                            %航向控制误差微分

Eu         =0;                                            %速度控制误差
EuLast     =0;                                            %速度控制上一时刻误差
EuDot      =0;                                            %速度控制误差积分
EuTotal    =0;                                            %速度控制误差微分

%%%%%%%%% 航向及舵角
Time       =[];                                           %时间变量容器
HCmd       =[];                                           %航向指令变量容器
DrReal     =[];                                           %方向舵舵角变量容器
DrCmd      =[];                                           %方向舵指令舵角变量容器
HCmd_rad   =[];

%%%%%%%%%% 算法设置
d_exp               = 10;                                               %期望距离
alpha               = 0.5419;                                           %回转半径限值
dim                 = 8;                                                %算法维数
LB                  = [5 5 5 5 0 0 0 0];                                %搜索空间下限
UB                  = [10 10 10 10 2*pi 2*pi 2*pi 2*pi];                %搜索空间上限
FEs                 = 100;                                              %迭代次数
N                   = 60;                                               %种群数量
fitness             = 0;                                                %适应度函数

arrive_radius       =4;                                 %航程点半径
count               =0;                                 %新增轮廓点
count_plan          =0 ;                                %计数_路径规划次数
arrive_flag         = 0 ;                               %到达路径点标志
fitness_pre         = -335;                             %预测规划满分评价值
fitness_nor         = -395;                             %正常规划满分评价值
flag_immediate_plan         = 0;                        %由预测规划转为正常规划标志
temp_count_Probe_point      = zeros(1,5);               %最近三拍探测到的轮廓点数量


%%%%%%%%%重规划计数变量
N_replan            = [];                            %舍弃的路径点数量
n                   = 0;                             %舍弃的路径点数量
N_store             = [];                            %路径点序列中的元素数量计数
count_pp            = 0;                             %路径点序列大小
abandon_points      = [];                            %舍弃的路径点
Time_arr            = [];                            %到达路径点的时间

%%%%%%%%%%%%%%%预测阈值
predict_count       = 45;               %声呐实时探测点数量的n次和
pre_val             = 10;               %新增轮廓点数量



emergency_response_time = [];           %距离过近时刻
all_plan_points         = [];           %路径点序列
all_plan_points_heading = [];  

%%%%%%%%%%%%%%%%%%画图用
pic_num                 = 1;            %画GIF图

yucebianjiedian         = [];           %预测轮廓拐点
Time_yuce               = [];           %预测时间
point_yuce              = [];           %预测时UUV位置
Time_lijiguihua         = [];           %预测规划转为正常规划时刻
point_lijiguihua        = [];           %预测规划转为正常规划时UUV位置
ceshi                   = [];           %声呐实时探测信息数量
m_count                 = [];           %实时新增轮廓点数量
m_obs                   = [];           %实时探测信息（模拟噪声）

m_path_point            = [m_path_point;[x_uuv,y_uuv]];         %初始化
timer1                  = clock;        %计时器

%%  主程序 到终点退出
for i=1:1000000
    Time       =[Time;i*T];
    %% 规划
    if 1 == arrive_flag

        %%****1 命令窗口显示
        count_plan = count_plan + 1;
        disp(['第',num2str(count_plan),'次规划']);
        %%****1end 命令窗口显示
        
        arrive_flag = 0;            %清除路径到达标志
     
        if (count < pre_val && sum(temp_count_Probe_point) < predict_count) && ((boundary_end(1)-x_uuv)^2+(boundary_end(2)-y_uuv)^2)<=30^2 || 1 == flag_predict
        flag_predict = 1;
            disp('***************预测规划***************');
            %地图中标记预测轮廓拐点
            map_state_change([],[],5,0);                        %将上一次预测的清除
            Rasterize_1(boundary_end(1),boundary_end(2),0,5); 
            %记录
            yucebianjiedian = [yucebianjiedian;boundary_end];
            Time_yuce       =[Time_yuce;i*T];
            point_yuce = [point_yuce;[x_uuv,y_uuv]];
            
            num_arr_path_point(length(N_replan)) = 2;           %到达第n个路径点时是都进行规划，进行何种规划。规划决策0 不规划  1正常  2 预测
            num_plan(count_plan) = 2;
        else
            num_plan(count_plan) = 1;
            num_arr_path_point(length(N_replan)) = 1;
        end
        count = 0;
        
        if 1 == flag_immediate_plan
            flag_immediate_plan = 0 ;
            Time_lijiguihua       =[Time_lijiguihua;i*T];
            point_lijiguihua = [point_lijiguihua;[x_uuv,y_uuv]];
        end
% 算法搜索空间范围
        LB(dim/2 +1:end) = [R_path_piont_heading - alpha...
                            R_path_piont_heading - 2*alpha...
                            R_path_piont_heading - 3*alpha...
                            R_path_piont_heading - 4*alpha];
        UB(dim/2 +1:end) = [R_path_piont_heading + alpha...
                            R_path_piont_heading + 2*alpha...
                            R_path_piont_heading + 3*alpha...
                            R_path_piont_heading + 4*alpha];

        [bestPositions,fitness,ppp ] = hgs_main(LB,UB,N,dim,FEs);       %路径规划

        all_plan_points = ppp(3:end-dim/2);                             %存储除第一个外所有的路径点坐标
        all_plan_points_heading = ppp(end-dim/2+2:end);

        %%****1 记录
        pppp = [pppp;ppp];
        Fitness=[Fitness; fitness];
        %%****1end 记录
        
        next_path_x(1) = ppp(1);
        next_path_y(1) = ppp(2);
        
        path_point_plan = [next_path_x,next_path_y];             %路径点‘笛卡尔坐标’
        R_path_piont = [next_path_x next_path_y];                %%当前跟踪的路径点
        R_path_piont_heading = bestPositions(2);
    end

%%   探测 
    if 1 ==flag_map
        [Probe_point,Dx,Dy,Dx_amx,Dy_amx] = multi_Sonar_gangchi(x_uuv,y_uuv,h);     %声呐进行探测
    elseif 2 ==flag_map
        [Probe_point,Dx,Dy,Dx_amx,Dy_amx] = multi_Sonar_dafudao(x_uuv,y_uuv,h); 
    elseif 3 ==flag_map  
        [Probe_point,Dx,Dy,Dx_amx,Dy_amx] = multi_complex_wall(x_uuv,y_uuv,h); 
    elseif 4 ==flag_map  
        [Probe_point,Dx,Dy,Dx_amx,Dy_amx] = multi_convex_wall(x_uuv,y_uuv,h); 
    elseif 5 ==flag_map  
        [Probe_point,Dx,Dy,Dx_amx,Dy_amx] = multi_concave1_wall(x_uuv,y_uuv,h); 
    end

    mDy = [mDy;Dy];                                                         %记录探测点坐标
    mDx = [mDx;Dx];
    ceshi = [ceshi ;Probe_point];                                           %记录探测点数量
    temp_count_Probe_point(mod(i,3)+1) = Probe_point;                       %计算最近三次探测点数量之和
    R_uuv = Rasterize_1(x_uuv,y_uuv,1,0);                                   %计算UUV栅格坐标

    if Probe_point > 0                                                      %如果探测到轮廓
        boundary_end = [Dx(end),Dy(end)];                                   %记录最后一次探测点
        [~,temp_count] = Rasterize_1(Dx',Dy',0,1,[R_uuv(1),R_uuv(2),1]);    %更新栅格地图
        count = temp_count + count;                                         %计算新增轮廓点
        obs = baye_c(x_uuv,y_uuv,Dx,Dy);                                    %模拟声呐噪声
        m_obs = [m_obs;obs];                                                %记录
    end
    
    m_count = [m_count;count];                                              %记录新增轮廓点

    if 0 == isempty(Dx_amx)                                                 %如果有未探测到轮廓的波束
	Rasterize_1(Dx_amx',Dy_amx',0,1,[R_uuv(1),R_uuv(2),0,h*R2D]);           %更新栅格地图
    end

    if 1 == flag_predict && count >= pre_val                                %若在预测期间探测到新边界，则预测标志清除
        flag_predict = 0;
        flag_immediate_plan = 1;
        disp('***************立即规划***************');
    end

    %% 跟踪
    map_state_change([],[],6,0);                                            %将上一拍的UUV位置  在上个地图上的标记清除
    R_uuv = Rasterize_1(x_uuv,y_uuv,1,6);                                   %uuv栅格坐标
    min_dist = realdist_compute(R_uuv(1),R_uuv(2));                         %计算UUV与边界的最小距离
    mmin_dist = [mmin_dist;min_dist];                                       %存储

    h_com = los(m_path_point(end,1),m_path_point(end,2),path_point_current(1),path_point_current(2),x_uuv,y_uuv); %%%到达的目标点 跟踪的目标点 当前位置
	HCmd       =[HCmd;h_com*R2D];
	HCmd_rad   =[HCmd_rad;h_com];
	Eu=u_com-u;                                  %计算用于速度控制的速度误差
	EuDot=(Eu-EuLast)/T;                         %计算用于速度控制的速度微分
	EuTotal=(EuTotal+Eu);                        %计算用于速度控制的速度积分
	if i==0
        EuDot=0;                                 %初始时刻将EuDot设置为0
	end
	[thrustCmd]=PIDu2(Eu,EuDot,EuTotal);          %调用纵向速度PID控制器
	[thrustReal] = realThruster2 (thrustCmd,thrustReal);%调用执行机构模型
	EuLast=Eu;                                   %更新前一时刻速度误差
    
	Eh=h_com-h;                                   %计算用于速度控制的速度误差
	if Eh > pi
        Eh = Eh - 2*pi;
	elseif Eh < -pi
        Eh = Eh + 2*pi;
    end
	EhDot=(Eh-EhLast)/T;                         %计算用于速度控制的速度微分
	EhTotal=(EhTotal+Eh);                        %计算用于速度控制的速度积分
	if i==0
        EhDot=0;                                 %初始时刻将EuDot设置为0
	end
	[drCmd]=PIDh2(Eh,EhDot,EhTotal);            %调用纵向速度PID控制器
	[drReal] = realThruster1 (drCmd,drReal);    %调用执行机构模型
	EhLast=Eh;                                 	%更新前一时刻速度误差 
	[x_uuv,y_uuv,u,v,r,h]=uuvmodelThrustRudder(x_uuv,y_uuv,u,v,r,h,thrustReal,drReal);%调uuv模型函数
	DrReal     =[DrReal;drReal]; 
	DrCmd      =[DrCmd;drCmd];
    
	%%%记录航行器走过的路径        
	xx=[xx;x_uuv];
	yy=[yy;y_uuv];
	hh=[hh;h];
    
%%%紧急响应    
    if min_dist < d_exp-4
        emergency_response;
        emergency_response_time = [emergency_response_time;i*T];
    end

%%%判断航行器是否到达下一个路径点
    dist_uuv_to_path_point=sqrt((path_point_current(1)-x_uuv).^2+(path_point_current(2)-y_uuv).^2);
    if dist_uuv_to_path_point < arrive_radius
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%第三章仿真图  
% %     figure(6)  
% %     c1 = plot(0,140,'k>','MarkerFaceColor','c');
% %     hold on
% %     c2 = plot(494,98,'k<','MarkerFaceColor','c');
% %     c3 = complex_wall;
% %     c4 = plot(xx,yy,'k-');
% %     c5 =  plot(m_obs(:,1),m_obs(:,2),'k.','LineWidth',5);%轮廓点
% %     rogm_x_min = map_center(1)-86;
% %     rogm_x_max = map_center(1)+86;
% %     rogm_y_min = map_center(2)-86;
% %     rogm_y_max = map_center(2)+86;
% %     plot([rogm_x_min,rogm_x_max,rogm_x_max,rogm_x_min,rogm_x_min],[rogm_y_min,rogm_y_min,rogm_y_max,rogm_y_max,rogm_y_min],'g--')
% %     plot(path_point_current(1),path_point_current(2),'g+');
% %     xlabel('北向（米）');
% %     ylabel('东向（米）');
% %     axis([-50 450 -50 450]);
% %     axis equal
% %     legend([c1 c2 c4 c3 c5],'起点','终点','航迹','实际轮廓','感知轮廓');
% %     hold off
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%end第三章仿真

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%栅格地图移动x
        bayes11(0,0,0,[path_point_current(1),path_point_current(2),1]);
        map_updata_1(path_point_current(1),path_point_current(2));
%%%更新跟踪的路径点坐标          
        m_path_point = [m_path_point;path_point_current];
        path_point_current = path_point_plan;
%%%重规划判断
        arrive_flag = 1;
        Time_arr = [Time_arr;i*T];
	if isempty(all_plan_points_heading)
         n = 0;
         count_pp = 0;
	end
        if 0 == isempty(all_plan_points_heading) && 0 == flag_predict
            fitness1 = replan_fitness(all_plan_points,all_plan_points_heading);
            fitness_nor = -98.5 * length(all_plan_points)/2;
        if  fitness1 <= fitness_nor   %%上次规划的适应度值足够好
            sequence = replan_fitness_compute(all_plan_points,all_plan_points_heading); %%重规划判断
            n = length(all_plan_points_heading) - sequence;  %%n为不行的个数，sequence为可以的个数
               if n>=1
                abandon_points = [abandon_points,all_plan_points(sequence*2+1:end)];
                %%%把不合格的删除
            	temp_all_plan_points = all_plan_points;
                all_plan_points = [];
                all_plan_points = temp_all_plan_points(1:sequence*2);
            	temp_all_plan_points_heading = all_plan_points_heading;
                all_plan_points_heading = [];
                all_plan_points_heading = temp_all_plan_points_heading(1:sequence);
                count_pp = length(all_plan_points_heading);
                %%%
                end
            if sequence >= 1  %%存在可以的路径点
                path_point_plan = all_plan_points(1:2); %%正在跟踪的路径的 下一个待跟踪点 赋值
                R_path_piont = path_point_plan; %%赋值
                R_path_piont_heading = all_plan_points_heading(1);
                all_plan_points_heading(1) = [];
                all_plan_points(1:2) = []; %%将上面赋值的点清除出队列
                arrive_flag = 0;
                count = 0;
                disp('***************不必重规划***************');
            end
        else
            n = length(all_plan_points_heading);
                if n>=1
                abandon_points = [abandon_points,all_plan_points];
                end
            all_plan_points_heading = [];
            all_plan_points = []; %%将上面赋值的点清除出队列
            count_pp = length(all_plan_points_heading);
        end

        end
     %%************  在预测时，若预测的适应度值较好，就一直跟踪这次规划的，不再进行规划
      if 0 == isempty(all_plan_points_heading) && 1 == flag_predict
            fitness1 = replan_fitness(all_plan_points,all_plan_points_heading);
            fitness_pre = -84.5 * length(all_plan_points)/2;
%      if 1 == flag_predict
        if fitness1 < fitness_pre && 0 == isempty(all_plan_points)
            count_pp = length(all_plan_points_heading);
            n = 0;
            path_point_plan = all_plan_points(1:2); %%正在跟踪的路径的 下一个待跟踪点 赋值
            R_path_piont = path_point_plan; %%赋值
            R_path_piont_heading = all_plan_points_heading(1);
            all_plan_points_heading(1) = [];
            all_plan_points(1:2) = []; %%将上面赋值的点清除出队列
            arrive_flag = 0;
            count = 0;
            disp('***************11111111111***************');
        else
            n = length(all_plan_points_heading);
                if n>=1
                abandon_points = [abandon_points,all_plan_points];
                end
            all_plan_points_heading = [];
            all_plan_points = []; %%将上面赋值的点清除出队列
            count_pp = length(all_plan_points_heading);
        end

      end
      
     %%************
    N_replan = [N_replan;n];
    N_store = [N_store;count_pp];
    num_arr_path_point(length(N_replan)) = 0;
    end

%% 判断是否到达终点        
        if (x_uuv-x_destination)^2+(y_uuv-y_destination)^2<=5^2 % 到达终点，退出循环
            disp('侥幸成功');
            break;
        end
        if 30 == i
            if 1 == flag_map
                x_destination = 365;
            elseif 2 == flag_map
                x_destination = 140;
            elseif 3 == flag_map
                x_destination = 494;
            elseif 4 == flag_map
                x_destination = 298;
            elseif 5 == flag_map
                x_destination = 283; 
            end
        end
end
timer2 = clock;                                                             %计时结束
timer_running = etime(timer2,timer1);                                       %计时时间
timer_simulation = Time(end);                                               %模拟时间
save('dafudao.mat');                                                        %保存工作区
Time_arr = [0;Time_arr(:,:)];
num_arr_path_point = [0,num_arr_path_point(:,:)];
N_replan = [0;N_replan(:,:)];
N_store = [1;N_store(:,:)];

X_AIM = m_path_point(:,1);
Y_AIM = m_path_point(:,2);
plot___________(timer_simulation,mmin_dist-d_exp,xx,yy,HCmd,hh,flag_map,X_AIM,Y_AIM,...
                point_yuce,m_obs,yucebianjiedian,ceshi,m_count,...
                Time_arr,num_arr_path_point,N_replan,N_store,abandon_points);
