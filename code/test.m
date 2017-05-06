clc;clear;close all;
%----------- load -----------%
load('a_Area_ap_a_rawdata');
ap_a = Kalmanfilter(a_Area_ap_a_rawdata);