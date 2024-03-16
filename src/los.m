function [hCom]=los(xCmdlast,yCmdlast,xCmd,yCmd,x,y)
L=6;
  d=((yCmd-y)^2+(xCmd-x)^2)^0.5;
  b=atan2(yCmd-yCmdlast,xCmd-xCmdlast); 
  c=b-atan2(yCmd-y,xCmd-x);
  e=d*sin(c);
  if e<=L&&e>=-L
    f=atan(e/L);
  else
    f=pi/2*sign(e);
  end
  hCom=b-f;
  

