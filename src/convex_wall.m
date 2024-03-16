function c2=convex_wall
%%%%%%%%%%%%%%%%%%%%%5凸型轮廓%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% xx1=150:213;
% d1=ones(1,64)*201;
% c2=plot(xx1,d1,'b-.','LineWidth',2);
hold on
xx1=200:300;  %%213,201  287,201
d1=300*exp(-(xx1-250).^2/2/1000)+50;
c2=plot(xx1,d1,'k-','LineWidth',2);
% xx1=287:400;   
% d1=ones(1,114)*201;
% plot(xx1,d1,'b-.','LineWidth',2);

box on
grid on
axis([100 400 0 400]);
set(gca,'ytick',-500:50:500);
set(gca,'xtick',-500:50:2000);
legend('复杂轮廓');
xlabel('北向X（米）');
ylabel('东向Y（米）');
end