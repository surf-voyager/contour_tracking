function c2=complex_wall
%%%%%%%%%%%%%%%%%复杂轮廓%%%%%%%%%%%%%55
xx1=0:100;
        d1=50*atan(0.1*xx1-5)+200;
c2=plot(xx1,d1,'b-.','LineWidth',2);
hold on
xx1=100:150;
        d1=-(0.008*(xx1-75).^2)+273.655;
plot(xx1,d1,'b-.','LineWidth',2);
xx1=150:200;
        d1=-10*(xx1-150).^0.5+228.8;
plot(xx1,d1,'b-.','LineWidth',2);
xx1=200:300;
        d1= 0.005*(xx1-174).^2+155.1525;
plot(xx1,d1,'b-.','LineWidth',2);
xx1=300:400;
        d1= 0.1*xx1+203.245;
plot(xx1,d1,'b-.','LineWidth',2);
xx1=400:500;
        d1=-50*atan(xx1-450)+165.61;
plot(xx1,d1,'b-.','LineWidth',2);
axis([0,500,0,400])
grid on
axis equal
xlabel('北向X（米 ）');
ylabel('东向Y（米）');

end