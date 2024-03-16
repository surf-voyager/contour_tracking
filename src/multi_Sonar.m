function [ Probe_point,mDx,mDy] = multi_Sonar( x,y,h)
global D2R R2D
D2R=pi/180;
R2D=180/pi;
%%%%%%%%%%%%%%%%%%变量初始化%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Probe_point=0; %探测到轮廓点的数量
distance=0; %当前单波束探测到的距离
mDx=[];mDy=[]; %存储探测到的轮廓点坐标
d1 = 0;
d2 = 0;
d3 = 0;
d4 = 0;
% if x<270
%     interval = 0:1:120;
% else
%     interval = 0:0.05:120;
% end
%     
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
for a=-60:1:60  %模拟多波束声呐的开角
    alpha=a*D2R;
    flag=0; %0未探测到轮廓，1探测到轮廓
    for k=0:1:120   %声呐探测距离，射线形式
        
%%%  求探测点坐标
        if k > 1
            d1 = 2000;
            d2 = 2000;
            d3 = 2000;
            d4 = 2000;
            [xx1,yy1]=Probepoint(k-1,alpha,h,x,y); %解算探测点坐标
            [xx2,yy2]=Probepoint(k,alpha,h,x,y);   
%%%解算探测点纵坐标，当轮廓函数改变时，随之改变
      if xx1>=100&&xx1<220
        d1=200;
        d2=200;
      elseif xx1>=220&&xx1<290
        d1=(tan(30/180*pi)*(xx1-220)+200);
        d2=(tan(30/180*pi)*(xx2-220)+200);
      elseif xx1>=290&&xx1<370
        d1=(tan(20/180*pi)*(xx1-290)+240);
        d2=(tan(20/180*pi)*(xx2-290)+240);
      elseif xx1>=370&&xx1<450
        d1= (tan(-10/180*pi)*(xx1-370)+269);
        d2= (tan(-10/180*pi)*(xx2-370)+269);
      elseif xx1>=450&&xx1<550
        d1= (tan(-40/180*pi)*(xx1-450)+255);
        d2= (tan(-40/180*pi)*(xx2-450)+255);
      elseif xx1>=550&&xx1<700
        d1= (tan(60/180*pi)*(xx1-550)+171);
        d2= (tan(60/180*pi)*(xx2-550)+171);      
      elseif xx1>=700&&xx1<780
        d1= (tan(-60/180*pi)*(xx1-700)+430);
        d2= (tan(-60/180*pi)*(xx2-700)+430); 
      elseif xx1>=780&&xx1<950
        d1= (tan(1/180*pi)*(xx1-780)+291);
        d2= (tan(1/180*pi)*(xx2-780)+291); 
      elseif xx1>=950&&xx1<1050
        d1= (tan(-30/180*pi)*(xx1-950)+294);
        d2= (tan(-30/180*pi)*(xx2-950)+294); 
      elseif xx1>=1050&&xx1<1080
        d1= (tan(-60/180*pi)*(xx1-1050)+236);
        d2= (tan(-60/180*pi)*(xx2-1050)+236);         
      end%%%解算探测点纵坐标结束

%%%探测点纵坐标与边界纵坐标相比较
        if((yy1>=d1)&&(yy2<=d2))    
            distance=k;
            flag=1;
            break;
        end
        
        
      if xx1>=1050&&xx1<1080
        d3= (tan(70/180*pi)*(xx1-1080)+184);
        d4= (tan(70/180*pi)*(xx2-1080)+184);
      elseif xx1>=989&&xx1<1050
        d3= (tan(30/180*pi)*(xx1-989)+68);
        d4= (tan(30/180*pi)*(xx2-989)+68);        
      elseif xx1>=800&&xx1<989
        d3= (tan(30/180*pi)*(xx1-989)+68);
        d4= (tan(30/180*pi)*(xx2-989)+68);  
      elseif xx1>=550&&xx1<800
        d3= (tan(5/180*pi)*(xx1-800)-41);
        d4= (tan(5/180*pi)*(xx2-800)-41);  
      elseif xx1>=350&&xx1<550
        d3= (tan(-10/180*pi)*(xx1-550)-62);
        d4= (tan(-10/180*pi)*(xx2-550)-62);  
      elseif xx1>=250&&xx1<350
        d3= (tan(-25.5/180*pi)*(xx1-250)+21);
        d4= (tan(-25.5/180*pi)*(xx2-250)+21);   
      elseif xx1>=100&&xx1<250
        d3= (tan(-50/180*pi)*(xx1-100)+200);
        d4= (tan(-50/180*pi)*(xx2-100)+200);  
      end 
        
        
        if((yy1<=d3)&&(yy2>=d4))    
            distance=k;
            flag=1;
            break;
        end
                
        end
%%%k++,进入下一次循环        
    end

    if flag==0
        distance=120;%当声纳探测不到障碍物时，默认为声纳的最大探测距离；
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
    
    

