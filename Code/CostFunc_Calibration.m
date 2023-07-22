function cost = CostFunc_Calibration(paras,theta,S_exp)
% CostFunction of Calibration(MSE)
% Input:
%   - paras: A 1*7 vector containing alpha0,beta,dela,Phi,Delta
%   - theta: A series of rotation angles
%   - S_exp: Experimentally measured normalized Stokes vectors
% Output:
%   - cost: Error between experimental data and calculated data
%

M = length(theta);     
K = length(paras);
S_sim = RAMS_Sim_Angles(paras,theta);
sigma = 0.001;
diff = (S_exp-S_sim)/sigma;
cost = sqrt(sum(diff.^2,'all'))/sqrt(3*M-K);

end