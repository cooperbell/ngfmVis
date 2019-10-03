function  retVal = logData( file, magData, hkData )

ngfmLoadConstants;

c = clock;



for n = numSamplesToStore+1-assumedSamplingRate:numSamplesToStore
   fprintf(file, '%d %d %d %d %d %6.3f %10.3f %10.3f %10.3f %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f\n', ...
    c(1), c(2), c(3), c(4), c(5), c(6), ...
    magData(1,n), magData(2,n), magData(3,n), ...
    hkData(1), hkData(2), hkData(3), hkData(4), hkData(5), hkData(6), hkData(7), hkData(8), hkData(9), hkData(10), hkData(11), hkData(12));
end



retVal = -1;

end