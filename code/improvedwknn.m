clc;clear;close all;
%-------- load & init--------%
map = openfig('map.fig','reuse');
load('testpoints');
load('a_radiomapdata_kalman');
apqty = 3;
k = 3;
weight = 0.8;
result = cell(1,1);
lastpoint = a_radiomapdata_kalman{1};
%-------improved wknn -------%
testqty = size(testpoints, 2);
tempcell = cell(size(a_radiomapdata_kalman));
for i = 1:testqty
    %----------- 计算欧式距离 -----------%
    tempcell(:,:) = {testpoints{i}(2,:)};
    EuclideanDistancecell = cellfun(@(x,y) (x - y).^2, a_radiomapdata_kalman, tempcell, 'UniformOutput', false);
    EuclideanDistance = sqrt(cellfun(@sum, EuclideanDistancecell));
    %----------- 判断目标区域 -----------%
    [sorted, index] = sort(EuclideanDistance(:));
    [y_index, x_index] = ind2sub(size(a_radiomapdata_kalman), index);
    y_wknn = sum(y_index(1:k).*(sorted(1:k).^(-1))) / sum(sorted(1:k).^(-1));
    x_wknn = sum(x_index(1:k).*(sorted(1:k).^(-1))) / sum(sorted(1:k).^(-1));
    if i == 1
        result{i} = [x_wknn y_wknn];
        continue;
    elseif (1 <= x_wknn) && (x_wknn <= 23)
        diff = testpoints{i} - testpoints{i-1};
        diff(1) = -diff(1);
    else
    end
    %----------- 计算定位结果 -----------%
    [sorted, index] = sort(EuclideanDistance(:));
    [y_index, x_index] = ind2sub(size(a_radiomapdata_kalman), index);
    if sum(diff(:)>0) >= 2
        x_boundary = floor(result{i-1}(1));
        lowweight = sorted(x_index <= x_boundary);
        highweight = sorted(x_index > x_boundary);
        x_lw = x_index(x_index <= x_boundary);
        x_hw = x_index(x_index > x_boundary);
        y_lw = y_index(x_index <= x_boundary);
        y_hw = y_index(x_index > x_boundary);
        x_wknnpro = (1 - weight) * sum(x_lw(1:k).*(lowweight(1:k).^(-1))) / sum(lowweight(1:k).^(-1)) + weight * sum(x_hw(1:k).*(highweight(1:k).^(-1))) / sum(highweight(1:k).^(-1));
        y_wknnpro = (1 - weight) * sum(y_lw(1:k).*(lowweight(1:k).^(-1))) / sum(lowweight(1:k).^(-1)) + weight * sum(y_hw(1:k).*(highweight(1:k).^(-1))) / sum(highweight(1:k).^(-1));
    else
        x_boundary = ceil(result{i-1}(1));
        lowweight = sorted(x_index >= x_boundary);
        highweight = sorted(x_index < x_boundary);
        x_lw = x_index(x_index >= x_boundary);
        x_hw = x_index(x_index < x_boundary);
        y_lw = y_index(x_index >= x_boundary);
        y_hw = y_index(x_index < x_boundary);
        x_wknnpro = (1 - weight) * sum(x_lw(1:k).*(lowweight(1:k).^(-1))) / sum(lowweight(1:k).^(-1)) + weight * sum(x_hw(1:k).*(highweight(1:k).^(-1))) / sum(highweight(1:k).^(-1));
        y_wknnpro = (1 - weight) * sum(y_lw(1:k).*(lowweight(1:k).^(-1))) / sum(lowweight(1:k).^(-1)) + weight * sum(y_hw(1:k).*(highweight(1:k).^(-1))) / sum(highweight(1:k).^(-1));
    end
    result{i} = [x_wknnpro y_wknnpro];
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