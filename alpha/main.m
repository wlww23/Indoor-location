clc;clear;close all;
load('rawdata_wifi.mat');
load('rawdata_accl.mat');
load('rawdata_attitude.mat');
load('radiomap_kalman.mat');
map = openfig('map.fig','reuse');

[pdrtime, stepsize, stepvelocity] = PDR(rawdata_accl, rawdata_attitude);
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
[xreal, yreal] = realposition(locresult);   
hold on;
scatter(xreal, yreal, 20, 'k');
text(xreal + 10, yreal, num2cell(1:size(xreal,2)));