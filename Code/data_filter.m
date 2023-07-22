function [stokes_data,angle] = data_filter(fdir,range,plotstate)
% 数据清洗函数，仅用于本项目提取csv文件中的斯托克斯矢量
% fdir既可以是文件夹（读取该文件夹下的csv文件），也可以是某一个csv文件的文件名
% range为待读取的行范围，plotstate用于控制是否把S1、S2、S3绘制出来
%

if nargin<3, plotstate = "off"; end
if (nargin<2) || isempty(range), range = [10,1009]; end
datarange = sprintf('C%d:E%d',range(1),range(2));
datalen = range(2)-range(1)+1;

% 判断输入的是否为文件夹，若是文件夹则读取文件夹下的csv文件列表；若是csv文件，则直接读取其信息
if isfolder(fdir)
    files = dir(fullfile(fdir,'*.csv'));    % 文件列表
else
    files = dir(fdir);
    fdir = files(1).folder;
end

% 判断是否需要绘图
if isequal(plotstate,'on')
    figure;
    h1 = subplot(221); hold(h1,'on'); title(h1,'S1');
    h2 = subplot(222); hold(h2,'on'); title(h2,'S2');
    h3 = subplot(223); hold(h3,'on'); title(h3,'S3');
end

len = size(files,1);
stokes_data = zeros(len,3);
if nargout == 2
    angle = zeros(len,1);
end

for i = 1:len
    fname = files(i).name;
    if nargout == 2
        angle(i,1) = str2double(fname(1:end-4));
    end
    
    % 读取数据并平均处理
    data = readmatrix(fullfile(fdir,fname),'Delimiter',';','Range',datarange);
    stokes_data(i,:) = mean(data);

    % Plot Figures
    if isequal(plotstate,'on')
        x = (datalen*(i-1)+1):datalen*i;
        scatter(h1,x',data(:,1),10,'filled');
        scatter(h2,x',data(:,2),10,'filled');
        scatter(h3,x',data(:,3),10,'filled');
    end
end

end