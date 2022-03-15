function [loglik] = model_nolearning_qbias_1beta(parameters,subj)

% beta
nd_qbias          = parameters(1);
qbias             = 1/(1+exp(-nd_qbias)); 

nd_beta       = parameters(2);
beta          = exp(nd_beta);

beta = [beta, beta];

% unpack data
actions = subj.actions; % 1 for action=1 and 2 for action=2
outcome = subj.outcome'; % 1 for outcome=1 and 0 for outcome=0
o_last  = [0; outcome]; 
% number of trials
T       = size(outcome,1);

% Q-value for each action
q       = [qbias, 0.5]; % Q-value for both actions initialized at 0

% to save probability of choice. Currently NaNs, will be filled below
p       = nan(T,1);

for t=1:T    
    % probability of action 1
    % this is equivalant to the softmax function, but overcomes the problem
    % of overflow when q-values or beta is big.
    p1   = 1./(1+exp(-beta(o_last(t)+1)*(q(1)-q(2))));
    
    % probability of action 2
    p2   = 1-p1;
    
    % read info for the current trial
    a    = actions(t); % action on this trial
   
    % store probability of the chosen action
    if a==1
        p(t) = p1;
    elseif a==2
        p(t) = p2;
    end
    
end
% log-likelihood is defined as the sum of log-probability of choice data 
% (given the parameters).
loglik = sum(log(p+eps));

end