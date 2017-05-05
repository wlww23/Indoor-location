clc;clear;close all;
%----------- load -----------%
load('a_Area_ap_a_rawdata');
load('a_Area_ap_b_rawdata');
load('a_Area_ap_c_rawdata');
%-------- gauss filter-------%
ap_a = Gaussianfilter(a_Area_ap_a_rawdata);
ap_b = Gaussianfilter(a_Area_ap_b_rawdata);
ap_c = Gaussianfilter(a_Area_ap_c_rawdata);
a_radiomapdata_gaussianfilter = cellfun(@(x,y,z) [x y z], ap_a, ap_b, ap_c, 'UniformOutput', false);
save('a_radiomapdata_gaussianfilter.mat', 'a_radiomapdata_gaussianfilter');