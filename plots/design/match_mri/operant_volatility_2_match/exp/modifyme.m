
%----------------------------------------------------------------------------
%        MAIN FILE TO EDIT
%
%        This is the only file that should demand any changes!!!
%
%----------------------------------------------------------------------------
fprintf('............ Setting basic parameters according to \n')
fprintf('............            MODIFYME.M\n'); fprintf('............ \n')

debug       = 0; % do debug mode, small screen (see setup.m)

doinstr     = 0; % 0: no instructions, just the experiment inside or outside the scanner
                 % 1: instructions and training, can be performed inside or
                 % outside the scanner 
                 
                 
                 
                 
                 
                 
%----------------------------------------------------------------------------
%        If set doscanner=1 exp will wait for the first trigger 
%        of the MR scanner and keys are different
%
%        If set doeeg=1 exp will wait for a button press (experimenter) to start 
%        and send markers, keys are different
%----------------------------------------------------------------------------
doscanner = 0; % 0: outside scanner the scanner,  1: inside the scanner 

doeeg     = 0; % do experiment and record eeg = 1 

dofirst    = 1;    % 1: day1 / first testing session, 0: day2 / second testing session  
stim_order = 0;    % 1: stim (intervention) at day1 / first testing session, 0: sham (control) at day1 / first testing session 
nprob_d    = -10;  % required difference between both session; can be positive or negative 
                   % because it always refers to sham (control) MINUS stim (intervention)
                  
%----------------------------------------------------------------------------
%        To save or not to save
%        This should ALWAYS be set to 1 when doing experiments obviously
%----------------------------------------------------------------------------
dosave = 1;      % save output? 

%----------------------------------------------------------------------------
%        Patient Information 
%--------------------------------------------------------------------------
type = '1B';      % '1' for controls, and '2' for patients, followed by the day_order code

subjn = '053_1';   % Subject Number_Day (1 or 2). Aufsteigend, fortlaufend 

payment = 1;      % is this subject being paid / should payment info be displayed
                  % at the end? Set this to zero for training!

%----------------------------------------------------------------------------
%        EXPERIMENT VERSION 
%			PLEASE check this is correct! 
%----------------------------------------------------------------------------
expversion = 'OPVOL_2.0_130716_MPI_fMRI_1_match';
