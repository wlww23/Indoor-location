clc;clear;close all;
%----------- load -----------%
load('a_Area_ap_a_rawdata');
load('a_Area_ap_b_rawdata');
load('a_Area_ap_c_rawdata');

%-------- gauss filter-------%
ap_a_guassfilter = Gaussianfilter(a_Area_ap_a_rawdata);
ap_b_guassfilter = Gaussianfilter(a_Area_ap_b_rawdata);
ap_c_guassfilter = Gaussianfilter(a_Area_ap_c_rawdata);
ap_a_radiomap_gauss = cellfun(@mean, ap_a_guassfilter, 'UniformOutput', false);
ap_b_radiomap_gauss = cellfun(@mean, ap_b_guassfilter, 'UniformOutput', false);
ap_c_radiomap_gauss = cellfun(@mean, ap_c_guassfilter, 'UniformOutput', false);
a_radiomapdata_gauss = cellfun(@(x,y,z) [x y z], ap_a_radiomap_gauss, ap_b_radiomap_gauss, ap_c_radiomap_gauss, 'UniformOutput', false);
save('a_radiomapdata_gauss.mat', 'a_radiomapdata_gauss');

%-------- kalman filter-------%
ap_a_kalman = Kalmanfilter(a_Area_ap_a_rawdata);
ap_b_kalman = Kalmanfilter(a_Area_ap_b_rawdata);
ap_c_kalman = Kalmanfilter(a_Area_ap_c_rawdata);
ap_a_radiomap_kalman  = cellfun(@mean, ap_a_kalman, 'UniformOutput', false);
ap_b_radiomap_kalman  = cellfun(@mean, ap_b_kalman, 'UniformOutput', false);
ap_c_radiomap_kalman  = cellfun(@mean, ap_c_kalman, 'UniformOutput', false);
a_radiomapdata_kalman = cellfun(@(x,y,z) [x y z], ap_a_radiomap_kalman, ap_b_radiomap_kalman, ap_c_radiomap_kalman, 'UniformOutput', false);
save('a_radiomapdata_kalman.mat', 'a_radiomapdata_kalman');