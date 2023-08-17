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