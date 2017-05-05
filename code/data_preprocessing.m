clc;clear;close all;
%----------- load -----------%
load('a_Area_ap_a_rawdata');
load('a_Area_ap_b_rawdata');
load('a_Area_ap_c_rawdata');
%--------- analysis ---------%
[m, n] = size(a_Area_ap_a_rawdata);
i = floor(m * n * rand(1));
x1 = 1:length(a_Area_ap_a_rawdata{i});
y1 = a_Area_ap_a_rawdata{i};
figure(1);plot(x1, y1, x1, ones(1,length(x1))*sum(y1)/length(y1), '-r');axis([0 length(x1) (min(y1)-10) (max(y1)+10)]);title('RSSI');
xlabel('N');
ylabel('RSSI(db)');

ap_a_dev = cell2mat(cellfun(@std, a_Area_ap_a_rawdata, 'UniformOutput', false));
figure(2);
for j = 1:size(ap_a_dev, 1)
    x2 = 1:length(ap_a_dev(1,:));
    y2 = ap_a_dev(j,:);
    subplot(2,2,j);plot(x2,y2);title('标准差与距离的关系');
    xlabel('Distance');
    ylabel('Standard Deviation');
end

ap_a_skewness = cell2mat(cellfun(@skewness, a_Area_ap_a_rawdata, 'UniformOutput', false));
figure(3);
for k = 1:size(ap_a_skewness, 1)
    x3 = 1:length(ap_a_skewness(1,:));
    y3 = ap_a_skewness(k,:);
    subplot(2,2,k);plot(x3,y3);title('偏度与距离的关系');
    xlabel('Distance');
    ylabel('Skewness');
end
