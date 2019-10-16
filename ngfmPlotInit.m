function [FigHandle, magData, plotHandles] = ngfmPlotInit(plotHandles, plots)
    %NGFMPLOTINIT Summary of this function goes here
    %   Detailed explanation goes here

    ngfmLoadConstants;
    global debugData;

    FigHandle = figure;
    set(FigHandle, 'Position', [10, 50, 1900, 900]);
    plotHandles.figure = FigHandle;
    
    % Plot selection drop down menu
    current_plot_menu = uicontrol('Style','popupmenu','String', plots, 'Position', [1000 870 120 20], 'Callback', @current_plot_callback);
    
    % TODO: Put a button here that seraches for file, callback fucntion
    % with call uigetfile and then copy that file into directory. We need
    % to delete that file on program exit probably

    index = linspace(0,secondsToDisplay,numSamplesToDisplay);
    magData = zeros(3,numSamplesToStore);                       % I CHNAGED THIS FROM NaN TO zeros

    % plot XYZ and PSD/Amp graphs
    ngfmPlotMagData;

    % display hk data for right now (future will be plotting)
    ngfmPlotHKData;
end

% callback function handles when a dropdown menu item is selected.
% Changes what the modular plot will show
function current_plot_callback(src,event)
        global spectra
        spectra = src.String{src.Value};
end

% idea for later when I import in scripts from other places
% function add_plot(src, event)
%     % src.value should have the path
%     % read that m file, write into our m file
%     % add to plots array, increment next_index
% end