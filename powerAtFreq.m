function [ retVal ] = powerAtFreq( timeseries, Fs, NFFT, frequency, fuz )
%POWERATFREQ Summary of this function goes here
%   Detailed explanation goes here

%NFFT = 2048;

j=0:1:NFFT-1;
z=2*pi*j/NFFT;
hft248dwin=1 - 1.985844164102*cos(z) + 1.791176438506*cos(2*z) - 1.282075284005*cos(3*z) + 0.667777530266*cos(4*z) - 0.240160796576*cos(5*z) + 0.056656381764*cos(6*z) - 0.008134974479*cos(7*z) + 0.000624544650*cos(8*z) - 0.000019808998*cos(9*z) + 0.000000132974*cos(10*z);
%hannwin=hann(NFFT);
detrendedTimeSeries = detrend(timeseries);

[Pxx,f] = pwelch(detrendedTimeSeries,hft248dwin,3*NFFT/4,NFFT,Fs);

ENBW = 5.6512*Fs/NFFT;
%%ENBF = 1.500*Fs/NFFT;

Ax = sqrt(Pxx*ENBW);

index = round(((frequency*NFFT)/Fs)+1);
fuz_distance = round(fuz*NFFT/100);

[maxval, maxindex] = max(Ax(index-fuz_distance:index+fuz_distance));

maxindex = maxindex + index-fuz_distance - 1;

loglog(f,Ax);

vline((Fs*(index-fuz_distance-1))/NFFT,'g');
vline((Fs*(index+fuz_distance-1))/NFFT,'g');

vline((Fs*(maxindex-1))/NFFT,'r');

%vline(maxindex);
hline(maxval);

format long;

maxval

retVal = [Ax,f];
end