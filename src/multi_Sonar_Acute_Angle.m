function [ Probe_point,mDx,mDy] = multi_Sonar_Acute_Angle( x,y,h)
global D2R R2D
D2R=pi/180;
R2D=180/pi;
%%%%%%%%%%%%%%%%%%������ʼ��%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Probe_point=0; %̽�⵽�����������
distance=0; %��ǰ������̽�⵽�ľ���
mDx=[];mDy=[]; %�洢̽�⵽������������
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
for a=-60:1:60  %ģ��ನ�����ŵĿ���
    alpha=a*D2R;
    flag=0; %0δ̽�⵽������1̽�⵽����
    for k=0:1:120   %����̽����룬������ʽ
        
%%%  ��̽�������
        if k > 1
            d1 = 2000;
            d2 = 2000;
            d3 = 2000;
            d4 = 2000;
            [xx1,yy1]=Probepoint(k-1,alpha,h,x,y); %����̽�������
            [xx2,yy2]=Probepoint(k,alpha,h,x,y);   
%%%����̽��������꣬�����������ı�ʱ����֮�ı�
      if xx1>=100&&xx1<200
        d1=200;
        d2=200;
      end%%%����̽������������

%%%̽�����������߽���������Ƚ�
        if((yy1>=d1)&&(yy2<=d2))    
            distance=k;
            flag=1;
            break;
        end
        
        
      if xx1>=100&&xx1<200
        d3= 200;
        d4= 200;       
      end 
        
        
        if((yy1<=d3)&&(yy2>=d4))    
            distance=k;
            flag=1;
            break;
        end
                
        end
%%%k++,������һ��ѭ��        
    end

    if flag==0
        distance=120;%������̽�ⲻ���ϰ���ʱ��Ĭ��Ϊ���ɵ����̽����룻
    end
    
    if distance<120
        Probe_point=Probe_point+1; %����̽�������
        mDx=[mDx;xx2];mDy=[mDy;yy2]; %ֻ��������̽��������
    end
    %%%���ſ��Ƕ���++,������һ��ѭ��
%     if 45==a
%         hold off
%     end
    
end
    
    