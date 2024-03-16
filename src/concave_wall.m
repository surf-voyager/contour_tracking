function c2=concave_wall
%%%%%%%%%%%%%%%%%%%%凹型轮廓%%%%%%%%%%%%%%%%%%5
xx1=185:315;
d1=0.04*(xx1-250).^2;
c2=plot(xx1,d1,'k-','LineWidth',2);
hold on
axis equal;

box on
grid on
% axis([100 450 -50 250]);
set(gca,'ytick',-500:50:500);
set(gca,'xtick',-500:50:2000);
legend('凹型轮廓');
xlabel('北向X（米）');
ylabel('东向Y（米）');
end