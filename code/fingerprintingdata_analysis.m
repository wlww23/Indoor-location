clc;clear;close all;
%----------- load -----------%
load('a_radiomapdata');
apqty = 3;
%--------- 数据分析 ----------%
for i = 1:apqty
    figure(i);
    temp = cellfun(@(x) x(i), a_radiomapdata, 'UniformOutput', false);
    for j = 1:size(a_radiomapdata,1)
        y = cell2mat(temp(j,:));
        x = 1:size(y, 2);
        subplot(2,2,j); plot(x,y);title(['RSSI与距离关系图(AP',num2str(i),')']);
        xlabel('Distance');
        ylabel('RSSI(db)');
    end
end