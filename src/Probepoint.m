function [point_X,point_Y] = Probepoint(sonar,sonar_Degree,h,X_l,Y_l)
% ��ȡ̽������꺯��
global D2R R2D
D2R=pi/180;
R2D=180/pi;
point_X = sonar*cos(sonar_Degree+h) + X_l;
point_Y = sonar*sin(sonar_Degree+h) + Y_l;
%% ��ȷ��
% point_Y=roundn(point_Y,-2);
% point_X=roundn(point_X,-2);
end