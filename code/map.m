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
%--------- points ----------%
xpa = [0:80:22*80 0:80:22*80 0:80:22*80 0:80:22*80];
ypa = [15*ones(1,23) 79*ones(1,23) (79+80)*ones(1,23) (79+80+68)*ones(1,23)];
xpb = [(22*80+29):80:(22*80+29+19*80) (22*80+29):80:(22*80+29+19*80) (22*80+29):80:(22*80+29+19*80) (22*80+29):80:(22*80+29+19*80) (22*80+29):80:(22*80+29+19*80)];
ypb = [15*ones(1,20) 95*ones(1,20) (95+80)*ones(1,20) (95+80+80)*ones(1,20) (95+80+80+80)*ones(1,20)];
xpc = [3378:80:(3378+4*80) 3378:80:(3378+4*80) 3378:80:(3378+4*80) 3378:80:(3378+4*80)];
ypc = [15*ones(1,5) 81*ones(1,5) (81+80)*ones(1,5) (81+80+67)*ones(1,5)];
xap = [0 1789 3698];
yap = [0 0 0];
hold on;
point = scatter(xpa, ypa, 20, 'r', 'fill');
scatter(xpb, ypb, 20, 'r', 'fill');
scatter(xpc, ypc, 20, 'r', 'fill');
ap = plot(xap, yap, '^', 'MarkerSize', 15, 'LineWidth', 2);
xlabel('x(cm)');
ylabel('y(cm)');
hleg1 = legend([point, ap], '参考点', 'AP节点');
set(hleg1, 'Position', [0.22, 0.80, 0.1, 0.1]);