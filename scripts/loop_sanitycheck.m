clc; clear all;

%% paths %%%
TK = 0; % set to 0 for Lara's computer
if TK ==1
homepath='C:\Users\katthagt\ownCloud\Shared\Reversal_Vol\scripts_cbm\';
else
homepath='/Users/larawieland/ownCloud/Shared/Reversal_Vol/scripts_cbm/'; % adapt
end

%% choose raw data and model for trajectory plotting
cd(homepath)
input = 'data_SALAD_T1.mat';            % pick correct dataset saved from cbm_loop first section
load(fullfile([pwd,'/', input])); 

model = 'iDU2al_SALAD_T1.mat';          % choose .mat-file that contains the fitted model from the third section in cbm_loop
load(fullfile([pwd,'/', model])); 
model_no = 4;                           % pick corresponding model_no [1-->SU 1 alpha, 2->SU 2 alphas, 3->iDU 1 alpha, 4->iDU 2 alphas, 5->DU 1 alpha, 6-> DU 2 alphas] 

if strfind(model,'hbi')
    params = cbm.output.parameters{model_no};
else
    params = cbm.output.parameters;
end

%% read out and transform parameters
if model_no ==1 | model_no == 3 | model_no == 5
alpha = 1./(1+exp(-params(:,1)));
    if model_no == 3
       kappa = 1./(1+exp(-params(:,2)))
    end
else
alphawin = 1./(1+exp(-params(:,1)));
alphaloss= 1./(1+exp(-params(:,2)));
    if model_no == 4
       kappa = 1./(1+exp(params(:,3)))
    end
end
beta = exp(params(:,end));

%% loop for single models fitted with LAP method (not hierarchical)
for sub = 1:length(data)

subj = data{sub};
parameters = params(sub,:);
[loglik, traj]=model_RL_iDU2al_2betas_withStress_NoScaling(parameters,subj); % pick correct model script starting with "model_" 

figure;

plot(traj.q); hold on; ylim([-.15,1.15]);
scatter(1:length(traj.q), data{sub}.outcome, '.k')
scatter(1:length(traj.q), data{sub}.actions-1.05, '.y')
title(fullfile(['Belief trajectories for model: ', model,', and subject: ', num2str(subj.code), ' with' ...
' responses (yellow) and outcomes (black)']));
   
close;  % set breakpoint here to look at the trajectories subjectwise


end

