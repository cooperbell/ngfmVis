% SOURCEMONITOR Read in data from source, send it to main thread
%   This function runs as an async worker called from ngfmVis(). 
%   It's purpose is to capture data from the source (serial port or file)
%   unencumbered from the rest of the program and send that data back to the
%   main thread. The data that is sent back is unformatted, raw data but
%   contains only the data in one individual packet. It calls fread() at a 
%   user-specified rate in Hz and sends that rate back to the main thread 
%   every 1 second. 
%
%   It runs in a continuous loop, terminating only on errors, EOFs, or if
%   the main program tells it to stop executing. It does not have any
%   output arguments.
%
%   Input Arguments:
%       - workerQueueConstant: A Parallel Pool Constant containing a reference to
%       a Pollable Data Queue for this worker to set up (workerQueue), allowing
%       for communication from the main thread to this thread
%       - packetQueue: A Pollable Data Queue that this worker sends packet
%       data over
%       - workerCommQueue: A Pollable Data Queue that this worker sends error
%       messages, error codes, termination codes, and the current sampling rate
%       over
%       - device: file or serial
%       - devicePath: file path or serial port
%       - serialBufferLen: constant to set up size of serial buffer
%       - targetSamplingHz: Rate in Hz at which the source should be sampled
%       - dle: first byte in the packet
%       - stx: second to last byte in packet
%       - etx: last byte in the packet
%
%   See also ngfmVis parfeval parallel.pool.Constant parallel.pool.PollableDataQueue
%   sourceMonitor>getAvgSamplingHz sourceMonitor>changeSamplingRate
function sourceMonitor(workerQueueConstant, packetQueue, workerCommQueue, ...
    device, devicePath, serialBufferLen, targetSamplingHz, dle, stx, etx)
    % construct queue that main can use to talk to this worker
    % and send it back for it to use
    workerQueue = workerQueueConstant.Value;
    send(workerCommQueue, workerQueue);
    
    finished = 0;
    serialBuffer = zeros(serialBufferLen);
    serialCounter = 1;
    numSampleRates = 100;
    samplingRates = zeros(1, numSampleRates);
    tolerance = 0.05;
    pauseTime = 0.005;
    avgSamplingHzToSend = 0;
    
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
            send(workerCommQueue, errorMsg);
            return;
        end
    else
        if (exist(devicePath, 'file') == 2)
            s = fopen(devicePath);
        else
            % Send error code 1, 'File not found'
            send(workerCommQueue, 2);
            return;
        end
    end

    % start stopwatch timers
    hearbeatTimer = tic;
    sampleRateTimer = tic;
    while (~finished)
        % Check for a message from main thread
        [data, dataAvail] = poll(workerQueue);
        if(dataAvail)
            if(data == 0)
                % properly close up port/file
                fclose(s);
                delete(s);
                clear s

                % send termination value
                send(workerCommQueue, 1);
                finished = 1;
                continue;
            elseif(ischar(data))
                % send hardware command
                fwrite(s,data,'char')
            end
        end
        
        % read port
        timeElapsed = toc(sampleRateTimer); % get elapsed time
        [A,count] = fread(s,32,'uint8');
        sampleRateTimer = tic; % restart stopwatch timer

        if (count == 0)
            pause(0.01);
            finished = 1;
            fclose(s);
            delete(s);
            clear s
                
            % Send error code 2, 'Fread returned zero'
            send(workerCommQueue, 3);
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
            avgSamplingHzToSend = avgSamplingHz;
        end
        
        if(toc(hearbeatTimer) > 1)
            send(workerCommQueue,tic);
            send(workerCommQueue,avgSamplingHzToSend);
        end
        pause(pauseTime);
    end
end

function [avgSamplingHz, samplingRates] = getAvgSamplingHz(samplingRates, timeElapsed)
% GETAVGSAMPLINGHZ Adds most recent timeElapsed to the array, compute new mean

    samplingRates(1,2:length(samplingRates)) = ...
        samplingRates(1,1:(length(samplingRates)-1));
    samplingRates(1) = timeElapsed;
    avgSamplingHz = 1/mean(samplingRates);
end

function [pauseTime, samplingRates] = changeSamplingRate(avgSamplingHz, ...
    targetSamplingHz, tolerance, pauseTime, numSampleRates)
% CHANGESAMPLINGRATE change the sampling rate if it needs to be changed
% otherwise return same rate

    rateDifference = 1 - (avgSamplingHz/targetSamplingHz);
    if(abs(rateDifference) > tolerance)
        if(rateDifference < 0)
            pauseTime = pauseTime + (pauseTime*abs(rateDifference));
        else
            pauseTime = pauseTime - (pauseTime*rateDifference);
        end
    end
    % clear sampling rates array
    samplingRates = zeros(1, numSampleRates);
end