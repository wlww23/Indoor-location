clc;clear;close all;
stepnum = [50; 49; 44; 49; 49; 48; 44; 50; 49; 49];
time = [37.4; 37.5; 34.9; 37.5; 39.3; 35.1; 33.2; 37.9; 35.7; 36.3];
distance = [33.78; 32.18; 29.78; 33.78; 33.78; 32.98; 28.98; 34.58; 33.78; 34.58];

l = distance ./ stepnum;
A = stepnum ./ time;
A(1:length(time),2) = 1; 
k = inv(A' * A) * (A' * l);