function [ Probe_point,mDx,mDy,mDx_max,mDy_max] = multi_complex_wall( x,y,h)
global D2R R2D max__probe_distance
D2R=pi/180;
R2D=180/pi;
%%%%%%%%%%%%%%%%%%变量初始化%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Probe_point=0; %探测到轮廓点的数量
distance=0; %当前单波束探测到的距离

mDx=[];mDy=[]; %存储探测到的轮廓点坐标  
mDx_max=[];mDy_max=[];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
for a=-45:1:45  %模拟多波束声呐的开角
    alpha=a*D2R;
    flag=0; %0未探测到轮廓，1探测到轮廓
    for k=0:.1:max__probe_distance   %声呐探测距离，射线形式
        
%%%  求探测点坐标
        if k > 1
            d1 = 20000;
            d2 = 20000;

            [xx1,yy1]=Probepoint(k-1,alpha,h,x,y); %解算探测点坐标
            [xx2,yy2]=Probepoint(k,alpha,h,x,y);   
%%%解算探测点纵坐标，当轮廓函数改变时，随之改变

%%%%%%%%%%%%%%%%%%%%复杂曲线%%%%%%%%%%%%%%%%%%%%%%%%%
      if xx1>=0&xx1<100
        d1=50*atan(0.1*xx1-5)+200;
        d2=50*atan(0.1*xx2-5)+200;
      elseif xx1>=100&xx1<150
        d1=-(0.008*(xx1-75).^2)+273.655;
        d2=-(0.008*(xx2-75).^2)+273.655;
      elseif xx1>=150&xx1<200
        d1=-10*(xx1-150).^0.5+228.8;
        d2=-10*(xx2-150).^0.5+228.8;
      elseif xx1>=200&xx1<300
        d1= 0.005*(xx1-174).^2+155.1525;
        d2= 0.005*(xx2-174).^2+155.1525;
      elseif xx1>=300&xx1<400
        d1= 0.1*xx1+203.245;
        d2= 0.1*xx2+203.245;
      elseif xx1>=400&xx1<500
        d1=-50*atan(xx1-450)+165.61;
        d2=-50*atan(xx2-450)+165.61;
      end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
 %%%解算探测点纵坐标结束

%%%探测点纵坐标与边界纵坐标相比较
        if((yy1>=d1)&&(yy2<=d2))    
            distance=k;
            flag=1;
            break;
        end

 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%       
       
        end
%%%k++,进入下一次循环        
    end

    if flag==0
        distance=max__probe_distance;%当声纳探测不到障碍物时，默认为声纳的最大探测距离；
        mDx_max=[mDx_max;xx2];mDy_max=[mDy_max;yy2];

    end
    
    if distance<max__probe_distance
        Probe_point=Probe_point+1; %计算探测点数量
        mDx=[mDx;xx2];mDy=[mDy;yy2]; %只保存声呐探测点的坐标        
    end

end