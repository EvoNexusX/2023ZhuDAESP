x = linspace(-5,5,100);
y = linspace(-5,5,100);
[X,Y] = meshgrid(x,y);
Z = Fun(X,Y);
figure;

% 设置颜色条
space = 256;
blue_map = [linspace(1, 0, space)', linspace(1, 0, space)', linspace(1, 1, space)'];% 渐变蓝的RGB值
colormap(blue_map);

surf(X,Y,Z,"FaceAlpha",0.5,"LineStyle","none");
title('Fig2.');
xlabel('X');
ylabel('Y');