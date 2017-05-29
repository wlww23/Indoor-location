%x——wifi定位结果横坐标矩阵
%y——wifi定位结果纵坐标矩阵
%v——运动目标运动距离矩阵
%t——时间间隔矩阵
%N——粒子个数
function result = Particlefilter(x, y, v, t, N)
particles = zeros(4,N);
k = 1;
while v(k) == 0
    x(k) = sum(x(1:k)) / k;
    y(k) = sum(y(1:k)) / k;
    k = k + 1;
end
if x(k) - x(k-1) > 0
    theta = pi / 2;
else
    theta = -pi / 2;
end
% theta = asin((x(2) - x(1)) / (v(2) * t(2)));
particles(1,:) = normrnd(x(k-1), 1, [1 N]);
particles(2,:) = normrnd(y(k-1), 1, [1 N]);
particles(3,:) = normrnd(v(k-1) * sin(theta), 0.01, [1 N]);%x方向速度
particles(4,:) = normrnd(v(k-1) * cos(theta), 0.01, [1 N]);%y方向速度
weights = ones(1,N) / N;
result = zeros(2,length(x));
result(1,1) = x(k-1);
result(2,1) = y(k-1);
% result(1,2) = x(2);
% result(2,2) = y(2);
for i = k:length(x)
    %-------- prediction --------%
    F = [1 0 t(i) 0; 0 1 0 t(i); 0 0 1 0; 0 0 0 1];
    n = [normrnd(0, 1, [1 N]); normrnd(0, 1, [1 N]); normrnd(0, 0.1, [1 N]); normrnd(0, 0.1, [1 N])];
    particles = F * particles + n;
    for j = 1:100
        idx = find((particles(1,:) < 0) | (particles(1,:) > 3698) | (particles(2,:) < 0) | ((particles(1,:) >= 0) & (particles(1,:) <= 1760) & (particles(2,:) > 227)) | ((particles(1,:) > 1760) & (particles(1,:) <= 3309) & (particles(2,:) > 335)) | ((particles(1,:) > 3309) & (particles(1,:) <= 3698) & (particles(2,:) > 228)));
    end
%     theta = (x(i) - x(i-1)) / v(i);
%     x_pre = particles(1,:) + v(i-1) * t(i) * cos(theta) + normrnd(0.5, 1, [1 N]);
%     y_pre = particles(2,:) + v(i-1) * t(i) * sin(theta) + normrnd(0.5, 1, [1 N]);
%     v_pre = particles(3,:) + normrnd(0, 0.1, [1 N]);
    %---------- update ----------%
    distance = arrayfun(@(x,y) sqrt(x^2 + y^2), particles(1,:) - x(i), particles(2,:) - y(i) , 'UniformOutput', true);
    weights = normpdf(distance, 0, 4) / sum(normpdf(distance, 0, 4));
    %-------- resampling --------%
    if 1 / sum(weights.^2) < length(x) / 2
        cumulative_sum = cumsum(weights);
        indexes = searchsorted(cumulative_sum, rand([1,length(weights)]));
        particles(:) = particles(:,indexes);
        weights = ones(1,length(weights)) / length(weights);
    end        
    %--------- estimate ---------%
    result(1,i) = sum(particles(1,:) .* weights);
    result(2,i) = sum(particles(2,:) .* weights);
end
end

function indexes = searchsorted(array1, array2)
array1 = [0 array1];
indexes = array2;
for i = 1 : length(array1) - 1
    indexes(array2 >= array1(i) & array2 < array1(i + 1)) = i - 1;
end
end