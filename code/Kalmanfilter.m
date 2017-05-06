%rawdatacell——存放原始数据的元胞数组
function result = Kalmanfilter(rawdatacell)
result = cellfun(@KF, rawdatacell, 'UniformOutput', false);
end
function outArray = KF(inArray)
a = 1;
r = 4;
kg = 0;
pk = 10;
xhat = inArray(1);
len = length(inArray);
outArray = zeros(1, len);
for i = 1:len
    xhat = a * xhat;
	pk = a * a * pk;
    kg = pk / (pk + r);
    outArray(i) = xhat + kg * (inArray(i) - xhat);
    xhat = outArray(i);
    pk = (1 - kg) * pk ;
end
end

