%%%%%%%%%%%%%%%%%%%%%%%平滑边界%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % h=80;%曲线高度
% % s=0.02;%曲线坡度
% % a=200;%中心点横坐标
% % x2=111.8.*(y2>=0&y2<=100)+(h*atan(0.02*(y2-200))+200).*(y2>100&y2<=300)+288.6.*(y2>300&y2<=500);
%       if yy1>=0&yy1<=100
%         d1=111.8;
%         d2=111.8;
%       elseif yy1>=100&yy1<300
%         d1=80*atan(0.02*(yy1-200))+200;
%         d2=80*atan(0.02*(yy2-200))+200;
%       else
%         d1=288.6;
%         d2=288.6;
%       end
%%%%%%%%%%%%%%%%%%%%%%%%%%凹型边界%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % % % % y0=250;
% % % % % a=0.03;
% % % % % x2=(-(0.0065*y2.^2)+440.205).*(y2>=0&y2<=150)+a*(y2-y0).^2.*(y2>150&y2<=350)+(10*(y2-350).^0.55+294).*(y2>350&y2<=500);
% x2=(-(0.004*y2.^2)+304.105).*(y2>=0&y2<=200)+0.06*(y2-250).^2.*(y2>200&y2<=300)+(10*(y2-300).^0.55+135.4).*(y2>300&y2<=500);

%       if yy1>=0&yy1<=500
%         d1=0.04*(yy1-250).^2;
%         d2=0.04*(yy2-250).^2;
%       end
%%%%%%%%%%%%%%%%%%%%%%%%%%凸型边界%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % % % y0=250;
% % % % h=300;
% % % % s=1000;
% % % % x2=50.*(y2>=0&y2<=100)+h*exp(-(y2-y0).^2/2/s)+50.*(y2>100&y2<=350)+50.*(y2>350&y2<=500);
%       if yy1>=0&yy1<=100
%         d1=50;
%         d2=50;
%       elseif yy1>100&yy1<=350
%         d1=300*exp(-(yy1-250).^2/2/1000)+50;
%         d2=300*exp(-(yy2-250).^2/2/1000)+50;
%       else
%         d1=50;
%         d2=50;
%       end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%