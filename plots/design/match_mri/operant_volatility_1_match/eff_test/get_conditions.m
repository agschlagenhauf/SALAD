function get_conditions(delay1, delay2, iti)

if ~nargin
    i1 = 1;
end

answer = 10;
dec = 7.5;
trial_dur = (2+delay1+dec+1.5+answer+delay2+2+iti);

trial_start = [0;cumsum(trial_dur(1:end-1,:))];
% 1. Specify Conditions
onsets{1}       = trial_start; % MODIFY
durations{1}    = 0;
names{1}        = 'InvestEvent';
pmod(1).name{1} = 'Investment';
pmod(1).param{1}= sort(rand(1,70)); % MODIFY
pmod(1).poly{1} = 1;

onsets{2}       = onsets{1} + delay1;
durations{2}    = 0;
names{2}        = 'PredEvent';
pmod(2).name{1} = 'Prediction';
pmod(2).param{1}= sort(rand(70,1)); % MODIFY
pmod(2).poly{1} = 1;

onsets{3}       = onsets{2} + dec + 1.5 + answer + delay2;
durations{3}    = 0;
names{3}        = 'OutcomeEvent';
pmod(3).name{1} = 'PE';
pmod(3).param{1}= sort(rand(70,1)); % MODIFY  
pmod(3).poly{1} = 1;
pmod(3).name{2} = 'signedPE';
pmod(3).param{2}= sort(rand(70,1)); % MODIFY
pmod(3).poly{2} = 1;


% save multiple_conditions onsets durations names pmod
save('multiple_conditions',  'onsets', 'durations', 'names', 'pmod');
