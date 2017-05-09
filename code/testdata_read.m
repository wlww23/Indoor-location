clc;clear;close all;
format = {'*.txt','TXT(*.txt)';'*.*','All Files(*.*)'};
[fileName, filePath] = uigetfile(format,'导入外部数据','*.txt','MultiSelect','on');
if ~isequal([fileName, filePath],[0, 0]);
    fileFullName = strcat(filePath, fileName);
else 
    return;
end
if iscell(fileFullName)
    N = length(fileFullName);  %文件个数
else
    N = 1;
    fileFullName = {fileFullName}; 
end
%--------- initialize ----------%
amac = '00-02-2A-00-2C-D2';
bmac = '00-02-2A-03-C2-28';
cmac = '00-02-2A-03-C2-58';
testpoints = cell(1,1);
%matFullName = fullfile(filePath, 'radiomapdata.mat'); 
%fidtemp = fopen(matFullName,'w'); %创建数据文件

for i = 1:N
    [pathstr, name, ext] = fileparts(fileFullName{i});    
    if  strcmp(cell2mat(regexp(name, 'point', 'match')), 'point')
        y = str2double(cell2mat(regexp(name, '(?<=y)\d.\d', 'match')));
        x = str2double(cell2mat(regexp(name, '(?<=x)\d{1,2}.\d', 'match')));
        area = cell2mat(regexp(name, '(?<=point_)[a-z]', 'match'));
        %tempmatFullName = fullfile(pathstr, strcat(name, '.mat'));
        fidin = fopen(fileFullName{i}, 'r'); %读取原始数据文件
        a = 0; b = 0; c = 0; arss = 0; brss = 0; crss = 0; xreal = 0; yreal = 0;
        while ~feof(fidin) % 判断是否为文件末尾
            tline = fgetl(fidin); % 从文件读入一行文本（不含回车键）
            if ~isempty(tline) % 判断是否空行
                mac = cell2mat(regexp(tline, '00-02-2A-00-2C-D2|00-02-2A-03-C2-28|00-02-2A-03-C2-58', 'match'));
                %计算每个AP的平均RSSI值
                if ~isempty(mac)
                    rss = str2double(cell2mat(regexp(tline, ',-[0-9][0-9],', 'match')));
                    switch mac
                        case amac
                            a = a + 1;
                            arss = arss + rss;
                        case bmac
                            b = b + 1;
                            brss = brss + rss;
                        case cmac
                            c = c + 1;
                            crss = crss + rss;
                        otherwise
                            warndlg('数据有误 运行已中断','error');
                    end
                end
            end
        end
        aavgrss = arss / a;
        bavgrss = brss / b;
        cavgrss = crss / c;
        %计算测试点在地图中的实际位置
        switch  area
            case 'a'
                if y >= 2
                    yreal = 79 + 80 + (y - 2) * 83;
                elseif y >= 1
                    yreal = 79 + (y - 1) * 80;
                else
                    yreal = 79 * y;
                end
                xreal = 80 * x;
            case 'b'
                if y >= 4
                    yreal = 95 + 80 + 80 + 80 + (y - 4) * 47;
                elseif y >= 3
                    yreal = 95 + 80 + 80 + (y - 3) * 80;
                elseif y >= 2
                    yreal = 95 + 80 +(y - 2) * 80;
                elseif y >= 1
                    yreal = 95 + (y - 1) * 80;
                else
                    yreal = 79 * y;
                end
                xreal = 22 * 80 + 13 + 16 + 80 * x;
            case 'c'
                if y >= 2
                    yreal = 81 + 80 + (y - 2) * 82;
                elseif y >= 1
                    yreal = 81 + (y - 1) * 80;
                else
                    yreal = 81 * y;
                end
                xreal = 22 * 80 + 13 + 16 + 80 * 19 + 15.5 + 53.5 + 80 * x;
            otherwise
                warndlg('数据有误','error'); 
        end
        testpoints{i} = [a b c; aavgrss, bavgrss, cavgrss; xreal yreal 0]; 
    elseif strcmp(cell2mat(regexp(name, 'path', 'match')), 'path')
        fidin = fopen(fileFullName{i}, 'r');
        testpath = cell(1,1);
        k = 1; lasttime = 1; a = 0; b = 0; c = 0; arss = 0; brss = 0; crss = 0; xreal = 0; yreal = 0;
        while ~feof(fidin)
            tline = fgetl(fidin); % 从文件读入一行文本（不含回车键）
            mac = cell2mat(regexp(tline, '00-02-2A-00-2C-D2|00-02-2A-03-C2-28|00-02-2A-03-C2-58', 'match'));
            if ~isempty(tline) && ~isempty(mac) % 判断是否空行且有无mac地址
                rss = str2double(cell2mat(regexp(tline, ',-[0-9][0-9],', 'match')));
                time = str2double(cell2mat(regexp(tline, '^[0-9]{1,}', 'match')));
                if time == lasttime
                    switch mac
                        case amac
                            a = a + 1;
                            arss = arss + rss;
                        case bmac
                            b = b + 1;
                            brss = brss + rss;
                        case cmac
                            c = c + 1;
                            crss = crss + rss;
                    end
                else
                    testpath{1, k} = [arss / a, brss / b, crss / c];
                    a = 0; b = 0; c = 0; arss = 0; brss = 0; crss = 0;
                    lasttime = time;
                    k = k + 1;
                    switch mac
                        case amac
                            a = a + 1;
                            arss = arss + rss;
                        case bmac
                            b = b + 1;
                            brss = brss + rss;
                        case cmac
                            c = c + 1;
                            crss = crss + rss;
                    end                    
                end                  
            end
        end
        testpath{1, k} = [arss / a, brss / b, crss / c];
    end
end
save('testpath.mat', 'testpath');