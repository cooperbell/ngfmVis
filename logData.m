% LOGDATA log mag and hk data to file
function logData(file, dataPacket, magData, hkData, debugData)
    ngfmLoadConstants;
    c = clock;

    if(debugData)
        for n = 1:100
           fprintf(file, '%d %d %d %d %d %6.3f %7d %7d %7d %7d %7d %7d %7d %7d %7d %7d %7d %7d %7d %7d %7d %7d %7d %7d\n', ...
            c(1), c(2), c(3), c(4), c(5), c(6), ...
            dataPacket.xdac(n), dataPacket.ydac(n), dataPacket.zdac(n), ...
            dataPacket.xadc(n), dataPacket.yadc(n), dataPacket.zadc(n), ...
            dataPacket.hk(1), dataPacket.hk(2), dataPacket.hk(3), ...
            dataPacket.hk(4), dataPacket.hk(5), dataPacket.hk(6), ...
            dataPacket.hk(7), dataPacket.hk(8), dataPacket.hk(9), ...
            dataPacket.hk(10), dataPacket.hk(11), dataPacket.hk(12));
        end
    else
        for n = numSamplesToStore+1-assumedSamplingRate:numSamplesToStore
           fprintf(file, '%d %d %d %d %d %6.3f %10.3f %10.3f %10.3f %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f\n', ...
            c(1), c(2), c(3), c(4), c(5), c(6), ...
            magData(1,n), magData(2,n), magData(3,n), ...
            hkData(1), hkData(2), hkData(3), hkData(4), hkData(5), ...
            hkData(6), hkData(7), hkData(8), hkData(9), hkData(10), ...
            hkData(11), hkData(12));
        end
    end
end