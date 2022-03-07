%%%% Loop for extraction of single-trial predictors and dependent variable for winstay/loseshift analysis of reversal learning data
%%%% in line with den Ouden et al., Neuron, 2013 (analysis from the Supplement)
%%%% code by Teresa Katthagen, May 2020.


clc
clear
close all

%%%%%%%%%%%%
data_path = '/Users/larawieland/Documents/Promotion/SALAD_3/data_raw/sample1_operant/CT/'; 
data =  dir([data_path '*.mat']);
%%%%%%%%%%%%%%
%% Set history of previous trials and total trials
history = 4; 
ntrials = 160;


% initialize variables
response        = NaN(ntrials, length(data));
outcome         = NaN(ntrials, length(data));
winstay         = NaN(ntrials, history, length(data));
loseshift       = NaN(ntrials, history, length(data));
reaction_times  = NaN(ntrials, length(data));

trial_idx       = 1:ntrials;


for sub = 1:length(data)
    sub
    subjects{sub} = data(sub).name(1:end-4);
    load([data_path data(sub).name], 'A', 'R','RT');
    group{sub} = data(sub).name(7); 
    fin        = length(A);
    response(1:fin, sub)   = double(A==1);
    outcome(1:fin, sub) = double(R==1);
    reaction_times(1:fin, sub) = double(RT);
    
    R     = double(R==1);
    resp  = A;
    resp(resp==2) = -1;


    for i = 1:length(R)
    for h = 1:history
    if i > h
    win                  = [resp(i-h), R(i-h)];
    winstay(i, h, sub)   = prod(win);
    
    loss                 = [-resp(i-h), 1-R(i-h)];
    loseshift(i,h,sub)   = prod(loss);
    end
    end
    end
    
substart             = sub*ntrials - ntrials+1;
subend               = sub*ntrials;

sub_name(substart:subend)  = subjects(sub);
sub_group(1:ntrials) = str2double(group{sub});
sub_idx(1:ntrials)   = sub;

table(substart:subend,:) = [sub_idx', sub_group', trial_idx', outcome(:,sub), response(:,sub), winstay(:,:,sub), loseshift(:,:,sub), reaction_times(:,sub)];

    
end

for h = 1:history
n_win_st{h}     = ['winstay_t', num2str(h)];
n_lose_sh{h}    = ['loseshift_t', num2str(h)];
end

var_names =['sub_idx', 'Group', 'Trial_idx', 'Outcome', 'Choice_t', n_win_st, n_lose_sh, 'RT'];




singletrialstable = array2table(table,'VariableNames',var_names)
% singletrialstable.Properties.RowNames = sub_name;
writetable(singletrialstable,'SALAD_CT_TransOp_singletrials_wRT.csv','WriteRowNames',true, 'Delimiter', 'comma') 

 


