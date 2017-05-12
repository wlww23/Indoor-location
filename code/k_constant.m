clc;clear;close all;
stepnum = [32; 44; 49; 54];
time = [23.78; 32.53; 36.77; 40.43];
distance = [24.8; 33.6; 37.6; 42.6];

l = distance ./ stepnum;
A = stepnum ./ time;
A(1:length(time),2) = 1; 
k = inv(A' * A) * (A' * l);