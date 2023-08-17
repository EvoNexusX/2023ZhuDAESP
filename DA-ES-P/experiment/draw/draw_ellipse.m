function draw_ellipse(group,colormap)
%     % 给定的协方差矩阵
%     C = [0.658575318043691, 0.00186573533446552;
%         0.00186573533446552, 0.684168815256863];
%     
    % 计算协方差矩阵的特征向量和特征值
    C = group.OPTS.C;
    [V, D] = eig(C);
    
    % 提取特征值
    lambda1 = D(1, 1);
    lambda2 = D(2, 2);
    
    % 计算椭圆的长短轴长度和旋转角度
    a = sqrt(lambda1);
    b = sqrt(lambda2);
    angle = atan2(V(2, 1), V(1, 1));
    
    % 参数方程的参数范围
    theta = linspace(0, 2*pi, 100);
    
    % 计算椭圆上的点的坐标
    x = a * cos(theta);
    y = b * sin(theta);
    
    % 旋转椭圆
    rotated_x = x * cos(angle) - y * sin(angle);
    rotated_y = x * sin(angle) + y * cos(angle);
    
    % 绘制椭圆
%     figure;
    plot(group.xmean(1,:)+rotated_x, group.xmean(2,:)+rotated_y, 'LineWidth', 1,"LineStyle","--","Color",[colormap]);
    axis equal;
    
    % 添加标题和轴标签
    title('绘制椭圆');
    xlabel('X 轴');
    ylabel('Y 轴');
    hold on;
end