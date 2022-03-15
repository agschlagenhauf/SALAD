function [loglik, traj] = model_PH_1LR(parameters,subj)
%% free parameters for Pearce Hall model: 
% alpha (= initial learning rate, logit-space), gamma (= decay parameter gamma,
% logit space), Con (= arbitray constant, log space),


%% determine priors
                % for all models with one alpha 
nd_alpha  = parameters(1);          % normally-distributed alpha
alpha     = 1/(1+exp(-nd_alpha));   % alpha (transformed to be between zero and one)
nd_gamma  = parameters(2);   
gamma     = 1/(1+exp(-nd_gamma));   % gamma (transformed to be between zero and one)
nd_Con    = parameters(3);   
Con       = 1/(1+exp(-nd_Con));     % Constant (transformed to be positive)
% Con        = 0.9; 


% beta
% nd_gamma  = parameters(1);
% gamma     = 1/(1+exp(-nd_gamma));
nd_beta_win  = parameters(end-1);
beta_win     = exp(nd_beta_win); 

nd_beta_loss = parameters(end);
beta_loss    = exp(nd_beta_loss);  

beta = [beta_loss, beta_win];

% unpack data
actions = [1; subj.actions']; % 1 for action=1 and 2 for action=2
outcome = [0; subj.outcome']; % 1 for outcome=1 and 0 for outcome=0
outcome(outcome==-1)= 0;

% number of trials
T       = size(outcome,1);

% Q-value for each action
q       = [0.5, 0.5]; % Q-value for both actions initialized at 0.5
delta   = 0; % prediction error delta initialized at 0

% to save probability of choice. Currently NaNs, will be filled below
p       = nan(T,1);


% initial dynamic learning rate k
k = alpha;
gamma_t = [0; repmat(gamma,T,1)];

for t=2:T    
    % probability of action 1
    % this is equivalant to the softmax function, but overcomes the problem
    % of overflow when q-values or beta is big.
    o_last = outcome(t-1);
    p1   = 1./(1+exp(-beta(o_last+1)*(q(t-1,1)-q(t-1,2))));
    
   
    % probability of action 2
    p2   = 1-p1;
    
    % read info for the current trial
    a    = actions(t); % action on this trial
    o    = outcome(t); % outcome on this trial

    
    % store probability of the chosen action
    if a==1
        p(t) = p1;
    elseif a==2
        p(t) = p2;
    end
    % which alpha to be used depends on the sign of prediction error
 if ~isnan(a)      
    delta(t,:)   = o - q(t-1,a);              % prediction error
%     delta(t, 3-a) = delta(t-1,3-a);            % no double update of unchosen option so far

    k(t,:)  = gamma_t(t-1)*Con*abs(delta(t-1))+((1-gamma_t(t-1))*k(t-1));
    
    q(t, a)        = q(t-1,a)   +   (k(t)*delta(t));    
    q(t,3-a)       = q(t-1,3-a); 

else
    da(t,:)    = da(t-1);
    q(t,:)   = q(t-1,:);
    k(t,:)     = k(t-1); 
    
end
end
% log-likelihood is defined as the sum of log-probability of choice data 
% (given the parameters).
p(1) = [];
loglik = sum(log(p+eps));

traj    = struct;      % store trajectories per subject
traj.a  = actions(2:end);
traj.o  = outcome(2:end);
traj.q  = q(1:end-1,:);
traj.da = delta(2:end,:);
traj.lr = k(2:end,:);

% Note that eps is a very small number in matlab (type eps in the command 
% window to see how small it is), which does not have any effect in practice, 
% but it overcomes the problem of underflow when p is very very small 
% (effectively 0).
end