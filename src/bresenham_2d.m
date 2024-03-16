function vPts = bresenham_2d(start_pt,goal_pt)
%%%%%%%%%%%%%%%%%%%%布雷森汉姆算法%%%
dx = abs(goal_pt(1,1) - start_pt(1,1));
dy = abs(goal_pt(1,2) - start_pt(1,2));
x = start_pt(1,1);
y = start_pt(1,2);
 
if (goal_pt(1,1) > start_pt(1,1))
    s1 = 1;
elseif (goal_pt(1,1) < start_pt(1,1))
    s1 = -1;
else
     s1 = 0;   
end
 
if (goal_pt(1,2) > start_pt(1,2))
    s2 = 1;
elseif (goal_pt(1,2) < start_pt(1,2))
    s2 = -1;
else
    s2 = 0;
end
 
if (dy > dx)
    temp = dx;
    dx = dy;
    dy = temp;
    interchange = 1;
else
    interchange = 0;
end
interchange;
p = 2*dy - dx;
vPts = [];
 
for i = 1:dx-1
    if (p >= 0)
        y = y + s2;
        x = x + s1;
        if (interchange == 0)
            p = p + 2*(dy - dx);
        else
            p = p + 2*(dy - dx);
        end
    else
        if (interchange == 0)
            x = x + s1;
            p =  p + 2*dy;
        else
            y = y + s2;
            p = p + 2*dy;
        end
        %p =  p + 2*dy;
    end
    
%     if (Imp(y,x) == 0)
%         disp('obs!');
%         return;
%     end
    
    vPts = [vPts; x,y];
    
% plot(vPts(:,1), vPts(:,2),'b*');
% hold on;
% plot([1,10], [1,9]);
% grid on;

end
 
end
% %  
% % ————————————————
% % 版权声明：本文为CSDN博主「Ruo_su.」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
% % 原文链接：https://blog.csdn.net/qq_44752711/article/details/128042362