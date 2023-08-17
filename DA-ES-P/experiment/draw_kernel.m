x = linspace(-2.5,2.5,100);
y = linspace(-2.5,2.5,100);
[X,Y] = meshgrid(x,y);
Z = Fun(X,Y);
figure
D = 2;
lambda = 7 + floor(3*log(D));
min_popsize = 7 + floor(3*log(D));
% 设置颜色条
% space = 256;
% blue_map = [linspace(1, 0, space)', linspace(1, 0, space)', linspace(1, 0, space)'];% 黑色的RGB值
% colormap(blue_map);

contour(X,Y,Z,"k","LineStyle","-");
hold on;
for seed = 94
    bestmem_set = [0 0];
    bestval_set = [-999];
    bestval = -999;
    color = [219 049 036;255 223 146;075 116 172]/255;
    color = [248 230 032; 053 183 119;048 104 141]/255;
    color = [216 56 58; 150 195 125; 47 127 193]/255;
    algRand = RandStream.create('mt19937ar','seed', seed);
    RandStream.setGlobalStream(algRand);
    xmean1 = [-sqrt(3)/2,-0.5];
    xmean2 = [ sqrt(3)/2,-0.5];
    xmean3 = [ 0,1];
    sigma = 0.5;
    pop1 = xmean1 + sigma*randn(algRand,lambda,2);
    pop2 = xmean2 + sigma*randn(algRand,lambda,2);
    pop3 = xmean3 + sigma*randn(algRand,lambda,2);
    pop = [pop1;pop2;pop3];
    groups = struct();
    for i = 1:3
        groups(i).idx = i;
        groups(i).OPTS.first = 1;
        groups(i).OPTS.pop = pop((i-1)*lambda+1:i*lambda,:);
        groups(i).OPTS.val = Fits(groups(i).OPTS.pop);
        groups(i).xmean = mean(groups(i).OPTS.pop)';
        x = groups(i).OPTS.pop - groups(i).xmean';
        groups(i).OPTS.sigma = 0.5;
        groups(i).OPTS.count = 0;
        groups(i).cc = std(groups(i).OPTS.val);
        [~,index] = sort(groups(i).OPTS.val,"descend");
        groups(i).bestval = max(groups(i).OPTS.val);
        groups(i).bestmem = groups(i).OPTS.pop(index(1),:);
        groups(i).delta = 0;
        groups(i).iters = 0;
    end
    itermax = 1;
    flag = 0;
    iters = 0;
    cc = zeros(1,3);
    while iters<= 30
%         if iters == 0
%             B = eye(D);                                   % B defines the coordinate system
%             d = eye(D);                                   % diagonal matrix D defines the scaling
%             C = B*d*(B*d)';                                 % covariance matrix
%             for k = 1:3
%                 groups(k).OPTS.C = C;
%             end
%         end
        if iters==1
            pre_pop = [groups(1).OPTS.pop;groups(3).OPTS.pop];
            sample_x = randn(20, 2);    % 待估计密度的数据点
            
            x = linspace(-5, 5, 1000)';
            y = linspace(-5, 5, 1000)';
            temp_pop = [x y];
%             denisty = zeros(1000,1000);
%             [XX, YY] = meshgrid(x, y);
%             for i = 1:1000
%                 for j = 1:1000
%                     temp_pop = [x(i) y(j)];
%                     denisty(i,j) = kernel(temp_pop, pre_pop, 2,0);
%                 end
%             end 
%             denisty_matrix = denisty;
%             % 计算二维双峰函数值
%             ZZ = zeros
%             ZZ = bimodal_function(XX, YY);
            % 调用核密度估计函数
            rho_mean = kernel(temp_pop, pre_pop, 2,0); % 假设数据维度为2

            % 创建一个网格来表示 x 和 y 范围
            [x_grid, y_grid] = meshgrid(linspace(min(temp_pop(:,1)), max(temp_pop(:,1)), 100), ...
                linspace(min(temp_pop(:,2)), max(temp_pop(:,2)), 100));

            % 使用 grid 上的点计算对应的密度值
            density_values = kernel([x_grid(:), y_grid(:)], pre_pop, 2,0);

            % 将一维的密度值变形成与网格一样的形状，以便绘制
            density_matrix = reshape(density_values, size(x_grid));
            space = 1024;
            % 创建三维图
            figure;
            blue_map = [linspace(1, 0, space)', linspace(1, 0, space)', linspace(1, 1, space)'];% 纯蓝色的RGB值
            h1 = surf(x_grid, y_grid, density_matrix, 'EdgeColor', 'none',"FaceAlpha",0.5);
            colormap(gca, blue_map); % 使用自定义的蓝色颜色映射
            caxis([min(density_values), max(density_values)]); % 设置颜色映射范围
            hold on;
            contour(X,Y,Z,"k","LineStyle","-");
            hold on;
            draw_ellipse(groups(2),[1 0 0])
%             colormap("autumn");
        end
        if iters~=31
            clf;
            contour(X,Y,Z,"k","LineStyle","-");
            colormap("autumn");
            hold on;
            fprintf('------------iters %d -----------------------\n',iters);
            for k = 1:3
                scatter(groups(k).OPTS.pop(:,1)',groups(k).OPTS.pop(:,2)',"MarkerEdgeColor",color(k,:) ,"LineWidth",2);
                hold on; 
                if iters~=0
                    draw_ellipse(groups(k),color(k,:));
                    scatter(groups(k).xmean(1,:),groups(k).xmean(2,:),"filled","Marker","*","MarkerFaceColor",color(k,:),"MarkerEdgeColor",color(k,:),"SizeData",100);
                    hold on;
                end
            end
           
            t = sprintf("Iters = %d",iters);
            title(t,FontSize=30);
            xlabel('X');
            ylabel('Y');
        end
        for i = 1:3
            if cc(i)==1
                continue;
            end
            new_groups =  ES_test(groups(i), -5, 5, itermax, algRand);
            groups(i) = new_groups;
            if groups(i).cc<=1e-3
                if ~isempty(bestmem_set)
                    dis_arr = pdist2(groups(i).bestmem, bestmem_set);
                    if min(dis_arr) >= 1e-3
                        bestmem_set = [bestmem_set; groups(i).bestmem];
                        bestval_set = [bestval_set; groups(i).bestval];
                        fprintf('---Find the peak at %d iteration!---\n',groups(i).iters);
                    else
                        fprintf('---Find the case!The seed is %d---\n',seed);
                    end
                    cc(i) = 1;

                end
            end
        end
        iters = iters + 1;
    end
 
end
t = sprintf("Iters = %d",iters);
title(t,FontSize=30);
xlabel('X');
ylabel('Y');