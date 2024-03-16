function c2=concave1_wall
%%%%%%%%%%%%%%%%%%%%°¼ÐÍÂÖÀª%%%%%%%%%%%%%%%%%%5

x=180:221;
y = ((100-10)/(200-221))*(x- (200) )+ (100) ;
c2=plot(x,y,'b-.','LineWidth',2);

hold on
axis equal;

x=221:400;
y = ((22-10)/(275-221))*(x- (221) )+ (10) ;
plot(x,y,'b-.','LineWidth',2);

end
