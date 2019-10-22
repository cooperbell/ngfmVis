global debugData;

mTextBoxPidLabel = uicontrol('style','text');
%set(mTextBoxPidLabel,'HorizontalAlignment', 'left');
set(mTextBoxPidLabel,'String','PID');
set(mTextBoxPidLabel,'Position', [10 35 50 20]);

mTextBoxPid = uicontrol('style','text');
%set(mTextBoxPid,'HorizontalAlignment', 'right');
set(mTextBoxPid,'String','NaN');
set(mTextBoxPid,'Position', [10 10 50 20]);
plotHandles.pid = mTextBoxPid;


mTextBoxPacketLengthLabel = uicontrol('style','text');
%set(mTextBoxPacketLengthLabel,'HorizontalAlignment', 'left');
set(mTextBoxPacketLengthLabel,'String','PktLen');
set(mTextBoxPacketLengthLabel,'Position', [60 35 50 20]);

mTextBoxPacketLength = uicontrol('style','text');
%set(mTextBoxPacketLength,'HorizontalAlignment', 'right');
set(mTextBoxPacketLength,'String','NaN');
set(mTextBoxPacketLength,'Position', [60 10 50 20]);
plotHandles.packetlength = mTextBoxPacketLength;


mTextBoxFsLabel = uicontrol('style','text');
%set(mTextBoxFsLabel,'HorizontalAlignment', 'left');
set(mTextBoxFsLabel,'String','FS');
set(mTextBoxFsLabel,'Position', [110 35 50 20]);

mTextBoxFs = uicontrol('style','text');
%set(mTextBoxFs,'HorizontalAlignment', 'right');
set(mTextBoxFs,'String','NaN');
set(mTextBoxFs,'Position', [110 10 50 20]);
plotHandles.fs = mTextBoxFs;


mTextBoxPPSOffsetLabel = uicontrol('style','text');
%set(mTextBoxPPSOffsetLabel,'HorizontalAlignment', 'left');
set(mTextBoxPPSOffsetLabel,'String','PPS');
set(mTextBoxPPSOffsetLabel,'Position', [160 35 50 20]);

mTextBoxPPSOffset = uicontrol('style','text');
%set(mTextBoxPPSOffset,'HorizontalAlignment', 'right');
set(mTextBoxPPSOffset,'String','NaN');
set(mTextBoxPPSOffset,'Position', [160 10 50 20]);
plotHandles.ppsoffset = mTextBoxPPSOffset;


mTextBoxHK0Label = uicontrol('style','text');
%set(mTextBoxHK0Label,'HorizontalAlignment', 'left');
if (debugData)
    set(mTextBoxHK0Label,'String','HK0');
else
    set(mTextBoxHK0Label,'String','+1V2');
end
set(mTextBoxHK0Label,'Position', [210 35 50 20]);

mTextBoxHK0 = uicontrol('style','text');
%set(mTextBoxHK0,'HorizontalAlignment', 'right');
set(mTextBoxHK0,'String','NaN');
set(mTextBoxHK0,'Position', [210 10 50 20]);
plotHandles.hk0 = mTextBoxHK0;


mTextBoxHK1Label = uicontrol('style','text');
%set(mTextBoxHK1Label,'HorizontalAlignment', 'left');
if (debugData)
    set(mTextBoxHK1Label,'String','HK1');
else
    set(mTextBoxHK1Label,'String','TSens');
end
set(mTextBoxHK1Label,'Position', [260 35 50 20]);

mTextBoxHK1 = uicontrol('style','text');
%set(mTextBoxHK1,'HorizontalAlignment', 'right');
set(mTextBoxHK1,'String','NaN');
set(mTextBoxHK1,'Position', [260 10 50 20]);
plotHandles.hk1 = mTextBoxHK1;


mTextBoxHK2Label = uicontrol('style','text');
%set(mTextBoxHK2Label,'HorizontalAlignment', 'left');
if (debugData)
    set(mTextBoxHK2Label,'String','HK2');
else
    set(mTextBoxHK2Label,'String','TRef');
end
set(mTextBoxHK2Label,'Position', [310 35 50 20]);

mTextBoxHK2 = uicontrol('style','text');
%set(mTextBoxHK2,'HorizontalAlignment', 'right');
set(mTextBoxHK2,'String','NaN');
set(mTextBoxHK2,'Position', [310 10 50 20]);
plotHandles.hk2 = mTextBoxHK2;

mTextBoxHK3Label = uicontrol('style','text');
%set(mTextBoxHK3Label,'HorizontalAlignment', 'left');
if (debugData)
    set(mTextBoxHK3Label,'String','HK3');
else
    set(mTextBoxHK3Label,'String','TBrd');
end
set(mTextBoxHK3Label,'Position', [360 35 50 20]);

mTextBoxHK3 = uicontrol('style','text');
%set(mTextBoxHK3,'HorizontalAlignment', 'right');
set(mTextBoxHK3,'String','NaN');
set(mTextBoxHK3,'Position', [360 10 50 20]);
plotHandles.hk3 = mTextBoxHK3;

mTextBoxHK4Label = uicontrol('style','text');
%set(mTextBoxHK4Label,'HorizontalAlignment', 'left');
if (debugData)
    set(mTextBoxHK4Label,'String','HK4');
else
    set(mTextBoxHK4Label,'String','V+');
end
set(mTextBoxHK4Label,'Position', [410 35 50 20]);

mTextBoxHK4 = uicontrol('style','text');
%set(mTextBoxHK4,'HorizontalAlignment', 'right');
set(mTextBoxHK4,'String','NaN');
set(mTextBoxHK4,'Position', [410 10 50 20]);
plotHandles.hk4 = mTextBoxHK4;

mTextBoxHK5Label = uicontrol('style','text');
%set(mTextBoxHK5Label,'HorizontalAlignment', 'left');
if (debugData)
    set(mTextBoxHK5Label,'String','HK5');
else
    set(mTextBoxHK5Label,'String','VIn');
end
set(mTextBoxHK5Label,'Position', [460 35 50 20]);

mTextBoxHK5 = uicontrol('style','text');
%set(mTextBoxHK5,'HorizontalAlignment', 'right');
set(mTextBoxHK5,'String','NaN');
set(mTextBoxHK5,'Position', [460 10 50 20]);
plotHandles.hk5 = mTextBoxHK5;

mTextBoxHK6Label = uicontrol('style','text');
%set(mTextBoxHK6Label,'HorizontalAlignment', 'left');
if (debugData)
    set(mTextBoxHK6Label,'String','HK6');
else
    set(mTextBoxHK6Label,'String','Ref/2');
end
set(mTextBoxHK6Label,'Position', [510 35 50 20]);

mTextBoxHK6 = uicontrol('style','text');
%set(mTextBoxHK6,'HorizontalAlignment', 'right');
set(mTextBoxHK6,'String','NaN');
set(mTextBoxHK6,'Position', [510 10 50 20]);
plotHandles.hk6 = mTextBoxHK6;

mTextBoxHK7Label = uicontrol('style','text');
%set(mTextBoxHK7Label,'HorizontalAlignment', 'left');
if (debugData)
    set(mTextBoxHK7Label,'String','HK7');
else
    set(mTextBoxHK7Label,'String','IIn');
end
set(mTextBoxHK7Label,'Position', [560 35 50 20]);

mTextBoxHK7 = uicontrol('style','text');
%set(mTextBoxHK7,'HorizontalAlignment', 'right');
set(mTextBoxHK7,'String','NaN');
set(mTextBoxHK7,'Position', [560 10 50 20]);
plotHandles.hk7 = mTextBoxHK7;

mTextBoxHK8Label = uicontrol('style','text');
%set(mTextBoxHK8Label,'HorizontalAlignment', 'left');
set(mTextBoxHK8Label,'String','HK8');
set(mTextBoxHK8Label,'Position', [610 35 50 20]);

mTextBoxHK8 = uicontrol('style','text');
%set(mTextBoxHK8,'HorizontalAlignment', 'right');
set(mTextBoxHK8,'String','NaN');
set(mTextBoxHK8,'Position', [610 10 50 20]);
plotHandles.hk8 = mTextBoxHK8;

mTextBoxHK9Label = uicontrol('style','text');
%set(mTextBoxHK9Label,'HorizontalAlignment', 'left');
set(mTextBoxHK9Label,'String','HK9');
set(mTextBoxHK9Label,'Position', [660 35 50 20]);

mTextBoxHK9 = uicontrol('style','text');
%set(mTextBoxHK9,'HorizontalAlignment', 'right');
set(mTextBoxHK9,'String','NaN');
set(mTextBoxHK9,'Position', [660 10 50 20]);
plotHandles.hk9 = mTextBoxHK9;

mTextBoxHK10Label = uicontrol('style','text');
%set(mTextBoxHK10Label,'HorizontalAlignment', 'left');
set(mTextBoxHK10Label,'String','HK10');
set(mTextBoxHK10Label,'Position', [710 35 50 20]);

mTextBoxHK10 = uicontrol('style','text');
%set(mTextBoxHK10,'HorizontalAlignment', 'right');
set(mTextBoxHK10,'String','NaN');
set(mTextBoxHK10,'Position', [710 10 50 20]);
plotHandles.hk10 = mTextBoxHK10;

mTextBoxHK11Label = uicontrol('style','text');
%set(mTextBoxHK11Label,'HorizontalAlignment', 'left');
set(mTextBoxHK11Label,'String','HK11');
set(mTextBoxHK11Label,'Position', [760 35 50 20]);

mTextBoxHK11 = uicontrol('style','text');
%set(mTextBoxHK11,'HorizontalAlignment', 'right');
set(mTextBoxHK11,'String','NaN');
set(mTextBoxHK11,'Position', [760 10 50 20]);
plotHandles.hk11 = mTextBoxHK11;

mTextBoxBoardidLabel = uicontrol('style','text');
%set(mTextBoxBoardidLabel,'HorizontalAlignment', 'left');
set(mTextBoxBoardidLabel,'String','Board ID');
set(mTextBoxBoardidLabel,'Position', [810 35 50 20]);

mTextBoxBoardid = uicontrol('style','text');
%set(mTextBoxBoardid,'HorizontalAlignment', 'right');
set(mTextBoxBoardid,'String','NaN');
set(mTextBoxBoardid,'Position', [810 10 50 20]);
plotHandles.boardid = mTextBoxBoardid;

mTextBoxSensoridLabel = uicontrol('style','text');
%set(mTextBoxSensoridLabel,'HorizontalAlignment', 'left');
set(mTextBoxSensoridLabel,'String','Sensor ID');
set(mTextBoxSensoridLabel,'Position', [860 35 50 20]);

mTextBoxSensorid = uicontrol('style','text');
%set(mTextBoxSensorid,'HorizontalAlignment', 'right');
set(mTextBoxSensorid,'String','NaN');
set(mTextBoxSensorid,'Position', [860 10 50 20]);
plotHandles.sensorid = mTextBoxSensorid;

mTextBoxCRCLabel = uicontrol('style','text');
%set(mTextBoxCRCLabel,'HorizontalAlignment', 'left');
set(mTextBoxCRCLabel,'String','CRC');
set(mTextBoxCRCLabel,'Position', [910 35 50 20]);

mTextBoxCRC = uicontrol('style','text');
%set(mTextBoxCRC,'HorizontalAlignment', 'right');
set(mTextBoxCRC,'String','NaN');
set(mTextBoxCRC,'Position', [910 10 50 20]);
plotHandles.crc = mTextBoxCRC;

% Magnetic data test boxes.

mTextBoxXAvgLabel = uicontrol('style','text');
%set(mTextBoxXAvgLabel,'HorizontalAlignment', 'left');
set(mTextBoxXAvgLabel,'String','X Avg');
set(mTextBoxXAvgLabel,'Position', [960 35 50 20]);

mTextBoxXAvg = uicontrol('style','text');
%set(mTextBoxXAvg,'HorizontalAlignment', 'right');
set(mTextBoxXAvg,'String','NaN');
set(mTextBoxXAvg,'Position', [960 10 50 20]);
plotHandles.xavg = mTextBoxXAvg;

mTextBoxXstddevLabel = uicontrol('style','text');
%set(mTextBoxXstddevLabel,'HorizontalAlignment', 'left');
set(mTextBoxXstddevLabel,'String','X stddev');
set(mTextBoxXstddevLabel,'Position', [1010 35 50 20]);

mTextBoxXstddev = uicontrol('style','text');
%set(mTextBoxXstddev,'HorizontalAlignment', 'right');
set(mTextBoxXstddev,'String','NaN');
set(mTextBoxXstddev,'Position', [1010 10 50 20]);
plotHandles.xstddev = mTextBoxXstddev;

mTextBoxYAvgLabel = uicontrol('style','text');
%set(mTextBoxYAvgLabel,'HorizontalAlignment', 'left');
set(mTextBoxYAvgLabel,'String','Y Avg');
set(mTextBoxYAvgLabel,'Position', [1060 35 50 20]);

mTextBoxYAvg = uicontrol('style','text');
%set(mTextBoxYAvg,'HorizontalAlignment', 'right');
set(mTextBoxYAvg,'String','NaN');
set(mTextBoxYAvg,'Position', [1060 10 50 20]);
plotHandles.yavg = mTextBoxYAvg;

mTextBoxYstddevLabel = uicontrol('style','text');
%set(mTextBoxYstddevLabel,'HorizontalAlignment', 'left');
set(mTextBoxYstddevLabel,'String','Y stddev');
set(mTextBoxYstddevLabel,'Position', [1110 35 50 20]);

mTextBoxYstddev = uicontrol('style','text');
%set(mTextBoxYstddev,'HorizontalAlignment', 'right');
set(mTextBoxYstddev,'String','NaN');
set(mTextBoxYstddev,'Position', [1110 10 50 20]);
plotHandles.ystddev = mTextBoxYstddev;

mTextBoxZAvgLabel = uicontrol('style','text');
%set(mTextBoxZAvgLabel,'HorizontalAlignment', 'left');
set(mTextBoxZAvgLabel,'String','Z Avg');
set(mTextBoxZAvgLabel,'Position', [1160 35 50 20]);

mTextBoxZAvg = uicontrol('style','text');
%set(mTextBoxZAvg,'HorizontalAlignment', 'right');
set(mTextBoxZAvg,'String','NaN');
set(mTextBoxZAvg,'Position', [1160 10 50 20]);
plotHandles.zavg = mTextBoxZAvg;

mTextBoxZstddevLabel = uicontrol('style','text');
%set(mTextBoxZstddevLabel,'HorizontalAlignment', 'left');
set(mTextBoxZstddevLabel,'String','Z stddev');
set(mTextBoxZstddevLabel,'Position', [1210 35 50 20]);

mTextBoxZstddev = uicontrol('style','text');
%set(mTextBoxZstddev,'HorizontalAlignment', 'right');
set(mTextBoxZstddev,'String','NaN');
set(mTextBoxZstddev,'Position', [1210 10 50 20]);
plotHandles.zstddev = mTextBoxZstddev;


% Amplitude Spectra Stuff

mTextBoxXAmpLabel = uicontrol('style','text');
%set(mTextBoxXAmpLabel,'HorizontalAlignment', 'left');
set(mTextBoxXAmpLabel,'String','X RMS');
set(mTextBoxXAmpLabel,'Position', [1260 35 50 20]);

mTextBoxXAmp = uicontrol('style','text');
%set(mTextBoxXAmp,'HorizontalAlignment', 'right');
set(mTextBoxXAmp,'String','NaN');
set(mTextBoxXAmp,'Position', [1260 10 50 20]);
plotHandles.xamp = mTextBoxXAmp;

mTextBoxXFreqLabel = uicontrol('style','text');
%set(mTextBoxXFreqLabel,'HorizontalAlignment', 'left');
set(mTextBoxXFreqLabel,'String','X Hz');
set(mTextBoxXFreqLabel,'Position', [1310 35 50 20]);

mTextBoxXFreq = uicontrol('style','text');
%set(mTextBoxXFreq,'HorizontalAlignment', 'right');
set(mTextBoxXFreq,'String','NaN');
set(mTextBoxXFreq,'Position', [1310 10 50 20]);
plotHandles.xfreq = mTextBoxXFreq;

mTextBoxYAmpLabel = uicontrol('style','text');
%set(mTextBoxYAmpLabel,'HorizontalAlignment', 'left');
set(mTextBoxYAmpLabel,'String','Y RMS');
set(mTextBoxYAmpLabel,'Position', [1360 35 50 20]);

mTextBoxYAmp = uicontrol('style','text');
%set(mTextBoxYAmp,'HorizontalAlignment', 'right');
set(mTextBoxYAmp,'String','NaN');
set(mTextBoxYAmp,'Position', [1360 10 50 20]);
plotHandles.yamp = mTextBoxYAmp;

mTextBoxYFreqLabel = uicontrol('style','text');
%set(mTextBoxYFreqLabel,'HorizontalAlignment', 'left');
set(mTextBoxYFreqLabel,'String','Y Hz');
set(mTextBoxYFreqLabel,'Position', [1410 35 50 20]);

mTextBoxYFreq = uicontrol('style','text');
%set(mTextBoxYFreq,'HorizontalAlignment', 'right');
set(mTextBoxYFreq,'String','NaN');
set(mTextBoxYFreq,'Position', [1410 10 50 20]);
plotHandles.yfreq = mTextBoxYFreq;

mTextBoxZAmpLabel = uicontrol('style','text');
%set(mTextBoxZAmpLabel,'HorizontalAlignment', 'left');
set(mTextBoxZAmpLabel,'String','Z RMS');
set(mTextBoxZAmpLabel,'Position', [1460 35 50 20]);

mTextBoxZAmp = uicontrol('style','text');
%set(mTextBoxZAmp,'HorizontalAlignment', 'right');
set(mTextBoxZAmp,'String','NaN');
set(mTextBoxZAmp,'Position', [1460 10 50 20]);
plotHandles.zamp = mTextBoxZAmp;

mTextBoxZFreqLabel = uicontrol('style','text');
%set(mTextBoxZFreqLabel,'HorizontalAlignment', 'left');
set(mTextBoxZFreqLabel,'String','Z Hz');
set(mTextBoxZFreqLabel,'Position', [1510 35 50 20]);

mTextBoxZFreq = uicontrol('style','text');
%set(mTextBoxZFreq,'HorizontalAlignment', 'right');
set(mTextBoxZFreq,'String','NaN');
set(mTextBoxZFreq,'Position', [1510 10 50 20]);
plotHandles.zfreq = mTextBoxZFreq;