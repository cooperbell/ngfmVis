function [FigHandle, magData, plotHandles] = ngfmPlotInit(plotHandles)
    %NGFMPLOTINIT Summary of this function goes here
    %   Detailed explanation goes here

    ngfmLoadConstants;

    plots1 = {'PlotAmplitude.m', 'PlotPSD.m'};
    spectra1 = string(plots1(1)); % NOTE: do I need this? Or can I use the current_plots_menu.Value?

    FigHandle = figure;
    set(FigHandle, 'Position', [10, 50, 1900, 900]);
    plotHandles.figure = FigHandle;
    
    % Plot selection drop down menu
    plotHandles.current_plot_menu = uicontrol('Style','popupmenu', ...
                                            'String', plots1, ...
                                            'Position', [1000 870 120 20], ...
                                            'Callback', @current_plot_callback);
    
    % Create BrowseButton
    plotHandles.browseButton = uicontrol('style', 'pushbutton', ...
                                        'String', 'Browse', ...
                                        'Position', [1480 865 100 22], ...
                                        'Callback', @pushedBrowseFile);
                                    
    setappdata(FigHandle, 'spectra', spectra1);
    setappdata(FigHandle, 'plots', plots1);
    
    % save GUI data
    guidata(plotHandles.figure,plotHandles); % do I need this anymore?

    %index = linspace(0,secondsToDisplay,numSamplesToDisplay);
    magData = zeros(3,numSamplesToStore);                       % I CHNAGED THIS FROM NaN TO zeros

    % plot XYZ and PSD/Amp graphs
%     ngfmPlotMagData;
    ngfmPlotSpectra;

    ngfmPlotXYZ;


    % display hk data for right now (future will be plotting)
    ngfmPlotHKData;
end

% callback function handles when a dropdown menu item is selected.
% Changes what the modular plot will show
function current_plot_callback(hObject,event)
    setappdata(hObject.Parent, 'spectra', hObject.String{hObject.Value})
end

% Callback function: Browse Button
function pushedBrowseFile(hObject, eventdata)
    
    [FileName,FilePath ]= uigetfile('*.m');
    sourceFilePath = fullfile(FilePath, FileName);
    if FileName ~= 0
        if FileName ~= ""
            % find a temp directory that has write access
            temp = tempdir;

            % add that temp directory to MATLAB's search path for this session
            addpath(temp);

            % copy the selected file to temp directory
            status = copyfile(FilePath, temp); % do something with status

            % update spectra
            setappdata(hObject.Parent, 'spectra', FileName)

            % add it plots array
            plots_temp = getappdata(hObject.Parent, 'plots');
            setappdata(hObject.Parent, 'plots', {FileName, plots_temp{1:end}});

            % update the dropdown menu
            handles = guidata(hObject);
            handles.current_plot_menu.String = getappdata(hObject.Parent, 'plots')
        else
            disp('error or no plot selected')
        end
    end 
end