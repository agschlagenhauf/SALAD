clear
clc
doscanner = 1; 
KbCheck;  
key = []; 
WaitSecs(1); 
keyright = '3'; 

if ~doscanner
   while 1
         [KeyIsDown Time KeyCode] = KbCheck; 
         if KeyIsDown; 
            Key = KbName(KeyCode); 
            response = Key
            break; 
         end
   end
elseif doscanner 
       if doscanner
        serial_port = 1;
        config_serial(serial_port, 19200,0,0,8);
        start_cogent;
       end
    clearserialbytes(serial_port)
    while 1
          readserialbytes(serial_port)
          [key, key_time, key_n] = getserialbytes(serial_port); key_time_ptb = GetSecs; 
          if  ~isempty(key) %strcmp(num2str(key),keyright) 
              key 
              break; end
    end

    if doscanner
	   stop_cogent;
    end
end
   