clc;clear;close all;
load('rawdata_wifi_c14-a19_45.mat');
load('rawdata_accl.mat');
load('rawdata_attitude.mat');
load('radiomap_kalman.mat');
map = openfig('map.fig','reuse');

[pdrtime, stepsize, stepvelocity] = PDR(rawdata_accl, rawdata_attitude);%迈步时刻，步长，步速
wifiresult = Improvedwknn(rawdata_wifi, radiomap_kalman);
[a,locs] = ismember(wifiresult(1,:), pdrtime);
n = 0; 
distance = zeros(1, length(locs));
velocity = zeros(1, length(locs));
time = zeros(1, length(locs));
for i = 1:length(locs)
    if locs(i) ~= 0 && locs(i) ~= 1
        distance(i) = sum(stepsize((n + 1):(locs(i) - 1)));
        velocity(i) = sum(stepvelocity((n + 1):(locs(i) - 1))) / (locs(i) - (n + 1));
        time(i) = distance(i) / velocity(i);
        n = locs(i) - 1;
    elseif locs(i) == 1
        distance(i) = stepsize(1);
        velocity(i) = stepvelocity(1);
        time(i) = distance(i) / velocity(i);
    else
        distance(i) = 0;
        velocity(i) = 0;
        time(i) = 0;
    end
end
locresult = Particlefilter(cell2mat(wifiresult(2,:)), cell2mat(wifiresult(3,:)), velocity, time, 1000);

%----------- 定位结果图 -----------%
[xreal, yreal] = realposition([48 10; 2 2]);
hold on;
h1 = plot(xreal, yreal, 'k-', 'LineWidth', 1.5);
text(xreal - 150, yreal - 10, {'起点', '终点'});

[xtest_wifi, ytest_wifi] = realposition(cell2mat(wifiresult(2:3,:))); 
h2 = plot(xtest_wifi, ytest_wifi, 'b-.o', 'LineWidth', 1.5);
text(xtest_wifi + 10, ytest_wifi + 10, num2cell(1:size(xtest_wifi,2)));

[xtest, ytest] = realposition(locresult);   
h3 = plot(xtest, ytest, 'r-^', 'LineWidth', 1.5);
text(xtest + 10, ytest + 10, num2cell(1:size(xtest,2)));
hleg = legend([h1 h2 h3], '真实路径', 'Wi-Fi指纹定位路径', '系统定位路径');
set(hleg, 'Position', [0.22, 0.80, 0.1, 0.1]);