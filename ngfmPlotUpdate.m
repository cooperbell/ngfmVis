function ngfmPlotUpdate( plotHandles, dataPacket, magData, hkData)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

ngfmLoadConstants;
global debugData;

ngfmPlotSpectra;


ngfmPlotXYZ;


% update hk data
set(plotHandles.xavg,'String',sprintf('%5.3f',mean(magData(1,numSamplesToStore-numSamplesToDisplay+1:numSamplesToStore))));
set(plotHandles.yavg,'String',sprintf('%5.3f',mean(magData(2,numSamplesToStore-numSamplesToDisplay+1:numSamplesToStore))));
set(plotHandles.zavg,'String',sprintf('%5.3f',mean(magData(3,numSamplesToStore-numSamplesToDisplay+1:numSamplesToStore))));

set(plotHandles.xstddev,'String',sprintf('%5.3f',std(magData(1,numSamplesToStore-numSamplesToDisplay+1:numSamplesToStore))));
set(plotHandles.ystddev,'String',sprintf('%5.3f',std(magData(2,numSamplesToStore-numSamplesToDisplay+1:numSamplesToStore))));
set(plotHandles.zstddev,'String',sprintf('%5.3f',std(magData(3,numSamplesToStore-numSamplesToDisplay+1:numSamplesToStore))));


if (debugData)
    set(plotHandles.pid,'String',sprintf('%02X',dataPacket.pid));
    set(plotHandles.packetlength,'String',sprintf('%04X',dataPacket.packetlength));
    set(plotHandles.fs,'String',sprintf('%04X',dataPacket.fs));
    set(plotHandles.ppsoffset,'String',sprintf('%08X',dataPacket.ppsoffset));
    set(plotHandles.hk0,'String',sprintf('%04X',dataPacket.hk(1)));
    set(plotHandles.hk1,'String',sprintf('%04X',dataPacket.hk(2)));
    set(plotHandles.hk2,'String',sprintf('%04X',dataPacket.hk(3)));
    set(plotHandles.hk3,'String',sprintf('%04X',dataPacket.hk(4)));
    set(plotHandles.hk4,'String',sprintf('%04X',dataPacket.hk(5)));
    set(plotHandles.hk5,'String',sprintf('%04X',dataPacket.hk(6)));
    set(plotHandles.hk6,'String',sprintf('%04X',dataPacket.hk(7)));
    set(plotHandles.hk7,'String',sprintf('%04X',dataPacket.hk(8)));
    set(plotHandles.hk8,'String',sprintf('%04X',dataPacket.hk(9)));
    set(plotHandles.hk9,'String',sprintf('%04X',dataPacket.hk(10)));
    set(plotHandles.hk10,'String',sprintf('%04X',dataPacket.hk(11)));
    set(plotHandles.hk11,'String',sprintf('%04X',dataPacket.hk(12)));
    set(plotHandles.boardid,'String',sprintf('%04X',dataPacket.boardid));
    set(plotHandles.sensorid,'String',sprintf('%04X',dataPacket.sensorid));
    set(plotHandles.crc,'String',sprintf('%04X',dataPacket.crc));
else
    set(plotHandles.pid,'String',sprintf('%d',dataPacket.pid));
    set(plotHandles.packetlength,'String',sprintf('%d',dataPacket.packetlength));
    set(plotHandles.fs,'String',sprintf('%d',dataPacket.fs));
    set(plotHandles.ppsoffset,'String',sprintf('%d',dataPacket.ppsoffset));

    set(plotHandles.hk0,'String',sprintf('%4.2f',hkData(1)));
    set(plotHandles.hk1,'String',sprintf('%4.2f',hkData(2)));
    set(plotHandles.hk2,'String',sprintf('%4.2f',hkData(3)));
    set(plotHandles.hk3,'String',sprintf('%4.2f',hkData(4)));
    set(plotHandles.hk4,'String',sprintf('%4.2f',hkData(5)));
    set(plotHandles.hk5,'String',sprintf('%4.2f',hkData(6)));
    set(plotHandles.hk6,'String',sprintf('%4.2f',hkData(7)));
    set(plotHandles.hk7,'String',sprintf('%4.2f',hkData(8)));
    set(plotHandles.hk8,'String',sprintf('%2.2f',hkData(9)));
    set(plotHandles.hk9,'String',sprintf('%2.2f',hkData(10)));
    set(plotHandles.hk10,'String',sprintf('%2.2f',hkData(11)));
    set(plotHandles.hk11,'String',sprintf('%2.2f',hkData(12)));
    set(plotHandles.boardid,'String',sprintf('%d',dataPacket.boardid));
    set(plotHandles.sensorid,'String',sprintf('%d',dataPacket.sensorid));
    set(plotHandles.crc,'String',sprintf('%04X',dataPacket.crc));
end

