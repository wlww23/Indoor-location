clc;clear;close all;
%----------- load -----------%
map = openfig('map.fig','reuse');
load('testpoints');
load('a_radiomapdata_gaussianfilter');
apqty = 3;
k = 3;
result = cell(1,1);
%----------- wknn -----------%
testqty = size(testpoints, 2);
tempcell = cell(size(a_radiomapdata_gaussianfilter));
for i = 1:testqty
    %----------- 计算欧式距离 -----------%
    tempcell(:,:) = {testpoints{i}(2,:)};
    EuclideanDistancecell = cellfun(@(x,y) (x - y).^2, a_radiomapdata_gaussianfilter, tempcell, 'UniformOutput', false);
    EuclideanDistance = sqrt(cellfun(@sum, EuclideanDistancecell));
    %----------- 计算定位结果 -----------%
    [sorted, index] = sort(EuclideanDistance(:));
    [y_index, x_index] = ind2sub(size(a_radiomapdata_gaussianfilter), index);
    y_wknn = sum(y_index(1:k).*(sorted(1:k).^(-1))) / sum(sorted(1:k).^(-1));
    x_wknn = sum(x_index(1:k).*(sorted(1:k).^(-1))) / sum(sorted(1:k).^(-1));
    result{i} = [x_wknn y_wknn]; 
end

%----------- 定位结果图 -----------%
for j = 1:testqty
    x = result{j}(1) - 1;
    y = result{j}(2) - 1;
    xloc = 80 * x;
    if y >= 2
        yloc = 79 + 80 + (y - 2) * 83;
    elseif y >= 1
        yloc = 79 + (y - 1) * 80;
    else
        yloc = 79 * y;
    end
    hold on;
    scatter(xloc, yloc, 20, 'k');
    text(xloc, yloc, num2str(j));
end
