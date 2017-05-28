clc;clear;close all;
%----------- load -----------%
map = openfig('testmap.fig','reuse');
load('testpoints');
load('radiomap_kalman');
apqty = 3;
k = 3;
result = cell(1,1);
%----------- wknn -----------%
testqty = size(testpoints, 2);
tempcell = cell(size(radiomap_kalman));
for i = 1:testqty
    %----------- 计算欧式距离 -----------%
    tempcell(:,:) = {testpoints{i}(2,:)};
    EuclideanDistancecell = cellfun(@(x,y) (x - y).^2, radiomap_kalman, tempcell, 'UniformOutput', false);
    EuclideanDistance = sqrt(cellfun(@sum, EuclideanDistancecell));
    %----------- 计算定位结果 -----------%
    [sorted, index] = sort(EuclideanDistance(:));
    [y_index, x_index] = ind2sub(size(radiomap_kalman), index);
    y_wknn = sum(y_index(1:k).*(sorted(1:k).^(-1))) / sum(sorted(1:k).^(-1));
    x_wknn = sum(x_index(1:k).*(sorted(1:k).^(-1))) / sum(sorted(1:k).^(-1));
    result{2,i} = x_wknn;
    result{3,i} = y_wknn;
end

%----------- 定位结果图 -----------%
[xreal, yreal] = realposition(cell2mat(result(2:3,:)));   
hold on;
plot(xreal, yreal, 'k^', 'MarkerSize', 7, 'MarkerFaceColor','k');
text(xreal + 10, yreal + 10, num2cell(1:size(xreal,2)));

%---------- 计算误差分布 ----------%
xtest = 0:80:22*80;
ytest = 79*ones(1,23);
error_wknn = sqrt((xtest/100 - xreal/100).^2 + (ytest/100 - yreal/100).^2);
save('error_wknn', 'error_wknn');
error_avg = mean(error_wknn)
error_std = std(error_wknn)
error_min = min(error_wknn)
error_max = max(error_wknn)
