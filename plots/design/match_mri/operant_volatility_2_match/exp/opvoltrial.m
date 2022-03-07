fprintf(['............. Trial number ' num2str(nt) '\n'])
Screen('TextSize',wd,40);
% Get images for instructions or main experiment 
if doinstr == 1
   dreieck_allg = dreieck;
   viereck_allg = viereck;
elseif doinstr == 0    
   dreieck_allg = dreieck_blau;
   viereck_allg = viereck_gelb;
end
Screen('DrawTexture',wd,dreieck_allg,[],box(  random_lr(nt),:));
Screen('DrawTexture',wd,viereck_allg, [],box(3-random_lr(nt),:));
% Show stimulus on screen at next possible display refresh cycle,
% and record stimulus onset time in 'startrt':
[T.trial_onset(nt)] = Screen('Flip', wd); 
if doeeg
   outp(888,1); wait(tpulseLPT);  outp(888,0);
end

% Get choices 
valid_choice=0; KeyIsDown=0; 
% while loop to show stimulus until subjects response or until "duration"
% seconds elapsed.
if doscanner | doeeg
   clearserialbytes(serial_port)
   while (GetSecs - T.trial_onset(nt)) <= Z.max_choice_time-monitorFlipInterval
           readserialbytes(serial_port)
           [key, key_time, key_n] = getserialbytes(serial_port); key_time_ptb = GetSecs; 
           if strcmp(num2str(key),keyleft) | strcmp(num2str(key),keyright) 
              KeyIsDown = 1;
              break; 
           end
    end
else
    while (GetSecs - T.trial_onset(nt)) <= Z.max_choice_time-monitorFlipInterval
           [KeyIsDown, endrt(nt), KeyCode] = KbCheck; 
           key = KbName(KeyCode);
           if   strcmp(num2str(key),keyleft) | strcmp(num2str(key),keyright) 
                KeyIsDown = 1;
                break; 
           end
    end
end
if KeyIsDown; 
   if iscell(key); key=key{1}; end
      if     strcmp(num2str(key),keyleft);
             button(nt) = key;
             if doscanner | doeeg
             rt_abs_cog(nt) = key_time;
             rt_abs_ptb(nt) = key_time_ptb;
             n_key(nt)  = key_n;
             else rt_abs_ptb(nt) = endrt(nt);
             end
             a_side(nt) = 1; redraw=1; % left was chosen
             RT(nt) = rt_abs_ptb(nt)-T.trial_onset(nt); 
             T.onset_missing_sign(nt) = NaN; % reaction time, missing onset NaN
      elseif strcmp(num2str(key),keyright); 
             button(nt) = key;
             if doscanner |doeeg
             rt_abs_cog(nt) = key_time;
             rt_abs_ptb(nt) = key_time_ptb;
             n_key(nt)  = key_n;
             else rt_abs_ptb(nt) = endrt(nt);
             end
             a_side(nt) = 2; redraw=1; % right was chosen 
             RT(nt) = rt_abs_ptb(nt)-T.trial_onset(nt); 
             T.onset_missing_sign(nt) = NaN;  % reaction time, missing onset NaN
      else KeyIsDown = 0; key='wrong_key'; 
      end
else key = 'no_response';
end

% get chosen option 
if      strcmpi(num2str(key),keyleft) ; a_side(nt) = 1; valid_choice=1;% left was chosen 
elseif  strcmpi(num2str(key),keyright); a_side(nt) = 2; valid_choice=1;% right was chosen
elseif  strcmpi(key,'ESCAPE'); checkabort; return
else    a_side(nt)=NaN; valid_choice=-1; % too slow
end

% Display feedback
if valid_choice==1; 
   if   random_lr(nt)==2; A(nt)=    a_side(nt);
   else A(nt)=  3-a_side(nt);
   end

   % compute feedback according to probabilities 
   if      S(nt) == A(nt) && random_prob_fb(nt) < Z.p_rew_good     % informative reward     = correct rewarded response
           C(nt) =  1;
           R(nt) =  1;
   elseif  S(nt) == A(nt) && random_prob_fb(nt) > Z.p_rew_good     % misleading punishment  = probabilistic error 
           C(nt) =  1;
           R(nt) = -1;
   elseif  S(nt) ~= A(nt) && random_prob_fb(nt) > (1-Z.p_rew_bad)  % misleading reward      = probabilistic win
           C(nt) =  0;
           R(nt) =  1;
   elseif  S(nt) ~= A(nt) && random_prob_fb(nt) < (1-Z.p_rew_bad)  % informative punishment = incporrect response
           C(nt) =  0;
           R(nt) = -1;
   end

   %........................ Draw boxes and frame arround choosen square
   % Display choice
   Screen('DrawTexture',wd,squareframe,[],boxl(a_side(nt),:));
   Screen('DrawTexture',wd,dreieck_allg,[],box(  random_lr(nt),:));
   Screen('DrawTexture',wd,viereck_allg,  [],box(3-random_lr(nt),:));
   T.onset_choice(nt) = Screen('Flip', wd);
   if doeda | doeeg 
      if     a_side(nt) == 1
             marker_lr = 2;
      elseif a_side(nt) == 2
             marker_lr = 3; 
      end
      outp(hex2dec('5C00'),marker_lr); wait(tpulseLPT);  outp(hex2dec('5C00'),0);
   end
   WaitSecs(Z.display_choice-monitorFlipInterval);
   
   if doeeg
      Screen('TextSize',wd,txt_fix);
      DrawFormattedText(wd,'+','center','center',txtcolor);
      T.post_choice_fix(nt) = Screen('Flip', wd);
      WaitSecs(Z.display_fix_post_choice-monitorFlipInterval); 
   end

   % Display feedback... 
   if     R(nt)==1
          Screen('DrawTexture',wd,smiley,[],box_center);
          if doeda | doeeg 
             fb_marker = 4;
          end
   elseif R(nt)==-1
          Screen('DrawTexture',wd,frowny,[],box_center);
          if doeda | doeeg 
             fb_marker = 5; 
          end 
   end
   % ... and write outcome explicitly, too 
   if     R(nt)==1
          text1 = txt_win; 
          text2 = cent_win; 
          ocol  = col_gr; 
   elseif R(nt)==-1
          text1 = txt_loss; 
          text2 = cent_loss; 
          ocol  = col_re; 
   end
   % Display feedback and choice 
   Screen('DrawTexture',wd,squareframe,[],boxl(a_side(nt),:));
   Screen('DrawTexture',wd,dreieck_allg,[],box(  random_lr(nt),:));
   Screen('DrawTexture',wd,viereck_allg,  [],box(3-random_lr(nt),:));[wt]=Screen(wd,'TextBounds',text1); ypos1= box_center(2)- 1.5*wt(4); %????
   [wt]=Screen(wd,'TextBounds',text2); ypos2= box_center(4)+1.5*wt(4);  %????
   DrawFormattedText(wd,text1,'center',ypos1,ocol);     
   DrawFormattedText(wd,text2,'center',ypos2,ocol);   
   T.onset_fb(nt) = Screen('Flip', wd);
   if doeeg
      outp(888,fb_marker); wait(tpulseLPT);  outp(888,0);
   end
   WaitSecs(Z.display_fb-monitorFlipInterval);
   checkabort;
   
elseif valid_choice==-1
% Display feedback when response was too slow
       T.onset_choice(nt) = NaN; 
       if doeeg
          Screen('TextSize',wd,txt_fix);
          DrawFormattedText(wd,'+','center','center',txtcolor);
          T.post_choice_fix(nt) = Screen('Flip', wd);
          WaitSecs(Z.display_fix_post_choice-monitorFlipInterval); 
       end
       fb_marker = 6;
       if     doeeg
              DrawFormattedText(wd,text_fb_too_slow,'center','center',red);
       else   DrawFormattedText(wd,text_fb_too_slow,'center',ypos_fb,red);
              Screen('DrawTexture',wd,dreieck_allg,[],box(  random_lr(nt),:));
              Screen('DrawTexture',wd,viereck_allg, [],box(3-random_lr(nt),:));
       end
       T.onset_fb(nt) = NaN; 
       T.onset_missing_sign(nt) = Screen('Flip', wd);
       if doeda | doeeg 
          outp(hex2dec('5C00'),fb_marker); wait(tpulseLPT);  outp(hex2dec('5C00'),0);
       end
       WaitSecs(Z.display_fb-monitorFlipInterval);
       S(nt+1) = S(nt);
       A(nt)   = NaN;
       R(nt)   = NaN;
       C(nt)   = NaN;
       checkabort;
end
       
% define state of next trial S(t+1)
if     nt == syschanges.first
       S(nt+1) = 3-S(nt);   % do reversal
       %n_changes =  n_changes + 1; 
       %nts_changes = [nts_changes nts_changes]
elseif nt == syschanges.second
       S(nt+1) = 3-S(nt);   % do reversal
       %n_changes =  n_changes + 1; 
       %nts_changes = [nts_changes nts_changes]
elseif nt == syschanges.third
       S(nt+1) = 3-S(nt);   % do reversal
       %n_changes =  n_changes + 1; 
       %nts_changes = [nts_changes nts_changes]
elseif nt == syschanges.fourth
       S(nt+1) = 3-S(nt);   % do reversal
       %n_changes =  n_changes + 1; 
       %nts_changes = [nts_changes nts_changes]
elseif nt == syschanges.fifth
       S(nt+1) = 3-S(nt);   % do reversal
       %n_changes =  n_changes + 1; 
       %nts_changes = [nts_changes nts_changes]
else   S(nt+1) = S(nt);
end


% Wait ITI and show fixationcross
Screen('TextSize',wd,txt_fix);
DrawFormattedText(wd,'+','center','center',txtcolor);
if doinstr
   pres_ITI(nt) = 2.5;
else
    if doscanner
       if   valid_choice == 1
            pres_ITI(nt) = Z.min_display_fix_cross + Z.max_choice_time - (T.onset_choice(nt)-T.trial_onset(nt)) + ITI_w_null(nt); 
       else valid_choice == -1; % missing, no adaption for rt 
            pres_ITI(nt) = Z.min_display_fix_cross + Z.max_choice_time - (T.onset_missing_sign(nt)-T.trial_onset(nt)) + Z.display_choice + ITI_w_null(nt); 
       end
    elseif doeeg
       if   valid_choice == 1
            pres_ITI(nt) = Z.min_display_fix_cross + Z.max_choice_time - (T.onset_choice(nt)-T.trial_onset(nt)) + ITI(nt); 
       else valid_choice == -1; % missing, no adaption for rt 
            pres_ITI(nt) = Z.min_display_fix_cross + Z.max_choice_time - (T.post_choice_fix(nt)-T.trial_onset(nt)) + Z.display_choice + ITI(nt); 
       end
    end
    
    end
end
T.trial_onsetend(nt) = Screen('Flip', wd);
WaitSecs(pres_ITI(nt)-monitorFlipInterval); 

checkabort;
