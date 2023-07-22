function S_out = RAMS_Sim(beta,alpha0,delta,Phi,Delta)
% Roll-Angle Measurement System Simulation Function
% Optical Path:LightSource-NPBS(Reflection)-SR(Sensing Retarder)
% -RM(Reflection Mirror)-NPBS(Transmission)
% Input:
%   -beta: Fast-axis orientation angle of SR
%   - alpha0: Initial polarization angle of the incident light source or polarizer
%   -delta: The retaedance of SR
%   - Phi: Amplitude ratio bewteen p- and s-polarizations after polarized 
%   light reflected from and transmitted through the NPBS
%   - Delta: Phase difference bewteen p- and s-polarizations after polarized 
%   light reflected from and transmitted through the NPBS
% Output:
%   - S_out: Normalized Stokes Vector of Emitted light
%


if nargin == 1
    alpha0 = beta(2);
    delta = beta(3);
    Phi = beta(4:5);
    Delta = beta(6:7);
    beta = beta(1);
end

% Stokes Vector of Polarized Light Source
S_in = [1 cosd(2*alpha0) sind(2*alpha0) 0]';    

N = -cosd(2*Phi);
C = sind(2*Phi).*cosd(Delta);
S = -sind(2*Phi).*sind(Delta);
% Mueller Matrix of NPBS(Reflection)
Mbs_r = [1 N(1) 0 0;
        N(1) 1 0 0;
        0 0 C(1) -S(1);
        0 0 S(1) C(1)];
% Mueller Matrix of NPBS(Transmission)                       
Mbs_t = [1 N(2) 0 0;
        N(2) 1 0 0;
        0 0 C(2) -S(2);
        0 0 S(2) C(2)];

% Mueller Matrix of RM                       
Mrm = diag([1 1 -1 -1]);                      

% Stokes Vector of Emitted light
S_out = Mbs_t*M_SR(delta,-beta)*Mrm*M_SR(delta,beta)*Mbs_r*S_in;
S_out = S_out/S_out(1);

end


%% Rotation Matrix Function
function R_Matrix = R(beta)
beta_sin = sind(2*beta);
beta_cos = cosd(2*beta);
R_Matrix = [1 0 0 0;
            0 beta_cos beta_sin 0;
            0 -beta_sin beta_cos 0;
            0 0 0 1];
end

%% Mueller Matrix Function of SR
function Msr_Matrix = M_SR(delta, beta)
Msr = [1 0 0 0;
       0 1 0 0;
       0 0 cosd(delta) sind(delta);
       0 0 -sind(delta) cosd(delta)];
Msr_Matrix = R(-beta)*Msr*R(beta);
end