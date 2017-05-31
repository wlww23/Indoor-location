clc;clear;close all;
a = [1 0 0 1 1 2 0 0 2 2 2];
k = 1;i = 0;
while k < length(a)
    if a(k)==0
        i = i + 1;
        k = k + 1;
        continue
    end
    for j = k:length(a)
        if a(j) == 0
            k = j;
            break
        end
        a(j)
        k = j;
    end
end