% 校准-自动测量主函数
% 校准过程使用软件保存的csv数据进行（csv数据不再需要手动处理）
% 测量过程实时进行，使用ocr方法（首次运行请在 APP-获取更多APP 中安装
% ScreenCapture 工具箱（Author: Yair Altman））
% created by：杨世龙&邓定选
% date：2023.5


%% 数据清洗与仪器标定
% 需修改校准数据所在文件夹，csv文件必须以角度值命名
% （可选）设置待校准参数的上下界（默认[-180,180]）和初始值（默认随机）

% 文件夹位置
fdir = "..\20230530data";
% 数据清洗，第2个参数为空时，默认为[10,1009]，即读取表格中10~1009行数据
[stokes_data, angle] = data_filter(fdir,[900 1009],'off');

% % 保存清洗后的数据
% save("20230529_data.mat",'stokes_data','angle');

% 设置校准数据
S_exp_cali = stokes_data;
theta_cali = angle;

% 设置上下界和初始值
paras_lb = -180+zeros(1,7);
paras_ub = 180+zeros(1,7);
paras0 = unifrnd(paras_lb,paras_ub);

% 系统参数校准
[paras_opt,cost] = RAMS_Calibration(theta_cali,S_exp_cali,paras0,paras_lb,paras_ub,"GA");

% 输出校准信息
fprintf('\n校准完成！\n');
fprintf('paras0: %s;\nparas_opt: %s;\ncost: %s.\n',num2str(paras0), num2str(paras_opt),num2str(cost));

% Plot Figures
x_angle = theta_cali(1):2:theta_cali(end);
S_sim = RAMS_Sim_Angles(paras_opt,x_angle);
figure; hold on;
plot(theta_cali,S_exp_cali,'-o','LineWidth',1.5);
plot(x_angle',S_sim,'-','linewidth',1.5);
legend(["S1\_exp","S2\_exp","S3\_exp","S1\_sim","S2\_sim","S3\_sim"],'Location','best');
hold off;

% Save Calibration Parameters
save('paras_opt.mat','paras_opt');


%% 角度测量
% 需修改OCR识别的间隔时间，设置待测量角度的上下界、初始值

clear; clc;

% OCR预设置
ha = ScreenCapture();
roi = ha.getROI();

% OCR间隔时间设置（单位：s）
t = 0.01;

% 设置待测量角度上下界和初始值
theta_lb = 0;
theta_ub = 180;
% theta0 = unifrnd(theta_lb,theta_ub);

% 设置每个角度的测量次数
len = 120;
angle_mat = zeros(len,100);
time_mat = zeros(len,100);
i = 1; j = 1;

% 加载优化好的系统参数
paras_opt = load('paras_opt.mat').paras_opt;

% 主循环
while true
    % 开始计时
    tic;
    
    % 获取图像
    screenImage = ha.capture(roi);
    % 预处理图像
    processedImage = ha.preprocessImage(screenImage);
    % 进行OCR识别
    ocrResults = ocr(processedImage,'CharacterSet','.0123456789-');

    % 提取数字结果
    recognizedText = str2num(ocrResults.Text);
%     toc;
    disp(recognizedText');
    if size(recognizedText,1) ~= 3 || sum(recognizedText.^2)>1.15 || sum(recognizedText.^2)<0.85
        continue;
    end
    S_exp = recognizedText';
    disp(sum(recognizedText.^2));

    % 滚转角测量主代码
    [theta,cost] = RAMS_Calculation(paras_opt,S_exp,[],theta_lb,theta_ub,"GA");
    
    % 输出测量信息
    fprintf('theta: %.4f;\ncost: %.6f.\n', theta, cost);
    time_exp = toc;
    fprintf('历时 %.6f 秒\n\n',time_exp);
    
    % 保存角度信息
    angle_mat(i,j) = theta;
    time_mat(i,j) = time_exp;
    i = i+1;
    
    % 判断当前角度测量次数是否达到
    if i > len
        i = 1; j = j+1;
        fprintf([repmat('=',1,30), '\n\n']);
        prompt = sprintf("当前角度测量次数已达到！\n\n请改变旋转部件的角度！\n\n注意！！！请改变角度值后再关闭本窗口！");
        % 输出提示信息，并等待窗口关闭
        answer = questdlg(prompt,"Notification","继续测量","结束测量","继续测量");
        if isequal(answer,"结束测量")
            break;
        end  
    end
    
    % 延迟一段时间，控制识别的频率
    pause(t);
end

% 绘图
% angle_mat_tmp = angle_mat(:,1:j-1);
figure; box on; hold on;
plot(1:len*(j-1),angle_mat(1:len*(j-1)),'r','linewidth',1.5);

