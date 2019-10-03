function [FigHandle, magData, plotHandles] = ngfmPlotInit(plotHandles, spectra )
%NGFMPLOTINIT Summary of this function goes here
%   Detailed explanation goes here

ngfmLoadConstants;
global debugData;

FigHandle = figure;
set(FigHandle, 'Position', [10, 50, 1900, 900]);
plotHandles.figure = FigHandle;

index = linspace(0,secondsToDisplay,numSamplesToDisplay);
magData = zeros(3,numSamplesToStore);                       % I CHNAGED THIS FROM NaN TO zeros

% plot XYZ and PSD/Amp graphs
ngfmPlotMagData;

% display hk data for right now (future will be plotting)
ngfmPlotHKData;

end