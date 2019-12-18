% Author: Cooper Bell
% This function runs as an async worker called from ngfmVis(). 
% It's purpose is to capture data from the source (port mostly)
% unencumbered from the rest of the program and send that data back to the
% main thread.
function sourceMonitor(workerQueueConstant, dataQueue, kill_queue, device, devicePath, serialBufferLen, dle, stx, etx)
    % construct queue that main can use to talk to this worker
    % and send it back for it to use
    workerQueue = workerQueueConstant.Value;
    send(dataQueue, workerQueue);
    
    finished = 0;
    serialBuffer = zeros(serialBufferLen);
    serialCounter = 1;
    
    % open serial port or file 
    if(strcmp(device, 'serial'))
        baudRate = 57600;
        s = serial(devicePath,'BaudRate',baudRate);
        try 
            fopen(s);
            flushinput(s);
        catch exception
            vec = {exception.message};
            send(dataQueue, vec);
            return;
        end
    else
        if (exist(devicePath, 'file') == 2)
            s = fopen(devicePath);
        else
            send(dataQueue, 2);
            return;
        end
    end
    
    while (~finished)
        % Check for a kill message from main thread
        [~, OK] = poll(workerQueue);
        if(OK)
            % properly close up port/file
            fclose(s);
            delete(s);
            clear s
            
            % send termination value
            send(kill_queue, 0);
            finished = 1;
            continue;
        else
            % read port
            [A,count] = fread(s,32,'uint8');
            
            if (count == 0)
                pause(0.01);
                finished = 1;
                fclose(s);
                delete(s);
                clear s
                send(dataQueue, 3);
            elseif (serialCounter+count > serialBufferLen)
                fprintf('Serial buffer overfilled');
            else
                if (count == 1)
                    serialBuffer(serialCounter) = A; % look into this
                else
                    serialBuffer(serialCounter:serialCounter+count-1) = A;
                end
                serialCounter = serialCounter + count;
            end
            
            newPacket = 0;
            tempPacket = zeros(1,1248);
            while ( (newPacket ==0 ) && (serialCounter > 1248) )
                if ((serialBuffer(1) == dle) && (serialBuffer(2) == stx) && (serialBuffer(1246) == etx) )
                    tempPacket = uint8(serialBuffer(1:1248));
                    newPacket = 1;
                    serialBuffer(1:serialCounter-1248) = serialBuffer(1249:serialCounter);
                    serialCounter = serialCounter - 1248;
                    % send to data queue
                    send(dataQueue, tempPacket); 
                else
                    serialBuffer(1:serialBufferLen-1)=serialBuffer(2:serialBufferLen);
                    serialCounter = serialCounter - 1;
                end
            end
%             pause(0.005); % This sets fread to ~175hz on my machine
            pause(0.01);
        end
    end
end