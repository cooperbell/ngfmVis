function  retVal = logDebugData( file, dataPacket, hkData )

ngfmLoadConstants;

c = clock;



for n = 1:100
   fprintf(file, '%d %d %d %d %d %6.3f %7d %7d %7d %7d %7d %7d %7d %7d %7d %7d %7d %7d %7d %7d %7d %7d %7d %7d\n', ...
    c(1), c(2), c(3), c(4), c(5), c(6), ...
    dataPacket.xdac(n), dataPacket.ydac(n), dataPacket.zdac(n), dataPacket.xadc(n), dataPacket.yadc(n), dataPacket.zadc(n), ...
    dataPacket.hk(1), dataPacket.hk(2), dataPacket.hk(3), dataPacket.hk(4), dataPacket.hk(5), dataPacket.hk(6), dataPacket.hk(7), dataPacket.hk(8), dataPacket.hk(9), dataPacket.hk(10), dataPacket.hk(11), dataPacket.hk(12));
end



retVal = -1;

end