function [partical,Destination_fitness,points] = hgs_main(LB,UB,n,dim,fes)
%%%%%%%首个路径段长度和首个航向  适应度值 所有路径点和航向%%%%%%%%%
global R_path_piont 
%只回传一个路径点
% r_path_piont = Rasterize_1(R_path_piont(1),R_path_piont(2),1,0); 
N=n; 
Function_name='F1'; 
FEs=fes; 
dimSize = dim;   

fobj=Get_Functions_HGS(Function_name);
lb = LB;
ub = UB;

[Destination_fitness,bestPositions,Convergence_curve]=HGS(N,FEs,lb,ub,dimSize,fobj);

partical(1) = bestPositions(1);
partical(2) = bestPositions(1+dimSize/2);

len = size(bestPositions,2)/2;
for c1=1:len
    if 1 == c1
        next_path_x(c1) = R_path_piont(1)+bestPositions(1)*cos(bestPositions(c1+len)); %x2=x1+lcos(theta)
        next_path_y(c1) = R_path_piont(2)+bestPositions(1)*sin(bestPositions(c1+len)); %y2=y1+lsin(theta)
    else
        next_path_x(c1) = next_path_x(c1-1)+bestPositions(c1)*cos(bestPositions(c1+len));
        next_path_y(c1) = next_path_y(c1-1)+bestPositions(c1)*sin(bestPositions(c1+len)); 
    end
    points(c1*2-1) = next_path_x(c1);
    points(c1*2) = next_path_y(c1);
end
points(dimSize+1:dimSize+len) =bestPositions(len+1:end);  %%[x1 y1 x2 y2 ...xn yn h1 h2...hn]
%Draw objective space
% figure(7),
% hold on
% semilogy(Convergence_curve,'Color','b','LineWidth',1);
% title('收敛曲线')
% xlabel('迭代次数');
% ylabel('历史评价值');
% axis tight
% grid off
% box on
% legend('HGS')
% % % figure(2)
% % % hold on
% % % plot(next_path_x,next_path_y,'*');
% % % hold off
% hold on
% plot(r_path_piont(1),r_path_piont(2),'gp');
% plot(Reference_point(1),Reference_point(2),'bo');
% 
% grid on
% disp('-----------------------------');
display(['The best location of HGS_x is: ', num2str(bestPositions(1:end))]);
display(['The best fitness of HGS is: ', num2str(Destination_fitness)]);
disp(newline);


