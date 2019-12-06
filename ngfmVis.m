% main function
% To read from file: ngfmVis('file','capture09102019.txt','log.txt')
% To read from serial: ngfmVis('serial','/dev/tty.usbserial-6961_0_0080','log.txt')
function ngfmVis(varargin)
    global VAR;
    VAR = varargin;
    
    % if no args, run input params GUI
    if nargin == 0
        ngfmVisParam1;
    end

    % parse input args
    p = inputParser;
    addRequired(p,'device',  @(x)any(strcmpi(x,{'serial', 'file'})));
    addRequired(p,'devicePath', @ischar);
    addRequired(p,'saveFile', @ischar);
    parse(p,VAR{:});
    
    % clear global used with the input params GUI
    clear global VAR;

    % load vars
    loadconfigxml;
    ngfmLoadConstants;
    magData = zeros(3,numSamplesToStore);
    hkData = zeros(12,hkPacketsToDisplay);
    
    %add the /lib folder to path
    addpath('lib', 'spectraPlots');
    

    % Print whether the mode is serial or file
    if strcmp(p.Results.device, 'serial')
        fprintf('Running is SERIAL mode on %s.\n', p.Results.devicePath);
    else
        fprintf('Running in FILE replay mode from %s.\n', p.Results.devicePath);
    end

    % enable logging to a specified file or don't
    if (strcmp(p.Results.saveFile, 'null'))
        loggingEnabled = 0;
    else
        loggingEnabled = 1;
        logFileHandle = fopen(p.Results.saveFile, 'w+');
    end

    if (loggingEnabled == 1)
        fprintf('Logging data to: %s\n', p.Results.saveFile);
    else
        fprintf('Logging data DISABLED.\n');
    end

    pause(2);

    fig = ngfmPlotInit();

    % Create a parallel pool if necessary
    if isempty(gcp())
        parpool(1);
    end

    % Get the worker to construct a data queue on which it can receive
    % messages from the main thread
    workerQueueConstant = parallel.pool.Constant(@parallel.pool.PollableDataQueue);

    % Get the worker to send the queue object back to the main thread
    workerQueueClient = fetchOutputs(parfeval(@(x) x.Value, 1, workerQueueConstant));

    % create a pollable data queue. The worker will send raw data to this
    % for the main thread to use
    data_queue = parallel.pool.PollableDataQueue;
    
    % create a queue for killing the program. The worker will send a value
    % to this that the main thread will see instantly instead of it being
    % pushed to the back of the data queue
    kill_queue = parallel.pool.PollableDataQueue;
    
    % call sourceMonitor asynchronously
    F = parfeval(@sourceMonitor, 0, workerQueueConstant, data_queue, kill_queue, p.Results.device, p.Results.devicePath, serialBufferLen, dle, stx, etx);
    
    
    % main loop vars
    newPacket = 0;
    tempPacket = zeros(1,1248);
    done=0;
    closereq = 0;
    key = [];
    
    % main loop
    while (~done)
        % check if the worker said it's done
        [data, kill_msg] = poll(kill_queue);
        if(kill_msg)
            if(data == 0)
                fprintf('Serial Port or File closed\n');
                done = 1;
                continue;
            end
        end
        
        % check if there's data to read
        [data, data_available] = poll(data_queue); 
        if(data_available)
            if(isa(data,'cell'))
                fprintf('%s\n', char(data));
                done = 1;
                continue;
            end
            if(data == 2)
                fprintf('Error: File not found\n');
                done = 1;
                continue;
            end
            if(data == 3)
                fprintf('Fread returned zero\n');
                done = 1;
                continue;
            end
            newPacket = 1;
            tempPacket = data;
        end 

        % parse packet
        if (newPacket)
            testpack = getDataPacket(dataPacket, tempPacket, inputOffset);
%             dataPacket.dle =            tempPacket(1);
%             dataPacket.stx =            tempPacket(2);
%             dataPacket.pid =            tempPacket(3);
%             dataPacket.packettype =     tempPacket(4);
%             dataPacket.packetlength =   swapbytes(typecast(tempPacket(5:6), 'uint16'));
%             dataPacket.fs =             swapbytes(typecast(tempPacket(7:8), 'uint16'));
%             dataPacket.ppsoffset =      swapbytes(typecast(tempPacket(9:12), 'uint32'));
%             dataPacket.hk(1) =          swapbytes(typecast(tempPacket(13:14), 'uint16'));
%             dataPacket.hk(2) =          swapbytes(typecast(tempPacket(15:16), 'uint16'));
%             dataPacket.hk(3) =          swapbytes(typecast(tempPacket(17:18), 'uint16'));
%             dataPacket.hk(4) =          swapbytes(typecast(tempPacket(19:20), 'uint16'));
%             dataPacket.hk(5) =          swapbytes(typecast(tempPacket(21:22), 'uint16'));
%             dataPacket.hk(6) =          swapbytes(typecast(tempPacket(23:24), 'uint16'));
%             dataPacket.hk(7) =          swapbytes(typecast(tempPacket(25:26), 'uint16'));
%             dataPacket.hk(8) =          swapbytes(typecast(tempPacket(27:28), 'uint16'));
%             dataPacket.hk(9) =          swapbytes(typecast(tempPacket(29:30), 'uint16'));
%             dataPacket.hk(10) =         swapbytes(typecast(tempPacket(31:32), 'uint16'));
%             dataPacket.hk(11) =         swapbytes(typecast(tempPacket(33:34), 'uint16'));
%             dataPacket.hk(12) =         swapbytes(typecast(tempPacket(35:36), 'uint16'));
% 
%             dataOffset = inputOffset;
%             for n = 1:100
%                 dataPacket.xdac(n) =    typecast( swapbytes( typecast( tempPacket(dataOffset + (n-1)*12 + 1:dataOffset + (n-1)*12 + 2), 'uint16') ), 'int16' );
%                 dataPacket.ydac(n) =    typecast( swapbytes( typecast( tempPacket(dataOffset + (n-1)*12 + 5:dataOffset + (n-1)*12 + 6), 'uint16') ), 'int16' );
%                 dataPacket.zdac(n) =    typecast( swapbytes( typecast( tempPacket(dataOffset + (n-1)*12 + 9:dataOffset + (n-1)*12 + 10), 'uint16') ), 'int16' );
% 
%                 dataPacket.xadc(n) =    typecast( swapbytes( typecast( tempPacket(dataOffset + (n-1)*12 + 3:dataOffset + (n-1)*12 + 4), 'uint16') ), 'int16' );
%                 dataPacket.yadc(n) =    typecast( swapbytes( typecast( tempPacket(dataOffset + (n-1)*12 + 7:dataOffset + (n-1)*12 + 8), 'uint16') ), 'int16' );
%                 dataPacket.zadc(n) =    typecast( swapbytes( typecast( tempPacket(dataOffset + (n-1)*12 + 11:dataOffset + (n-1)*12 + 12), 'uint16') ), 'int16' );
% 
%             end
% 
%             dataOffset = dataOffset + 100*12;
% 
%             dataPacket.boardid =        swapbytes(typecast(tempPacket(dataOffset+1:dataOffset+2), 'uint16'));
%             dataPacket.sensorid =       swapbytes(typecast(tempPacket(dataOffset+3:dataOffset+4), 'uint16'));
%             dataPacket.reservedA =      typecast(tempPacket(dataOffset+5), 'uint8');
%             dataPacket.reservedB =      typecast(tempPacket(dataOffset+6), 'uint8');
%             dataPacket.reservedC =      typecast(tempPacket(dataOffset+7), 'uint8');
%             dataPacket.reservedD =      typecast(tempPacket(dataOffset+8), 'uint8');
%             dataPacket.reservedE =      typecast(tempPacket(dataOffset+9), 'uint8');
%             dataPacket.etx =            typecast(tempPacket(dataOffset+10), 'uint8');
%             dataPacket.crc =            swapbytes(typecast(tempPacket(dataOffset+11:dataOffset+12), 'uint16'));
% 
%             if(isequaln(testpack, dataPacket))
%                 asd = 0;
%             else
%                 asd = 1;
%             end
            fprintf('Packet parser PID = %d.\n', dataPacket.pid);

            [testpack, magData, hkData] = interpretData( testpack, magData, hkData, hk);
            
            % put a try catch in for now to handle the window being closed
            % until we can put in a proper close request callback
            try
                [fig, closereq, key, debugData] = ...
                    ngfmPlotUpdate(fig, testpack, magData, hkData);
            catch exception
                closereq = 1;
                fprintf('Plot error: %s\n', exception.message)
            end
            
            if (loggingEnabled)
                if (~debugData)
                    logData( logFileHandle, magData, hkData );
                else
                    logDebugData( logFileHandle, dataPacket );
                end
            end
            
        end
        pause(0.001);
        
        % check if the user closed the main window
        if (closereq == 1)
                % Send [] as a "poison pill" to the worker to get it to stop.
                % This properly closes up the serial port, preventing the
                % worker from terminating while still holding onto it and 
                % causing the port to be unconnectable to new workers
                send(workerQueueClient, []);
                if strcmp(p.Results.device, 'file')
                    % most likely the file has been read and the worker is
                    % terminated, so just close whole program
                    pause(0.1);
                    done = 1;
                    continue;
                end
        end

        if(~isempty(key))
%             if strcmp(key,'`')
%                 debugData = ~debugData;
            if strcmp(p.Results.device, 'serial')
                %have this sent over serial worker
                fwrite(s,k);
            end
            key = [];
        end
    end
    
    disp('Terminating program')
    
    if(isvalid(fig))
        close(fig);
    end

    if (loggingEnabled)
        fclose(logFileHandle);
    end
end
