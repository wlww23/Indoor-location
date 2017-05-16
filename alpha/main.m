clc;clear;close all;
load('rawdata_wifi.mat');
load('rawdata_accl.mat');
load('rawdata_attitude.mat');
load('radiomap_kalman.mat');

[pdrtime, stepsize] = PDR(rawdata_accl, rawdata_attitude);
wifiresult = Improvedwknn(testdata, radiomap);
[a,locs] = ismember(wifiresult(1,:), pdrtime);
n = 0; 
distance = zeros(1, (length(locs) + 1));
for i = 1:length(locs)
    d = stepsize((n + 1):(locs(i) - 1));
    n = locs(i) - 1;
    distance(i + 1) = d;
end
result = Particlefilter(cell2mat(wifiresult(2,:)), cell2mat(wifiresult(3,:)), distance, 1000);