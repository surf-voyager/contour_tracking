%% ��������  XΪ�����꣬YΪ������
clear all;                                                %������б���
close all;                                                %�������ͼ��
clc;                                                      %����
set(0,'defaultfigurecolor','w') ;       %��ͼ��������Ϊ��ɫ
% dbstop if all error;                  %��������ʱ������ֹͣ�ڴ���
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%1 δ���� 2���ڸ��� 3������ 4�Ѹ��� 5Ԥ��߽�
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ȫ�ֱ�����ʼ��
global D2R R2D T  R_path_piont R_path_piont_heading map  map_center  flag_predict   drMax thrustMax max__probe_distance
D2R                     = pi/180;
R2D                     = 180/pi;
T                       = 0.5;                       %����ʱ��
thrustMax      = 2200;                          %���ƽ������������ֵ,N
drMax          = 30*D2R;                        %��ֱ���

flag_predict   = 0;                    %Ԥ���־
max__probe_distance     = 60;                        %�������̽�����
map                     = zeros(2*max__probe_distance+31,2*max__probe_distance+31);            %դ���ͼ��ʼ��
flag_map = input('�������ͼ���','s');
flag_map = str2num(flag_map);
% flag_map = 5;
% % map_center ��һ��������  R_path_piont�������������ͺ��򣨵ڶ��κ����뱱��нǣ�
if 1 == flag_map %% �۳�
    map_center              = [435;91];%�۳�%[420;90];%�۳�%[140;460];%�󸣵� %[100;230];% [100;230];%                 %դ���ͼ�������꣨��ֵΪ�������ϵ�µ����꣩
    R_path_piont            = [445,98];%�۳�%[437,98];%�۳�%[145,460];%�󸣵�%[120,230];%[120,230];%    %��ǰ���ٵ�·����ġ��ѿ������ꡯ ���һ�������ٵĵ� �ڹ滮ʱ��Ϊ�ο���R=reference
    R_path_piont_heading    = 34.5*D2R; %�۳�%0;%�󸣵�%0;%  0;%                        %��ǰ���ٵ�·����Ĺ滮�����
elseif 2 == flag_map %% �󸣵�
    map_center              = [140;440];%�󸣵� %[420;90];%�۳�%[424;107];%�۳�%[100;230];% [100;230];%                 %դ���ͼ�������꣨��ֵΪ�������ϵ�µ����꣩
    R_path_piont            = [150,440];%�󸣵�%[437,98];%�۳�%[428,111];%�۳�%[120,230];%[120,230];%    %��ǰ���ٵ�·����ġ��ѿ������ꡯ ���һ�������ٵĵ� �ڹ滮ʱ��Ϊ�ο���R=reference
    R_path_piont_heading    = 0;%�󸣵�%34.5*D2R; %�۳�%0;%  0;%                        %��ǰ���ٵ�·����Ĺ滮�����
elseif 3 == flag_map %% ���ӵ���
     map_center              = [0;140];
     R_path_piont            = [10,143];
     R_path_piont_heading    = 0.2353;
elseif 4 == flag_map %% ͹����    
     map_center              = [202;203];
     R_path_piont            = [204,215];
     R_path_piont_heading    = 80*D2R;
elseif 5 == flag_map %% ������    
     map_center              = [210;102];
     R_path_piont            = [213,92];
     R_path_piont_heading    = -1.29;
end

%% ����������ʼ��
xx = [];                                        %uuv��x����
yy = [];                                        %uuv��y����
hh = [];                                        %uuv�ĺ���
mDy = [];                                       %����̽����Ϣ��x����
mDx = [];                                       %����̽����Ϣ��y����

Fitness = [];                                   %·���滮������ֵ
pppp = [];                                      %·���滮�Ľ��
mmin_dist = [];                                 %UUV������ʵʱ����
m_path_point = [];                              %�Ѹ��ٵ�·����
%% ������ʼ��
u_com               =2;     %ָ�������ٶȣ����٣�
v_com               =0;     %ָ������ٶȣ����٣�
h_com               =0;     %ָ�������
u                   =0;     %ʵ�������ٶȣ����٣�
v                   =0;     %ʵ�ʺ����ٶ�
r                   =0;     %ʵ��ƫת���ٶ�

%   x_uuv y_uuv��һ����  path_point_current�ڶ�����  path_point_plan��������
if 1 == flag_map %% �۳�
   h                   =35*D2R;                 %ʵ�������
   x_uuv               =435;                    %ʵ��xλ�á��ѿ������ꡯ
   y_uuv               =91;                     %ʵ��yλ��
   path_point_current  = [440,94];              %��ǰ���ٵ�·���㡮�ѿ������ꡯ
   path_point_plan     = [445,98];              %��ǰ���ٵĺ�һ��·���㡮�ѿ������ꡯ
   y_destination       = 153;                   %������y����
elseif 2 == flag_map  %% �󸣵�
   h                   =0;
   x_uuv               =140;
   y_uuv               =440;
   path_point_current  = [145,440];
   path_point_plan     = [150,440];
   y_destination       =440;
elseif 3 == flag_map   %% ���ӵ���
   h                   =0.1923;
   x_uuv               =0;
   y_uuv               =140;
   path_point_current  = [5,141];
   path_point_plan     = [10,143];
   y_destination       =98;  
elseif 4 == flag_map   %%͹����
   h                   =80*D2R;
   x_uuv               =202;
   y_uuv               =203;
   path_point_current  = [203,209];
   path_point_plan     = [204,215];
   y_destination       =203;  
elseif 5 == flag_map   %% ������
   h                   =-1.4;
   x_uuv               =210;
   y_uuv               =102;
   path_point_current  = [211,98];
   path_point_plan     = [213,92];
   y_destination       =34;  
end

x_destination       =-200;              %�������ʼֵ��������ã�����Ҫ�����ʼ��ԶһЩ��

%%%%%%%%% ִ�л�����PID
thrustReal =0;                                            %���ƽ���ʵ������
thrustCmd  =0;                                            %���ƽ���ָ������

drReal     =0;                                            %�����ʵ�ʶ��
drCmd      =0;                                            %�����ָ����

Eh         =0;                                            %����������
EhLast     =0;                                            %���������һʱ�����
EhDot      =0;                                            %�������������
EhTotal    =0;                                            %����������΢��

Eu         =0;                                            %�ٶȿ������
EuLast     =0;                                            %�ٶȿ�����һʱ�����
EuDot      =0;                                            %�ٶȿ���������
EuTotal    =0;                                            %�ٶȿ������΢��

%%%%%%%%% ���򼰶��
Time       =[];                                           %ʱ���������
HCmd       =[];                                           %����ָ���������
DrReal     =[];                                           %������Ǳ�������
DrCmd      =[];                                           %�����ָ���Ǳ�������
HCmd_rad   =[];

%%%%%%%%%% �㷨����
d_exp               = 10;                                               %��������
alpha               = 0.5419;                                           %��ת�뾶��ֵ
dim                 = 8;                                                %�㷨ά��
LB                  = [5 5 5 5 0 0 0 0];                                %�����ռ�����
UB                  = [10 10 10 10 2*pi 2*pi 2*pi 2*pi];                %�����ռ�����
FEs                 = 100;                                              %��������
N                   = 60;                                               %��Ⱥ����
fitness             = 0;                                                %��Ӧ�Ⱥ���

arrive_radius       =4;                                 %���̵�뾶
count               =0;                                 %����������
count_plan          =0 ;                                %����_·���滮����
arrive_flag         = 0 ;                               %����·�����־
fitness_pre         = -335;                             %Ԥ��滮��������ֵ
fitness_nor         = -395;                             %�����滮��������ֵ
flag_immediate_plan         = 0;                        %��Ԥ��滮תΪ�����滮��־
temp_count_Probe_point      = zeros(1,5);               %�������̽�⵽������������


%%%%%%%%%�ع滮��������
N_replan            = [];                            %������·��������
n                   = 0;                             %������·��������
N_store             = [];                            %·���������е�Ԫ����������
count_pp            = 0;                             %·�������д�С
abandon_points      = [];                            %������·����
Time_arr            = [];                            %����·�����ʱ��

%%%%%%%%%%%%%%%Ԥ����ֵ
predict_count       = 45;               %����ʵʱ̽���������n�κ�
pre_val             = 10;               %��������������



emergency_response_time = [];           %�������ʱ��
all_plan_points         = [];           %·��������
all_plan_points_heading = [];  

%%%%%%%%%%%%%%%%%%��ͼ��
pic_num                 = 1;            %��GIFͼ

yucebianjiedian         = [];           %Ԥ�������յ�
Time_yuce               = [];           %Ԥ��ʱ��
point_yuce              = [];           %Ԥ��ʱUUVλ��
Time_lijiguihua         = [];           %Ԥ��滮תΪ�����滮ʱ��
point_lijiguihua        = [];           %Ԥ��滮תΪ�����滮ʱUUVλ��
ceshi                   = [];           %����ʵʱ̽����Ϣ����
m_count                 = [];           %ʵʱ��������������
m_obs                   = [];           %ʵʱ̽����Ϣ��ģ��������

m_path_point            = [m_path_point;[x_uuv,y_uuv]];         %��ʼ��
timer1                  = clock;        %��ʱ��

%%  ������ ���յ��˳�
for i=1:1000000
    Time       =[Time;i*T];
    %% �滮
    if 1 == arrive_flag

        %%****1 �������ʾ
        count_plan = count_plan + 1;
        disp(['��',num2str(count_plan),'�ι滮']);
        %%****1end �������ʾ
        
        arrive_flag = 0;            %���·�������־
     
        if (count < pre_val && sum(temp_count_Probe_point) < predict_count) && ((boundary_end(1)-x_uuv)^2+(boundary_end(2)-y_uuv)^2)<=30^2 || 1 == flag_predict
        flag_predict = 1;
            disp('***************Ԥ��滮***************');
            %��ͼ�б��Ԥ�������յ�
            map_state_change([],[],5,0);                        %����һ��Ԥ������
            Rasterize_1(boundary_end(1),boundary_end(2),0,5); 
            %��¼
            yucebianjiedian = [yucebianjiedian;boundary_end];
            Time_yuce       =[Time_yuce;i*T];
            point_yuce = [point_yuce;[x_uuv,y_uuv]];
            
            num_arr_path_point(length(N_replan)) = 2;           %�����n��·����ʱ�Ƕ����й滮�����к��ֹ滮���滮����0 ���滮  1����  2 Ԥ��
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
% �㷨�����ռ䷶Χ
        LB(dim/2 +1:end) = [R_path_piont_heading - alpha...
                            R_path_piont_heading - 2*alpha...
                            R_path_piont_heading - 3*alpha...
                            R_path_piont_heading - 4*alpha];
        UB(dim/2 +1:end) = [R_path_piont_heading + alpha...
                            R_path_piont_heading + 2*alpha...
                            R_path_piont_heading + 3*alpha...
                            R_path_piont_heading + 4*alpha];

        [bestPositions,fitness,ppp ] = hgs_main(LB,UB,N,dim,FEs);       %·���滮

        all_plan_points = ppp(3:end-dim/2);                             %�洢����һ�������е�·��������
        all_plan_points_heading = ppp(end-dim/2+2:end);

        %%****1 ��¼
        pppp = [pppp;ppp];
        Fitness=[Fitness; fitness];
        %%****1end ��¼
        
        next_path_x(1) = ppp(1);
        next_path_y(1) = ppp(2);
        
        path_point_plan = [next_path_x,next_path_y];             %·���㡮�ѿ������ꡯ
        R_path_piont = [next_path_x next_path_y];                %%��ǰ���ٵ�·����
        R_path_piont_heading = bestPositions(2);
    end

%%   ̽�� 
    if 1 ==flag_map
        [Probe_point,Dx,Dy,Dx_amx,Dy_amx] = multi_Sonar_gangchi(x_uuv,y_uuv,h);     %���Ž���̽��
    elseif 2 ==flag_map
        [Probe_point,Dx,Dy,Dx_amx,Dy_amx] = multi_Sonar_dafudao(x_uuv,y_uuv,h); 
    elseif 3 ==flag_map  
        [Probe_point,Dx,Dy,Dx_amx,Dy_amx] = multi_complex_wall(x_uuv,y_uuv,h); 
    elseif 4 ==flag_map  
        [Probe_point,Dx,Dy,Dx_amx,Dy_amx] = multi_convex_wall(x_uuv,y_uuv,h); 
    elseif 5 ==flag_map  
        [Probe_point,Dx,Dy,Dx_amx,Dy_amx] = multi_concave1_wall(x_uuv,y_uuv,h); 
    end

    mDy = [mDy;Dy];                                                         %��¼̽�������
    mDx = [mDx;Dx];
    ceshi = [ceshi ;Probe_point];                                           %��¼̽�������
    temp_count_Probe_point(mod(i,3)+1) = Probe_point;                       %�����������̽�������֮��
    R_uuv = Rasterize_1(x_uuv,y_uuv,1,0);                                   %����UUVդ������

    if Probe_point > 0                                                      %���̽�⵽����
        boundary_end = [Dx(end),Dy(end)];                                   %��¼���һ��̽���
        [~,temp_count] = Rasterize_1(Dx',Dy',0,1,[R_uuv(1),R_uuv(2),1]);    %����դ���ͼ
        count = temp_count + count;                                         %��������������
        obs = baye_c(x_uuv,y_uuv,Dx,Dy);                                    %ģ����������
        m_obs = [m_obs;obs];                                                %��¼
    end
    
    m_count = [m_count;count];                                              %��¼����������

    if 0 == isempty(Dx_amx)                                                 %�����δ̽�⵽�����Ĳ���
	Rasterize_1(Dx_amx',Dy_amx',0,1,[R_uuv(1),R_uuv(2),0,h*R2D]);           %����դ���ͼ
    end

    if 1 == flag_predict && count >= pre_val                                %����Ԥ���ڼ�̽�⵽�±߽磬��Ԥ���־���
        flag_predict = 0;
        flag_immediate_plan = 1;
        disp('***************�����滮***************');
    end

    %% ����
    map_state_change([],[],6,0);                                            %����һ�ĵ�UUVλ��  ���ϸ���ͼ�ϵı�����
    R_uuv = Rasterize_1(x_uuv,y_uuv,1,6);                                   %uuvդ������
    min_dist = realdist_compute(R_uuv(1),R_uuv(2));                         %����UUV��߽����С����
    mmin_dist = [mmin_dist;min_dist];                                       %�洢

    h_com = los(m_path_point(end,1),m_path_point(end,2),path_point_current(1),path_point_current(2),x_uuv,y_uuv); %%%�����Ŀ��� ���ٵ�Ŀ��� ��ǰλ��
	HCmd       =[HCmd;h_com*R2D];
	HCmd_rad   =[HCmd_rad;h_com];
	Eu=u_com-u;                                  %���������ٶȿ��Ƶ��ٶ����
	EuDot=(Eu-EuLast)/T;                         %���������ٶȿ��Ƶ��ٶ�΢��
	EuTotal=(EuTotal+Eu);                        %���������ٶȿ��Ƶ��ٶȻ���
	if i==0
        EuDot=0;                                 %��ʼʱ�̽�EuDot����Ϊ0
	end
	[thrustCmd]=PIDu2(Eu,EuDot,EuTotal);          %���������ٶ�PID������
	[thrustReal] = realThruster2 (thrustCmd,thrustReal);%����ִ�л���ģ��
	EuLast=Eu;                                   %����ǰһʱ���ٶ����
    
	Eh=h_com-h;                                   %���������ٶȿ��Ƶ��ٶ����
	if Eh > pi
        Eh = Eh - 2*pi;
	elseif Eh < -pi
        Eh = Eh + 2*pi;
    end
	EhDot=(Eh-EhLast)/T;                         %���������ٶȿ��Ƶ��ٶ�΢��
	EhTotal=(EhTotal+Eh);                        %���������ٶȿ��Ƶ��ٶȻ���
	if i==0
        EhDot=0;                                 %��ʼʱ�̽�EuDot����Ϊ0
	end
	[drCmd]=PIDh2(Eh,EhDot,EhTotal);            %���������ٶ�PID������
	[drReal] = realThruster1 (drCmd,drReal);    %����ִ�л���ģ��
	EhLast=Eh;                                 	%����ǰһʱ���ٶ���� 
	[x_uuv,y_uuv,u,v,r,h]=uuvmodelThrustRudder(x_uuv,y_uuv,u,v,r,h,thrustReal,drReal);%��uuvģ�ͺ���
	DrReal     =[DrReal;drReal]; 
	DrCmd      =[DrCmd;drCmd];
    
	%%%��¼�������߹���·��        
	xx=[xx;x_uuv];
	yy=[yy;y_uuv];
	hh=[hh;h];
    
%%%������Ӧ    
    if min_dist < d_exp-4
        emergency_response;
        emergency_response_time = [emergency_response_time;i*T];
    end

%%%�жϺ������Ƿ񵽴���һ��·����
    dist_uuv_to_path_point=sqrt((path_point_current(1)-x_uuv).^2+(path_point_current(2)-y_uuv).^2);
    if dist_uuv_to_path_point < arrive_radius
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%�����·���ͼ  
% %     figure(6)  
% %     c1 = plot(0,140,'k>','MarkerFaceColor','c');
% %     hold on
% %     c2 = plot(494,98,'k<','MarkerFaceColor','c');
% %     c3 = complex_wall;
% %     c4 = plot(xx,yy,'k-');
% %     c5 =  plot(m_obs(:,1),m_obs(:,2),'k.','LineWidth',5);%������
% %     rogm_x_min = map_center(1)-86;
% %     rogm_x_max = map_center(1)+86;
% %     rogm_y_min = map_center(2)-86;
% %     rogm_y_max = map_center(2)+86;
% %     plot([rogm_x_min,rogm_x_max,rogm_x_max,rogm_x_min,rogm_x_min],[rogm_y_min,rogm_y_min,rogm_y_max,rogm_y_max,rogm_y_min],'g--')
% %     plot(path_point_current(1),path_point_current(2),'g+');
% %     xlabel('�����ף�');
% %     ylabel('�����ף�');
% %     axis([-50 450 -50 450]);
% %     axis equal
% %     legend([c1 c2 c4 c3 c5],'���','�յ�','����','ʵ������','��֪����');
% %     hold off
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%end�����·���

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%դ���ͼ�ƶ�x
        bayes11(0,0,0,[path_point_current(1),path_point_current(2),1]);
        map_updata_1(path_point_current(1),path_point_current(2));
%%%���¸��ٵ�·��������          
        m_path_point = [m_path_point;path_point_current];
        path_point_current = path_point_plan;
%%%�ع滮�ж�
        arrive_flag = 1;
        Time_arr = [Time_arr;i*T];
	if isempty(all_plan_points_heading)
         n = 0;
         count_pp = 0;
	end
        if 0 == isempty(all_plan_points_heading) && 0 == flag_predict
            fitness1 = replan_fitness(all_plan_points,all_plan_points_heading);
            fitness_nor = -98.5 * length(all_plan_points)/2;
        if  fitness1 <= fitness_nor   %%�ϴι滮����Ӧ��ֵ�㹻��
            sequence = replan_fitness_compute(all_plan_points,all_plan_points_heading); %%�ع滮�ж�
            n = length(all_plan_points_heading) - sequence;  %%nΪ���еĸ�����sequenceΪ���Եĸ���
               if n>=1
                abandon_points = [abandon_points,all_plan_points(sequence*2+1:end)];
                %%%�Ѳ��ϸ��ɾ��
            	temp_all_plan_points = all_plan_points;
                all_plan_points = [];
                all_plan_points = temp_all_plan_points(1:sequence*2);
            	temp_all_plan_points_heading = all_plan_points_heading;
                all_plan_points_heading = [];
                all_plan_points_heading = temp_all_plan_points_heading(1:sequence);
                count_pp = length(all_plan_points_heading);
                %%%
                end
            if sequence >= 1  %%���ڿ��Ե�·����
                path_point_plan = all_plan_points(1:2); %%���ڸ��ٵ�·���� ��һ�������ٵ� ��ֵ
                R_path_piont = path_point_plan; %%��ֵ
                R_path_piont_heading = all_plan_points_heading(1);
                all_plan_points_heading(1) = [];
                all_plan_points(1:2) = []; %%�����渳ֵ�ĵ����������
                arrive_flag = 0;
                count = 0;
                disp('***************�����ع滮***************');
            end
        else
            n = length(all_plan_points_heading);
                if n>=1
                abandon_points = [abandon_points,all_plan_points];
                end
            all_plan_points_heading = [];
            all_plan_points = []; %%�����渳ֵ�ĵ����������
            count_pp = length(all_plan_points_heading);
        end

        end
     %%************  ��Ԥ��ʱ����Ԥ�����Ӧ��ֵ�Ϻã���һֱ������ι滮�ģ����ٽ��й滮
      if 0 == isempty(all_plan_points_heading) && 1 == flag_predict
            fitness1 = replan_fitness(all_plan_points,all_plan_points_heading);
            fitness_pre = -84.5 * length(all_plan_points)/2;
%      if 1 == flag_predict
        if fitness1 < fitness_pre && 0 == isempty(all_plan_points)
            count_pp = length(all_plan_points_heading);
            n = 0;
            path_point_plan = all_plan_points(1:2); %%���ڸ��ٵ�·���� ��һ�������ٵ� ��ֵ
            R_path_piont = path_point_plan; %%��ֵ
            R_path_piont_heading = all_plan_points_heading(1);
            all_plan_points_heading(1) = [];
            all_plan_points(1:2) = []; %%�����渳ֵ�ĵ����������
            arrive_flag = 0;
            count = 0;
            disp('***************11111111111***************');
        else
            n = length(all_plan_points_heading);
                if n>=1
                abandon_points = [abandon_points,all_plan_points];
                end
            all_plan_points_heading = [];
            all_plan_points = []; %%�����渳ֵ�ĵ����������
            count_pp = length(all_plan_points_heading);
        end

      end
      
     %%************
    N_replan = [N_replan;n];
    N_store = [N_store;count_pp];
    num_arr_path_point(length(N_replan)) = 0;
    end

%% �ж��Ƿ񵽴��յ�        
        if (x_uuv-x_destination)^2+(y_uuv-y_destination)^2<=5^2 % �����յ㣬�˳�ѭ��
            disp('���ҳɹ�');
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
timer2 = clock;                                                             %��ʱ����
timer_running = etime(timer2,timer1);                                       %��ʱʱ��
timer_simulation = Time(end);                                               %ģ��ʱ��
save('dafudao.mat');                                                        %���湤����
Time_arr = [0;Time_arr(:,:)];
num_arr_path_point = [0,num_arr_path_point(:,:)];
N_replan = [0;N_replan(:,:)];
N_store = [1;N_store(:,:)];

X_AIM = m_path_point(:,1);
Y_AIM = m_path_point(:,2);
plot___________(timer_simulation,mmin_dist-d_exp,xx,yy,HCmd,hh,flag_map,X_AIM,Y_AIM,...
                point_yuce,m_obs,yucebianjiedian,ceshi,m_count,...
                Time_arr,num_arr_path_point,N_replan,N_store,abandon_points);
