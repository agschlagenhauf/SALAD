%----------------------------------------------------------------------------
%           Experimental Parameters
%           DO NOT MODIFY between subjects within one experiment
%----------------------------------------------------------------------------

% payout settings 
maxpayout=10;           % maximal payout in Euro 
minpayout=3; 	     	% minimal payout in Euro 
Z.cent_per_point=0.1; 

%number trials instructions and main experiment  
if doinstr==1;   Z.Ntrials       = 20;   % number of learning trials in training (no null events)
else             Z.Ntrials       = 160;  % number of learning trials in scanner (without null events)
end

%probabilistic and system changes settings
Z.p_rew_good            =  .8;              % probability to get reward for correct choice (valid positive feedback)
Z.p_rew_bad             =  .2;              % probability to get reward for incorrect choice (invalid positive feedback)  
Z.nprob_l               = [42 22];          % limit, 1.96 std 
syschanges.first        = 55; 
syschanges.second       = 70; 
syschanges.third        = 90; 
syschanges.fourth       = 105; 
syschanges.fifth        = 125; 


% timing
Z.max_choice_time             =  1.5;             % maximal time to respond sec
if doeeg                                          
   Z.display_choice           =  0.5;             % duration to highlight choice with frame without feedback
   Z.display_fix_post_choice  =  1.5;             % ISI for EEG between logged choice and feedback presentation
else
   Z.display_choice           =  0;
   Z.display_fix_post_choice  =  0;
end
Z.display_fb                  =  0.5;             % duration to display feedback
Z.min_display_fix_cross       =  1;               % + jittered ITI for fMRI; mean 2.5s + 20% null events

% keys 
KbName('UnifyKeyNames');
instrbackward           = 'LeftArrow'; 			% left key for changing instruction page 
instrforward            = 'RightArrow';			% right key for changing instruction page 
if ~doscanner && ~doeeg
   keyleft     = 'f';           % left key 
   keyright    = 'j';           % right key 
elseif doscanner == 1
   keyleft     = '3'; % left key, responsbox
   keyright    = '4'; % right key, responsbox 
   trigger     = '5'; % trigger send from the scanner, equals 5 on numpad (BCAN only, MPI Parallelport)
elseif doeeg == 1
   keyleft     = '2'; % left key, responsbox
   keyright    = '1'; % right key, responsbox 
end

% ITIs for scanning
% load predefined variable 'ITI' containing exponentialy distributed
% values: 
if     doscanner
       load('iti_w_null.mat'); 
elseif doeeg
       load('iti_wo_null.mat'); 
       ITI = ITI_wo_null(randperm(160)); 
end
