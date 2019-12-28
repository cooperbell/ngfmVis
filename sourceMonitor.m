% Author: Cooper Bell
% This function runs as an async worker called from ngfmVis(). 
% It's purpose is to capture data from the source (serial port or file)
% unencumbered from the rest of the program and send that data back to the
% main thread.
function sourceMonitor(workerQueueConstant, packetQueue, workerDoneQueue, ...
    device, devicePath, serialBufferLen, targetSamplingHz, dle, stx, etx)
    % construct queue that main can use to talk to this worker
    % and send it back for it to use
    workerQueue = workerQueueConstant.Value;
    send(workerDoneQueue, workerQueue);
    
    finished = 0;
    serialBuffer = zeros(serialBufferLen);
    serialCounter = 1;
    numSampleRates = 100;
    samplingRates = zeros(1, numSampleRates);
    tolerance = 0.05;
    pauseTime = 0.005;
    
    % open serial port or file 
    if(strcmp(device, 'serial'))
        baudRate = 57600;
        s = serial(devicePath,'BaudRate',baudRate);
        try
            % open port
            fopen(s);
            flushinput(s);
        catch exception
            % Send serial port error with message
            errorMsg = {exception.message};
            send(workerDoneQueue, errorMsg);
            return;
        end
    else
        if (exist(devicePath, 'file') == 2)
            s = fopen(devicePath);
        else
            % Send error code 1, 'File not found'
            send(workerDoneQueue, 2);
            return;
        end
    end
    
    tic
    while (~finished)
        % Check for a message from main thread, close everything up
        [data, dataAvail] = poll(workerQueue);
        if(dataAvail)
            if(data == 0)
                % properly close up port/file
                fclose(s);
                delete(s);
                clear s

                % send termination value
                send(workerDoneQueue, 1);
                finished = 1;
                continue;
            elseif(ischar(data))
                % send hardware command
                fwrite(s,data,'char')
            end
        end
        
        % read port
        timeElapsed = toc;
        [A,count] = fread(s,32,'uint8');
        tic

        if (count == 0)
            pause(0.01);
            finished = 1;
            fclose(s);
            delete(s);
            clear s
            % Send error code 2, 'Fread returned zero'
            send(workerDoneQueue, 3);
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
                send(packetQueue, tempPacket); 
            else
                serialBuffer(1:serialBufferLen-1)=serialBuffer(2:serialBufferLen);
                serialCounter = serialCounter - 1;
            end
        end
        
        % get current average sampling rate
        [avgSamplingHz, samplingRates] = getAvgSamplingHz(samplingRates, timeElapsed);
        
        % wait until samplingRates is full
        if(~ismember(samplingRates, 0))
            [pauseTime, samplingRates] = changeSamplingRate(avgSamplingHz, ...
                targetSamplingHz, tolerance, pauseTime, numSampleRates);
%             send(packetQueue,avgSamplingHz); % debug
        end
        pause(pauseTime);
    end
end

% Adds most recent timeElapsed to the array, computes new mean
function [avgSamplingHz, samplingRates] = getAvgSamplingHz(samplingRates, timeElapsed)
    samplingRates(1,2:length(samplingRates)) = ...
        samplingRates(1,1:(length(samplingRates)-1));
    samplingRates(1) = timeElapsed;
    avgSamplingHz = 1/mean(samplingRates);
end

% change the sampling rate if it needs to be changed
% otherwise return same rate
function [pauseTime, samplingRates] = changeSamplingRate(avgSamplingHz, ...
    targetSamplingHz, tolerance, pauseTime, numSampleRates)
    rateDifference = 1 - (avgSamplingHz/targetSamplingHz);
    if(abs(rateDifference) > tolerance)
        if(rateDifference < 0)
            pauseTime = pauseTime + (pauseTime*abs(rateDifference));
        else
            pauseTime = pauseTime - (pauseTime*rateDifference);
        end
    end
    samplingRates = zeros(1, numSampleRates);
end