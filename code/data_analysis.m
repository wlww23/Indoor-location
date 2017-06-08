clc;clear;close all;
%----------- load -----------%
load('a_Area_ap_a_rawdata');
load('a_Area_ap_b_rawdata');
load('a_Area_ap_c_rawdata');
ap_a_kalman = Kalmanfilter(a_Area_ap_a_rawdata);
ap_b_kalman = Kalmanfilter(a_Area_ap_b_rawdata);
ap_c_kalman = Kalmanfilter(a_Area_ap_c_rawdata);
ap_a_gauss = Gaussianfilter(a_Area_ap_a_rawdata);
%--------- analysis ---------%
[m, n] = size(ap_a_kalman);
% i = floor(m * n * rand(1));
i = 60;
x1 = 1:length(ap_a_kalman{i});
y1 = a_Area_ap_a_rawdata{i};
x2 = 1:length(ap_a_gauss{i});
y2 = ap_a_gauss{i};
y3 = ap_a_kalman{i};
figure(1);h = plot(x1, y1, x1, ones(1,length(x1))*sum(y1)/length(y1),'-.', x2, y2, '-o', x1, y3, '-*');axis([0 length(x1)+1 (min(y1)-2) (max(y1)+5)]);
set(h(1), 'LineWidth', 2);set(h(2), 'LineWidth', 2);set(h(3), 'LineWidth', 2);set(h(4), 'LineWidth', 2);
xlabel('Sampling Number');
ylabel('RSS Value(dBm)');
legend('原始', '均值滤波', '高斯滤波', '卡尔曼滤波');

figure(2);h2 = plot(x1, ones(1,length(x1))*sum(y1)/length(y1), '--', x2, y2, '-o', x2, ones(1,length(x2)) * mean(y2));axis([0 length(x1)+1 (min(y1)-2) (max(y1)+5)]);
set(h2(1), 'LineWidth', 2);set(h2(2), 'LineWidth', 2);set(h2(3), 'LineWidth', 2);
xlabel('Sampling Number');
ylabel('RSS Value(dBm)');
legend('原始采样序列均值','高斯滤波采样序列', '高斯滤波后均值');

figure(3);h3 = plot(x1, ones(1,length(x1))*sum(y1)/length(y1), '--', x1, y3, '-o', x1, ones(1,length(x1)) * mean(y3));axis([0 length(x1)+1 (min(y1)-2) (max(y1)+5)]);
set(h3(1), 'LineWidth', 2);set(h3(2), 'LineWidth', 2);set(h3(3), 'LineWidth', 2);
xlabel('Sampling Number');
ylabel('RSS Value(dBm)');
legend('原始采样序列均值','卡尔曼滤波采样序列', '卡尔曼滤波后均值');

ap_a_dev = cell2mat(cellfun(@std, ap_a_kalman, 'UniformOutput', false));
figure(4);
for j = 1:size(ap_a_dev, 1)
    x2 = 1:length(ap_a_dev(1,:));
    y2 = ap_a_dev(j,:);
    subplot(2,2,j);plot(0.8 * x2, y2);title('标准差与距离的关系');
    xlabel('Distance/m');
    ylabel('Standard Deviation');
end

ap_a_skewness = cell2mat(cellfun(@skewness, ap_a_kalman, 'UniformOutput', false));
figure(5);
for k = 1:size(ap_a_skewness, 1)
    x3 = 1:length(ap_a_skewness(1,:));
    y3 = ap_a_skewness(k,:);
    subplot(2,2,k);plot(0.8 * x3, y3);title('偏度与距离的关系');
    xlabel('Distance/m');
    ylabel('Skewness');
end
