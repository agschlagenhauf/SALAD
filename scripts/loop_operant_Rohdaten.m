clc
clear
close all

office =1;

if office==1;
data_path = '/Users/larawieland/Documents/ECN/Promotion/SALAD/data_raw/sample1_operant/T2/'; 
data =  dir([data_path '*.mat']);
else
% data_path = 'C:\Users\teres_000\ownCloud\Shared\FDOPA_SCHIZ_new\clasa_f20\VD\VD_unmed\'; % C:\Dropbox\Transfer\clasa_f20\VD\
end
sim = 1;

% initialize variables
Loss_BW = NaN(length(data),100);
J       = NaN(length(data),100);
IDX     = NaN(length(data),100);


for sub = 1:length(data)
    sub
    subjects{sub} = data(sub).name(1:end-4);
    load([data_path data(sub).name]);
    group{sub} = data(sub).name(7); 
%     R = R(~isnan(A)); A = A(~isnan(A));
%     y = A';  


miss(sub)          = sum(isnan(A));
p_miss(sub)        = sum(isnan(A))/160;
Correct_pre(sub,:) = sum(C(1:55)==1)/(55-sum(isnan(C(1:55))));
Correct_rev(sub,:) = sum(C(56:125)==1)/(70-sum(isnan(C(56:125))));
Correct_post(sub,:)=sum(C(126:end)==1)/(35-sum(isnan(C(126:end))));

RT_pre(sub,:) = mean(nonzeros((RT(1:55))));
RT_rev(sub,:) = mean(nonzeros((RT(56:125))));
RT_post(sub,:)= mean(nonzeros((RT(126:end))));
% Co(sub,:) = C; %Co(isnan(Co))=999;

% State(sub,:) = S; %S(isnan(S))=999;
Correct(sub,:)= sum(C==1)/length(A(~isnan(A)));


% stay and switch
stay                 = A(1:end-1)==A(2:end); 
sw                   = A(1:end-1)~=A(2:end); 

% percent stay switch
p_stay(sub,:)        = sum(stay)/length(A(2:end)); 
p_sw(sub,:)          = sum(sw)/length(A(2:end));

% percent switch independent of feedback
sw_pre(sub,:) = sum(sw(1:55)==1)/(55-sum(C(1:55)==NaN));
sw_rev(sub,:) = sum(sw(56:125)==1)/(70-sum(C(56:125)==NaN));
sw_post(sub,:)= sum(sw(126:end)==1)/(35-sum(C(126:end)==NaN));

% percent stay independent of feedback
stay_pre(sub,:)   = sum(stay(1:55)==1)/(55-sum(C(1:55)==NaN));
stay_rev(sub,:)   = sum(stay(56:125)==1)/(70-sum(C(56:125)==NaN));
stay_post(sub,:)  = sum(stay(126:end)==1)/(35-sum(C(126:end)==NaN));

% percent win stay and win shift
bla=[R(1:end-1)'.* stay'];
p_w_st_total(sub,:)      = sum(bla==1)/sum(R(1:end-1)==1);
p_w_st_pre(sub,:)        = sum(bla(1:55)==1)/sum(R(1:55)==1);
p_w_st_rev(sub,:)        = sum(bla(56:125)==1)/sum(R(56:125)==1);
p_w_st_post(sub,:)       = sum(bla(126:end)==1)/sum(R(126:end)==1);

p_w_sw(sub,:)            = 1-p_w_st_total(sub,:);

% percent lose stay and lose shift
bla = R==-1; foo      = [bla(1:end-1)'.* stay'];
p_l_st_total(sub,:)   = sum(foo==1) /sum(R(1:end-1)==-1);
p_l_sw_total(sub,:)   = sum(sw(R(1:end-1)==-1))/sum(R(1:end-1)==-1);
p_l_sw_pre(sub,:)     = sum(sw(R(1:55)==-1))/sum(R(1:55)==-1);
p_l_sw_pre11(sub,:)   = sum(sw(R(11:55)==-1))/sum(R(11:55)==-1);
p_l_sw_rev(sub,:)     = sum(sw(R(56:125)==-1))/sum(R(56:125)==-1);
p_l_sw_post(sub,:)    = sum(sw(R(126:end)==-1))/sum(R(126:end)==-1);

j   = 1; 
idx = 0;
for i=1:length(sw)
if sw(i)==1
j       = j+1;
idx(j) = i;
% loss_n(j) = ln + bla(i);
if i>1 & sw(i-1)==0
   loss_bw(j)=sum(bla((idx(j-1)+1):i));
else
   loss_bw(j)=0;
end
end

end

loss_bw(1)=[]; idx(1)=[];
x=zeros(1,length(idx)); x(idx<55)=1;
loss_bw_1=loss_bw(x==1); loss_bw_pre(sub)=nanmean(loss_bw_1);

x=zeros(1,length(idx)); x(idx>55 & idx<126)=1;
loss_bw_2=loss_bw(x==1); loss_bw_rev(sub)=nanmean(loss_bw_2);

x=zeros(1,length(idx)); x(idx>125)=1;
loss_bw_3=loss_bw(x==1); loss_bw_post(sub)=nanmean(loss_bw_3);


J(sub)                          = j-1;
Loss_BW(sub,1:length(loss_bw))  = loss_bw;
IDX(sub, 1:length(idx)-1)       = idx(2:end);
clear j idx loss_bw
end

 


