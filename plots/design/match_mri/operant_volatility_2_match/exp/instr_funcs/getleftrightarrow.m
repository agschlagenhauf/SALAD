Screen('DrawTexture',wd,arrow,[],arrowsquare);
Screen('Flip',wd);

if doscanner | doeeg
   clearserialbytes(serial_port)
    while 1
          readserialbytes(serial_port)
          [key, key_time, key_n] = getserialbytes(serial_port); key_time_ptb = GetSecs; 
           if     strcmp(num2str(key),keyright); page=page+1; break;
           elseif strcmp(num2str(key),keyleft) & page>1;page=page-1; break;end
    end

else
    while 1
      [KeyIsDown, time, KeyCode]=KbCheck;
	  if KeyIsDown; 
		 key = KbName(KeyCode);
		 if iscell(key); key=key{1};end
            if     strcmpi(key,instrforward);page=page+1; break; 
            elseif strcmpi(key,instrbackward) & page>1;page=page-1; break;
	        elseif strcmpi(key,'ESCAPE'); 
                   aborted=1; 
                   Screen('Fillrect',wd,ones(1,3)*80);
			       text='Aborting experiment';
			       col=[200 30 0];
			       Screen('TextSize',wd,60);
			       DrawFormattedText(wd,text,'center','center',col,60);
                   Screen('CloseAll')
                   fclose('all')
                   ShowCursor
			       error('Pressed ESC --- aborting experiment')
		    end
      end
    end
end
WaitSecs(0.3);
