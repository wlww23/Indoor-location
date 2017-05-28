clc;clear;close all;
%----------- init -----------%
map = openfig('testmap.fig','reuse');
load('testpoints');
load('a_radiomapdata_kalman');
load('a_Area_ap_a_rawdata');
load('a_Area_ap_b_rawdata');
load('a_Area_ap_c_rawdata');
ap_a_kalman = Kalmanfilter(a_Area_ap_a_rawdata);
ap_b_kalman = Kalmanfilter(a_Area_ap_b_rawdata);
ap_c_kalman = Kalmanfilter(a_Area_ap_c_rawdata);
ap_a_mu = cellfun(@mean, ap_a_kalman, 'UniformOutput', false);
ap_a_mu = cellfun(@(x,y,z) [x y z], ap_a_mu, ap_a_mu, ap_a_mu, 'UniformOutput', false);
ap_b_mu = cellfun(@mean, ap_b_kalman, 'UniformOutput', false);
ap_b_mu = cellfun(@(x,y,z) [x y z], ap_b_mu, ap_b_mu, ap_b_mu, 'UniformOutput', false);
ap_c_mu = cellfun(@mean, ap_c_kalman, 'UniformOutput', false);
ap_c_mu = cellfun(@(x,y,z) [x y z], ap_c_mu, ap_c_mu, ap_c_mu, 'UniformOutput', false);
ap_a_sigma = cellfun(@std, ap_a_kalman, 'UniformOutput', false);
ap_a_sigma = cellfun(@(x,y,z) [x y z], ap_a_sigma, ap_a_sigma, ap_a_sigma, 'UniformOutput', false);
ap_b_sigma = cellfun(@std, ap_b_kalman, 'UniformOutput', false);
ap_b_sigma = cellfun(@(x,y,z) [x y z], ap_b_sigma, ap_b_sigma, ap_b_sigma, 'UniformOutput', false);
ap_c_sigma = cellfun(@std, ap_c_kalman, 'UniformOutput', false);
ap_c_sigma = cellfun(@(x,y,z) [x y z], ap_c_sigma, ap_c_sigma, ap_c_sigma, 'UniformOutput', false);
apqty = 3;
k = 3;
[m, n] = size(a_radiomapdata_kalman);
testqty = size(testpoints, 2);
result = cell(1,1);

%---------- bayes -----------%
for i = 1:testqty
    tempcell(1:m,1:n) = {testpoints{i}(2,:)};
    P_siLi = cellfun(@(x,y,z) (1 ./ (sqrt(2 * pi) * z)) .* exp(-(x - y) .^ 2 ./ (2 * z .^ 2)), tempcell, ap_a_mu, ap_a_sigma, 'UniformOutput', false);
    P_SLi = cell2mat(cellfun(@prod, P_siLi, 'UniformOutput', false));
    P_S = sum(sum(P_SLi));
    P_LiS = P_SLi / P_S;
    %----------- 计算定位结果 -----------%
    % [sorted, index] = sort(P_LiS(:));
    [x_index, y_index] = meshgrid(1:n, 1:m);
    x_bayes = sum(sum(x_index .* P_LiS));
    y_bayes = sum(sum(y_index .* P_LiS));
    result{2,i} = x_bayes;
    result{3,i} = y_bayes;
end
%----------- 定位结果图 -----------%
[xreal, yreal] = realposition(cell2mat(result(2:3,:)));   
hold on;
plot(xreal, yreal, 'k^', 'MarkerSize', 7, 'MarkerFaceColor','k');
text(xreal + 10, yreal + 10, num2cell(1:size(xreal,2)));

%---------- 计算误差分布 ----------%
xtest = 0:80:22*80;
ytest = 79*ones(1,23);
error_bayes = sqrt((xtest/100 - xreal/100).^2 + (ytest/100 - yreal/100).^2);
save('error_bayes', 'error_bayes');
error_avg = mean(error_bayes)
error_std = std(error_bayes)
error_min = min(error_bayes)
error_max = max(error_bayes)