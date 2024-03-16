function [ Probe_point,mDx,mDy,mDx_max,mDy_max] = multi_Sonar_mapp_2( x,y,h)
global D2R R2D
D2R=pi/180;
R2D=180/pi;
%%%%%%%%%%%%%%%%%%变量初始化%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Probe_point=0; %探测到轮廓点的数量
distance=0; %当前单波束探测到的距离
mDx=[];mDy=[]; %存储探测到的轮廓点坐标
mDx_max=[];mDy_max=[];
d1 = 0;
d2 = 0;
d3 = 0;
d4 = 0;
d5 = 0;
d6 = 0;
d7 = 0;
d8 = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
for a=-60:1:60  %模拟多波束声呐的开角
    alpha=a*D2R;
    flag=0; %0未探测到轮廓，1探测到轮廓
    for k=0:.5:120   %声呐探测距离，射线形式
        
%%%  求探测点坐标
        if k > 1
            d1 = 2000;
            d2 = 2000;
            d3 = 2000;
            d4 = 2000;
            d5 = 2000;
            d6 = 2000; 
            d7 = 2000;
            d8 = 2000;            
            [xx1,yy1]=Probepoint(k-1,alpha,h,x,y); %解算探测点坐标
            [xx2,yy2]=Probepoint(k,alpha,h,x,y);   
%%%解算探测点纵坐标，当轮廓函数改变时，随之改变
      if xx1>=100&&xx1<220
        d1=200;
        d2=200;
      elseif xx1>=220&&xx1<300
        d1=(tan(30/180*pi)*(xx1-220)+200);
        d2=(tan(30/180*pi)*(xx2-220)+200);
      elseif xx1>=300&&xx1<400
        d1=(tan(-60/180*pi)*(xx1-300)+246);
        d2=(tan(-60/180*pi)*(xx2-300)+246);
      elseif xx1>=400&&xx1<600
        d1= (tan(30/180*pi)*(xx1-400)+73);
        d2= (tan(30/180*pi)*(xx2-400)+73);
ff = 1;
      elseif xx1>=600&&xx1<800
        d1= (tan(-60/180*pi)*(xx1-550)+390);
        d2= (tan(-60/180*pi)*(xx2-550)+390);      
      elseif xx1>=-100&&xx1<-50
        d1= (tan(82.55/180*pi)*(xx1+50)-180);
        d2= (tan(82.55/180*pi)*(xx2+50)-180); 
      elseif xx1>=-50&&xx1<40
        d1= (tan(60/180*pi)*(xx1-40)-24);
        d2= (tan(60/180*pi)*(xx2-40)-24); 
      elseif xx1>=40&&xx1<100
        d1= (tan(75/180*pi)*(xx1-100)+200);
        d2= (tan(75/180*pi)*(xx2-100)+200);    
      end%%%解算探测点纵坐标结束

%%%探测点纵坐标与边界纵坐标相比较
        if((yy1>=d1)&&(yy2<=d2))    
            distance=k;
            flag=1;
            break;
        end
        
    if xx1>=500&&xx1<550
        d5= (tan(30/180*pi)*(xx1-500)+361);
        d6= (tan(30/180*pi)*(xx2-500)+361);
	elseif xx1>=550&&xx1<600
        d5= (tan(-60/180*pi)*(xx1-550)+390);
        d6= (tan(-60/180*pi)*(xx2-550)+390);   
    end
        if((yy1>=d5)&&(yy2<=d6))    
            distance=k;
            flag=1;
            break;
        end    
        
        
      if xx1>=500&&xx1<600
        d3= (tan(-60/180*pi)*(xx1-600)+188);
        d4= (tan(-60/180*pi)*(xx2-600)+188);
      elseif xx1>=-100&&xx1<800
        d3= (tan(30/180*pi)*(xx1-800)-43);
        d4= (tan(30/180*pi)*(xx2-800)-43);         
      end 
        
        
        if((yy1<=d3)&&(yy2>=d4))    
            distance=k;
            flag=1;
            break;
        end
        
      if xx1>=500&&xx1<600
        d7= (tan(30/180*pi)*(xx1-800)-43);
        d8= (tan(30/180*pi)*(xx2-800)-43);         
      end 
        
        
        if((yy1<=d7)&&(yy2>=d8))    
            distance=k;
            flag=1;
            break;
        end
                
        end
%%%k++,进入下一次循环        
    end

    if flag==0
        distance=120;%当声纳探测不到障碍物时，默认为声纳的最大探测距离；
    mDx_max=[mDx_max;xx2];mDy_max=[mDy_max;yy2];
    end
    
    if distance<120
        Probe_point=Probe_point+1; %计算探测点数量
        mDx=[mDx;xx2];mDy=[mDy;yy2]; %只保存声呐探测点的坐标

    end
    %%%声呐开角度数++,进入下一次循环
%     if 45==a
%         hold off
%     end
    
end
    
    