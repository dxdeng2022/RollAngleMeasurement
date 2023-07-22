% 滚转角测量主函数
% 这是事先保存测量数据到csv的程序，实时测量请使用 main_automeasurement.m 程序

%% 1. 校准数据清洗，csv文件必须以角度值命名
% 需修改校准数据所在文件夹，和清洗后需保存的数据文件名（.mat）

fdir = "..\20230425data";
[stokes_data, angle] = data_filter(fdir,[],'on');        
save("20230422_data.mat",'stokes_data','angle');

% 需测量的数据不用以角度值命名，只需返回stokes_data，不应返回angle
% stokes_data = data_filter(fdir,[],'on');


%% 2. 参数校准
% 需修改校准数据的文件名（和数据范围），（可选）设置参数上下界和初始值

clear; clc;

% 加载校准数据
temp = load("20230422_data.mat");
S_exp_cali = temp.stokes_data(1:10,:);
theta_cali = temp.angle(1:10);

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


%% 3. 参数测量
% 需输入待测量的斯托克斯数据，和设置待测量角度的上下界、初始值

clear; clc;

% 加载待测量的斯托克斯数据
temp = load('20230422_data.mat');
S_exp_calc = temp.stokes_data(11:15,:);
% S_exp_calc = data_filter('..\20230422data\156.csv');

% 设置待测量角度上下界和初始值
theta_lb = 90;
theta_ub = 180;
% theta0 = unifrnd(theta_lb,theta_ub);

% 加载优化好的系统参数
paras_opt = load('paras_opt.mat').paras_opt;

% 滚转角测量主代码
theta = zeros(size(S_exp_calc,1),1);
cost = zeros(size(theta));
for i = 1:length(theta)
    S_exp = S_exp_calc(i,:);
    [theta(i),cost(i)] = RAMS_Calculation(paras_opt,S_exp,[],theta_lb,theta_ub,"GA");
end

% 输出测量信息
fprintf('\ntheta: %s;\ncost: %s.\n',num2str(theta'),num2str(cost'));

