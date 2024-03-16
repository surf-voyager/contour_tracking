function [ Probe_point,mDx,mDy,mDx_max,mDy_max] = multi_Sonar_gangchi( x,y,h)
global D2R R2D
D2R=pi/180;
R2D=180/pi;
%%%%%%%%%%%%%%%%%%变量初始化%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Probe_point=0; %探测到轮廓点的数量
distance=0; %当前单波束探测到的距离
max__probe_distance = 60;
mDx=[];mDy=[]; %存储探测到的轮廓点坐标  
mDx_max=[];mDy_max=[];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
for a=-45:1:45  %模拟多波束声呐的开角
    alpha=a*D2R;
    flag=0; %0未探测到轮廓，1探测到轮廓
    for k=0:.5:max__probe_distance   %声呐探测距离，射线形式
        
%%%  求探测点坐标
        if k > 1
            d1 = 20000;
            d2 = 20000;
            d3 = 20000;
            d4 = 20000;

            [xx1,yy1]=Probepoint(k-1,alpha,h,x,y); %解算探测点坐标
            [xx2,yy2]=Probepoint(k,alpha,h,x,y);   
%%%解算探测点纵坐标，当轮廓函数改变时，随之改变
      if xx1>=440&&xx1<488
          in_flag=1;
        d1=((82-115)/(440-488))*(xx1- (488) )+ (115) ;
        d2=((82-115)/(440-488))*(xx2- (488) )+ (115) ;
      elseif xx1>=488&&xx1<570
          in_flag=2;
        d1=((205-115)/(570-488))*(xx1- (488) )+ (115)  ;
        d2=((205-115)/(570-488))*(xx2- (488) )+ (115)  ;
      elseif xx1>=570&&xx1<640
          in_flag=3;
        d1=((205-320)/(570-640))*(xx1- (640) )+ (320);
        d2=((205-320)/(570-640))*(xx2- (640) )+ (320);
      elseif xx1>=0&&xx1<10
          in_flag=4;
        d1=((440-392)/(0-10))*(xx1- (10) )+ (392);
        d2=((440-392)/(0-10))*(xx2- (10) )+ (392);
      elseif xx1>=10&&xx1<26
          in_flag=5;
        d1=((342-392)/(26-10))*(xx1- (10) )+ (392);
        d2=((342-392)/(26-10))*(xx2- (10) )+ (392);
      elseif xx1>=26&&xx1<50
          in_flag=6;
        d1=((342-295)/(26-50))*(xx1- (50) )+ (295);
        d2=((342-295)/(26-50))*(xx2- (50) )+ (295);      
      elseif xx1>=50&&xx1<108
          in_flag=7;
        d1=((230-295)/(108-50))*(xx1- (50) )+ (295);
        d2=((230-295)/(108-50))*(xx2- (50) )+ (295); 
      elseif xx1>=108&&xx1<192
          in_flag=8;
        d1=((230-175)/(108-192))*(xx1- (192) )+ (175);
        d2=((230-175)/(108-192))*(xx2- (192) )+ (175); 
      elseif xx1>=192&&xx1<275
          in_flag=9;
        d1=((148-175)/(275-192))*(xx1- (192) )+ (175);
        d2=((148-175)/(275-192))*(xx2- (192) )+ (175);       
      elseif xx1>=275&&xx1<336
          in_flag=10;
        d1=((148-140)/(275-336))*(xx1- (336) )+ (140);
        d2=((148-140)/(275-336))*(xx2- (336) )+ (140);         
      elseif xx1>=336&&xx1<405
          in_flag=11;
        d1=((150-140)/(405-336))*(xx1- (336) )+ (140);
        d2=((150-140)/(405-336))*(xx2- (336) )+ (140);         
      elseif xx1>=405&&xx1<410
          in_flag=12;
        d1=((150-138)/(405-410))*(x- (410) )+ (138);
        d2=((150-138)/(405-410))*(x- (410) )+ (138);  
        
      end%%%解算探测点纵坐标结束

%%%探测点纵坐标与边界纵坐标相比较
        if((yy1>=d1)&&(yy2<=d2))    
            distance=k;
            flag=1;
            break;
        end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  

 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
   
      if xx1>=484&&xx1<640
          in_flag=13;
        d3=((613-320)/(484-640))*(xx1- (640) )+ (320);
        d4=((613-320)/(484-640))*(xx2- (640) )+ (320);
      elseif xx1>=348&&xx1<484
          in_flag=14;
        d3= ((613-528)/(484-348))*(xx1- (348) )+ (528);
        d4= ((613-528)/(484-348))*(xx2- (348) )+ (528); 
      elseif xx1>=298&&xx1<348
          in_flag=15;
        d3= ((514-528)/(298-348))*(xx1- (348) )+ (528);
        d4= ((514-528)/(298-348))*(xx2- (348) )+ (528);          
      elseif xx1>=294&&xx1<298
          in_flag=16;
        d3= ((514-522)/(298-294))*(xx1- (294) )+ (522);
        d4= ((514-522)/(298-294))*(xx2- (294) )+ (522);         
      elseif xx1>=230&&xx1<294
          in_flag=17;
        d3= ((495-522)/(230-294))*(xx1- (294) )+ (522);
        d4= ((495-522)/(230-294))*(xx2- (294) )+ (522);            
      elseif xx1>=213&&xx1<230
          in_flag=18;
        d3= ((495-500)/(230-213))*(xx1- (213) )+ (500);
        d4= ((495-500)/(230-213))*(xx2- (213) )+ (500);         
      elseif xx1>=180&&xx1<213
          in_flag=19;
        d3= ((540-500)/(180-213))*(xx1- (180) )+ (540);
        d4= ((540-500)/(180-213))*(xx2- (180) )+ (540);       
      elseif xx1>=110&&xx1<180
          in_flag=20;
        d3= ((540-487)/(180-110))*(xx1- (180) )+ (540);
        d4= ((540-487)/(180-110))*(xx2- (180) )+ (540);        
      elseif xx1>=90&&xx1<110
          in_flag=21;
        d3= ((525-487)/(90-110))*(xx1- (110) )+ (487);
        d4= ((525-487)/(90-110))*(xx2- (110) )+ (487);         
      elseif xx1>=7&&xx1<90
          in_flag=22;
        d3= ((525-475)/(90-7))*(xx1- (7) )+ (475);
        d4= ((525-475)/(90-7))*(xx2- (7) )+ (475);        
      elseif xx1>=0&&xx1<7
          in_flag=23;
        d3= ((440-475)/(0-7))*(xx1- (7) )+ (475);
        d4= ((440-475)/(0-7))*(xx2- (7) )+ (475);         
      end 
        
        
        if((yy1<=d3)&&(yy2>=d4))    
            distance=k;
            flag=1;
            break;
        end
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%       
       
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
    %%%声呐开角度数++,进入下一次循环
%     if 45==a
%         hold off
%     end
    
end