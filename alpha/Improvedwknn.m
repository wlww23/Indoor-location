function result = Improvedwknn(testdata, radiomap)
%----------- init -----------%
k = 3;
weight = 0.8;
result = cell(1,1);
%-------improved wknn -------%
testqty = size(testdata, 2);
tempcell = cell(size(radiomap));
for i = 1:testqty
    %----------- 计算欧式距离 -----------%
    tempcell(:,:) = testdata(2,i);
    EuclideanDistancecell = cellfun(@(x,y) (x - y).^2, radiomap, tempcell, 'UniformOutput', false);
    EuclideanDistance = sqrt(cellfun(@sum, EuclideanDistancecell));
    %----------- 判断目标区域 -----------%
    [sorted, index] = sort(EuclideanDistance(:));
    [y_index, x_index] = ind2sub(size(radiomap), index);
    y_wknn = sum(y_index(1:k).*(sorted(1:k).^(-1))) / sum(sorted(1:k).^(-1));
    x_wknn = sum(x_index(1:k).*(sorted(1:k).^(-1))) / sum(sorted(1:k).^(-1));
    if i == 1
        result{1,i} = cell2mat(testdata{1,i});
        result{2,i} = x_wknn;
        result{3,i} = y_wknn;
        continue;
    elseif (1 <= x_wknn) && (x_wknn <= 23)
        diff = testdata{2, i} - testdata{2, i-1};
        diff(1) = -diff(1);
    else
        diff = testdata{2, i} - testdata{2, i-1};
        diff(1) = -diff(1);
        diff(2) = -diff(2);
    end
    %----------- 计算定位结果 -----------%
    [sorted, index] = sort(EuclideanDistance(:));
    [y_index, x_index] = ind2sub(size(radiomap), index);
    if sum(diff(:)>0) >= 2
        x_boundary = floor(result{2, i-1}(1));
        lowweight = sorted(x_index <= x_boundary);
        highweight = sorted(x_index > x_boundary);
        x_lw = x_index(x_index <= x_boundary);
        x_hw = x_index(x_index > x_boundary);
        y_lw = y_index(x_index <= x_boundary);
        y_hw = y_index(x_index > x_boundary);
        x_wknnpro = (1 - weight) * sum(x_lw(1:k).*(lowweight(1:k).^(-1))) / sum(lowweight(1:k).^(-1)) + weight * sum(x_hw(1:k).*(highweight(1:k).^(-1))) / sum(highweight(1:k).^(-1));
        y_wknnpro = (1 - weight) * sum(y_lw(1:k).*(lowweight(1:k).^(-1))) / sum(lowweight(1:k).^(-1)) + weight * sum(y_hw(1:k).*(highweight(1:k).^(-1))) / sum(highweight(1:k).^(-1));
    else
        x_boundary = ceil(result{2, i-1}(1));
        lowweight = sorted(x_index >= x_boundary);
        highweight = sorted(x_index < x_boundary);
        x_lw = x_index(x_index >= x_boundary);
        x_hw = x_index(x_index < x_boundary);
        y_lw = y_index(x_index >= x_boundary);
        y_hw = y_index(x_index < x_boundary);
        x_wknnpro = (1 - weight) * sum(x_lw(1:k).*(lowweight(1:k).^(-1))) / sum(lowweight(1:k).^(-1)) + weight * sum(x_hw(1:k).*(highweight(1:k).^(-1))) / sum(highweight(1:k).^(-1));
        y_wknnpro = (1 - weight) * sum(y_lw(1:k).*(lowweight(1:k).^(-1))) / sum(lowweight(1:k).^(-1)) + weight * sum(y_hw(1:k).*(highweight(1:k).^(-1))) / sum(highweight(1:k).^(-1));
    end
    result{1,i} = cell2mat(testdata{1,i});
    result{2,i} = x_wknnpro;
    result{3,i} = y_wknnpro;
end
end