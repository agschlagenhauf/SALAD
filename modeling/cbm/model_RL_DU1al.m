function [loglik, traj] = model_RL_DU2al(parameters,subj)

kappa = 1;

% determine alpha
nd_alpha1  = parameters(1);         % normally-distributed alpha
alpha1     = 1/(1+exp(-nd_alpha1)); % alpha1 (transformed to be between zero and one)
nd_alpha2  = parameters(2);         % normally-distributed alpha
alpha2     = 1/(1+exp(-nd_alpha2)); % alpha2 (transformed to be between zero and one)
alpha      = [alpha1, alpha1];

% beta
nd_beta  = parameters(end);
beta     = exp(nd_beta);  

% unpack data
actions = subj.actions; % 1 for action=1 and 2 for action=2
outcome = subj.outcome; % 1 for outcome=1 and 0 for outcome=0

% number of trials
T       = size(outcome,2);

% to save probability of choice. Currently NaNs, will be filled below
p        = nan(T,1);
q        = nan(T,2);
delta    = nan(T,1);
delta_uc = nan(T,1);

% Q-value for each action
q(1,:)  = [0.5, 0.5]; % Q-value for both actions initialized at 0

for t=1:T    
    % probability of action 1
    % this is equivalant to the softmax function, but overcomes the problem
    % of overflow when q-values or beta is big.
    p1   = 1./(1+exp(-beta*(q(t,1)-q(t,2))));
    
    % probability of action 2
    p2   = 1-p1;
    
    % read info for the current trial
    a    = actions(t); % action on this trial
    o    = outcome(t); % outcome on this trial
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
    q(t+1,1)       = q(t,1) +   (alpha(2-o)*delta(t));    
    q(t+1,2)       = q(t,2) +   (kappa*alpha(2-o_uc)*delta_uc(t));
    elseif a ==2
    q(t+1,2)       = q(t,2) +   (alpha(2-o)*delta(t));    
    q(t+1,1)       = q(t,1) +   (kappa*alpha(2-o_uc)*delta_uc(t));    
    end
else
    da(t)        = 0;
    da_uc(t)     = 0;
    q(t+1,:)     = q(t,:);
   

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