load iDU2al_bothcond_adding.mat
% load iDU2al.mat

for sub = 1:length(data)
subj1 = data{sub}; 
parameters = cbm.output.parameters(sub,:); 
% F1 = model_RL(parameters,subj1,2),

al_neutral(sub,:)=sgm(parameters(1:2),1)
al_stress(sub,:)=[sgm(parameters(1)+parameters(6),1), sgm(parameters(2)+parameters(7),1)];
ka_neutral(sub,:)=sgm(parameters(3),1) 
ka_stress(sub,:)=sgm(parameters(3)+parameters(8),1)

[F1, traj] =model_RL_iDU2al_2betas_withStress(parameters,subj1);






scatter(1:length(subj1.actions),subj1.actions-1); hold on
plot(traj.q)
close

end