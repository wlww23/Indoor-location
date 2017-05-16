function [pdrtime, Ssize, Svelocity] = PDR(rawdata_accl, rawdata_attitude)
%------------ init ------------%
gravity_geo = cell(size(rawdata_accl(2,:)));
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
accl_amp = cell2mat(cellfun(@norm, accl_geo, 'UniformOutput', false));

accl_carry_amp = cellfun(@norm, rawdata_accl(2,:), 'UniformOutput', false);
accl_removegravity_amp = cell2mat(cellfun(@(x) (x - 1) * 9.80665, accl_carry_amp, 'UniformOutput', false));
%------- peak detection -------%
[pks, locs] = findpeaks(accl_removegravity_amp, 'minpeakdistance', 3, 'minpeakheight', 0.5);
% stepnum = length(pks) - 1;
%---- step size estimation ----%
distance = 0; Ssize = zeros(1,(length(pks) - 1));
for i = 1:(length(pks) - 1)
    Sf = 10 / (locs(i+1) - locs(i) + 1);
    Ss = -0.044057003564490 * Sf + 0.737680934225466;
    Ssize(i) = Ss;
    Svelocity(i) = Ss / Sf;
    distance = distance + Ss;
end
pdrtime = rawdata_accl(1,(locs));
end