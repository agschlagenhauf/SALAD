% Run this line only once after starting up matlab & then comment
%spm_jobman('initcfg');


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1. Automatic adaptation of batch due to modification
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
donull = 0; 
%pathRoot = '/filer/workspace/chmathys/Efficiency/'; % where the efficiency analysis takes place
pathRoot='./';
nVols      = 440;      % MODIFY
TR         = 2;      % in seconds
nSlices    = 36;
onsetSlice = 1;    % to which all regressors are temporally aligned

cs = eye(3);
%get_iti; 
%delays1=rand(70, 1); % 1000 test cases
%delays2=rand(70, 2); % 1000 test case
itis      = zeros(160,1000); % 1000 test cases
if donull; nulls = zeros(160,1000); end% 1000 test cases
for a = 1:size(itis,2)
    get_iti;
    itis(:,a) = ITI';
    if donull; nulls(:,a) = do_null; end% 1000 test cases
end

% MODIFY according to your implementation of get_conditions

%ITI1 = 1:size(delays1,2); %delay 1 = (70,1)-vector
%ITI2 = 1:size(delays2,2); %delay 2 = (70,1)-vector
ITI1  = 1:size(itis,2);

% END MODIFY


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 2. Automatic adaptation of batch due to modification
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load(fullfile(pathRoot, 'batch_glm_specify.mat'));
matlabbatch{1}.spm.stats.fmri_design.timing.RT = TR;
matlabbatch{1}.spm.stats.fmri_design.sess.nscan = nVols;
matlabbatch{1}.spm.stats.fmri_design.timing.fmri_t = nSlices;
matlabbatch{1}.spm.stats.fmri_design.timing.fmri_t0 = onsetSlice;
matlabbatch{1}.spm.stats.fmri_design.dir = ...
    cellstr(pathRoot);
matlabbatch{1}.spm.stats.fmri_design.sess.multi = ...
    cellstr(fullfile(pathRoot, 'multiple_conditions.mat'));


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 3. Run Efficiency calculation for different design configurations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%[I1, I2, I3] = ndgrid(ITI1, ITI2, ITI3);
%[I1] = ndgrid(ITI1);
[I1] = ITI1; 

nConfigs = numel(I1);

eff = zeros(nConfigs,size(cs,2));
for n=1:nConfigs
    %delay1 = delays1(:,I1(n));
    %delay2 = delays2(:,I2(n));
    iti = itis(:,I1(n));
    get_conditions_opvol(iti);
    
    
    %spm_jobman('interactive', matlabbatch); % for debugging
    
    delete(fullfile(pathRoot, 'SPM.mat'));
    spm_jobman('run', matlabbatch);
    pause(0.5);
    
    load(fullfile(pathRoot, 'SPM.mat'));
    %% A) Alternative: Access before prewhitening and filtering
    % X = SPM.xX.X;
    
    %% B) High-pass filter X as SPM would do in spm_spm
    
    % create filter according to spm_sp and spm_filter
    xX = SPM.xX;
    xX.K.row = 1:nVols; xX.K.RT= TR; xX.K.HParam=128; xX.K = spm_filter(xX.K);
    
    % we cannot prewhiten without data (hyperparameter estimation);
    W = eye(nVols);
    
    xX.xKXs   = spm_sp('Set',spm_filter(xX.K,W*xX.X));    
    
    % after pre-whitening and filtering
    X = xX.xKXs.X;
    for indC = 1:size(cs,2)
        c = cs(:,indC);
        eff(n,indC) = 1/(c'*pinv(X'*X)*c);
    end
end




%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 2. Analysis of 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

hist(eff);
[maxeff, ind] = max(eff);

fprintf('Minimum efficiency: %f\n', min(eff));
fprintf('Maximum efficiency: %f\n', maxeff);
fprintf('Median efficiency:  %f\n', median(eff));
fprintf('Relative efficiency range compared to Median %6.2f per cent \n', 100*(maxeff-min(eff))/median(eff));

%fprintf('Parameter settings of optimal solution: i1= %6.3f \t i2=%6.3f\t i3=%6.3f\n', I1(ind), I2(ind), I3(ind));
fprintf('Parameter settings of optimal solution: i1= %6.3f \n', I1(ind)); %I2(ind), I3(ind));

