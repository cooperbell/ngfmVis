function  [dataPacket, magData, hkData] = interpretData( dataPacket, magData, hkData, hk)
ngfmLoadConstants;

for i = 1:length(hk)
    switch i
        case 1
            HK0Scale = hk(1,2);
            HK0Offset = hk(1,3);
        case 2
            HK1Scale = hk(2,2);
            HK1Offset = hk(2,3);
        case 3
            HK2Scale = hk(3,2);
            HK2Offset = hk(3,3);
        case 4
            HK3Scale = hk(4,2);
            HK3Offset = hk(4,3);
        case 5
            HK4Scale = hk(5,2);
            HK4Offset = hk(5,3);
        case 6
            HK5Scale = hk(6,2);
            HK5Offset = hk(6,3);
        case 7
            HK6Scale = hk(7,2);
            HK6Offset = hk(7,3);
        case 8
            HK7Scale = hk(8,2);
            HK7Offset = hk(8,3);
        case 9
            HK8Scale = hk(8,2);
            HK8Offset = hk(8,3);
        case 10
            HK9Scale = hk(9,2);
            HK9Offset = hk(9,3);
        case 11
            HK10Scale = hk(10,2);
            HK10Offset = hk(10,3);
        case 12
            HK11Scale = hk(11,2);
            HK11Offset = hk(11,3);
    end
end

magData(1,1:numSamplesToStore-assumedSamplingRate) = magData(1,assumedSamplingRate+1:numSamplesToStore);
magData(2,1:numSamplesToStore-assumedSamplingRate) = magData(2,assumedSamplingRate+1:numSamplesToStore);
magData(3,1:numSamplesToStore-assumedSamplingRate) = magData(3,assumedSamplingRate+1:numSamplesToStore);


magData(1,numSamplesToStore-assumedSamplingRate+1:numSamplesToStore) = XDACScale*double(dataPacket.xdac) + XADCScale*double(dataPacket.xadc) + XOffset;
magData(2,numSamplesToStore-assumedSamplingRate+1:numSamplesToStore) = YDACScale*double(dataPacket.ydac) + YADCScale*double(dataPacket.yadc) + YOffset;
magData(3,numSamplesToStore-assumedSamplingRate+1:numSamplesToStore) = ZDACScale*double(dataPacket.zdac) + ZADCScale*double(dataPacket.zadc) + ZOffset;


for i = 1:12
    hkData(i,2:hkSecondsToDisplay) = hkData(i,1:hkSecondsToDisplay-1);
end


hkData(1,1) = HK0Scale*double(dataPacket.hk(1))+HK0Offset; % debug
hkData(2,1) = HK1Scale*double(dataPacket.hk(2))+HK1Offset; % debug
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


% hkData(1) = HK0Scale*double(dataPacket.hk(1))+HK0Offset;
% hkData(2) = HK1Scale*double(dataPacket.hk(2))+HK1Offset;
% hkData(3) = HK2Scale*double(dataPacket.hk(3))+HK2Offset;
% hkData(4) = HK3Scale*double(dataPacket.hk(4))+HK3Offset;
% hkData(5) = HK4Scale*double(dataPacket.hk(5))+HK4Offset;
% hkData(6) = HK5Scale*double(dataPacket.hk(6))+HK5Offset;
% hkData(7) = HK6Scale*double(dataPacket.hk(7))+HK6Offset;
% hkData(8) = HK7Scale*double(dataPacket.hk(8))+HK7Offset;
% hkData(9) = HK8Scale*double(dataPacket.hk(9))+HK8Offset;
% hkData(10) = HK9Scale*double(dataPacket.hk(10))+HK9Offset;
% hkData(11) = HK10Scale*double(dataPacket.hk(11))+HK10Offset;
% hkData(12) = HK11Scale*double(dataPacket.hk(12))+HK11Offset;
