function  plot___________(timer33,mmin_dist,xx,yy,HCmd,hh,...
    flag111,x_aim,y_aim,yuce,liji,bianjie,probe_points,new_points,...
     Time_arr,num_arr_path_point,N_replan,N_store,abandon_points)

HCmd = HCmd * pi/180;
% set (gcf,'Position', [950 150 500 400]) ;%%%%%%%%%%%%%%��ͼ��С
% set (gcf,'Position', [950 150 500 200]) ;%%%%%%%%%%%%%%��ͼ��С
figure(20)  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% stairs(Time_arr,N_replan,'b','LineWidth',1.2);
hold on
stem(Time_arr,N_replan,'b','LineWidth',1.2,'Marker','none');
plot([0,timer33],[0,0],'b','LineWidth',1.2)
grid on
box on
xlim([0,timer33]);
ylim([0,4]);
set(gca,'ytick',0:1:4);
set(gca,'xtick',0:200:2000);
% xlabel('ʱ�䣨�룩');
% ylabel('�ع滮ָ��N');
xlabel('Time/s');
ylabel('Replanning Signal N');
set (gcf,'Position', [950 350 500 200]) ;%%%%%%%%%%%%%%��ͼ��С

data_start = 0; %������ ʱ����
data_end = timer33; %������ ʱ��ֹ
data_amount = length(probe_points); %������ ����

figure(21)  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(3,1,3);  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% stairs(Time_arr,num_arr_path_point,'b','LineWidth',1.2);
hold on
stem(Time_arr,num_arr_path_point,'b','LineWidth',1.2,'Marker','none');
plot([0,data_end],[0,0],'b','LineWidth',1.2)
grid on
box on
xmin = 0;
xmax = data_end;
xlim([xmin,xmax]);
ylim([0,3]);
set(gca,'ytick',0:1:3);
set(gca,'xtick',0:200:2000);
% xlabel('ʱ�䣨�룩');
% ylabel('�滮ָ��\sigma');
xlabel('Time/s');
ylabel('Planning Signal \sigma');

subplot(3,1,1);  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
plot(linspace(data_start,data_end,data_amount),probe_points,'b','LineWidth',1.2);
grid on
% xlabel('ʱ�䣨�룩');
% ylabel('����̽��㣨����');
xlabel('Time/s');
ylabel('Sonar Detection Points');
xmin = 0;
xmax = data_end;
ymin = 0;
ymax = ceil(max(probe_points)/10)*10;
axis([xmin xmax ymin ymax]);
% set(0,'defaultfigurecolor','w') ;
set(gca,'xtick',0:100:data_end);
set(gca,'ytick',ymin:15:ymax);
box on

subplot(3,1,2);  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
plot(linspace(data_start,data_end,data_amount),new_points,'b','LineWidth',1.2);
grid on
% xlabel('ʱ�䣨�룩');
% ylabel('���������㣨����');
xlabel('Time/s');
ylabel('Newly Added Contour Points');
xmin = 0;
xmax = data_end;
ymin = 0;
ymax = ceil(max(new_points)/10)*10;
axis([xmin xmax ymin ymax]);
set(gca,'xtick',0:100:data_end);
set(gca,'ytick',ymin:30:ymax);
set (gcf,'Position', [950 150 500 400]) ;%%%%%%%%%%%%%%��ͼ��С

figure(22)

hold on
data_start = 1; %������ ʱ����
data_end = timer33; %������ ʱ��ֹ
data_amount = length(mmin_dist); %������ ����
xmin = 0;
xmax = data_end;
ymin = floor(min(mmin_dist));
ymax = ceil(max(mmin_dist));
plot(linspace(data_start,data_end,data_amount),mmin_dist,'b','LineWidth',1.2);
grid on
box on
% xlabel('ʱ�䣨�룩');
% ylabel('�������ף�');
xlabel('Time/s');
ylabel('Distance Error/m');
axis([xmin xmax ymin ymax]);
set(gca,'xtick',0:200:data_end);
set(gca,'ytick',ymin:2:ymax);
% set (gcf,'Position', [950 150 500 160]) ;%%%%%%%%%%%%%%��ͼ��С
set (gcf,'Position', [950 150 500 200]) ;%%%%%%%%%%%%%%��ͼ��С


% 
% figure(21)
% stairs(Time_arr,N_store,'b','LineWidth',1.2);
% % plot(1:length(N_store),N_store,'b');
% grid on
% box on



% grid on
% % box on
% figure(11)
% if 3 == flag111
%     set (gcf,'Position', [50 50 400 150]) ;
% else
%     set (gcf,'Position', [50 50 1000 300]) ;
% end
% hold on
% data_start = 1; %������ ʱ����
% data_end = timer33; %������ ʱ��ֹ
% data_amount = length(mmin_dist); %������ ����
% xmin = 1;
% xmax = data_end;
% ymin = floor(min(mmin_dist))-1;
% ymax = ceil(max(mmin_dist))+1;
% plot(linspace(data_start,data_end,data_amount),mmin_dist,'b');
% grid on
% xlabel('ʱ�䣨�룩');
% ylabel('�������ף�');
% % title('����')
% axis([xmin xmax ymin ymax]);
% % set(0,'defaultfigurecolor','w') ;
% set(gca,'xtick',0:100:data_end);
% set(gca,'ytick',ymin:2:ymax);
% % axis([xmin xmax ymin 5]);
% % set (gcf,'Position', [50 50 710 165]) ;
% % set(gca,'ytick',ymin:2:5);
% 

% 
% box on
% HCmd = HCmd * pi/180;
% data_amount = length(hh);
% figure(12)
% if 3 == flag111
%     set (gcf,'Position', [50 50 400 150]) ;
% else
%     set (gcf,'Position', [50 50 1000 300]) ;
% end
% hold on
% plot(linspace(data_start,data_end,data_amount),hh,'r');
% plot(linspace(data_start,data_end,data_amount),HCmd,'b--');
% grid on
% xlabel('ʱ�䣨�룩');
% ylabel('���򣨻��ȣ�');
% % title('����')
% xmin = 1;
% xmax = data_end;
% ymin = -4;
% ymax = 4;
% axis([xmin xmax ymin ymax]);
% % set(0,'defaultfigurecolor','w') ;
% set(gca,'xtick',0:100:data_end);
% set(gca,'ytick',ymin:1:ymax);
% lgd = legend('ʵ�ʺ���','ָ���');
% set(lgd,'Location','best')

% 
% 
% figure(13)
% if 3 == flag111
%     set (gcf,'Position', [50 50 400 350]) ;
% else
%     set (gcf,'Position', [150 50 750 700]) ;
% end
% 
% hold on
% 
% c3=plot(x_aim,y_aim,'gx');
% c1=plot(xx,yy,'r');
% 
% switch flag111
%     case 1
%         c2=gangchi;
%     case 2
%         c2=dafudao;
%     case 3
%         c2=complex_wall;
%     case 4
%         convex_wall;
% end
% if 0 == isempty(yuce)
%     c4 = plot(yuce(:,1),yuce(:,2),'rp');
%     c5 = plot(liji(:,1),liji(:,2),'bp');
%     c6 = plot(bianjie(:,1),bianjie(:,2),'kp');
%     if 1 == flag111   
%         lgd = legend([c1,c2,c3,c4,c5,c6],'���й켣','�۳�����','·����','Ԥ��滮��','��ʶ������','Ԥ�����ݵ�');
%     elseif 2 == flag111   
%         lgd = legend([c1,c2,c3,c4,c5,c6],'���й켣','��������','·����','Ԥ��滮��','��ʶ������','Ԥ�����ݵ�');
%     elseif 3 == flag111   
%         lgd = legend([c1,c2,c3,c4,c5,c6],'���й켣','��������','·����','Ԥ��滮��','��ʶ������','Ԥ�����ݵ�');
%     end
%     set(lgd,'Location','best')
% else
%     if 1 == flag111   
%         lgd = legend([c1,c2,c3],'���й켣','�۳�����','·����');
%     elseif 2 == flag111   
%         lgd = legend([c1,c2,c3],'���й켣','��������','·����');
%     elseif 3 == flag111   
%         lgd = legend([c1,c2,c3],'���й켣','��������','·����');
%     end  
%     set(lgd,'Location','best')
% end
% len_11=length(abandon_points);
% if len_11>0
%     for cl=1:2:len_11/2
%         plot(abandon_points(cl),abandon_points(cl+1),'rx');
%     end
% end
% 
% grid on
% xlabel('����X���ף�');
% ylabel('����Y���ף�');
% % set(0,'defaultfigurecolor','w') ;

% % 
% 
% plot(xx,yy,'r');
% switch flag111
%     case 1
%         gangchi;
%     case 2
%         dafudao;
%     case 3
%         zhijiaotu;
%     case 4
%         mapp_2;
% end
% xlabel('����X���� ��');
% ylabel('����Y���ף�');
% % set(0,'defaultfigurecolor','w') ;
% name_str=[date,'��ͼ'];
% legend('���ٹ켣','��������');
% h=getframe(gcf);%��ȡ��ǰ��Ļ
% fout = sprintf('F:\\�о�ɮ\\ʵ����11111\\�۳�\\17m\\%s.jpg',name_str);%casͼ����
% imwrite(mat2gray(h.cdata), fout);

%  legend('����·��','��������');
% 
% data_amount = length(dr_com);
% figure(14)
% if 3 == flag111
%     set (gcf,'Position', [50 50 400 150]) ;
% else
%     set (gcf,'Position', [50 50 1000 300]) ;
% end
% hold on
% plot(linspace(data_start,data_end,data_amount),dr_real*180/pi,'r');
% plot(linspace(data_start,data_end,data_amount),dr_com*180/pi,'b--');
% grid on
% xlabel('ʱ�䣨�룩');
% ylabel('������ǣ��ȣ�');
% % title('����')
% xmin = 1;
% xmax = data_end;
% ymin = -35;
% ymax = 35;
% axis([xmin xmax ymin ymax]);
% % set(0,'defaultfigurecolor','w') ;
% set(gca,'xtick',0:100:data_end);
% set(gca,'ytick',ymin:10:ymax);
% lgd = legend('ʵ�ʶ��','ָ����');
% set(lgd,'Location','best')

% 
% figure(15)
% if 3 == flag111
%     set (gcf,'Position', [50 50 400 150]) ;
% else
%     set (gcf,'Position', [50 50 1000 300]) ;
% end
% hold on
% plot(linspace(data_start,data_end,data_amount),probe_points,'b.');
% % plot(linspace(data_start,data_end,data_amount),HCmd,'b--');
% grid on
% xlabel('ʱ�䣨�룩');
% ylabel('����̽��㣨����');
% % title('����')
% xmin = 1;
% xmax = data_end;
% ymin = 0;
% ymax = ceil(max(probe_points)/20)*20;
% axis([xmin xmax ymin 90]);
% % set(0,'defaultfigurecolor','w') ;
% set(gca,'xtick',0:20:data_end);
% set(gca,'ytick',ymin:15:ymax);
% box on
% % legend('ʵ�ʺ���','ָ���');
% set (gcf,'Position', [950 150 340 110]) ;%%%%%%%%%%%%%%��ͼ��С
% 
% name_str=[date,'����̽��߽������'];
% h=getframe(gcf);%��ȡ��ǰ��Ļ
% fout = sprintf(file_path,name_str);%casͼ����
% imwrite(mat2gray(h.cdata), fout);
% % a=ones(1,12);
% % b=ones(1,10);
% % plot(1:28,[a,2,2,])
% % grid on
% % xlabel('�ź���');
% % ylabel('�滮���Σ�');
% 
% figure(16)
% if 3 == flag111
%     set (gcf,'Position', [50 50 400 150]) ;
% else
%     set (gcf,'Position', [50 50 1000 300]) ;
% end
% hold on
% plot(linspace(data_start,data_end,data_amount),new_points,'b.');
% % plot(linspace(data_start,data_end,data_amount),HCmd,'b--');
% grid on
% xlabel('ʱ�䣨�룩');
% ylabel('���������㣨����');
% % title('����')
% xmin = 1;
% xmax = data_end;
% ymin = 0;
% ymax = ceil(max(new_points)/10)*10;
% axis([xmin xmax ymin 100]);
% % set(0,'defaultfigurecolor','w') ;
% set(gca,'xtick',0:100:data_end);
% set(gca,'ytick',ymin:10:100);
% set (gcf,'Position', [950 150 500 200]) ;%%%%%%%%%%%%%%��ͼ��С
% % legend('ʵ�ʺ���','ָ���');


figure(17)
set (gcf,'Position', [1 1 1300 600]) ;
data_start = 1; %������ ʱ����
data_end = timer33; %������ ʱ��ֹ
data_amount = length(mmin_dist); %������ ����
xmin = 1;
xmax = data_end;
ymin = floor(min(mmin_dist))-1;
ymax = ceil(max(mmin_dist))+1;
% subplot(2,2,4);
% hold on
% plot(linspace(data_start,data_end,data_amount),mmin_dist,'b');
% grid on
% xlabel('Time/s');
% ylabel('Distance Error/m');
% % title('����')
% axis([xmin xmax ymin ymax]);
% % set(0,'defaultfigurecolor','w') ;
% set(gca,'xtick',0:100:data_end);
% set(gca,'ytick',ymin:2:ymax);
% 
% subplot(2,2,2);
% hold on
% data_amount = length(hh);
% plot(linspace(data_start,data_end,data_amount),hh,'r');
% plot(linspace(data_start,data_end,data_amount),HCmd,'b--');
% grid on
% xlabel('Time/s');
% ylabel('Heading/rad');
% % title('����')
% xmin = 1;
% xmax = data_end;
% ymin = -4;
% ymax = 4;
% axis([xmin xmax ymin ymax]);
% % set(0,'defaultfigurecolor','w') ;
% set(gca,'xtick',0:100:data_end);
% set(gca,'ytick',ymin:1:ymax);
% lgd = legend('Real Heading','Command Heading');
% set(lgd,'Location','best')




% subplot(2,2,[1 3]);
hold on
c3=plot(x_aim,y_aim,'gx');
c1=plot(xx,yy,'r');

switch flag111
    case 1
        c2=gangchi;
    case 2
        c2=dafudao;
    case 3
        c2=complex_wall;
    case 4
        c2=convex_wall;
	case 5
        c2=concave1_wall;
end

len_11=length(abandon_points);%����
% if len_11>0
for ccl=1:2:len_11
   c9 = plot(abandon_points(ccl),abandon_points(ccl+1),'bx');
end
%     legend(c9,'Discard Points');
% end

if 0 == isempty(yuce)
    c4 = plot(yuce(:,1),yuce(:,2),'rp');
    c5 = plot(liji(:,1),liji(:,2),'k.','LineWidth',5);
    c6 = plot(bianjie(:,1),bianjie(:,2),'k^','MarkerFaceColor','m');
    c7 = plot(143,440,'k>','MarkerFaceColor','c');
    c8 = plot(137,440,'k<','MarkerFaceColor','c');
    if 1 == flag111   
        lgd = legend([c1,c2,c3,c4,c5,c6,c7,c8,c9],'UUV Trajectory','Harbor Contour','Planned Path Points','Predicted Path Points','Perceptual Contour','Contour Inflection Points','Start Point','Stop Point','Discard Points');
    elseif 2 == flag111   
        lgd = legend([c1,c2,c3,c4,c5,c6,c7,c8,c9],'UUV Trajectory','Island Contour','Planned Path Points','Predicted Path Points','Perceptual Contour','Contour Inflection Points','Start Point','Stop Point','Discard Points');
    elseif 3 == flag111   
        lgd = legend([c1,c2,c3,c4,c5,c6,c7,c8,c9],'UUV Trajectory','Complex Contour','Planned Path Points','Predicted Path Points','Perceptual Contour','Contour Inflection Points','Start Point','Stop Point','Discard Points');
	elseif 4 == flag111   
        lgd = legend([c1,c2,c3,c4,c5,c6,c7,c8,c9],'UUV Trajectory','Convex Contour','Planned Path Points','Predicted Path Points','Perceptual Contour','Contour Inflection Points','Start Point','Stop Point','Discard Points');
	elseif 5 == flag111   
        lgd = legend([c1,c2,c3,c4,c5,c6,c7,c8,c9],'UUV Trajectory','Concave Contour','Planned Path Points','Predicted Path Points','Perceptual Contour','Contour Inflection Points','Start Point','Stop Point','Discard Points');
    end
    set(lgd,'Location','best')
else
    if 1 == flag111   
        lgd = legend([c1,c2,c3],'UUV Trajectory','Harbor Contour','Planned Path Points');
    elseif 2 == flag111   
        lgd = legend([c1,c2,c3],'UUV Trajectory','Island Contour','Planned Path Points');
    elseif 3 == flag111   
        lgd = legend([c1,c2,c3],'UUV Trajectory','Complex Contour','Planned Path Points');
    elseif 4 == flag111   
        lgd = legend([c1,c2,c3],'UUV Trajectory','Convex Contour','Planned Path Points');
    elseif 5 == flag111   
        lgd = legend([c1,c2,c3],'UUV Trajectory','Concave Contour','Planned Path Points');
    end  
    set(lgd,'Location','best')
end

grid on
xlabel('X/m');
ylabel('Y/m');
% set(0,'defaultfigurecolor','w') ;


end