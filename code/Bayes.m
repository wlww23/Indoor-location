clc;clear;close all;
%----------- init -----------%
map = openfig('map.fig','reuse');
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
    result{i} = [x_bayes y_bayes];
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