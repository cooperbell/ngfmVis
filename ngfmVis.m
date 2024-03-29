% NGFMVIS Main function
%   ngfmVis(varargin) reads in data from either a file or a serial source, 
%   parses it according to the packet format in /resources, sends it to
%   ngfmPlotUpdate to be visualized, and logs it if necessary. This
%   function is the focal point for the whole program, handling program 
%   set up, thread management, and tear down.
% 
%   Example Input Arguments:
%   To read from file: ngfmVis('file','capture09102019.txt','')
%   To read from serial: ngfmVis('serial','/dev/tty.usbserial-6961_0_0080','')
%
%   Subfunctions: parsePacket setupSourceMonitorWorker
%
%   See also sourceMonitor, interpretData, ngfmPlotInit, ngfmPlotUpdate
function ngfmVis(varargin)
    % if no args, run input params GUI
    if(nargin == 0)
        fig = ngfmVisParam;
        waitfor(fig, 'Visible', 'off');
        if(~isvalid(fig))
            return
        end
        varargin = getappdata(fig, 'params');
        delete(fig);
        clear fig
    end

    % parse input args
    p = inputParser;
    addRequired(p,'device',  @(x)any(strcmpi(x,{'serial', 'file'})));
    addRequired(p,'devicePath', @ischar);
    addRequired(p,'saveFile', @ischar);
    parse(p,varargin{:});

    % load vars
    ngfmLoadConstants;
    magData = zeros(3,numSamplesToStore);
    hkData = zeros(12,hkPacketsToDisplay);
    logFile = p.Results.saveFile;
    
    dataPacket = struct('dle', uint8(0), 'stx', uint8(0), 'pid', uint8(0),...
        'packettype', uint8(0), 'packetlength', uint16(0), ...
        'fs', uint16(0), 'ppsoffset', uint32(0), 'hk', zeros(1,12,'int16'),...
        'xdac', zeros(1,100,'int16'), 'ydac', zeros(1,100,'int16'), ...
        'zdac', zeros(1,100,'int16'), 'xadc', zeros(1,100,'int16'), ...
        'yadc', zeros(1,100,'int16'), 'zadc', zeros(1,100,'int16'), ...
        'boardid', uint16(0), 'sensorid', uint16(0), 'reservedA', uint8(0),...
        'reservedB', uint8(0), 'reservedC', uint8(0), 'reservedD', uint8(0), ...
        'etx', uint8(0), 'crc', uint16(0) );
    
    % add subfolders to path
    addpath('lib', 'spectraPlots', 'log');
    
    % Print whether the mode is serial or file
    if strcmp(p.Results.device, 'serial')
        fprintf('Running in SERIAL mode on %s.\n', p.Results.devicePath);
    else
        fprintf('Running in FILE replay mode from %s.\n', p.Results.devicePath);
    end

    % enable logging to a specified file or don't
    if (strcmp(logFile, 'null'))
        loggingEnabled = 0;
         fprintf('Logging data DISABLED.\n');
    else
        loggingEnabled = 1;
        if(strcmp(logFile, ''))
            logFile = strcat('log_', datestr(now,'yyyymmdd-HHMMSS'), '.txt');
        end
        logFileHandle = fopen(strcat('log/',logFile), 'w+');
        fprintf('Logging data to: %s\n', logFile);
    end

    % give user time to read the console
    pause(2);
    
    % set up GUI
    fig = ngfmPlotInit();
    
    % setup the parallel stuff. Construct queues and call sourceMonitor
    % asynchronously
    [F, packetQueue, workerCommQueue, workerQueue] = ...
        setupSourceMonitorWorker(p.Results.device, p.Results.devicePath, ...
            serialBufferLen, targetSamplingHz, dle, stx, etx);

    % main loop vars
    done = 0;
    closeRequest = 0;
    key = [];
    heartbeatTimer = NaN;
    samplingRate = 0.0;
    workerMsgs = {'Serial port closed\n', 'Error: File not found\n', ...
                'Fread returned zero\n'};
    
    % main loop
    while (~done)
        % If the worker is done, the print the error or associated code's
        %   message, begin program exit process
        % Else it is the current sampling rate
        if (workerCommQueue.QueueLength > 0)
            % process all available packets at once
            for i = 1:workerCommQueue.QueueLength
            [workerCommQueueData, workerCommQueueDataAvail] = poll(workerCommQueue, 0.01);
                if(workerCommQueueDataAvail)
                    if(isa(workerCommQueueData,'cell'))
                        fprintf('%s\n', char(workerCommQueueData));
                        done = 1;
                        continue;
                    elseif(ismember(workerCommQueueData, [1 2 3]))
                        fprintf(string(workerMsgs(workerCommQueueData)))
                        done = 1;
                        continue;
                    elseif(isa(workerCommQueueData,'double'))
                        samplingRate = workerCommQueueData;
                    elseif(isa(workerCommQueueData,'uint64'))
                        heartbeatTimer = workerCommQueueData;
                    end
                end
            end
        end
        
        % check if there's data to read
        if (packetQueue.QueueLength > 0)
            if(strcmp(p.Results.device, 'serial'))
                numToRead = packetQueue.QueueLength;
            else
                numToRead = 1;
            end
            
            % process all available packets at once
            for i = 1:numToRead
                [packetQueueData, packetQueueDataAvail] = poll(packetQueue, 0.1); 
                if(packetQueueDataAvail && isa(packetQueueData, 'uint8'))
                    % parse packet
                    dataPacket = parsePacket(dataPacket, packetQueueData);
                    fprintf('Packet parser PID = %d.\n', dataPacket.pid);
                    [dataPacket, magData, hkData] = interpretData(dataPacket, magData, hkData);
                end
            end

            % put a try catch in for now to handle the window being closed
            % until we can put in a proper close request callback
            try
                [fig, closeRequest, key, debugData] = ...
                    ngfmPlotUpdate(fig, dataPacket, magData, hkData, samplingRate);
            catch exception
                closeRequest = 1;
                fprintf('Plot error: %s\n', exception.message)
            end

            % log
            if (loggingEnabled)
                logData(logFileHandle, dataPacket, magData, hkData, debugData);
            end
        end
        
        % check if the user closed the main window
        if (closeRequest == 1)
            % Send 0 as a "poison pill" to the worker to get it to stop.
            % This properly closes up the serial port, preventing the
            % worker from terminating while still holding onto it and 
            % causing the port to be unconnectable to new workers
            send(workerQueue, 0);
            if strcmp(p.Results.device, 'file')
                % most likely the file has been read and the worker is
                % terminated, so just close whole program
                pause(0.1);
                done = 1;
                continue;
            end
        end

        % Check if there is a hardware command to send
        if(~isempty(key) && strcmp(p.Results.device, 'serial'))
            % send the commands to the async worker's queue
            for i = 1:length(key)
                send(workerQueue, char(key(i)));
            end
        end
        
        % update hearbeat GUI label
        if(~isnan(heartbeatTimer))
            updateHeartbeat(fig, heartbeatTimer);
        end
    end
    
    % close up
    disp('Terminating program')
    
    if(isvalid(fig))
        close(fig);
    end

    if (loggingEnabled)
        fclose(logFileHandle);
    end
end

% update hearbeat GUI label
function updateHeartbeat(fig, heartbeatTimer)
    handles = guidata(fig);
    if(toc(heartbeatTimer) < 1)
        handles.hbeat.String = '<1s';
    else
        handles.hbeat.String = sprintf('%1.0fs',toc(heartbeatTimer));
        drawnow();
    end
end

% Construct queues for communicating back and forth with the async worker
% Call sourceMonitor asynchronously
function [F, packetQueue, workerCommQueue, workerQueue] = ...
    setupSourceMonitorWorker(device, devicePath, serialBufferLen, ...
        targetSamplingHz, dle, stx, etx)

    % Create a parallel pool if necessary
    if isempty(gcp())
        parpool(1);
    end

    % Get the worker to construct a data queue on which it can receive
    % messages from the main thread
    workerQueueConstant = parallel.pool.Constant(@parallel.pool.PollableDataQueue);

    % Pollable data queue that the worker will use to send raw data over
    % for the main thread to use
    packetQueue = parallel.pool.PollableDataQueue;
    
    % Pollable data queue that the worker will use to send data over
    % that tells the main thread it is done executing
    % and sends the sampling rate over
    workerCommQueue = parallel.pool.PollableDataQueue;
    
    % call sourceMonitor asynchronously
    F = parfeval(@sourceMonitor, 0, workerQueueConstant, packetQueue, ...
                 workerCommQueue, device, devicePath, serialBufferLen, ...
                 targetSamplingHz, dle, stx, etx);
    
    % get the worker's queue back for main to use
    % This queue is for main to send data over to allow the async worker
    % to terminate gracefully, avoiding serial port and thread lockups
    [workerCommQueueData, workerCommQueueDataAvail] = poll(workerCommQueue, 1);
    if(workerCommQueueDataAvail)
        workerQueue = workerCommQueueData;
    end
end

function dataPacket = parsePacket(dataPacket, tempPacket)
% PARSEPACKET parses the data packet according to the format
%
% See also ngfmVis
    dataPacket.dle =            tempPacket(1);
    dataPacket.stx =            tempPacket(2);
    dataPacket.pid =            tempPacket(3);
    dataPacket.packettype =     tempPacket(4);
    dataPacket.packetlength =   swapbytes(typecast(tempPacket(5:6), 'uint16'));
    dataPacket.fs =             swapbytes(typecast(tempPacket(7:8), 'uint16'));
    dataPacket.ppsoffset =      swapbytes(typecast(tempPacket(9:12), 'uint32'));
    dataPacket.hk(1) =          swapbytes(typecast(tempPacket(13:14), 'uint16'));
    dataPacket.hk(2) =          swapbytes(typecast(tempPacket(15:16), 'uint16'));
    dataPacket.hk(3) =          swapbytes(typecast(tempPacket(17:18), 'uint16'));
    dataPacket.hk(4) =          swapbytes(typecast(tempPacket(19:20), 'uint16'));
    dataPacket.hk(5) =          swapbytes(typecast(tempPacket(21:22), 'uint16'));
    dataPacket.hk(6) =          swapbytes(typecast(tempPacket(23:24), 'uint16'));
    dataPacket.hk(7) =          swapbytes(typecast(tempPacket(25:26), 'uint16'));
    dataPacket.hk(8) =          swapbytes(typecast(tempPacket(27:28), 'uint16'));
    dataPacket.hk(9) =          swapbytes(typecast(tempPacket(29:30), 'uint16'));
    dataPacket.hk(10) =         swapbytes(typecast(tempPacket(31:32), 'uint16'));
    dataPacket.hk(11) =         swapbytes(typecast(tempPacket(33:34), 'uint16'));
    dataPacket.hk(12) =         swapbytes(typecast(tempPacket(35:36), 'uint16'));

    dataOffset = 36;
    for n = 1:100
        dataPacket.xdac(n) =    typecast( swapbytes( typecast( tempPacket(dataOffset + (n-1)*12 + 1:dataOffset + (n-1)*12 + 2), 'uint16') ), 'int16' );
        dataPacket.ydac(n) =    typecast( swapbytes( typecast( tempPacket(dataOffset + (n-1)*12 + 5:dataOffset + (n-1)*12 + 6), 'uint16') ), 'int16' );
        dataPacket.zdac(n) =    typecast( swapbytes( typecast( tempPacket(dataOffset + (n-1)*12 + 9:dataOffset + (n-1)*12 + 10), 'uint16') ), 'int16' );

        dataPacket.xadc(n) =    typecast( swapbytes( typecast( tempPacket(dataOffset + (n-1)*12 + 3:dataOffset + (n-1)*12 + 4), 'uint16') ), 'int16' );
        dataPacket.yadc(n) =    typecast( swapbytes( typecast( tempPacket(dataOffset + (n-1)*12 + 7:dataOffset + (n-1)*12 + 8), 'uint16') ), 'int16' );
        dataPacket.zadc(n) =    typecast( swapbytes( typecast( tempPacket(dataOffset + (n-1)*12 + 11:dataOffset + (n-1)*12 + 12), 'uint16') ), 'int16' );

    end

    dataOffset = dataOffset + 100*12;

    dataPacket.boardid =        swapbytes(typecast(tempPacket(dataOffset+1:dataOffset+2), 'uint16'));
    dataPacket.sensorid =       swapbytes(typecast(tempPacket(dataOffset+3:dataOffset+4), 'uint16'));
    dataPacket.reservedA =      typecast(tempPacket(dataOffset+5), 'uint8');
    dataPacket.reservedB =      typecast(tempPacket(dataOffset+6), 'uint8');
    dataPacket.reservedC =      typecast(tempPacket(dataOffset+7), 'uint8');
    dataPacket.reservedD =      typecast(tempPacket(dataOffset+8), 'uint8');
    dataPacket.reservedE =      typecast(tempPacket(dataOffset+9), 'uint8');
    dataPacket.etx =            typecast(tempPacket(dataOffset+10), 'uint8');
    dataPacket.crc =            swapbytes(typecast(tempPacket(dataOffset+11:dataOffset+12), 'uint16'));
end

function [dataPacket, magData, hkData] = interpretData(dataPacket, magData, hkData)
% INTERPRETDATA Add scaling and offset to the mag and house keeping data
%
% See also ngfmVis
    ngfmLoadConstants;

    % shift mag data left
    magData(1,1:numSamplesToStore-assumedSamplingRate) = magData(1,assumedSamplingRate+1:numSamplesToStore);
    magData(2,1:numSamplesToStore-assumedSamplingRate) = magData(2,assumedSamplingRate+1:numSamplesToStore);
    magData(3,1:numSamplesToStore-assumedSamplingRate) = magData(3,assumedSamplingRate+1:numSamplesToStore);

    % store new mag data at the end
    magData(1,numSamplesToStore-assumedSamplingRate+1:numSamplesToStore) = XDACScale*double(dataPacket.xdac) + XADCScale*double(dataPacket.xadc) + XOffset;
    magData(2,numSamplesToStore-assumedSamplingRate+1:numSamplesToStore) = YDACScale*double(dataPacket.ydac) + YADCScale*double(dataPacket.yadc) + YOffset;
    magData(3,numSamplesToStore-assumedSamplingRate+1:numSamplesToStore) = ZDACScale*double(dataPacket.zdac) + ZADCScale*double(dataPacket.zadc) + ZOffset;

    % shift hk data right
    for i = 1:12
        hkData(i,2:hkPacketsToDisplay) = hkData(i,1:hkPacketsToDisplay-1);
    end

    % store new hk data at the beginning
    hkData(1,1) = HK0Scale*double(dataPacket.hk(1))+HK0Offset; 
    hkData(2,1) = HK1Scale*double(dataPacket.hk(2))+HK1Offset; 
    hkData(3,1) = HK2Scale*double(dataPacket.hk(3))+HK2Offset;
    hkData(4,1) = HK3Scale*double(dataPacket.hk(4))+HK3Offset;
    hkData(5,1) = HK4Scale*double(dataPacket.hk(5))+HK4Offset;
    hkData(6,1) = HK5Scale*double(dataPacket.hk(6))+HK5Offset;
    hkData(7,1) = HK6Scale*double(dataPacket.hk(7))+HK6Offset;
    hkData(8,1) = HK7Scale*double(dataPacket.hk(8))+HK7Offset;
    hkData(9,1) = HK8Scale*double(dataPacket.hk(9))+HK8Offset;
    hkData(10,1) = HK9Scale*double(dataPacket.hk(10))+HK9Offset;
    hkData(11,1) = HK10Scale*double(dataPacket.hk(11))+HK10Offset;
    hkData(12,1) = HK11Scale*double(dataPacket.hk(12))+HK11Offset;
end


