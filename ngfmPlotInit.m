function [figHandle, magData, plotHandles] = ngfmPlotInit(plotHandles, plots)
    %NGFMPLOTINIT Summary of this function goes here
    %   Detailed explanation goes here

    ngfmLoadConstants;
    global debugData;

    S.fig = figure;
    set(S.fig, 'Position', [10, 50, 1900, 900]);
    plotHandles.figure = S.fig;
    figHandle = S.fig;
    
    % Plot selection drop down menu
    S.current_plot_menu = uicontrol('Style','popupmenu', ...
                                            'String', plots, ...
                                            'Position', [1000 870 120 20], ...
                                            'Callback', @current_plot_callback);
    
    % Create BrowseButton
    S.browseButton = uicontrol('style', 'pushbutton', ...
                                        'String', 'Browse', ...
                                        'Position', [1480 865 100 22], ...
                                        'Callback', @pushedBrowseFile);
                                    
    S.x_plot = subplot('position', [0.11 0.70 0.39 0.25]);
                                    
    guidata(S.fig,S);

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

% Callback function: Browse Button
function pushedBrowseFile(hObject, eventdata)
    global spectra
    global plots
    global next_index
    
    [FileName,FilePath ]= uigetfile('*.m');
    sourceFilePath = fullfile(FilePath, FileName);
    
    if FileName ~= ""
        % find a temp directory that has write access
        temp = tempdir;

        % add that temp directory to MATLAB's search path for this session
        addpath(temp);

        % copy the selected file to temp directory
        status = copyfile(FilePath, temp);
        
        % update spectra
        spectra = FileName;

        % add it plots array 
        plots = {FileName, plots{1:end}};
        next_index = next_index + 1;
        
        % update the dropdown menu
        handles = guidata(hObject);
        handles.current_plot_menu.String = plots;
    else
        disp('error or no plot selected')
    end
end