function  [dataPacket, magData, hkData] = interpretData( dataPacket, magData, hkData )
ngfmLoadConstants;

magData(1,1:numSamplesToStore-assumedSamplingRate) = magData(1,assumedSamplingRate+1:numSamplesToStore);
magData(2,1:numSamplesToStore-assumedSamplingRate) = magData(2,assumedSamplingRate+1:numSamplesToStore);
magData(3,1:numSamplesToStore-assumedSamplingRate) = magData(3,assumedSamplingRate+1:numSamplesToStore);


magData(1,numSamplesToStore-assumedSamplingRate+1:numSamplesToStore) = XDACScale*double(dataPacket.xdac) + XADCScale*double(dataPacket.xadc) + XOffset;
magData(2,numSamplesToStore-assumedSamplingRate+1:numSamplesToStore) = YDACScale*double(dataPacket.ydac) + YADCScale*double(dataPacket.yadc) + YOffset;
magData(3,numSamplesToStore-assumedSamplingRate+1:numSamplesToStore) = ZDACScale*double(dataPacket.zdac) + ZADCScale*double(dataPacket.zadc) + ZOffset;

hkData(1) = HK0Scale*double(dataPacket.hk(1))+HK0Offset;
hkData(2) = HK1Scale*double(dataPacket.hk(2))+HK1Offset;
hkData(3) = HK2Scale*double(dataPacket.hk(3))+HK2Offset;
hkData(4) = HK3Scale*double(dataPacket.hk(4))+HK3Offset;
hkData(5) = HK4Scale*double(dataPacket.hk(5))+HK4Offset;
hkData(6) = HK5Scale*double(dataPacket.hk(6))+HK5Offset;
hkData(7) = HK6Scale*double(dataPacket.hk(7))+HK6Offset;
hkData(8) = HK7Scale*double(dataPacket.hk(8))+HK7Offset;
hkData(9) = HK8Scale*double(dataPacket.hk(9))+HK8Offset;
hkData(10) = HK9Scale*double(dataPacket.hk(10))+HK9Offset;
hkData(11) = HK10Scale*double(dataPacket.hk(11))+HK10Offset;
hkData(12) = HK11Scale*double(dataPacket.hk(12))+HK11Offset;