% Author: David Miles
% Modified by: Cooper Bell 11/27/2019
% Sets up GUI. Contains all callbacks
function [fig] = ngfmPlotInit(debugData)
    ngfmLoadConstants;
    
    % create figure
    % add 'CloseRequestFcn', @my_closereq when done with everything
    fig = figure('Name', 'ngfmVis', 'NumberTitle','off', ...
                'WindowState', 'fullscreen', 'Tag', 'fig', ...
                'KeyPressFcn', @keyPressCallback);
                            
    handles = guihandles(fig);
    
    % create tabs
    tabgp = uitabgroup(fig);
    handles.tab1 = uitab(tabgp,'Title','ngfmVis', 'Tag', 'tab1');
    handles.tab2 = uitab(tabgp,'Title','Housekeeping Data', 'Tag', 'tab2');
                            
    % create axes
    handles.ax = axes('Parent', handles.tab1, 'Position', [0.07 0.70 0.39 0.25], ...
                        'XLim', [0 10], 'XLimMode', 'manual');
                      
    handles.ay = axes('Parent', handles.tab1, 'Position', ...
                          [0.07 0.40 0.39 0.25], 'XLim', [0 10], ...
                          'XLimMode', 'manual');
                      
    handles.az = axes('Parent', handles.tab1, 'Position', ...
                          [0.07 0.10 0.39 0.25], 'XLim', [0 10], ...
                          'XLimMode', 'manual');
                      
    handles.aw = axes('Parent', handles.tab1, 'Position', ...
                          [0.55 0.10 0.39 0.85]);
                      
    
    % load in current scripts
    if(isfolder('spectraPlots'))
        filePattern = fullfile('spectraPlots', '*.m');
        allFiles = dir(filePattern);
        numScripts = size(allFiles);
        plots = {};
        for i = 1:numScripts(1)
            plots = [plots, allFiles(i).name];
        end
    else
        errorMessage = 'Unable to locate folder: \spectraPlots';
        warndlg(errorMessage);
    end
    
    % create dropdown
    handles.currentPlotMenu = uicontrol('Parent', handles.tab1, ...
                                        'Style','popupmenu', ...
                                        'String', plots, ...
                                        'Units', 'Normalized', ...
                                        'Position', [0.55 0.965 0.075 0.02], ...
                                        'Interruptible', 'off', ...
                                        'Tag', 'currentPlotMenu', ...
                                        'Callback', @DropdownCallback);
    
    % create add plot button
    handles.addPlotButton = uicontrol('Parent', handles.tab1, ...
                                     'style', 'pushbutton', ...
                                     'String', 'Add Plot', ...
                                     'Units', 'Normalized', ...
                                     'Position', [0.635 0.965 0.05 0.02], ...
                                     'Callback', @AddPlotButtonCallback);
                                     
     % create delete plot button
    handles.deletePlotButton = uicontrol('Parent', handles.tab1, ...
                                         'style', 'pushbutton', ...
                                         'String', 'Delete Plot', ...
                                         'Units', 'Normalized', ...
                                         'Position', [0.695 0.965 0.05 0.02], ...
                                         'Callback', @DeletePlotButtonCallback);
                                        
    % create program quit button
    handles.quitButton = uicontrol('Parent', handles.tab1, ...
                                       'style', 'pushbutton', ...
                                       'String', 'Quit Program', ...
                                       'Units', 'Normalized', ...
                                       'Callback', @QuitButtonCallback, ...
                                       'Position', [0.01 0.965 0.047 0.022]);
                                        
    % plot spectra first so it'll look normal
    spectra = string(handles.currentPlotMenu.String(handles.currentPlotMenu.Value));
    handles = setupSpectraPlot(spectra,handles);
    
    % create XYZ line handles
    ytmp = zeros(1,numSamplesToDisplay);
    handles.lnx = plot(handles.ax,x,ytmp);
    handles.lny = plot(handles.ay,x,ytmp);
    handles.lnz = plot(handles.az,x,ytmp);

    % add XYZ axes properties
    handles.ax.YLabel.String = 'Bx (nT)';
    handles.ay.YLabel.String = 'By (nT)';
    handles.az.YLabel.String = 'Bz (nT)';
    handles.az.XLabel.String = 'Time (s)';

    % add XYZ line properties
    handles.lnx.Color = 'red';
    handles.lny.Color = 'green';
    handles.lnz.Color = 'blue';
    handles.lnx.Tag = 'lnx';
    handles.lny.Tag = 'lny';
    handles.lnz.Tag = 'lnz';
                                 
    % Other Data Fields
    setappdata(fig, 'closereq', 0);
    setappdata(fig, 'key', []);
    setappdata(fig, 'addPlot', []);
    setappdata(fig, 'permanenceFlag', 0);
    setappdata(fig, 'deletePlots', {});
    handles = setupMiscdata(handles, debugData);
    
%     % hk stuff
%     pause(0.1);
%     xtmp = linspace(1,hkSecondsToDisplay,hkSecondsToDisplay);
%     ytmp = zeros(1,hkSecondsToDisplay);
%     handles = setupHKData(handles, xtmp, ytmp);
   
    % store handles for use in callbacks
    guidata(fig, handles)
end

% dropdown menu callback
% Changes what the modular plot will show
function DropdownCallback(hObject, ~)
    handles = guidata(hObject);
    spectra = string(hObject.String(hObject.Value));
    handles = setupSpectraPlot(spectra, handles); % should I be calling this here?
    guidata(hObject,handles)
end

% Callback for when the quit button is pressed
function QuitButtonCallback(hObject,~)
    handles = guidata(hObject);
    setappdata(handles.fig, 'closereq', 1);
end

% Callback for when a key is pressed on the figure
function keyPressCallback(hObject, event)
    handles = guidata(hObject);
    key = event.Character;
    if(key == 'q')
        setappdata(handles.fig, 'closereq', 1);
    else
        setappdata(handles.fig, 'key', key);
    end
end

% Add button callback
function AddPlotButtonCallback(hObject, ~)
    [FileName,FilePath ]= uigetfile('*.m');
    if (FileName ~= 0 & FileName ~= "")
        handles = guidata(hObject);
        % check to make sure it's not a duplicate
        if(~ismember(FileName, handles.currentPlotMenu.String))
            popUpFig = figure('Name','Add a plot', ...
                          'NumberTitle', 'off', ...
                          'Resize', 'off', ...
                          'MenuBar', 'none');
        
            uicontrol('Parent', popUpFig, ...
                           'Style', 'edit', ...
                           'String', FileName, ...
                           'Enable', 'inactive', ...
                           'Units', 'normalized', ...
                           'FontSize', 10, ...
                           'Position', [.02 0.88 0.22 0.052]);

            permanenceToggle = uicontrol('Parent', popUpFig, ...
                           'Style', 'radiobutton', ...
                           'String', 'Add permanently', ...
                           'Units', 'normalized', ...
                           'FontSize', 12, ...
                           'Position', [.02 0.72 0.3 0.06]);

            % ok button
            uicontrol('Parent', popUpFig, ...
                                 'String', 'Ok', ...
                                 'Units', 'normalized', ...
                                 'Callback', @okButtonCallback, ...
                                 'Position', [.85 0.05 0.12 0.05]);

            % cancel button
            uicontrol('Parent', popUpFig, ...
                                     'String', 'Cancel', ...
                                     'Units', 'normalized', ...
                                     'Callback', @cancelButtonCallback, ...
                                     'Position', [.7 0.05 0.12 0.05]);
        else
            warndlg('Cannot have duplicate script names', 'Warning', ...
                    'modal');
        end
    end
    
    function okButtonCallback(~, ~)
        setappdata(handles.fig, 'addPlot', fullfile(FilePath, FileName));
        setappdata(handles.fig, 'permanenceFlag', permanenceToggle.Value);
        delete(popUpFig);
    end

    function cancelButtonCallback(~, ~)
        delete(popUpFig);
    end
end

% Delete button callback
function DeletePlotButtonCallback(hObject, ~)
    handles = guidata(hObject);
    plotsToDeleteList = {};
    popUpFig = figure('Name','Manage Spectra Plots', ...
                      'NumberTitle', 'off', ...
                      'MenuBar', 'none');
    
    % dispaly all current plots with a delete button
    plots = handles.currentPlotMenu.String;
    bottom_align = 0.92;
    for idx = 1:length(plots)
        uicontrol('Parent', popUpFig, ...
                  'Style', 'Text', ...
                  'String', string(plots(idx)), ...
                  'Units', 'normalized', ...
                  'FontSize', 12, ...
                  'BackgroundColor','white',...
                  'HorizontalAlignment', 'left', ...
                  'Tag', string(plots(idx)), ...
                  'Position', [.05 bottom_align 0.4 0.05]);

        uicontrol('Parent', popUpFig, ...
                   'String', 'Delete',...
                   'Units', 'normalized', ...
                   'UserData', string(plots(idx)), ...
                   'Position', [.6 bottom_align 0.3 0.05], ...
                   'Callback', @deleteCallback);

        bottom_align = bottom_align - 0.1;
    end              
                  
    % ok button
    uicontrol('Parent', popUpFig, ...
                         'String', 'Ok', ...
                         'Units', 'normalized', ...
                         'Callback', @OkButtonCallback, ...
                         'Position', [.85 0.05 0.12 0.05]);

    % cancel button
    uicontrol('Parent', popUpFig, ...
                             'String', 'Cancel', ...
                             'Units', 'normalized', ...
                             'Callback', @CancelButtonCallback, ...
                             'Position', [.7 0.05 0.12 0.05]);
                         
    function deleteCallback(~, event)
        plotName = event.Source.UserData;
        answer = questdlg('Confirm delete?', 'Confirm deletion', ...
                         'No','Yes', 'No');
        if(strcmp(answer, 'Yes'))
            % add to delete queue
            plotsToDeleteList = [plotsToDeleteList, plotName];

            % overwrite plot name & delete button with confirmation text
            delete(event.Source);
            selectionLabel = findobj('Tag', string(plotName));
            selectionLabel.Position(3) = 1;
            selectionLabel.String = strcat('Deleted', {' '}, ...
                selectionLabel.String);
            selectionLabel.FontAngle = 'italic';
            selectionLabel.HorizontalAlignment = 'center';
        end
    end

    function OkButtonCallback(~, ~)
        if(~isempty(plotsToDeleteList))
            setappdata(handles.fig, 'deletePlots', plotsToDeleteList);
        end
        delete(popUpFig);
    end

    function CancelButtonCallback(~, ~)
        delete(popUpFig);
    end
end

function [plotHandles] = setupHKData(plotHandles, xtmp, ytmp)
    plotHandles.fig = figure('Name', 'Housekeeping Data', 'NumberTitle','off', ...
                'WindowState', 'fullscreen', 'Tag', 'hkFig');
            
    % column 1            
    plotHandles.hk0 = axes('Parent', plotHandles.fig, 'Position', [0.05 0.80 0.25 0.15], ...
                            'XLim', [0 60], 'XLimMode', 'manual');

    plotHandles.hk1 = axes('Parent', plotHandles.fig, 'Position', [0.05 0.55 0.25 0.15], ...
                            'XLim', [0 60], 'XLimMode', 'manual');

    plotHandles.hk2 = axes('Parent', plotHandles.fig, 'Position', [0.05 0.3 0.25 0.15], ...
                            'XLim', [0 60], 'XLimMode', 'manual');

    plotHandles.hk3 = axes('Parent', plotHandles.fig, 'Position', [0.05 0.05 0.25 0.15], ...
                            'XLim', [0 60], 'XLimMode', 'manual');


    % column 2                    
    plotHandles.hk4 = axes('Parent', plotHandles.fig, 'Position', [0.36 0.80 0.25 0.15], ...
                            'XLim', [0 60], 'XLimMode', 'manual');

    plotHandles.hk5 = axes('Parent', plotHandles.fig, 'Position', [0.36 0.55 0.25 0.15], ...
                            'XLim', [0 60], 'XLimMode', 'manual');

    plotHandles.hk6 = axes('Parent', plotHandles.fig, 'Position', [0.36 0.3 0.25 0.15], ...
                            'XLim', [0 60], 'XLimMode', 'manual');

    plotHandles.hk7 = axes('Parent', plotHandles.fig, 'Position', [0.36 0.05 0.25 0.15], ...
                            'XLim', [0 60], 'XLimMode', 'manual');


    % column 3                    
    plotHandles.hk8 = axes('Parent', plotHandles.fig, 'Position', [0.67 0.80 0.25 0.15], ...
                            'XLim', [0 60], 'XLimMode', 'manual');

    plotHandles.hk9 = axes('Parent', plotHandles.fig, 'Position', [0.67 0.55 0.25 0.15], ...
                            'XLim', [0 60], 'XLimMode', 'manual');

    plotHandles.hk10 = axes('Parent', plotHandles.fig, 'Position', [0.67 0.3 0.25 0.15], ...
                            'XLim', [0 60], 'XLimMode', 'manual');

    plotHandles.hk11 = axes('Parent', plotHandles.fig, 'Position', [0.67 0.05 0.25 0.15], ...
                            'XLim', [0 60], 'XLimMode', 'manual');
       
    % create line handles                    
    plotHandles.lnHK0 = plot(plotHandles.hk0, xtmp, ytmp);
    plotHandles.lnHK1 = plot(plotHandles.hk1, xtmp, ytmp);
    plotHandles.lnHK2 = plot(plotHandles.hk2, xtmp, ytmp);
    plotHandles.lnHK3 = plot(plotHandles.hk3, xtmp, ytmp);
    plotHandles.lnHK4 = plot(plotHandles.hk4, xtmp, ytmp);
    plotHandles.lnHK5 = plot(plotHandles.hk5, xtmp, ytmp);
    plotHandles.lnHK6 = plot(plotHandles.hk6, xtmp, ytmp);
    plotHandles.lnHK7 = plot(plotHandles.hk7, xtmp, ytmp);
    plotHandles.lnHK8 = plot(plotHandles.hk8, xtmp, ytmp);
    plotHandles.lnHK9 = plot(plotHandles.hk9, xtmp, ytmp);
    plotHandles.lnHK10 = plot(plotHandles.hk10, xtmp, ytmp);
    plotHandles.lnHK11 = plot(plotHandles.hk11, xtmp, ytmp);
    
    % axes properties
    plotHandles.hk0.Title.String = '+1V2';
    plotHandles.hk1.Title.String = 'TSens';
    plotHandles.hk2.Title.String = 'TRef';
    plotHandles.hk3.Title.String = 'TBrd';
    plotHandles.hk4.Title.String = 'V+';
    plotHandles.hk5.Title.String = 'VIn';
    plotHandles.hk6.Title.String = 'Ref/2';
    plotHandles.hk7.Title.String = 'IIn';
    plotHandles.hk8.Title.String = 'HK8';
    plotHandles.hk9.Title.String = 'HK9';
    plotHandles.hk10.Title.String = 'HK10';
    plotHandles.hk11.Title.String = 'HK11';

    plotHandles.hk0.XLabel.String = 'Seconds ago';
end

function [plotHandles] = setupMiscdata(plotHandles, debugData)
    uicontrol('Parent', plotHandles.tab1, 'style','text','String','PID', 'Position', [10 35 50 20]);
    plotHandles.pid = uicontrol('Parent', plotHandles.tab1, 'style','text','String','NaN','Position', [10 10 50 20]);
    
    uicontrol('Parent', plotHandles.tab1, 'style','text','String','PktLen','Position', [60 35 50 20]);
    plotHandles.packetlength = uicontrol('Parent', plotHandles.tab1, 'style','text','String','NaN','Position', [60 10 50 20]);
    
    uicontrol('Parent', plotHandles.tab1, 'style','text','String','FS','Position', [110 35 50 20]);
    plotHandles.fs = uicontrol('Parent', plotHandles.tab1, 'style','text','String','NaN','Position', [110 10 50 20]);
    
    uicontrol('Parent', plotHandles.tab1, 'style','text','String','PPS','Position', [160 35 50 20]);
    plotHandles.ppsoffset = uicontrol('Parent', plotHandles.tab1, 'style','text','String','NaN','Position', [160 10 50 20]);
    
    % housekeeping data labels
    mTextBoxHK0Label = uicontrol('Parent', plotHandles.tab1, 'style','text','Position', [210 35 50 20]);
    plotHandles.hk0 = uicontrol('Parent', plotHandles.tab1, 'style','text','String','NaN','Position', [210 10 50 20]);

    mTextBoxHK1Label = uicontrol('Parent', plotHandles.tab1, 'style','text','Position', [260 35 50 20]);
    plotHandles.hk1 = uicontrol('Parent', plotHandles.tab1, 'style','text','String','NaN','Position', [260 10 50 20]);
    
    % do the same as above ^^^ deleting the var
    mTextBoxHK2Label = uicontrol('Parent', plotHandles.tab1, 'style','text','Position', [310 35 50 20]);
    mTextBoxHK2 = uicontrol('Parent', plotHandles.tab1, 'style','text','String','NaN','Position', [310 10 50 20]);
    plotHandles.hk2 = mTextBoxHK2;
    
    mTextBoxHK3Label = uicontrol('Parent', plotHandles.tab1, 'style','text','Position', [360 35 50 20]);
    mTextBoxHK3 = uicontrol('Parent', plotHandles.tab1, 'style','text','String','NaN','Position', [360 10 50 20]);
    plotHandles.hk3 = mTextBoxHK3;
    
    mTextBoxHK4Label = uicontrol('Parent', plotHandles.tab1, 'style','text','Position', [410 35 50 20]);
    mTextBoxHK4 = uicontrol('Parent', plotHandles.tab1, 'style','text','String','NaN','Position', [410 10 50 20]);
    plotHandles.hk4 = mTextBoxHK4;
    
    mTextBoxHK5Label = uicontrol('Parent', plotHandles.tab1, 'style','text','Position', [460 35 50 20]);
    mTextBoxHK5 = uicontrol('Parent', plotHandles.tab1, 'style','text','String','NaN','Position', [460 10 50 20]);
    plotHandles.hk5 = mTextBoxHK5;
    
    mTextBoxHK6Label = uicontrol('Parent', plotHandles.tab1, 'style','text','Position', [510 35 50 20]);
    mTextBoxHK6 = uicontrol('Parent', plotHandles.tab1, 'style','text','String','NaN','Position', [510 10 50 20]);
    plotHandles.hk6 = mTextBoxHK6;
    
    mTextBoxHK7Label = uicontrol('Parent', plotHandles.tab1, 'style','text','Position', [560 35 50 20]);
    mTextBoxHK7 = uicontrol('Parent', plotHandles.tab1, 'style','text','String','NaN','Position', [560 10 50 20]);
    plotHandles.hk7 = mTextBoxHK7;
    
    uicontrol('Parent', plotHandles.tab1, 'style','text','String','HK8','Position', [610 35 50 20]);
    mTextBoxHK8 = uicontrol('Parent', plotHandles.tab1, 'style','text','String','NaN','Position', [610 10 50 20]);
    plotHandles.hk8 = mTextBoxHK8;
    
    uicontrol('Parent', plotHandles.tab1, 'style','text','String','HK9','Position', [660 35 50 20]);
    mTextBoxHK9 = uicontrol('Parent', plotHandles.tab1, 'style','text','String','NaN','Position', [660 10 50 20]);
    plotHandles.hk9 = mTextBoxHK9;
    
    uicontrol('Parent', plotHandles.tab1, 'style','text','String','HK10','Position', [710 35 50 20]);
    mTextBoxHK10 = uicontrol('Parent', plotHandles.tab1, 'style','text','String','NaN','Position', [710 10 50 20]);
    plotHandles.hk10 = mTextBoxHK10;
    
    uicontrol('Parent', plotHandles.tab1, 'style','text','String','HK11','Position', [760 35 50 20]);
    mTextBoxHK11 = uicontrol('Parent', plotHandles.tab1, 'style','text','String','NaN','Position', [760 10 50 20]);
    plotHandles.hk11 = mTextBoxHK11;
    
    if(debugData)
        set(mTextBoxHK0Label,'String','HK0');
        set(mTextBoxHK1Label,'String','HK1');
        set(mTextBoxHK2Label,'String','HK2');
        set(mTextBoxHK3Label,'String','HK3');
        set(mTextBoxHK4Label,'String','HK4');
        set(mTextBoxHK5Label,'String','HK5');
        set(mTextBoxHK6Label,'String','HK6');
        set(mTextBoxHK7Label,'String','HK7');
    else
        set(mTextBoxHK0Label,'String','+1V2');
        set(mTextBoxHK1Label,'String','TSens');
        set(mTextBoxHK2Label,'String','TRef');
        set(mTextBoxHK3Label,'String','TBrd');
        set(mTextBoxHK4Label,'String','V+');
        set(mTextBoxHK5Label,'String','VIn');
        set(mTextBoxHK6Label,'String','Ref/2');
        set(mTextBoxHK7Label,'String','IIn');
    end
    
    uicontrol('Parent', plotHandles.tab1, 'style','text','String','Board ID','Position', [810 35 50 20]);
    boardIDLabel = uicontrol('Parent', plotHandles.tab1, 'style','text','String','NaN','Position', [810 10 50 20]);
    plotHandles.boardid = boardIDLabel;
    
    uicontrol('Parent', plotHandles.tab1, 'style','text','String','Sensor ID','Position', [860 35 50 20]);
    sensorIDLabel = uicontrol('Parent', plotHandles.tab1, 'style','text','String','NaN','Position', [860 10 50 20]);
    plotHandles.sensorid = sensorIDLabel;
    
    uicontrol('Parent', plotHandles.tab1, 'style','text','String','CRC','Position', [910 35 50 20]);
    crcLabel = uicontrol('Parent', plotHandles.tab1, 'style','text','String','NaN','Position', [910 10 50 20]);
    plotHandles.crc = crcLabel;
    
    % Magnetic data test boxes.

    uicontrol('Parent', plotHandles.tab1, 'style','text','String','X Avg','Position', [960 35 50 20]);
    xavgLabel = uicontrol('Parent', plotHandles.tab1, 'style','text','String','NaN','Position', [960 10 50 20]);
    plotHandles.xavg = xavgLabel;
    
    uicontrol('Parent', plotHandles.tab1, 'style','text','String','X stddev','Position', [1010 35 50 20]);
    xstddevLabel = uicontrol('Parent', plotHandles.tab1, 'style','text','String','NaN','Position', [1010 10 50 20]);
    plotHandles.xstddev = xstddevLabel;
    
    uicontrol('Parent', plotHandles.tab1, 'style','text','String','Y Avg','Position', [1060 35 50 20]);
    yavgLabel = uicontrol('Parent', plotHandles.tab1, 'style','text','String','NaN','Position', [1060 10 50 20]);
    plotHandles.yavg = yavgLabel;
    
    uicontrol('Parent', plotHandles.tab1, 'style','text','String','Y stddev','Position', [1110 35 50 20]);
    ystddevLabel = uicontrol('Parent', plotHandles.tab1, 'style','text','String','NaN','Position', [1110 10 50 20]);
    plotHandles.ystddev = ystddevLabel;
    
    uicontrol('Parent', plotHandles.tab1, 'style','text','String','Z Avg','Position', [1160 35 50 20]);
    zavgLabel = uicontrol('Parent', plotHandles.tab1, 'style','text','String','NaN','Position', [1160 10 50 20]);
    plotHandles.zavg = zavgLabel;
    
    uicontrol('Parent', plotHandles.tab1, 'style','text','String','Z stddev','Position', [1210 35 50 20]);
    zstddevLabel = uicontrol('Parent', plotHandles.tab1, 'style','text','String','NaN','Position', [1210 10 50 20]);
    plotHandles.zstddev = zstddevLabel;
    
    % Amplitude Spectra Stuff

    uicontrol('Parent', plotHandles.tab1, 'style','text','String','X RMS','Position', [1260 35 50 20]);
    xampLabel = uicontrol('Parent', plotHandles.tab1, 'style','text','String','NaN','Position', [1260 10 50 20]);
    plotHandles.xamp = xampLabel;
    
    uicontrol('Parent', plotHandles.tab1, 'style','text','String','X Hz','Position', [1310 35 50 20]);
    xfreqLabel = uicontrol('Parent', plotHandles.tab1, 'style','text','String','NaN','Position', [1310 10 50 20]);
    plotHandles.xfreq = xfreqLabel;
    
    uicontrol('Parent', plotHandles.tab1, 'style','text','String','Y RMS','Position', [1360 35 50 20]);
    yampLabel = uicontrol('Parent', plotHandles.tab1, 'style','text','String','NaN','Position', [1360 10 50 20]);
    plotHandles.yamp = yampLabel;
    
    uicontrol('Parent', plotHandles.tab1, 'style','text','String','Y Hz','Position', [1410 35 50 20]);
    yfreqLabel = uicontrol('Parent', plotHandles.tab1, 'style','text','String','NaN','Position', [1410 10 50 20]);
    plotHandles.yfreq = yfreqLabel;
    
    uicontrol('Parent', plotHandles.tab1, 'style','text','String','Z RMS','Position', [1460 35 50 20]);
    zampLabel = uicontrol('Parent', plotHandles.tab1, 'style','text','String','NaN','Position', [1460 10 50 20]);
    plotHandles.zamp = zampLabel;
    
    uicontrol('Parent', plotHandles.tab1, 'style','text','String','Z Hz','Position', [1510 35 50 20]);
    zfreqLabel = uicontrol('Parent', plotHandles.tab1, 'style','text','String','NaN','Position', [1510 10 50 20]);
    plotHandles.zfreq = zfreqLabel;
end