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
for i = 1:N
    [pathstr, name, ext] = fileparts(fileFullName{i});
    fidin = fopen(fileFullName{i}, 'r');
    rawdata_wifi = cell(1,1);
    k = 1; lasttime = 1; a = 0; b = 0; c = 0; arss = 0; brss = 0; crss = 0;
    while ~feof(fidin)
        tline = fgetl(fidin); % 从文件读入一行文本（不含回车键）
        mac = cell2mat(regexp(tline, '00-02-2A-00-2C-D2|00-02-2A-03-C2-28|00-02-2A-03-C2-58', 'match'));
        if ~isempty(tline) && ~isempty(mac) % 判断是否空行且有无mac地址
            rss = str2double(cell2mat(regexp(tline, ',-[0-9][0-9],', 'match')));
            time = str2double(cell2mat(regexp(tline, '^[0-9]{1,}', 'match')));
            realtimecell = regexp(tline, '(0\d{1}|1\d{1}|2[0-3]):[0-5]\d{1}:([0-5]\d{1})', 'match');
            realtime = regexprep(realtimecell(1), ':', '');
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
                 rawdata_wifi{1, k} = realtime;
            else
                 rawdata_wifi{2, k} = [arss / a, brss / b, crss / c];
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
     rawdata_wifi{2, k} = [arss / a, brss / b, crss / c];
     save('rawdata_wifi.mat', 'rawdata_wifi');
end