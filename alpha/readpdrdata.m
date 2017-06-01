clc;clear;close all;
load('a16-c14_49.mat');
n = 1; rawdata_attitude = cell(1,1); rawdata_accl = cell(1,1);
% rawdata_pdr = cell2mat(rawdata_pdr);
for i = 1:(size(rawdata_pdr,1) / 3)
    rawdata_attitude{1,i} = cell2mat(rawdata_pdr(n,1));
    rawdata_accl{1,i} = cell2mat(rawdata_pdr(n,1));
    for j = 1:3
        rawdata_attitude{2,i}(j) = cell2mat(rawdata_pdr(n,2));
        rawdata_accl{2,i}(j) = cell2mat(rawdata_pdr(n,3));
        n = n + 1;
    end
end
save('rawdata_attitude.mat', 'rawdata_attitude');
save('rawdata_accl.mat', 'rawdata_accl');