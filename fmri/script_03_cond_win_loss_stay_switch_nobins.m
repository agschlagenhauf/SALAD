clear
clc
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
stats_path      = '/Volumes/DoReMe/DRMH05/DRMH05T1/rev/';   
einzelstats_pre = stats_path(29:end);
%model_path       = 'C:\Users\katthagt\ownCloud\operant_unmed\models\';
vd_data         = '/Volumes/DoReMe/DRMH05/DRMH05T1/rev/behav/';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%get modelling regressors
%    load (fullfile(model_path, 'SU_06_model_2alpha_1rho_05-Oct-2016'), 'est')
% get number of scans    
    %load nr_scans
%get beh data including onsets
    cd(vd_data); sub_file = dir('*WS.mat');
    
for sub = 1:length(sub_file) 
    %try 
    fprintf('working on %s \n', sub_file(sub).name);
    cd(vd_data);load(sub_file(sub).name, 'T', 'A', 'R');
    cd(stats_path);
    if ~exist([einzelstats_pre '_' sub_file(sub).name(7:12)]) mkdir([einzelstats_pre '_' sub_file(sub).name(7:12)]); end    
    sub_stats_path  = fullfile(stats_path, [einzelstats_pre '_' sub_file(sub).name(7:12)]);
        
%     miss =A(A==NaN);
    R = R(~isnan(A));
    x=A(~isnan(A));  stay=zeros(length(x)-1,1);shift=zeros(length(x)-1,1);
    for i=2:length(x);
    if x(i)-x(i-1)==0
        stay(i-1)=1;
    else shift(i-1)=1;
    end
    end
    

    %n_miss(sub) = sum(A==0);
    %get onsets
    names       = {'win','loss', 'missings'}; 
    durations   = {0 0 2};

    onsets_feedback = T.onset_fb' -T.baseline_start; 
    %onsets_cue      = T.onset_cue'-T.baseline_start; 
    
    %onsets_missings = T.onset_missing_sign'-T.baseline_start;
    onsets_missings = onsets_feedback(isnan(A));
    onsets_feedback = onsets_feedback(~isnan(A));  
    onsets_win      = onsets_feedback(R==1);
    onsets_loss     = onsets_feedback(R==-1);
    onsets{1} = onsets_win;
    onsets{2} = onsets_loss;
    
    if ~isempty(onsets_missings)
        onsets{3} = onsets_missings-1; 
    else 
        onsets{3} = NaN;
    end

      
    win_stay = stay; win_stay = win_stay(R(1:end-1)'==1); win_shift=abs(win_stay-1);
    lose_shift=shift; lose_shift=lose_shift(R(1:end-1)'==-1);lose_stay=abs(lose_shift-1);
     
    
    if length(onsets_loss) > length(lose_shift);
       lose_shift = [lose_shift;0]; lose_stay = [lose_stay;0]; 
    else win_shift = [win_shift;0]; win_stay = [win_stay;0]; 
    end
    
    %%%get parametric modulators from model 
    % 1st parametric modulator "Feedback_pmod", 
%     pmod(1).name{1}  = 'win_PE';
%     pmod(1).param{1} = est(sub).traj.da(R==1,1);
%     pmod(1).poly{1}  = 1;
%    
%     pmod(2).name{1}  = 'loss_PE';
%     pmod(2).param{1} = est(sub).traj.da(R==-1,1);
%     pmod(2).poly{1}  = 1;

    pmod(1).name{1}  = 'win_stay';
    pmod(1).param{1} = win_stay;
    pmod(1).poly{1}  = 1;
   
    pmod(1).name{2}  = 'win_shift';
    pmod(1).param{2} = win_shift;
    pmod(1).poly{2}  = 1;
   
    pmod(2).name{1}  = 'lose_stay';
    pmod(2).param{1} = lose_stay;
    pmod(2).poly{1}  = 1;

    pmod(2).name{2}  = 'lose_shift';
    pmod(2).param{2} = lose_shift;
    pmod(2).poly{2}  = 1;
    
    %%% save multiple condition files
    cd(sub_stats_path)
    save(['conditions_' sub_file(sub).name(12:17) '.mat'], 'onsets', 'durations', 'names', 'pmod');
    %save(['conditions_' sub_file(sub).name(7:12) '.mat'], 'onsets', 'durations', 'names', 'pmod');
    clear onsets names durations R T A pmod stay shift x lose_stay lose_shift win_stay win_shift
    %catch
    %end
end

        
        
