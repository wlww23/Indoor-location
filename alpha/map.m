clc;clear;close all;
%----------- map -----------%
x = [0 3700 3700 3324.5 3324.5 1773 1773 0 0];
y = [0 0 243 243 382 382 242 242 0];
line(x, y, 'COLOR', 'k', 'LineWidth', 2);axis([-100 3750 -20 390]);
% title('WiFi指纹测量平面图');
%--------- shadow ----------%
xs1 = [0 0 1773 1773];
ys1 = [242 382 382 242];
xs2 = [3324.5 3324.5 3698 3698];
ys2 = [243 382 382 243];
hold on;
patch(xs1, ys1, 'k','facealpha',0.2);
patch(xs2, ys2, 'k','facealpha',0.2); 
text(750, 300, '墙', 'FontName', '等线', 'FontSize', 20, 'FontWeight', 'bold');
text(3400, 300, '墙', 'FontName', '等线', 'FontSize', 20, 'FontWeight', 'bold');
xlabel('x(cm)');
ylabel('y(cm)');