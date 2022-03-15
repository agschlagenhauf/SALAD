clc 
clear all
close;

system = getenv('COMPUTERNAME');
if strcmp(system, 'C15MW-PS-FO-02') % Teresa's office pc
prefix = 'T:\owncloud\';
addpath(fullfile([prefix, 'cbm-master-original\cbm-master\codes']));
elseif strcmp(system,'C15MN-PS-FO-13') % Teresas laptop
prefix = 'C:\users\katthagt\owncloud\';
addpath(fullfile([prefix, 'cbm-master-original\cbm-master\codes']));
else
prefix = '/Users/larawieland/Owncloud/'; % Lara's PC
addpath('/Users/larawieland/ownCloud/Shared/Reversal_Vol/scripts_cbm/'); % adapt
addpath('/Users/larawieland/Documents/Promotion/Modeling/cbm/codes/'); % adapt
savepath = '/Users/larawieland/Documents/Promotion/SALAD_3/modeling';
end


cd(fullfile([prefix, '/Shared/Reversal_Vol/scripts_cbm/']));
addpath(fullfile([prefix, '/Shared/Reversal_Vol/scripts_cbm/']));

% addpath('C:\Users\katthagt\ownCloud\Shared\NegSym\Modeling\hgfToolBox_v4.15');
input_path_CT = fullfile([prefix, 'Shared/Reversal_Vol/SALAD_data/HC_Control/']); %behavioral data in mat files
input_path_ST = fullfile([prefix, 'Shared/Reversal_Vol/SALAD_data/HC_Stress/']); 

% load data
input_CT =  dir([input_path_CT, '*WS.mat']);
input_ST =  dir([input_path_ST, '*WS.mat']);
data = {};
nmodels = 6;
nsubjects = length(input_CT); %should have the same number of subjects in both conditions

% subject loop to store all individual choice data in cohensive input file needed for cbm
for sub = 1:length(input_CT)
    data{sub,1}.code   = input_CT(sub).name(7:12);
    data{sub,1}.T      = input_CT(sub).name(14);
        load([input_path_CT input_CT(sub).name], 'R', 'A'); %load individual choice data from Control condition
        fprintf(input_CT(sub).name)
        R_1 = R(~isnan(A));  A_1 = A(~isnan(A)); R_1(R_1==-1)=0; %check whether your model needs losses as 0 or -1
%     Cond_idx_1 = zeros(1,length(R_1)); % initialise Condition index
        clear R A;
        load([input_path_ST input_ST(sub).name], 'R', 'A') %load individual choice data from Stress condition
        fprintf(input_ST(sub).name)
        R_2 = R(~isnan(A));  A_2 = A(~isnan(A)); R_2(R_2==-1)=0; %check whether your model needs losses as 0 or -1
        R = horzcat(R_1,R_2); A = horzcat(A_1,A_2); %append R and A from ST condition to CT condition
%     Cond_idx_2 = ones(1,length(R_2));
%     Cond_idx = horzcat(Cond_idx_1,Cond_idx_2);
    data{sub,1}.trial_idx = length(A_1)+1;
    data{sub,1}.actions = A;
    data{sub,1}.outcome = R;
    clear A A_1 A_2 R R_1 R_2  
end

%% choose raw data and model for trajectory plotting
input = data;            % pick correct dataset saved from cbm_loop first section


model = 'hbi_bothCond_scaling_DU.mat';          % choose .mat-file that contains the fitted model from the third section in cbm_loop
load(fullfile([pwd,'/', model])); 
model_no = 2;                           % pick corresponding model_no [1: no scaling, 2: only betas scaling, 3: only alpha scaling, 4: all scaling]

if strfind(model,'hbi')
    params = cbm.output.parameters{model_no};
else
    params = cbm.output.parameters;
end

%% read out and transform parameters
if model_no == 2 %model_no ==1 | model_no == 3 | model_no == 5
% alpha = 1./(1+exp(-params(:,1)));
%     if model_no == 3
%        kappa = 1./(1+exp(-params(:,2)))
%     end
alphawin = 1./(1+exp(-params(:,1)));
alphaloss= 1./(1+exp(-params(:,2)));
beta_win = exp(params(:,3));
beta_loss = exp(params(:,4));
%     if model_no == 4
%        kappa = 1./(1+exp(params(:,3)))
%     end
scaling_win = params(:,5);
scaling_loss = params(:,6);

tr_stress_beta_win = exp(beta_win+scaling_win);
tr_stress_beta_loss = exp(beta_loss+scaling_loss);
end


%% loop for single models fitted with LAP method (not hierarchical)
for sub = 1:length(data)

subj = data{sub};
parameters = params(sub,:);
[loglik, traj]=model_RL_DU2al_2betas_withStress_NoScaling(parameters,subj); % pick correct model script starting with "model_" 

figure;

plot(traj.q); hold on; ylim([-.15,1.15]);
scatter(1:length(traj.q), data{sub}.outcome, '.k')
scatter(1:length(traj.q), data{sub}.actions-1.05, '.y')
title(fullfile(['Belief trajectories for model: ', model,', and subject: ', num2str(subj.code), ' with' ...
' responses (yellow) and outcomes (black)']));
   
close;  % set breakpoint here to look at the trajectories subjectwise


end

