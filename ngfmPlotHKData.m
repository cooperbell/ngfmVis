mTextBoxPidLabel = uicontrol('style','text');
set(mTextBoxPidLabel,'HorizontalAlignment', 'left');
set(mTextBoxPidLabel,'String','PID');
set(mTextBoxPidLabel,'Position', [20 800 50 20]);

mTextBoxPid = uicontrol('style','text');
set(mTextBoxPid,'HorizontalAlignment', 'right');
set(mTextBoxPid,'String','NaN');
set(mTextBoxPid,'Position', [80 800 50 20]);
plotHandles.pid = mTextBoxPid;


mTextBoxPacketLengthLabel = uicontrol('style','text');
set(mTextBoxPacketLengthLabel,'HorizontalAlignment', 'left');
set(mTextBoxPacketLengthLabel,'String','PktLen');
set(mTextBoxPacketLengthLabel,'Position', [20 775 50 20]);

mTextBoxPacketLength = uicontrol('style','text');
set(mTextBoxPacketLength,'HorizontalAlignment', 'right');
set(mTextBoxPacketLength,'String','NaN');
set(mTextBoxPacketLength,'Position', [80 775 50 20]);
plotHandles.packetlength = mTextBoxPacketLength;


mTextBoxFsLabel = uicontrol('style','text');
set(mTextBoxFsLabel,'HorizontalAlignment', 'left');
set(mTextBoxFsLabel,'String','FS');
set(mTextBoxFsLabel,'Position', [20 750 50 20]);

mTextBoxFs = uicontrol('style','text');
set(mTextBoxFs,'HorizontalAlignment', 'right');
set(mTextBoxFs,'String','NaN');
set(mTextBoxFs,'Position', [80 750 50 20]);
plotHandles.fs = mTextBoxFs;


mTextBoxPPSOffsetLabel = uicontrol('style','text');
set(mTextBoxPPSOffsetLabel,'HorizontalAlignment', 'left');
set(mTextBoxPPSOffsetLabel,'String','PPS');
set(mTextBoxPPSOffsetLabel,'Position', [20 725 50 20]);

mTextBoxPPSOffset = uicontrol('style','text');
set(mTextBoxPPSOffset,'HorizontalAlignment', 'Right');
set(mTextBoxPPSOffset,'String','NaN');
set(mTextBoxPPSOffset,'Position', [80 725 50 20]);
plotHandles.ppsoffset = mTextBoxPPSOffset;


mTextBoxHK0Label = uicontrol('style','text');
set(mTextBoxHK0Label,'HorizontalAlignment', 'left');
if (debugData)
    set(mTextBoxHK0Label,'String','HK0');
else
    set(mTextBoxHK0Label,'String','+1V2');
end
set(mTextBoxHK0Label,'Position', [20 700 50 20]);

mTextBoxHK0 = uicontrol('style','text');
set(mTextBoxHK0,'HorizontalAlignment', 'right');
set(mTextBoxHK0,'String','NaN');
set(mTextBoxHK0,'Position', [80 700 50 20]);
plotHandles.hk0 = mTextBoxHK0;


mTextBoxHK1Label = uicontrol('style','text');
set(mTextBoxHK1Label,'HorizontalAlignment', 'left');
if (debugData)
    set(mTextBoxHK1Label,'String','HK1');
else
    set(mTextBoxHK1Label,'String','TSens');
end
set(mTextBoxHK1Label,'Position', [20 675 50 20]);

mTextBoxHK1 = uicontrol('style','text');
set(mTextBoxHK1,'HorizontalAlignment', 'right');
set(mTextBoxHK1,'String','NaN');
set(mTextBoxHK1,'Position', [80 675 50 20]);
plotHandles.hk1 = mTextBoxHK1;


mTextBoxHK2Label = uicontrol('style','text');
set(mTextBoxHK2Label,'HorizontalAlignment', 'left');
if (debugData)
    set(mTextBoxHK2Label,'String','HK2');
else
    set(mTextBoxHK2Label,'String','TRef');
end
set(mTextBoxHK2Label,'Position', [20 650 50 20]);

mTextBoxHK2 = uicontrol('style','text');
set(mTextBoxHK2,'HorizontalAlignment', 'right');
set(mTextBoxHK2,'String','NaN');
set(mTextBoxHK2,'Position', [80 650 50 20]);
plotHandles.hk2 = mTextBoxHK2;

mTextBoxHK3Label = uicontrol('style','text');
set(mTextBoxHK3Label,'HorizontalAlignment', 'left');
if (debugData)
    set(mTextBoxHK3Label,'String','HK3');
else
    set(mTextBoxHK3Label,'String','TBrd');
end
set(mTextBoxHK3Label,'Position', [20 625 50 20]);

mTextBoxHK3 = uicontrol('style','text');
set(mTextBoxHK3,'HorizontalAlignment', 'right');
set(mTextBoxHK3,'String','NaN');
set(mTextBoxHK3,'Position', [80 625 50 20]);
plotHandles.hk3 = mTextBoxHK3;

mTextBoxHK4Label = uicontrol('style','text');
set(mTextBoxHK4Label,'HorizontalAlignment', 'left');
if (debugData)
    set(mTextBoxHK4Label,'String','HK4');
else
    set(mTextBoxHK4Label,'String','V+');
end
set(mTextBoxHK4Label,'Position', [20 600 50 20]);

mTextBoxHK4 = uicontrol('style','text');
set(mTextBoxHK4,'HorizontalAlignment', 'right');
set(mTextBoxHK4,'String','NaN');
set(mTextBoxHK4,'Position', [80 600 50 20]);
plotHandles.hk4 = mTextBoxHK4;

mTextBoxHK5Label = uicontrol('style','text');
set(mTextBoxHK5Label,'HorizontalAlignment', 'left');
if (debugData)
    set(mTextBoxHK5Label,'String','HK5');
else
    set(mTextBoxHK5Label,'String','VIn');
end
set(mTextBoxHK5Label,'Position', [20 575 50 20]);

mTextBoxHK5 = uicontrol('style','text');
set(mTextBoxHK5,'HorizontalAlignment', 'right');
set(mTextBoxHK5,'String','NaN');
set(mTextBoxHK5,'Position', [80 575 50 20]);
plotHandles.hk5 = mTextBoxHK5;

mTextBoxHK6Label = uicontrol('style','text');
set(mTextBoxHK6Label,'HorizontalAlignment', 'left');
if (debugData)
    set(mTextBoxHK6Label,'String','HK6');
else
    set(mTextBoxHK6Label,'String','Ref/2');
end
set(mTextBoxHK6Label,'Position', [20 550 50 20]);

mTextBoxHK6 = uicontrol('style','text');
set(mTextBoxHK6,'HorizontalAlignment', 'right');
set(mTextBoxHK6,'String','NaN');
set(mTextBoxHK6,'Position', [80 550 50 20]);
plotHandles.hk6 = mTextBoxHK6;

mTextBoxHK7Label = uicontrol('style','text');
set(mTextBoxHK7Label,'HorizontalAlignment', 'left');
if (debugData)
    set(mTextBoxHK7Label,'String','HK7');
else
    set(mTextBoxHK7Label,'String','IIn');
end
set(mTextBoxHK7Label,'Position', [20 525 50 20]);

mTextBoxHK7 = uicontrol('style','text');
set(mTextBoxHK7,'HorizontalAlignment', 'right');
set(mTextBoxHK7,'String','NaN');
set(mTextBoxHK7,'Position', [80 525 50 20]);
plotHandles.hk7 = mTextBoxHK7;

mTextBoxHK8Label = uicontrol('style','text');
set(mTextBoxHK8Label,'HorizontalAlignment', 'left');
set(mTextBoxHK8Label,'String','HK8');
set(mTextBoxHK8Label,'Position', [20 500 50 20]);

mTextBoxHK8 = uicontrol('style','text');
set(mTextBoxHK8,'HorizontalAlignment', 'right');
set(mTextBoxHK8,'String','NaN');
set(mTextBoxHK8,'Position', [80 500 50 20]);
plotHandles.hk8 = mTextBoxHK8;

mTextBoxHK9Label = uicontrol('style','text');
set(mTextBoxHK9Label,'HorizontalAlignment', 'left');
set(mTextBoxHK9Label,'String','HK9');
set(mTextBoxHK9Label,'Position', [20 475 50 20]);

mTextBoxHK9 = uicontrol('style','text');
set(mTextBoxHK9,'HorizontalAlignment', 'right');
set(mTextBoxHK9,'String','NaN');
set(mTextBoxHK9,'Position', [80 475 50 20]);
plotHandles.hk9 = mTextBoxHK9;

mTextBoxHK10Label = uicontrol('style','text');
set(mTextBoxHK10Label,'HorizontalAlignment', 'left');
set(mTextBoxHK10Label,'String','HK10');
set(mTextBoxHK10Label,'Position', [20 450 50 20]);

mTextBoxHK10 = uicontrol('style','text');
set(mTextBoxHK10,'HorizontalAlignment', 'right');
set(mTextBoxHK10,'String','NaN');
set(mTextBoxHK10,'Position', [80 450 50 20]);
plotHandles.hk10 = mTextBoxHK10;

mTextBoxHK11Label = uicontrol('style','text');
set(mTextBoxHK11Label,'HorizontalAlignment', 'left');
set(mTextBoxHK11Label,'String','HK11');
set(mTextBoxHK11Label,'Position', [20 425 50 20]);

mTextBoxHK11 = uicontrol('style','text');
set(mTextBoxHK11,'HorizontalAlignment', 'right');
set(mTextBoxHK11,'String','NaN');
set(mTextBoxHK11,'Position', [80 425 50 20]);
plotHandles.hk11 = mTextBoxHK11;

mTextBoxBoardidLabel = uicontrol('style','text');
set(mTextBoxBoardidLabel,'HorizontalAlignment', 'left');
set(mTextBoxBoardidLabel,'String','Board ID');
set(mTextBoxBoardidLabel,'Position', [20 400 50 20]);

mTextBoxBoardid = uicontrol('style','text');
set(mTextBoxBoardid,'HorizontalAlignment', 'right');
set(mTextBoxBoardid,'String','NaN');
set(mTextBoxBoardid,'Position', [80 400 50 20]);
plotHandles.boardid = mTextBoxBoardid;

mTextBoxSensoridLabel = uicontrol('style','text');
set(mTextBoxSensoridLabel,'HorizontalAlignment', 'left');
set(mTextBoxSensoridLabel,'String','Sensor ID');
set(mTextBoxSensoridLabel,'Position', [20 375 50 20]);

mTextBoxSensorid = uicontrol('style','text');
set(mTextBoxSensorid,'HorizontalAlignment', 'right');
set(mTextBoxSensorid,'String','NaN');
set(mTextBoxSensorid,'Position', [80 375 50 20]);
plotHandles.sensorid = mTextBoxSensorid;

mTextBoxCRCLabel = uicontrol('style','text');
set(mTextBoxCRCLabel,'HorizontalAlignment', 'left');
set(mTextBoxCRCLabel,'String','CRC');
set(mTextBoxCRCLabel,'Position', [20 350 50 20]);

mTextBoxCRC = uicontrol('style','text');
set(mTextBoxCRC,'HorizontalAlignment', 'right');
set(mTextBoxCRC,'String','NaN');
set(mTextBoxCRC,'Position', [80 350 50 20]);
plotHandles.crc = mTextBoxCRC;

% Magnetic data test boxes.

mTextBoxXAvgLabel = uicontrol('style','text');
set(mTextBoxXAvgLabel,'HorizontalAlignment', 'left');
set(mTextBoxXAvgLabel,'String','X Avg');
set(mTextBoxXAvgLabel,'Position', [20 325 50 20]);

mTextBoxXAvg = uicontrol('style','text');
set(mTextBoxXAvg,'HorizontalAlignment', 'right');
set(mTextBoxXAvg,'String','NaN');
set(mTextBoxXAvg,'Position', [80 325 50 20]);
plotHandles.xavg = mTextBoxXAvg;

mTextBoxXstddevLabel = uicontrol('style','text');
set(mTextBoxXstddevLabel,'HorizontalAlignment', 'left');
set(mTextBoxXstddevLabel,'String','X stddev');
set(mTextBoxXstddevLabel,'Position', [20 300 50 20]);

mTextBoxXstddev = uicontrol('style','text');
set(mTextBoxXstddev,'HorizontalAlignment', 'right');
set(mTextBoxXstddev,'String','NaN');
set(mTextBoxXstddev,'Position', [80 300 50 20]);
plotHandles.xstddev = mTextBoxXstddev;

mTextBoxYAvgLabel = uicontrol('style','text');
set(mTextBoxYAvgLabel,'HorizontalAlignment', 'left');
set(mTextBoxYAvgLabel,'String','Y Avg');
set(mTextBoxYAvgLabel,'Position', [20 275 50 20]);

mTextBoxYAvg = uicontrol('style','text');
set(mTextBoxYAvg,'HorizontalAlignment', 'right');
set(mTextBoxYAvg,'String','NaN');
set(mTextBoxYAvg,'Position', [80 275 50 20]);
plotHandles.yavg = mTextBoxYAvg;

mTextBoxYstddevLabel = uicontrol('style','text');
set(mTextBoxYstddevLabel,'HorizontalAlignment', 'left');
set(mTextBoxYstddevLabel,'String','Y stddev');
set(mTextBoxYstddevLabel,'Position', [20 250 50 20]);

mTextBoxYstddev = uicontrol('style','text');
set(mTextBoxYstddev,'HorizontalAlignment', 'right');
set(mTextBoxYstddev,'String','NaN');
set(mTextBoxYstddev,'Position', [80 250 50 20]);
plotHandles.ystddev = mTextBoxYstddev;

mTextBoxZAvgLabel = uicontrol('style','text');
set(mTextBoxZAvgLabel,'HorizontalAlignment', 'left');
set(mTextBoxZAvgLabel,'String','Z Avg');
set(mTextBoxZAvgLabel,'Position', [20 225 50 20]);

mTextBoxZAvg = uicontrol('style','text');
set(mTextBoxZAvg,'HorizontalAlignment', 'right');
set(mTextBoxZAvg,'String','NaN');
set(mTextBoxZAvg,'Position', [80 225 50 20]);
plotHandles.zavg = mTextBoxZAvg;

mTextBoxZstddevLabel = uicontrol('style','text');
set(mTextBoxZstddevLabel,'HorizontalAlignment', 'left');
set(mTextBoxZstddevLabel,'String','Z stddev');
set(mTextBoxZstddevLabel,'Position', [20 200 50 20]);

mTextBoxZstddev = uicontrol('style','text');
set(mTextBoxZstddev,'HorizontalAlignment', 'right');
set(mTextBoxZstddev,'String','NaN');
set(mTextBoxZstddev,'Position', [80 200 50 20]);
plotHandles.zstddev = mTextBoxZstddev;


% Amplitude Spectra Stuff

mTextBoxXAmpLabel = uicontrol('style','text');
set(mTextBoxXAmpLabel,'HorizontalAlignment', 'left');
set(mTextBoxXAmpLabel,'String','X RMS');
set(mTextBoxXAmpLabel,'Position', [20 175 50 20]);

mTextBoxXAmp = uicontrol('style','text');
set(mTextBoxXAmp,'HorizontalAlignment', 'right');
set(mTextBoxXAmp,'String','NaN');
set(mTextBoxXAmp,'Position', [80 175 50 20]);
plotHandles.xamp = mTextBoxXAmp;

mTextBoxXFreqLabel = uicontrol('style','text');
set(mTextBoxXFreqLabel,'HorizontalAlignment', 'left');
set(mTextBoxXFreqLabel,'String','X Hz');
set(mTextBoxXFreqLabel,'Position', [20 150 50 20]);

mTextBoxXFreq = uicontrol('style','text');
set(mTextBoxXFreq,'HorizontalAlignment', 'right');
set(mTextBoxXFreq,'String','NaN');
set(mTextBoxXFreq,'Position', [80 150 50 20]);
plotHandles.xfreq = mTextBoxXFreq;

mTextBoxYAmpLabel = uicontrol('style','text');
set(mTextBoxYAmpLabel,'HorizontalAlignment', 'left');
set(mTextBoxYAmpLabel,'String','Y RMS');
set(mTextBoxYAmpLabel,'Position', [20 125 50 20]);

mTextBoxYAmp = uicontrol('style','text');
set(mTextBoxYAmp,'HorizontalAlignment', 'right');
set(mTextBoxYAmp,'String','NaN');
set(mTextBoxYAmp,'Position', [80 125 50 20]);
plotHandles.yamp = mTextBoxYAmp;

mTextBoxYFreqLabel = uicontrol('style','text');
set(mTextBoxYFreqLabel,'HorizontalAlignment', 'left');
set(mTextBoxYFreqLabel,'String','Y Hz');
set(mTextBoxYFreqLabel,'Position', [20 100 50 20]);

mTextBoxYFreq = uicontrol('style','text');
set(mTextBoxYFreq,'HorizontalAlignment', 'right');
set(mTextBoxYFreq,'String','NaN');
set(mTextBoxYFreq,'Position', [80 100 50 20]);
plotHandles.yfreq = mTextBoxYFreq;

mTextBoxZAmpLabel = uicontrol('style','text');
set(mTextBoxZAmpLabel,'HorizontalAlignment', 'left');
set(mTextBoxZAmpLabel,'String','Z RMS');
set(mTextBoxZAmpLabel,'Position', [20 75 50 20]);

mTextBoxZAmp = uicontrol('style','text');
set(mTextBoxZAmp,'HorizontalAlignment', 'right');
set(mTextBoxZAmp,'String','NaN');
set(mTextBoxZAmp,'Position', [80 75 50 20]);
plotHandles.zamp = mTextBoxZAmp;

mTextBoxZFreqLabel = uicontrol('style','text');
set(mTextBoxZFreqLabel,'HorizontalAlignment', 'left');
set(mTextBoxZFreqLabel,'String','Z Hz');
set(mTextBoxZFreqLabel,'Position', [20 50 50 20]);

mTextBoxZFreq = uicontrol('style','text');
set(mTextBoxZFreq,'HorizontalAlignment', 'right');
set(mTextBoxZFreq,'String','NaN');
set(mTextBoxZFreq,'Position', [80 50 50 20]);
plotHandles.zfreq = mTextBoxZFreq;