function [ P, f, ENBW] = welchPSDSpectrum( data, fs, nfft )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

j=0:1:nfft-1;
z=2*pi*j/nfft;

window = hann(nfft);
%window = kaiser(nfft,5);

ENBW = 1.5000*fs/nfft;
%ENBW = 2.2830*fs/nfft;

detrendedTimeSeries = detrend(data);

[P,f] = pwelch(detrendedTimeSeries,window,round(3*nfft/4),nfft,fs,'onesided');
end

