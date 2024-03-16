function [ Probe_point,mDx,mDy,mDx_max,mDy_max] = multi_concave_wall( x,y,h)
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

%%%%%%%%%%%%%%%%%%%%������%%%%%%%%%%%%%%%%%%%%%%%%%
      if xx1>=150&xx1<=400
        d1=0.04*(xx1-250).^2;
        d2=0.04*(xx2-250).^2;
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