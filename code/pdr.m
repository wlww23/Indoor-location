clc;clear;close all;
%------------ load ------------%
load('rawdata_accl.mat');
load('rawdata_attitude.mat');
gravity_geo = cell(size(rawdata_accl(2,:)));
%----------- figure -----------%
x = 1:length(rawdata_accl(2,:));
yx = cell2mat(cellfun(@(x) x(1), rawdata_accl(2,:), 'UniformOutput', false));
yy = cell2mat(cellfun(@(x) x(2), rawdata_accl(2,:), 'UniformOutput', false));
yz = cell2mat(cellfun(@(x) x(3), rawdata_accl(2,:), 'UniformOutput', false));
figure(1);plot(x, yx, x, yy, '-*r', x, yz, '-dg');title('载体坐标下加速度');
legend('X轴向加速度', 'Y轴向加速度', 'Z轴向加速度');
xlabel('Samples');
ylabel('Accelerate(g)');
%- coordinate transformation -%
C_b_2 = cellfun(@(x) [cos(x(1)) 0 -sin(x(1)); 0 1 0; sin(x(1)) 0 cos(x(1))], rawdata_attitude(2,:), 'UniformOutput', false);
C_1_t = cellfun(@(x) [cos(x(2)) -sin(x(2)) 0; sin(x(2)) cos(x(2)) 0; 0 0 1], rawdata_attitude(2,:), 'UniformOutput', false);
C_2_1 = cellfun(@(x) [1 0 0; 0 cos(x(3)) sin(x(3)); 0 -sin(x(3)) cos(x(3))], rawdata_attitude(2,:), 'UniformOutput', false); 
C = cellfun(@(x,y,z) x * y * z, C_b_2, C_2_1, C_1_t, 'UniformOutput', false); 
gravity_geo(:) = {[0 0 1]};
gravity_carry = cellfun(@(x,y) x * y', C, gravity_geo, 'UniformOutput', false); 
accl_transpose = cellfun(@(x) x', rawdata_accl(2,:), 'UniformOutput', false);
accl_removegravity = cellfun(@(x,y) x + y, accl_transpose, gravity_carry, 'UniformOutput', false);
accl_geo = cellfun(@(x,y) x' * y, C, accl_removegravity, 'UniformOutput', false);
accl_geo = cellfun(@(x) x' * 9.80665, accl_geo, 'UniformOutput', false);
%----------- figure -----------%
x_geo = 1:length(accl_geo);
yx_geo = cell2mat(cellfun(@(x) x(1), accl_geo, 'UniformOutput', false));
yy_geo = cell2mat(cellfun(@(x) x(2), accl_geo, 'UniformOutput', false));
yz_geo = cell2mat(cellfun(@(x) x(3), accl_geo, 'UniformOutput', false));
figure(2);plot(x_geo, yx_geo, x_geo, yy_geo, 'r', x_geo, yz_geo, 'g');title('地理坐标下加速度');
legend('X轴向加速度', 'Y轴向加速度', 'Z轴向加速度');
xlabel('Samples');
ylabel('Accelerate(m/s^2)');

accl_carry_amp = cellfun(@norm, rawdata_accl(2,:), 'UniformOutput', false);
accl_removegravity_amp = cell2mat(cellfun(@(x) (x - 1) * 9.80665, accl_carry_amp, 'UniformOutput', false));
figure(3);plot(x_geo, accl_removegravity_amp);title('地理坐标下加速度幅值');
xlabel('Samples');
ylabel('Accelerate(m/s^2)');

% accl_amp = cell2mat(cellfun(@norm, accl_geo, 'UniformOutput', false));
% figure(4);plot(x_geo, accl_amp);title('地理坐标下加速度幅值');
% xlabel('samples');
% ylabel('accelerate(m^2\cdot s^{-1})');

%------- peak detection -------%
[pks, locs] = findpeaks(accl_removegravity_amp, 'minpeakdistance', 3, 'minpeakheight', 0.5);
stepnum = length(pks) - 1;
hold on; plot(x_geo(locs), pks + 0.05, 'k^');
 
%---- step size estimation ----%
distance = 0; Ssize = zeros(1,(length(pks) - 1));
for i = 1:(length(pks) - 1)
    Sf = 10 / (locs(i+1) - locs(i) + 1);
    Ss = 0.071487442073476 * Sf + 0.587726697659036;
    Ssize(i) = Ss;
    distance = distance + Ss;
end
time = rawdata_accl(1,(locs));
fprintf('step number is %d. \n', stepnum);
fprintf('walking distance is %.2f m', distance);
