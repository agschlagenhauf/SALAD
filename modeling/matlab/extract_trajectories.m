close all;
clear;
clc;

%% automatically chooses system and adapts path prefix
system = getenv('COMPUTERNAME');
if strcmp(system, 'C15MW-PS-FO-02') % Teresa's office pc
    prefix = 'T:\owncloud\';
elseif strcmp(system,'C15MN-PS-FO-13') % Teresa's laptop
    prefix = 'C:\users\katthagt\owncloud\';
    
elseif strcmp(system,'HERMINE') % Sophies's laptop
    prefix = 'T:\Shared\dissociate_delusions\';
elseif strcmp(system,'C15MW-PS-FO-144') % Analyse Rechner
    prefix = 'E:\dissociate_delusions\';
end

addpath([pwd, '\tapas-master\HGF']);
model_path = fullfile([prefix '\modeling_pipeline\output\']);
models = dir([model_path, '27-Jan-2021_M6_N86_withNaN.mat']);

%old model
%models = dir([model_path,' NEW_M6_N86_withNaN_SIRSversion']);

mu3=[];
epsi2 = []
sigma2 = []

%% 

%%Precision weighted prediction error (est.traj.epsi) regarding the outcome on a given trial relative to current beliefs about the probability of that outcome (ε2), (
%extract ε2, σ2 (informational uncertainty) and predicted environmental uncertainty
est_all =[];

for m =1:length(models)
    load([model_path, models(m).name])
    mu3_m=NaN(length(est),150);
    epsi2_m=NaN(length(est),150);
    sigma2_m=NaN(length(est),150);
    
    for sub = 1:length(est)
        mu3_m(sub,1:length(est(sub).traj.mu(:,3))) = est(sub).traj.mu(:,3);
        epsi2_m(sub,1:length(est(sub).traj.epsi(:,2))) = est(sub).traj.epsi(:,2);
        sigma2_m(sub,1:length(est(sub).traj.sa(:,2))) = est(sub).traj.sa(:,2);
    end
    
    mu3 = [mu3; mu3_m];
    epsi2 = [epsi2; epsi2_m];
    sigma2 = [sigma2; sigma2_m];
    
    est_all = [est_all, est];
    clear mu3_m epsi2_m sigma2_m
end

%% Compute predicted environmental uncertainty
for sub = 1:86
    for trial = 1: 160
        yeu(sub, trial) = exp(est(sub).p_prc.ka(2)*mu3(sub,trial)+est(sub).p_prc.om(2));
    end
end

%% Compute phase-specific means
yeu_t = yeu';
mu3_t = mu3';
epsi2_t = epsi2';
sa2_t = sigma2';

for i = 1: 86
     mu3_pre(i,:) = mean(mu3_t(1:55, i));
     mu3_rev(i,:) = mean(mu3_t(56:125, i));
     mu3_post(i,:) = mean(mu3_t(126:150, i));
     
     yeu_pre(i,:) = mean(yeu_t(1:55, i));
     yeu_rev(i,:) = mean(yeu_t(56:125, i));
     yeu_post(i,:) = mean(yeu_t(126:150, i));
     
     sa2_pre(i,:) = mean(sa2_t(1:55, i));
     sa2_rev(i,:) = mean(sa2_t(56:125, i));
     sa2_post(i,:) = mean(sa2_t(126:150, i));
   
     epsi2_pre(i,:) = mean(epsi2_t(2:55, i)); %!!!! SHIFT TRIALS???? 
     epsi2_rev(i,:) = mean(epsi2_t(56:125, i));
     epsi2_post(i,:) = mean(epsi2_t(126:150, i)); 
     
     mu3_pred_med(i,:) = mean(mu3_t(1:55, i));
     mu3_rev_med(i,:) = mean(mu3_t(56:125, i));
     mu3_post_med(i,:) = mean(mu3_t(126:150, i));
     
     yeu_pre_med(i,:) = mean(yeu_t(1:55, i), 'omitnan' );
     yeu_rev_med(i,:) = mean(yeu_t(56:125, i), 'omitnan' );
     yeu_post_med(i,:) = mean(yeu_t(126:160, i), 'omitnan' );
     
     sa2_pre_med(i,:) = mean(sa2_t(1:55, i), 'omitnan' );
     sa2_rev_med(i,:) = mean(sa2_t(56:125, i), 'omitnan' );
     sa2_post_med(i,:) = mean(sa2_t(126:160, i), 'omitnan' );
   
     epsi2_pre(i,:) = median(epsi2_t(2:55, i), 'omitnan'); %!!!! SHIFT TRIALS???? 
     epsi2_rev(i,:) = median(epsi2_t(56:125, i), 'omitnan' );
     epsi2_post(i,:) = median(epsi2_t(126:160, i), 'omitnan' ); 
     
end

%!!!!!! 0024 has less trials, mu3, sa2, espi2 ...post computed by hand
sa2_post(1) = mean(sa2_t(126:141, 1));
mu3_post(1) = mean(mu3_t(126:141, 1));
epsi2_post(1) = mean(epsi2_t(126:141, 1));
yeu_post(1) = mean(epsi2_t(126:141, 1));

traj_subs = table(subjects', yeu_pre, yeu_rev, yeu_post,  mu3_pre, mu3_rev, mu3_post, sa2_pre, sa2_rev, sa2_post, epsi2_pre, epsi2_rev, epsi2_post);
%writetable(traj_subs, 'traj_subs.xlsx')

%outlier
%DD_data<-filter(DD_data, Code!="sz_20_196" & Code!="sz_20_136" & Code!="sz_20_123" & Code!="sz_10_014")
%DD_data<- filter(DD_data, Code!="sz_00_061", Code!="sz_20_108",Code!=" sz_20_092", Code!="sz_10_050", Code!="sz_20_125")

est = est_all;
clear est_all

%% Find mean and sd of trajectory parameters
% mean_epsi = mean(epsi2, 'all', 'omitnan');
% std_epsi = std(epsi2, 0,'all',  'omitnan');
% mean_sa = mean(sigma2, 'all',  'omitnan');
% std_sa = std(sigma2, 0, 'all',  'omitnan');
% mean_mu = mean (mu3, 'all',  'omitnan');
% std_mu = std(mu3, 0,'all',  'omitnan');
% 
% %For each subject find outlier trials, doesnt work if there are some with
% extremely high leverage
% for i = 1:86
%    out_epsi_max(i, :) =  epsi2(i,:)>mean_epsi+(std_epsi*2);
%    out_epsi_min(i, :) =  epsi2(i,:)<mean_epsi-(std_epsi*2);   
%    out_sigma_max(i, :) =  sigma2(i,:)>mean_sa+(std_sa*2);
%    out_sigma_min(i, :) =  sigma2(i,:)<mean_sa-(std_sa*2);  
%    out_mu_max(i, :) =  mu3(i,:)>mean_mu+(std_mu*2);
%    out_mu_min(i, :) =  mu3(i,:)<mean_mu-(std_mu*2);
% end
% 
% %Determine in which trials outlier are, eg.
% whichtrial = find(sum(out_epsi_max))

%Find max and min easier way
%  max_epsi = max(epsi2 ,[], 1)'
%  min_epsi = min(epsi2 ,[], 1)'
%  max_sa = max(sigma2 ,[], 1)'
%  min_sa = min(sigma2 ,[], 1)'
%  max_mu = max(mu3 ,[], 1)'
%  min_mu = min(mu3 ,[], 1)'
%  max_min_traj = table(max_epsi, min_epsi, max_sa, min_sa, max_mu, min_mu)


%% check for weird trajectories by maximum/minimum values
sub = 1:size(mu3,1);
y=repmat(sub',[1,160]);
i = y(epsi2==max(epsi2));
x = unique(i);

% for j = 1:length(x)
%     subject= x(j)
%     plot(mu3(x(j),:));
%     %close;
% end

%no SPM.mat created for thiese subjects, bc mu traj contained NaNs
 %outliers = [71]
% anfangs bei 11 einseitige Inputs und responses
% bei 3, muss was anderes der Grund sein
%39, 73, 78 unauffällig
% "sz_20_196" & Code!="sz_20_136" & Code!="sz_20_123" & Code!="sz_10_014"
outliers = [39;73;78;3]
% % 26 --> only loseshift?
for j = 1:length(outliers)
    tapas_hgf_binary_v1_plotTraj(est(outliers(j)));
    set(gcf,'name',char(subjects(outliers(j))),'numbertitle','off')
    % close;
end


%% Sliding window analyse
for sub = 1:86
    for i = 20:160
        %Sliding window mean and sd from 20 prev trials
        m_epsi(sub,i) = mean(epsi2(sub,i-19:i-1), 'omitnan'); 
        sd_epsi(sub,i) = std(epsi2(sub,i-19:i-1), 'omitnan') ;
        
        m_sa(sub,i) = mean(sigma2(sub,i-19:i-1), 'omitnan'); 
        sd_sa(sub,i) = std(sigma2(sub,i-19:i-1), 'omitnan') ;
        
        m_mu(sub,i) = mean(mu3(sub,i-19:i-1), 'omitnan'); 
        sd_mu(sub,i) = std(mu3(sub,i-19:i-1), 'omitnan') ;
    end
end


%% Find values that are larger or smaller than mean +/- 100*SD
for sub = 1:86
     [mY, Zn, mZ, mn, outlier] = onesided_med(esi2(sub), step, threshold)
     outlier_all(sub) = outlier
end

%EPSI

%Abgebrochen
% epsi2(11,:) = [];
% epsi2(77,:) = [];
% epsi2(72,:) = [];
% epsi2(38,:) = [];
% 
% %Outlier
% epsi2(23,:) = [];
% epsi2(66,:) = [];
% epsi2(48,:) = [];
% epsi2(69,:) = [];


which_smaller = epsi2(:,1:160)< (m_epsi - (100*sd_epsi));
which_larger = epsi2(:,1:160)> (m_epsi + (100*sd_epsi));
epsi_noutlier_per_trial = sum(which_larger) + sum(which_smaller);

%SIGMA
which_smaller_sa = sigma2(:,1:160)< (m_sa - (100*sd_sa));
which_larger_sa = sigma2(:,1:160)>( m_sa + (100*sd_sa));
sa_noutlier_per_trial = sum(which_larger_sa) + sum(which_smaller_sa);

%MU
which_smaller_mu = mu3(:,1:160)< (m_mu - (100*sd_mu));
which_larger_mu = mu3(:,1:160)> (m_mu + (100*sd_mu));
mu_noutlier_per_trial = sum(which_larger_mu) + sum(which_smaller_mu);

outlier_on_trial = [epsi_noutlier_per_trial', mu_noutlier_per_trial', sa_noutlier_per_trial']

clearvars -except outlier_on_trial epsi2 sigma2 mu3 yeu subjects traj_subs est