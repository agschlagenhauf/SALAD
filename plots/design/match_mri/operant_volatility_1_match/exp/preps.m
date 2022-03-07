%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%% Setup %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

aborted=0; % if this parameter is set to one, things will abort. 

% make sure we use different random numbers
rand('twister',sum(1000*clock));

%....................... Saving 
namestring_long  = ['OPVOL_' type '_'  subjn datestr(now,'_yymmdd_HHMM')]; % detailed name string
namestring_short = ['OPVOL_' type '_' subjn];                              % simplified name string 

if doinstr; namestring_short = [namestring_short '_training'];namestring_long = [namestring_long '_training'];end

if exist('data')~=7; eval(['!mkdir data']); end % make 'data' folder if doesn't exist

if dosave 
	fprintf('............ Data will be saved as                              \n');
	fprintf('............ %s and %s \n',namestring_long,namestring_short);
	fprintf('............ in the folder ''data''\n');
end

% setup variables
S=zeros(1,Z.Ntrials); S(1) = (rand(1)>.5)+1; % randomize state of first trial
A=zeros(1,Z.Ntrials); 
C=zeros(1,Z.Ntrials);
R=NaN(1,Z.Ntrials);

% define random numbers
random_lr               = (rand(1,Z.Ntrials)>0.5)+1;	% left or right 

if doinstr
    random_prob_fb =  rand(1,Z.Ntrials); % random number between 0 and 1 to compute if fb is probabilistic or not
else
    if ~dofirst
        cd('SCR/user/schlagenhauf/Experimente/SALAD/operant/operant_volatility_2/exp');
        file = dir(['data/OPVOL_' type '_' subjn '*_WS.mat']);
        day1 = load(fullfile('data',file.name), 'random_prob_fb');
        sday1 = sum(day1.random_prob_fb>Z.p_rew_good); 
        cd('SCR/user/schlagenhauf/Experimente/SALAD/operant/operant_volatility_1/exp');
    end
    while 1
        random_prob_fb =  rand(1,Z.Ntrials); % random number between 0 and 1 to compute if fb is probabilistic or not
        nprob          =  sum(random_prob_fb>Z.p_rew_good);
        if     dofirst && stim_order
            if  nprob < Z.nprob_l(1) && nprob > Z.nprob_l(2)
                if (nprob+nprob_d) < Z.nprob_l(1) && (nprob+nprob_d) > Z.nprob_l(2)
                    break;
                end
            end
        elseif ~dofirst && stim_order
            if  nprob < Z.nprob_l(1) && nprob > Z.nprob_l(2)
                if (nprob-sday1)>= nprob_d-1 && (nprob-sday1)<= nprob_d+1
                    break;
                end
            end
        elseif  dofirst && ~stim_order
            if  nprob < Z.nprob_l(1) && nprob > Z.nprob_l(2)
                if (nprob-nprob_d) < Z.nprob_l(1) && (nprob-nprob_d) > Z.nprob_l(2)
                    break;
                end
            end
        elseif  ~dofirst && ~stim_order
            if  nprob < Z.nprob_l(1) && nprob > Z.nprob_l(2)
                if (sday1-nprob)>= nprob_d-1 && (sday1-nprob)<= nprob_d+1
                    break;
                end
            end
        end
    end
end