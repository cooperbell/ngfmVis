% main function
% To read from file: ngfmVis('file','capture09102019.txt','log.txt')
% To read from serial: ngfmVis('serial','/dev/tty.usbserial-6961_0_0080','log.txt')
function ngfmVis(varargin)
    % if no args, run input params GUI
    if nargin == 0
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
%     loadconfigxml;
    ngfmLoadConstants;
    magData = zeros(3,numSamplesToStore);
    hkData = zeros(12,hkPacketsToDisplay);
    logFile = p.Results.saveFile;
    
    dataPacket = struct('dle', uint8(0), 'stx', uint8(0), 'pid', uint8(0), 'packettype', uint8(0), 'packetlength', uint16(0), 'fs', uint16(0), 'ppsoffset', uint32(0), ...
        'hk', zeros(1,12,'int16'), 'xdac', zeros(1,100,'int16'), 'ydac', zeros(1,100,'int16'), 'zdac', zeros(1,100,'int16'), ...
        'xadc', zeros(1,100,'int16'), 'yadc', zeros(1,100,'int16'), 'zadc', zeros(1,100,'int16'), ...
        'boardid', uint16(0), 'sensorid', uint16(0), 'reservedA', uint8(0), 'reservedB', uint8(0), 'reservedC', uint8(0), 'reservedD', uint8(0), ...
        'etx', uint8(0), 'crc', uint16(0) );
    
    %add subfolders to path
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
    drawnow();
    
    % setup the parallel stuff. Construct queues and call sourceMonitor
    % asynchronously
    [F, packetQueue, workerCommQueue, workerQueue] = ...
        setupSourceMonitorWorker(p.Results.device, p.Results.devicePath, ...
            serialBufferLen, targetSamplingHz, dle, stx, etx);

    % main loop vars
    done = 0;
    closeRequest = 0;
    key = [];
    workerMsgs = {'Serial port closed\n', 'Error: File not found\n', ...
                'Fread returned zero\n'};
    
    % main loop
    while (~done)
        % If the worker is done, the print the error or associated code's
        %   message, begin program exit process
        % Else it is the current sampling rate
        [workerDoneQueueData, workerDoneQueueDataAvail] = poll(workerCommQueue, 0.01);
        if(workerDoneQueueDataAvail)
            if(isa(workerDoneQueueData,'cell'))
                fprintf('%s\n', char(workerDoneQueueData));
                done = 1;
                continue;
            elseif(ismember(workerDoneQueueData, [1 2 3]))
                fprintf(string(workerMsgs(workerDoneQueueData)))
                done = 1;
                continue;
            elseif(isa(workerDoneQueueData,'double'))
                fprintf('Sampling Rate: %3.2f\n', workerDoneQueueData);
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
                [packetQueueData, packetQueueDataAvail] = poll(packetQueue, 1); 
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
                    ngfmPlotUpdate(fig, dataPacket, magData, hkData);
            catch exception
                closeRequest = 1;
                fprintf('Plot error: %s\n', exception.message)
            end

            % log
            if (loggingEnabled)
                if (~debugData)
                    logData( logFileHandle, magData, hkData );
                else
                    logDebugData( logFileHandle, dataPacket );
                end
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

% Construct queues for communicating back and forth with the async worker
% Call sourceMonitor asynchronously
function [F, packetQueue, workerCommQueue, workerQueue] = ...
    setupSourceMonitorWorker(device, devicePath, serialBufferLen, ...
        targetSamplingHz ,dle, stx, etx)

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
    [workerDoneQueueData, workerDoneQueueDataAvail] = poll(workerCommQueue, 1);
    if(workerDoneQueueDataAvail)
        workerQueue = workerDoneQueueData;
    end
end

% parses the data packet according to the format
function dataPacket = parsePacket(dataPacket, tempPacket)
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
