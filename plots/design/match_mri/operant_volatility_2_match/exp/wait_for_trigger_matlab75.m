function wait_for_trigger_matlab75()
ioObj=io32;
status=io32(ioObj);
while(1)
    key=io32(ioObj,889);
    key=bitand(key,64);
    if key==0
        break;
    end
end
