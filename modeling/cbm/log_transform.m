
% choose winning model here
params = cbm.output.parameters{3, 1}

if model_no ==1 | model_no == 3 | model_no == 5
alpha = 1./(1+exp(-params(:,1)));
    if model_no == 3
       beta_loss = 1./(1+exp(-params(:,2)))
       beta_win = 1./(1+exp(-params(:,3)))
    end
end