function [loglik, traj] = model_RL_iDU2al_2betas_withStress_scaling_onlybetas(parameters,subj)

% determine alpha_control
nd_alpha1  = parameters(1);         % normally-distributed alpha
alpha1     = 1/(1+exp(-nd_alpha1)); % alpha1 (transformed to be between zero and one)
% nd_alpha2  = parameters(2);         % normally-distributed alpha
% alpha2     = 1/(1+exp(-nd_alpha2)); % alpha2 (transformed to be between zero and one)
alpha      = alpha1;

% determine kappa
nd_kappa  = parameters(3);
kappa     = 1/(1+exp(-nd_kappa));

% betas
nd_beta_win  = parameters(4);
beta_win     = exp(nd_beta_win);  

nd_beta_loss  = parameters(5);
beta_loss     = exp(nd_beta_loss); 
beta = [beta_loss, beta_win];

% determine beta_stress
scaling_beta_win  = parameters(6);
beta_win_stress   = exp(nd_beta_win+scaling_beta_win);  

scaling_beta_loss  = parameters(7);
beta_loss_stress   = exp(nd_beta_loss+scaling_beta_loss);  
beta_stress = [beta_loss_stress, beta_win_stress];



% unpack data
actions = subj.actions; % 1 for action=1 and 2 for action=2
outcome = [0, subj.outcome]; % 1 for outcome=1 and 0 for outcome=0
idx     = subj.trial_idx;

% number of trials
T       = size(actions,2);

% number of trials
% to save probability of choice. Currently NaNs, will be filled below
p        = nan(T,1);
q        = nan(T,2);
delta    = nan(T,1);
delta_uc = nan(T,1);

% Q-value for each action
q(1,:)  = [0.5, 0.5]; % Q-value for both actions initialized at 0

for t=1:T  
if t == idx 
    q(idx, :) = [0.5, 0.5];
    beta  = beta_stress;
end
    % probability of action 1
    % this is equivalant to the softmax function, but overcomes the problem
    % of overflow when q-values or beta is big.
    o_last = outcome(t);
    p1   = 1./(1+exp(-beta(o_last+1)*(q(t,1)-q(t,2))));
    
    % probability of action 2
    p2   = 1-p1;
    
    % read info for the current trial
    a    = actions(t); % action on this trial
    o    = outcome(t+1); % outcome on this trial
    o_uc = abs(o-1); % unchosen outcome on this trial
    
    % store probability of the chosen action
    if a==1
        p(t) = p1;
    elseif a==2
        p(t) = p2;
    end
    % which alpha to be used depends on the sign of prediction error
       
    delta(t)    = o - q(t,a); % prediction error
    delta_uc(t) = o_uc - q(t, 3-a);
   
if ~isnan(a)
    if a ==1
    q(t+1,1)       = q(t,1) +   (alpha(o+1)*delta(t));    
    q(t+1,2)       = q(t,2) +   (kappa*alpha(o_uc+1)*delta_uc(t));
    elseif a ==2
    q(t+1,2)       = q(t,2) +   (alpha(o+1)*delta(t));    
    q(t+1,1)       = q(t,1) +   (kappa*alpha(o_uc+1)*delta_uc(t));    
    end
else
    da(t)        = 0;
    da_uc(t)     = 0;
    q(t+1,:)       = q(t,:);
   

end
end
% log-likelihood is defined as the sum of log-probability of choice data 
% (given the parameters). Note that eps is a very small number in matlab (type eps in the command 
% window to see how small it is), which does not have any effect in practice, 
% but it overcomes the problem of underflow when p is very very small 
% (effectively 0).
loglik = sum(log(p+eps));

traj = struct;      % store trajectories per subject
traj.a = actions';
traj.o = outcome';
traj.q = q(1:end-1,:);
traj.da = [delta', delta_uc'];

end