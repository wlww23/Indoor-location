%locresult--存放定位结果的矩阵,其中locresult(1,:)存放x坐标,locresult(2,:)存放y坐标
function [xreal, yreal] = realposition(locresult)
xreal = zeros(1, size(locresult,2));
yreal = zeros(1, size(locresult,2));
for i = 1:size(locresult,2)
    x = locresult(1,i) - 1;
    y = locresult(2,i) - 1;
    if x <= 22
        xreal(i) = 80 * x;
        if y >= 2
            yreal(i) = 79 + 80 + (y - 2) * 83;
        elseif y >= 1
            yreal(i) = 79 + (y - 1) * 80;
        else
            yreal(i) = 79 * y;
        end
    elseif x <= 22.4483 && x > 22
        xreal(i) = 29 * (x - 22) + 1760;
        if y >= 2
            yreal(i) = 79 + 80 + (y - 2) * 83;
        elseif y >= 1
            yreal(i) = 79 + (y - 1) * 80;
        else
            yreal(i) = 79 * y;
        end
    elseif x < 23 && x > 22.4483
        xreal(i) = 29 * (x - 22) + 1760;
        if y >= 3
            yreal(i) = 95 + 80 + 80 + (y - 3) * (80 + 47);
        elseif y >= 2
            yreal(i) = 95 + 80 + (y - 2) * 80;
        elseif y >= 1
            yreal(i) = 95 + (y - 1) * 80;
        else
            yreal(i) = 95 * y;
        end    
    elseif x >= 23 && x <= 42
        xreal(i) = 29 + 22 * 80 + (x - 23) * 80;
        if y >= 3
            yreal(i) = 95 + 80 + 80 + (y - 3) * (80 + 47);
        elseif y >= 2
            yreal(i) = 95 + 80 + (y - 2) * 80;
        elseif y >= 1
            yreal(i) = 95 + (y - 1) * 80;
        else
            yreal(i) = 95 * y;
        end
    elseif x > 42 && x <= 42.2246 
        xreal(i) = (15.5 + 53.5) * (x - 42) + 3309;
        if y >= 3
            yreal(i) = 95 + 80 + 80 + (y - 3) * (80 + 47);
        elseif y >= 2
            yreal(i) = 95 + 80 + (y - 2) * 80;
        elseif y >= 1
            yreal(i) = 95 + (y - 1) * 80;
        else
            yreal(i) = 95 * y;
        end
    elseif x > 42.2246  && x < 43
        xreal(i) = (15.5 + 53.5) * (x - 42) + 3309;
        if y >= 2
            yreal(i) = 81 + 80 + (y - 2) * 82;
        elseif y >= 1
            yreal(i) = 81 + (y - 1) * 80;
        else
            yreal(i) = 81 * y;
        end
    elseif x >= 43
        xreal(i) = 3378 + (x - 43) * 80;
        if y >= 2
            yreal(i) = 81 + 80 + (y - 2) * 82;
        elseif y >= 1
            yreal(i) = 81 + (y - 1) * 80;
        else
            yreal(i) = 81 * y;
        end
    end    
end
end