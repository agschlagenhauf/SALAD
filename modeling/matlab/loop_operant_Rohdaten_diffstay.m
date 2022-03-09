clc
clear
close all

owncloud = 1;

if owncloud == 1;
data_path = '/Users/larawieland/Owncloud/Shared/DoReMe/Tasks/Helicopter/exp/data_heli/'; 
else
data_path = '/S'; 
end

data =  dir([data_path '*_WS.mat']);

for sub = 1:47
    sub
    subjects{sub} = data(sub).name(7:13);
    load([data_path data(sub).name], 'bag_caught', 'bag_location', 'bag_type',....
    'catch_trial', 'position_bucket', 'x_bucket_start', 'T', 'Z');

% simple behavioral variables
caught(sub)                 = sum(bag_caught == 1);
p_caught(sub)               = sum(caught/70);
money_bag_caught(sub,:)     = sum(bag_caught == 1 & bag_type==2);
neutral_bag_caught(sub,:)   = sum(bag_caught == 1 & bag_type==1);

bucket_move(sub)            = x_bucket_start(1:end-1) - position_bucket(1:end);
pred_error(sub)             = bag_location(1:end) - position_bucket(1:end);

end


