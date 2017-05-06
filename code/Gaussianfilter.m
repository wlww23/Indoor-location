%rawdatacell——存放原始数据的元胞数组
function result = Gaussianfilter(rawdatacell)
dev = cellfun(@std, rawdatacell, 'UniformOutput', false);
avg = cellfun(@mean, rawdatacell, 'UniformOutput', false);
min = cellfun(@(x,y) x - y, avg, dev, 'UniformOutput', false);
max = cellfun(@(x,y) x + y, avg, dev, 'UniformOutput', false);
index = cellfun(@(x,y,z) find((y<=x)&(x<=z)), rawdatacell, min, max, 'UniformOutput', false);
result = cellfun(@(x,y) x(y), rawdatacell, index, 'UniformOutput', false);
% absrssi= cellfun(@abs, filtered, 'UniformOutput', false);
% geomeanrssi = cellfun(@geomean, absrssi, 'UniformOutput', false);
% result = cellfun(@(x) -x, geomeanrssi, 'UniformOutput', false);
end