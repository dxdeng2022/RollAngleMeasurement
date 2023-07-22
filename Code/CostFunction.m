function cost = CostFunction(paras_opt,theta,S_exp)
% CostFunction for Roll Angle Extraction
%

cost = zeros(size(theta));
for i = 1:length(theta)
    paras = [theta(i)+paras_opt(1) paras_opt(2:end)];
    S_sim = RAMS_Sim(paras);
    S_sim = S_sim(2:4)';
    cost(i) = norm(S_exp-S_sim);
end

end