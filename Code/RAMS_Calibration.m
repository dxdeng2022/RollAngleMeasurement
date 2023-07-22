function [paras_opt,cost] = RAMS_Calibration(theta,S_exp,paras0,paras_lb,paras_ub,method)
% 参量校准主程序
% 待校准参量7个，beta0,alpha0,delta,Phi(2),Delta(2)

if (nargin < 6) || isempty(method), method = "GA"; end
if (nargin < 5) || isempty(paras_ub), paras_ub = 180; end
if (nargin < 4) || isempty(paras_lb), paras_lb = -180; end 
if (nargin < 3) || isempty(paras0), paras0 = unifrnd(paras_lb,paras_ub); end

nVar = length(paras0);
costfunction = @(x)(CostFunc_Calibration(x,theta,S_exp));

% 参数优化
switch method
    case "GA"
        options = optimoptions('ga','PlotFcns', 'gaplotbestf',  'Display', 'iter', 'FitnessLimit', 1e-8, ...
            'Generations', 1000, 'InitialPopulation', paras0, 'TolFun', 1e-8);
        [paras_opt,cost] = ga(costfunction, nVar, [], [], [], [],paras_lb, paras_ub,[], options);
    
    case "LM"
        options = optimset('Algorithm', 'levenberg-marquardt', 'Display', 'iter', 'MaxIter', 100000, ...
        'MaxFunEvals', 1e8, 'TolFun', 1e-10, 'TolX', 1e-10);
        [paras_opt, ~, cost] = lsqnonlin(costfunction, paras0, paras_lb, paras_ub, options);

    case "SN"     % 模拟退火
        options = optimoptions('simulannealbnd','PlotFcn','saplotbestf','MaxIterations',10000);
        [paras_opt,cost] = simulannealbnd(costfunction,paras0,paras_lb,paras_ub,options);
    
    case "PSO"    % 粒子群
        options = optimoptions('particleswarm','PlotFcn','pswplotbestf','Display','iter','MaxIterations',1000);
        [paras_opt,cost] = particleswarm(costfunction,nVar,paras_lb,paras_ub,options);
    otherwise
        paras_opt = zeros(1,nVar); cost = nan;
        waitfor(errordlg("Please input correct options!","Error"));
        return;
end

end
