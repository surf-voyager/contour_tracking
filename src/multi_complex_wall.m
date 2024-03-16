function [ Probe_point,mDx,mDy,mDx_max,mDy_max] = multi_complex_wall( x,y,h)
global D2R R2D max__probe_distance
D2R=pi/180;
R2D=180/pi;
%%%%%%%%%%%%%%%%%%������ʼ��%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Probe_point=0; %̽�⵽�����������
distance=0; %��ǰ������̽�⵽�ľ���

mDx=[];mDy=[]; %�洢̽�⵽������������  
mDx_max=[];mDy_max=[];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
for a=-45:1:45  %ģ��ನ�����ŵĿ���
    alpha=a*D2R;
    flag=0; %0δ̽�⵽������1̽�⵽����
    for k=0:.1:max__probe_distance   %����̽����룬������ʽ
        
%%%  ��̽�������
        if k > 1
            d1 = 20000;
            d2 = 20000;

            [xx1,yy1]=Probepoint(k-1,alpha,h,x,y); %����̽�������
            [xx2,yy2]=Probepoint(k,alpha,h,x,y);   
%%%����̽��������꣬�����������ı�ʱ����֮�ı�

%%%%%%%%%%%%%%%%%%%%��������%%%%%%%%%%%%%%%%%%%%%%%%%
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
 %%%����̽������������

%%%̽�����������߽���������Ƚ�
        if((yy1>=d1)&&(yy2<=d2))    
            distance=k;
            flag=1;
            break;
        end

 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%       
       
        end
%%%k++,������һ��ѭ��        
    end

    if flag==0
        distance=max__probe_distance;%������̽�ⲻ���ϰ���ʱ��Ĭ��Ϊ���ɵ����̽����룻
        mDx_max=[mDx_max;xx2];mDy_max=[mDy_max;yy2];

    end
    
    if distance<max__probe_distance
        Probe_point=Probe_point+1; %����̽�������
        mDx=[mDx;xx2];mDy=[mDy;yy2]; %ֻ��������̽��������        
    end

end