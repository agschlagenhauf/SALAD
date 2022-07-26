
Z.Ntrials       = 160;  % number of learning trials in scanner (without null events)
if donull
   load ('iti_wo_null.mat')
   Z.p_null_events = 0.2;
   Z.N_null_events = Z.Ntrials*Z.p_null_events; 
   pos_null        = randi(Z.Ntrials,[Z.N_null_events,1]);
   db = zeros(length(pos_null),1);
   db_1 = zeros(length(pos_null),1);
   while 1
         for i = 1:length(pos_null)
             db(i)   = any([pos_null(1:i-1); pos_null(i+1:end)] == pos_null(i));
             db_1(i) = any([pos_null(1:i-1); pos_null(i+1:end)] == pos_null(i)+1);
             if db(i) == 1
                pos_null(i) = randi(Z.Ntrials);
             end
             if db_1(i) == 1
                pos_null(i) = randi(Z.Ntrials);
             end
         end
         if sum(db) == 0 && sum(db_1) == 0
            break
         end
    end
    do_null = zeros(Z.Ntrials,1);
    do_null(pos_null) = 1;
    ITI_wo_null(do_null==1) = ITI_wo_null(do_null==1)+4.5;
    ITI = ITI_wo_null; 
else
% load predefined variable 'ITI' containing exponentialy distributed
% values to optimize the sequence of the previously optimized 
    if     a <= 1000
           load('ITI_CLASA_OPVOL_0-7_mean1_5_st1_nt160.mat') 
           if   donull 
                ITI_final(do_null==1) = ITI_final(do_null==1)+4.5;
                ITI = ITI_final; 
           else ITI = ITI_final(randperm(Z.Ntrials));
           end
    elseif a > 1000 & a <= 2000
           load('ITI_CLASA_OPVOL_0-7_mean1_5_st4_nt160.mat') 
           if   donull 
                ITI_final(do_null==1) = ITI_final(do_null==1)+4.5;
                ITI = ITI_final; 
           else ITI = ITI_final(randperm(Z.Ntrials));
           end
    elseif a > 2000
           load('ITI_CLASA_OPVOL_0-7_mean1_5_st10_nt160.mat') 
           if   donull 
                ITI_final(do_null==1) = ITI_final(do_null==1)+4.5;
                ITI = ITI_final; 
           else ITI = ITI_final(randperm(Z.Ntrials));
           end
    end
end