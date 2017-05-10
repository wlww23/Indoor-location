clc;clear;close all;
%----------- load -----------%
load('a_radiomapdata_kalman');
apqty = 3;
%--------- 数据分析 ----------%
for i = 1:apqty
    figure(i);
    temp = cellfun(@(x) x(i), a_radiomapdata_kalman, 'UniformOutput', false);
    for j = 1:size(a_radiomapdata_kalman,1)
        y = cell2mat(temp(j,:));
        x = 1:size(y, 2);
        subplot(2,2,j); plot(x,y);title(['RSSI与距离关系图(AP',num2str(i),')']);
        xlabel('Distance');
        ylabel('Gauss filtered RSSI(db)');
    end
end

for m = 1:apqty
    figure(m);
    temp = cellfun(@(x) x(m), a_radiomapdata_kalman, 'UniformOutput', false);
    for n = 1:size(a_radiomapdata_kalman,1)
        y = cell2mat(temp(n,:));
        x = 1:size(y, 2);
        subplot(2,2,n); plot(x,y);title(['RSSI与距离关系图(AP',num2str(m),')']);
        xlabel('Distance');
        ylabel('Gauss filtered RSSI(db)');
    end
end