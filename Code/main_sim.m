% Simulation for paper 2020 Fig.3

% % Initialization
% alpha0 = 48.63;          % Initial polarization angle of source
% beta0 = 93.42;           % Fast-axis orientation angle of SR
% delta = 90;             % The retaedance of SR
% Phi = [-15.34 40.49];    % Amplitude ratio of p- and s-(NPBS)
% Delta = [20.15 -0.31];   % Phase difference of p- and s-(NPBS)

% alpha0 = 48.63;          % Initial polarization angle of source
% beta0 = 93.42;           % Fast-axis orientation angle of SR
% delta = 137.91;          % The retaedance of SR
% Phi = [-38.05 39.9];     % Amplitude ratio of p- and s-(NPBS)
% Delta = [17.6 0.66];     % Phase difference of p- and s-(NPBS)

% paras = [beta0 alpha0 delta Phi Delta];
% paras = [-91.4084 -160.7307   135    0.2572 -135.6020   41.9672  160.3883];
paras = load('paras_opt.mat').paras_opt;

theta = 0:0.5:180;           % Rotation angles
S_sim = RAMS_Sim_Angles(paras,theta);

% Theta = repmat(theta',1,3);
% plot(Theta,S_sim,'-^','LineWidth',1.5);
% legend(["S1","S2","S3"]);
% % hold on; plot([90 90],ylim,'k','linewidth',1.5);
% % plot([180 180],ylim,'k','linewidth',1.5);

% 3D plot
plot3(S_sim(:,1),S_sim(:,2),S_sim(:,3),'r','LineWidth',2);
xlabel("S1"); ylabel("S2"); zlabel("S3");
hold on; box on;
scatter3(S_sim(1,1),S_sim(1,2),S_sim(1,3),20,'ko','filled');     % 0度
scatter3(S_sim(181,1),S_sim(181,2),S_sim(181,3),20,'ko','filled');  % 90度
% scatter3(S_sim(21,1),S_sim(21,2),S_sim(21,3),50,'ys','filled');   % 40度
% scatter3(S_sim(140,1),S_sim(140,2),S_sim(140,3),50,'bs','filled');

[x,y,z] = sphere(50);
surf(x,y,z);

set(gca,'XMinorTick','on','YMinorTick','on','ZMinorTick','on','linewidth',1.5);
set(gca,'fontname','times new roman','fontsize',14);


%% Save data
stokes_data = S_sim;
angle = theta';
save('20230416_sim_data.mat','stokes_data','angle');

