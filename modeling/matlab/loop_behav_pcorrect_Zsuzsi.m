% Adjusted, Z. Sjoerds Jan. 2015, for use in SALAD study (within-subject test-retest)
% exra adjustments Feb 2016 to calculate amount of probabilistic errors
% ATTENTION: SECOND CELL IS NOT ADJUSTED! RUN ONLY FIRST CELL!!

close all
clear
clc


%%%%%%%%%%%%
%modifyme

% day = '2' %for readout of correct day-data

%settings
do_log            =0;

cond = 2; % adapt here for CT = 1 and ST = 2

if cond == 1
data_path         = '/Users/larawieland/Documents/Promotion/SALAD_3/data_raw/sample1_operant/ST/';
else 
data_path         = '/Users/larawieland/Documents/Promotion/SALAD_3/data_raw/sample1_operant/CT/';
end

%%%%%%%%%%%%%%%

% load data 
cd (data_path)
all_data    = dir( '*WS.mat');
Nsj=length(all_data) % number of subjects
group = [];
       


phlo = [ones(1,55)             ones(1,70)+1 ones(1,35)+2]; 
phsh = [ones(1,55)             ones(1,70)+1 ones(1,34)+2 0];
phma = [0 ones(1,55)           ones(1,70)+1 ones(1,34)+2];
       
       
for sub = 1:length(all_data)
  
    sjs(sub,:) = all_data(sub).name(7:16);

    %define groups 1 == controls, 2==AD-patients, 3==heavy-drinkers
%     if     all_data(sub).name(7)=='1';
%            group(sub)=1; 
%            
%     elseif all_data(sub).name(7)=='2';
%            group(sub)=2;
%     
%     elseif all_data(sub).name(7)=='3';
%            group(sub)=3;       
%            
%     end
  
    eval(['load ' [data_path all_data(sub).name] ' R A C RT;']);
    %A(sub,:)=A; 
    valid(sub) = sum(~isnan(A));
    valid_start(sub) = sum(~isnan(A(1:55)));
    valid_start35(sub) = sum(~isnan(A(1:35)));
    valid_middle(sub) = sum(~isnan(A(56:125)));
    valid_end(sub)   = sum(~isnan(A(126:end)));
    
    a = A(~isnan(A))';
    r = R(~isnan(A))'; 
    c = C(~isnan(A))';
    proberror = (c==1 & r==-1)+(c==0 & r==1);
    
    p_correct(sub)   = sum(C(~isnan(A)))/valid(sub); %Anzahl korrekter antworten ??ber komplettes Exp
    p_correct_start(sub) = nansum(C(1:55))   /valid_start(sub); 
    p_correct_start35(sub) = nansum(C((1:35)))   /valid_start35(sub);
    p_correct_middle(sub) = nansum(C((56:125)))   /valid_middle(sub);
    p_correct_end(sub)   = nansum(C((126:end)))/valid_end(sub);  
   
    RT(RT==0)=NaN;
    rt(sub) = nanmean(RT);
    rt_start(sub) = nanmean(RT(1:55));
    rt_start35(sub) = nanmean(RT(1:35));
    rt_middle(sub) = nanmean(RT(56:125));
    rt_end(sub) = nanmean(RT(126:end));
    
    correct_start15(sub,:)  = C((1:15));
    correct_middle15(sub,:) = nanmean([C((56:70)); C((71:85)); C((91:105)); C((106:120))]);
    correct_end15(sub,:)    = C((126:140));
    
    nprob_errors(sub,:) = sum(((C==1)&(R==-1))+((C==0)&(R==1)));
    nprob_errors_start(sub,:) = sum(((C(1:55)==1)&(R(1:55)==-1))+((C(1:55)==0)&(R(1:55)==1)));
    nprob_errors_middle(sub,:) = sum(((C(56:125)==1)&(R(56:125)==-1))+((C(56:125)==0)&(R(56:125)==1)));
    nprob_errors_end(sub,:) = sum(((C(126:end)==1)&(R(126:end)==-1))+((C(126:end)==0)&(R(126:end)==1)));
    
    %winstay loseshift, logistic regression
    if     do_log
           phlov = phlo(~isnan(A)); 
           phshv = phsh(~isnan(A)); 
           phmav = phma(~isnan(A)); 
           st = a(1:end-1)==a(2:end);
           Y = st;
           X = [r(1:end-1)==1 phshv(1:end-1)' proberror(1:end-1) ];  
           N = ones(size(Y));
           [B,DEV,STATS] = glmfit(double(X), [Y N], 'binomial', 'link', 'logit', 'constant', 'on');
           YHAT          = glmval(B,double(X),'logit', 'constant', 'on');
           %X2 = [r(1:end-1)==1 phshv(1:end-1)'];  
           %[B2,DEV2,STATS2] = glmfit(double(X2), [Y N], 'binomial', 'link', 'logit', 'constant', 'on');
           %YHAT2          = glmval(B2,double(X2),'logit', 'constant', 'on');
           
           output{sub}.B     = B;
           output{sub}.DEV   = DEV;
           output{sub}.STATS = STATS;
           output{sub}.YHAT  = YHAT;
           output{sub}.pp    = [mean(YHAT(X(:,1)==1)) mean(YHAT(X(:,1)==0)) ... 
                                mean(YHAT(X(:,1)==1 & X(:,2)==1)) mean(YHAT(X(:,1)==0 & X(:,2)==1)) ... 
                                mean(YHAT(X(:,1)==1 & X(:,2)==2)) mean(YHAT(X(:,1)==0 & X(:,2)==2)) ... 
                                mean(YHAT(X(:,1)==1 & X(:,2)==3)) mean(YHAT(X(:,1)==0 & X(:,2)==3)) ... 
                                mean(YHAT) ...
                                mean(YHAT(X(:,1)==1 & X(:,3)==1)) mean(YHAT(X(:,1)==0 & X(:,3)==1)) ...
                                mean(YHAT(X(:,1)==1 & X(:,3)==0)) mean(YHAT(X(:,1)==0 & X(:,3)==0))];   
           p_w_st(sub)  = output{sub}.pp(1);
           p_l_st(sub)  = output{sub}.pp(2); 
           p_w_st1(sub) = output{sub}.pp(3); 
           p_w_st2(sub) = output{sub}.pp(5); 
           p_w_st3(sub) = output{sub}.pp(7); 
           p_l_st1(sub) = output{sub}.pp(4); 
           p_l_st2(sub) = output{sub}.pp(6); 
           p_l_st3(sub) = output{sub}.pp(8); 
           p_st(sub)    = output{sub}.pp(9);
           p_sw(sub)    = 1-p_st(sub); 
           p_w_st_prob(sub) = output{sub}.pp(10); 
           p_l_st_prob(sub) = output{sub}.pp(11); 
           p_w_st_prob_no(sub)    = output{sub}.pp(12); 
           p_l_st_prob_no(sub)    = output{sub}.pp(13); 
           
           p_st1(sub) = mean(YHAT(X(:,2)==1));
           p_st2(sub) = mean(YHAT(X(:,2)==2));
           p_st3(sub) = mean(YHAT(X(:,2)==3));
    end
    
end
block_diff    = p_correct_start-p_correct_end;
data          = p_correct_start35; 

    sjn(:,1) = str2num(sjs(:,6:8)); 
    sjn(:,2) = str2num(sjs(:,10)); 


allp_corrects = [sjn p_correct' p_correct_start' p_correct_middle' p_correct_end'];
arrrts = [sjn rt' rt_start' rt_middle' rt_end'];
allvalid = [sjn valid' valid_start' valid_middle' valid_end'];
winstay = [sjn p_w_st' p_l_st' p_w_st1' p_w_st2' p_w_st3' p_l_st1' p_l_st2' p_l_st3' p_st' p_sw' p_st1' p_st2' p_st3'];

%data          = [p_correct(1:28) p_correct(30:end)]; 

% %% new
% 
% p_correct_c = p_correct((sjn(:,2)=='A' & sjn(:,8)=='1') | (sjn(:,2)=='B' & sjn(:,8)=='2'));
% p_correct_start_c = p_correct_start((sjn(:,2)=='A' & sjn(:,8)=='1') | (sjn(:,2)=='B' & sjn(:,8)=='2'));
% p_correct_middle_c = p_correct_middle((sjn(:,2)=='A' & sjn(:,8)=='1') | (sjn(:,2)=='B' & sjn(:,8)=='2'));
% p_correct_end_c = p_correct_end((sjn(:,2)=='A' & sjn(:,8)=='1') | (sjn(:,2)=='B' & sjn(:,8)=='2'));
% 
% p_correct_s = p_correct((sjn(:,2)=='B' & sjn(:,8)=='1') | (sjn(:,2)=='A' & sjn(:,8)=='2'));
% p_correct_start_s = p_correct_start((sjn(:,2)=='B' & sjn(:,8)=='1') | (sjn(:,2)=='A' & sjn(:,8)=='2'));
% p_correct_middle_s = p_correct_middle((sjn(:,2)=='B' & sjn(:,8)=='1') | (sjn(:,2)=='A' & sjn(:,8)=='2'));
% p_correct_end_s = p_correct_end((sjn(:,2)=='B' & sjn(:,8)=='1') | (sjn(:,2)=='A' & sjn(:,8)=='2'));



%% PLOTS, e.g. to compare groups
% Modify a few parameters, e.g. 'group'

% organize data for bar plots
mean_both1  = [mean(p_correct(group==1)) mean(p_correct(group==2))];

%sem_both1   = [std(data(demo_data(:,3)==1))/sqrt(sum(demo_data(:,3)==1)) std(data(demo_data(:,3)==3))/sqrt(sum(demo_data(:,3)==1))];
figure('Color', 'w', 'Position', [200 200 800 700], 'Units', 'centimeters'); hold on; 
ylabel(' correct choices ','fontsize', 18); 
bar([1], mean_both1(1), 0.5,  'g'); 
bar([2], mean_both1(2), 0.5,  'b'); 
%errorbar(mean_both1, sem_both1,  'Color', 'black', 'LineStyle', 'none')
xt=[1 2]; 
xl={'HC' 'OCD'}; 
set(gca, 'Color', 'w', 'xTick', xt, 'xTicklabel', xl, 'ylim', [.5 .9], 'xlim', [0.5 2.5],'fontsize', 16); 


[sig p con stats] = ttest2((p_correct(group==1)), (p_correct(group==2)))

fprintf ('middle')
[sig p con stats] = ttest2((p_correct_middle(group==1)), (p_correct_middle(group==2)))

fprintf ('start')
[sig p con stats] = ttest2((p_correct_start(group==1)), (p_correct_start(group==2)))

fprintf ('end')
[sig p con stats] = ttest2((p_correct_end(group==1)), (p_correct_end(group==2)))

fprintf ('Blockdifferenz')
[sig p con stats] = ttest2((block_diff (group==1)), (block_diff (group==2)))







%text(1.8, 0.95, ['Two-sample t-test:'], 'fontsize', 14); 
t1 = num2str(stats.tstat);t2 = num2str(p);
text(1.8, 0.16, ['t=' t1(1:4), 'p=' t2],'fontsize', 16); 
%legend('HIGH', 'LOW', 'Location', 'BestOutside');
hold off; 

% organize data for bar plots
%mean_both2  = [mean(data(demo_data(:,4)==1)) mean(data(demo_data(:,4)==3))];
%sem_both2   = [std(data(demo_data(:,4)==1))/sqrt(sum(demo_data(:,4)==1)) std(data(demo_data(:,4)==3))/sqrt(sum(demo_data(:,4)==1))];
figure('Color', 'w', 'Position', [200 200 800 700], 'Units', 'centimeters'); hold on; 
ylabel(' correct choices ','fontsize', 18); 
bar([1], mean_both2(1), 0.5,  'g'); 
bar([2], mean_both2(2), 0.5,  'b'); 
errorbar(mean_both2, sem_both2,  'Color', 'black', 'LineStyle', 'none')
xt=[1 2]; 
xl={'HC' 'BE'}; 
set(gca, 'Color', 'w', 'xTick', xt, 'xTicklabel', xl, 'ylim', [.5 .9], 'xlim', [0.5 2.5],'fontsize', 16); 
[sig p x1 stats] = ttest2(data(demo_data(:,4)==1), data(demo_data(:,4)==3)); 
%text(1.8, 0.95, ['Two-sample t-test:'], 'fontsize', 14); 
t1 = num2str(stats.tstat);t2 = num2str(p);
text(1.8, 0.91, ['t=' t1(1:4) ', p=' t2],'fontsize', 16); 
%legend('HIGH', 'LOW', 'Location', 'BestOutside');
hold off; 
