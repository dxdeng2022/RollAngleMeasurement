% 遍历多角度，用于手动分析哪里的误差最小

theta = 0:1:180;
paras_opt = load('paras_opt.mat').paras_opt;
temp = load('20230529_data.mat');

figure;
for i = 1:length(temp.stokes_data)
    S_exp = temp.stokes_data(i,:);
    cost = CostFunction(paras_opt,theta,S_exp);
    subplot(3,5,i);
    plot(theta,cost,'-k','LineWidth',1.5);
    legend(num2str(temp.angle(i)));
end