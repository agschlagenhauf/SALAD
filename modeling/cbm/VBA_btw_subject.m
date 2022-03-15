% First level analysis
% =============================================================
% the following part simulate some fake subject-level data.
% This has to be replace by your own single subject inversions

% description of the experiment dimension
nMod  = 6 ;  % number of models
nCond = 2 ;  % number of experiment conditions
nSub1 = 28; % number of subject in the first group
nSub2 = 28; % number of subject in the second group

% evidence matrix for your first group
L_1 = randn(nMod,nSub1,nCond) ; % use dummy data for the example

% and for your second group
L_2 = randn(nMod,nSub2,nCond) ; % use dummy data for the example

% Between condition analysis
% =============================================================
% here, we generate the evidence matrices for the composite
% models that describe the subject's behaviour across conditions

%perform the between condition analyses for each group
[~,out_cond_1] = VBA_groupBMC_btwConds(L_1);
[~,out_cond_2] = VBA_groupBMC_btwConds(L_2);

% gather the evidence for the nMod^nCond composite models
L_btw_1 = out_cond_1.VBA.btw.out.L ; 
L_btw_2 = out_cond_2.VBA.btw.out.L ;

% save the family partionning for later
% family 1 is for "all conditions equals"
% family 2 is for "conditions are different"
btw_families = out_cond_1.families ; %identitcal to out_cond_2.families

% Between group analysis
% =============================================================
% here, we test the composite models differ accross group

% test if 1 group has a condition effect but hte other doesn't
options_btw_group.families = btw_families; % restrict group differences to families
[h,p,post_hoc] = VBA_groupBMC_btwGroups({L_btw_1,L_btw_2},options_btw_group)

% test if groups have the same between condition effect
[h,p,post_hoc] = VBA_groupBMC_btwGroups({L_btw_1,L_btw_2}) % no families

