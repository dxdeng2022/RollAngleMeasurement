function S_sim = RAMS_Sim_Angles(paras,theta)
% 多个角度下的斯托克斯矢量仿真
%

S_sim = zeros(length(theta),3);
para = paras;
for i = 1:length(theta)
    para(1) = paras(1)+theta(i);
    S_tmp = RAMS_Sim(para);
    S_sim(i,:) = S_tmp(2:4)';
end