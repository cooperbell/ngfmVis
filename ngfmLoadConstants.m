serialBufferLen = 10000;
assumedSamplingRate = 100;
secondsToDisplay = 10;
secondsToWelch = 60*60;
hkPacketsToDisplay = 100;
targetSamplingHz = 150;

nfft = 8*2048;

NumXTicks = 11;
NumYTicks = 5;

%XDACScale = 1.9460;
%XADCScale = -0.1273;
%XOffset = 0;

XDACScale = 1.94;
XADCScale = 0.0134/1.05;
XOffset = 0;

YDACScale = 1.9460;
YADCScale = -0.1273;
%YDACScale = 1;
%YADCScale = 0;

YOffset = 0;

ZDACScale = 1.9460;
ZADCScale = -0.1273;
ZOffset = 0;

HK0Scale = 1;
HK0Offset = 0;
HK1Scale = 1;
HK1Offset = 0;
HK2Scale = 1;
HK2Offset = 0;
HK3Scale = 1;
HK3Offset = 0;
HK4Scale = 1;
HK4Offset = 0;
HK5Scale = 1;
HK5Offset = 0;
HK6Scale = 1;
HK6Offset = 0;
HK7Scale = 1;
HK7Offset = 0;
HK8Scale = 1;
HK8Offset = 0;
HK9Scale = 1;
HK9Offset = 0;
HK10Scale = 1;
HK10Offset = 0;
HK11Scale = 1;
HK11Offset = 0;

% HK0Scale = (2.5/4096.0);
% HK0Offset = 0;
% HK1Scale = (2.5*1e6/(4096.0*5000.0));
% HK1Offset = -273.15;
% HK2Scale = 0.0313;
% HK2Offset = -20.51;
% HK3Scale = 0.0313;
% HK3Offset = -20.51;
% HK4Scale = (3.0*2.5/4096.0);
% HK4Offset = 0;
% HK5Scale = (3.0*2.5/4096.0);
% HK5Offset = 0;
% HK6Scale = 2.5/4096.0;
% HK6Offset = 0;
% HK7Scale = 0.107;
% HK7Offset = 0;
% HK8Scale = 1;
% HK8Offset = 0;
% HK9Scale = 1;
% HK9Offset = 0;
% HK10Scale = 1;
% HK10Offset = 0;
% HK11Scale = 1;
% HK11Offset = 0;

dle = hex2dec('10');
stx = hex2dec('02');
etx = hex2dec('03');

% Calculated values before here
numSamplesToDisplay = assumedSamplingRate*secondsToDisplay;
numSamplesToStore = assumedSamplingRate*secondsToWelch;
x = linspace(0,secondsToDisplay,numSamplesToDisplay);
hkX = linspace(0,hkPacketsToDisplay,hkPacketsToDisplay);