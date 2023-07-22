function [theta,cost] = RAMS_Calculation(paras,S_exp,theta0,theta_lb,theta_ub,method)
% Roll-Angle Measurement System Calculation Function
% 
if (nargin < 6) || isempty(method), method = "GA"; end
if (nargin < 5) || isempty(theta_ub), theta_ub = 180; end
if (nargin < 4) || isempty(theta_lb), theta_lb = -180; end 
if (nargin < 3) || isempty(theta0), theta0 = unifrnd(theta_lb,theta_ub); end

costfunction = @(x)(CostFunction(paras,x,S_exp));

switch method
    case "GA"
        nVar = 1;
        options = optimoptions('ga', 'FitnessLimit', 1e-8, 'Display', 'off',...
            'Generations', 1000, 'InitialPopulation', theta0, 'TolFun', 1e-8);
        [paras_opt,cost] = ga(costfunction, nVar, [], [], [], [],theta_lb, theta_ub,[], options);

    case "SN"   % 模拟退火
        [paras_opt,cost] = simulannealbnd(costfunction, theta0,theta_lb, theta_ub);

    case "LM"
        options = optimset('Algorithm', 'levenberg-marquardt');
        [paras_opt,~,cost] = lsqnonlin(costfunction,theta0,theta_lb,theta_ub,options);
    otherwise
        theta = 0; cost = nan;
        waitfor(errordlg("Please input correct options!","Error"));
        return;
end

theta = paras_opt;

end