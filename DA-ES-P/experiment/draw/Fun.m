% 定义双峰函数
function z = Fun(x, y)
% 两个峰的中心点
peak1 = [0, 1];
peak2 = [-sqrt(3)/2,-1/2];
peak3 = [ sqrt(3)/2,-1/2];
% 两个峰的方差，控制峰的宽度
sigma1 = 0.5;
sigma2 = 0.5;
sigma3 = 0.5;
% 计算高斯分布函数
z = 1/(2*pi*sigma1*sigma2) * exp(-((x-peak1(1)).^2/(2*sigma1^2) + (y-peak1(2)).^2/(2*sigma2^2)))...
    + 1/(2*pi*sigma1*sigma2) * exp(-((x-peak2(1)).^2/(2*sigma1^2) + (y-peak2(2)).^2/(2*sigma2^2)))...
    + 1/(2*pi*sigma1*sigma2) * exp(-((x-peak3(1)).^2/(2*sigma1^2) + (y-peak3(2)).^2/(2*sigma2^2)));
z = 450*z;
end