function [ Probe_point,mDx,mDy,mDx_max,mDy_max] = multi_concave_wall( x,y,h)
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

%%%%%%%%%%%%%%%%%%%%凹曲线%%%%%%%%%%%%%%%%%%%%%%%%%
      if xx1>=150&xx1<=400
        d1=0.04*(xx1-250).^2;
        d2=0.04*(xx2-250).^2;
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