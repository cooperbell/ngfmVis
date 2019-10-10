function ngfmVis( script, varargin )
p = inputParser;
p.addRequired('device',  @(x)any(strcmpi(x,{'serial', 'file'})));
p.addRequired('devicePath', @ischar);
p.addRequired('saveFile', @ischar);
p.addParameter('spectra','PlotAmplitude.m', @(x) any(validatestring(x,{'PlotPSD.m', 'PlotAmplitude.m'}))); % slated 4 deletion
p.parse(script,varargin{:});

% modular plot attributes
global current_plot;
global plots;
global next_index;

current_plot = p.Results.spectra;
plots = {'PlotPSD.m', 'PlotAmplitude.m'};
next_index = 3;



ngfmLoadConstants;

global debugData;
debugData = 0;

%cwb% open serial port or open file path
if strcmp(p.Results.device, 'serial')
    disp(sprintf('Running is SERIAL mode on %s.', p.Results.devicePath));
    baudRate = 57600;
    delete(instrfindall);
    s = serial(p.Results.devicePath,'BaudRate',baudRate);
    fopen(s);
    flushinput(s);
else
    disp(sprintf('Running in FILE replay mode from %s.', p.Results.devicePath));
    if (exist(p.Results.devicePath, 'file') == 2)
        s = fopen(p.Results.devicePath);
    else
        disp(sprintf('File %s not found. Terminating.', p.Results.devicePath));
        return;
    end
end

%cwb% enable logging to a specified file or don't
if (strcmp(p.Results.saveFile, 'null'))
    loggingEnabled = 0;
else
    loggingEnabled = 1;
    logFileHandle = fopen(p.Results.saveFile, 'w+');
end

if (loggingEnabled == 1)
    disp(sprintf('Logging data to: %s\n', p.Results.saveFile));
else
    disp(sprintf('Logging data DISABLED.\n'));
end

pause(2);

dataPacket = struct('dle', uint8(0), 'stx', uint8(0), 'pid', uint8(0), 'packettype', uint8(0), 'packetlength', uint16(0), 'fs', uint16(0), 'ppsoffset', uint32(0), ...
    'hk', zeros(1,12,'int16'), 'xdac', zeros(1,100,'int16'), 'ydac', zeros(1,100,'int16'), 'zdac', zeros(1,100,'int16'), ...
    'xadc', zeros(1,100,'int16'), 'yadc', zeros(1,100,'int16'), 'zadc', zeros(1,100,'int16'), ...
    'boardid', uint16(0), 'sensorid', uint16(0), 'reservedA', uint8(0), 'reservedB', uint8(0), 'reservedC', uint8(0), 'reservedD', uint8(0), ...
    'etx', uint8(0), 'crc', uint16(0) );


plotHandles = struct('figure', [], 'px', [], 'py', [], 'pz', [], 'pid', [], 'packetlength', [], 'fs', [], 'ppsoffset', [], ... 
    'hk0', [], 'hk1', [], 'hk2', [], 'hk3', [], 'hk4', [], 'hk5', [], 'hk6', [], 'hk7', [], 'hk8', [], 'hk9', [], 'hk10', [], 'hk11', [], ...
    'boardid', [], 'sensorid', [], 'crc', [], 'xavg', [], 'xstddev', [], 'yavg', [], 'ystddev', [], 'zavg', [], 'zstddev', [], ...
    'xamp', [], 'xfreq', [], 'yamp', [], 'yfreq', [], 'zamp', [], 'zfreq', [] );


[FigHandle, magData, plotHandles] = ngfmPlotInit(plotHandles, plots);

serialBuffer = zeros(serialBufferLen);
serialCounter = 1;

hkData = zeros(1,12);


done=0;
global k;
k = [];
set(FigHandle,'keypress','global k; k=get(gcf,''currentchar'');');
while (~done)
    if (strcmp(p.Results.device, 'file'))
        if feof(s)
           return;
        end
    end
    
    [A,count] = fread(s,32,'uint8');

    if (count == 0)
        pause(0.01);
        disp( 'Fread returned zero' );
        continue;
    elseif (serialCounter+count > serialBufferLen)
        disp('Serial buffer overfilled');
    else
        if (count == 1)
            serialBuffer(serialCounter) = A;
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
        else
            serialBuffer(1:serialBufferLen-1)=serialBuffer(2:serialBufferLen);
            serialCounter = serialCounter - 1;
        end
    end
    
    if (newPacket)
        dataPacket.dle =        tempPacket(1);
        dataPacket.stx =        tempPacket(2);
        dataPacket.pid =        tempPacket(3);
        dataPacket.packettype = tempPacket(4);
        dataPacket.packetlength = swapbytes(typecast(tempPacket(5:6), 'uint16'));
        dataPacket.fs =         swapbytes(typecast(tempPacket(7:8), 'uint16'));
        dataPacket.ppsoffset =  swapbytes(typecast(tempPacket(9:12), 'uint32'));
        dataPacket.hk(1) =      swapbytes(typecast(tempPacket(13:14), 'uint16'));
        dataPacket.hk(2) =      swapbytes(typecast(tempPacket(15:16), 'uint16'));
        dataPacket.hk(3) =      swapbytes(typecast(tempPacket(17:18), 'uint16'));
        dataPacket.hk(4) =      swapbytes(typecast(tempPacket(19:20), 'uint16'));
        dataPacket.hk(5) =      swapbytes(typecast(tempPacket(21:22), 'uint16'));
        dataPacket.hk(6) =      swapbytes(typecast(tempPacket(23:24), 'uint16'));
        dataPacket.hk(7) =      swapbytes(typecast(tempPacket(25:26), 'uint16'));
        dataPacket.hk(8) =      swapbytes(typecast(tempPacket(27:28), 'uint16'));
        dataPacket.hk(9) =      swapbytes(typecast(tempPacket(29:30), 'uint16'));
        dataPacket.hk(10) =     swapbytes(typecast(tempPacket(31:32), 'uint16'));
        dataPacket.hk(11) =     swapbytes(typecast(tempPacket(33:34), 'uint16'));
        dataPacket.hk(12) =     swapbytes(typecast(tempPacket(35:36), 'uint16'));
        
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
        
        disp(sprintf('Packet parser PID = %d.', dataPacket.pid));
        
        [dataPacket, magData, hkData] = interpretData( dataPacket, magData, hkData );
        
        [plotHandles] = ngfmPlotUpdate(plotHandles, dataPacket, magData, hkData);
        
        if (loggingEnabled)
            if (~debugData)
                logData( logFileHandle, magData, hkData );
            else
                logDebugData( logFileHandle, dataPacket );
            end
        end
       
        
        if (strcmp(p.Results.device, 'file'))
            pause(0.001);
        else
            pause(0.001);
        end
    end



    
      if ~isempty(k)
        if strcmp(k,'q')
            done = 1;
        elseif strcmp(k,'`')
            debugData = ~debugData;
        elseif strcmp(p.Results.device, 'serial')
            fwrite(s,k);
        end
        k = [];
      end
      
    
    pause(0.0001);
    
end

close(FigHandle);

fclose(s);

if (loggingEnabled)
    fclose(logFileHandle);
end


end
