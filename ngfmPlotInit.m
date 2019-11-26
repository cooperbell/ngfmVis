function [plotHandles] = ngfmPlotInit(debugData)
    ngfmLoadConstants;
    global menuCallbackInvoked;
    menuCallbackInvoked = 0;
    
    %create plotHandles struct
    plotHandles = struct('closereq', 0, 'key', []);
    
    % create figure
    % add 'CloseRequestFcn', @my_closereq when done with everything
    plotHandles.figure = figure('Name', 'ngfmVis', 'NumberTitle','off', ...
                                'WindowState', 'fullscreen', ...
                                'KeyPressFcn', @keyPressCallback);                       
                            
    % create axes
    plotHandles.ax = axes('Parent', plotHandles.figure, 'Position', ...
                          [0.07 0.70 0.39 0.25], 'XLim', [0 10], ...
                          'XLimMode', 'manual');
                      
    plotHandles.ay = axes('Parent', plotHandles.figure, 'Position', ...
                          [0.07 0.40 0.39 0.25], 'XLim', [0 10], ...
                          'XLimMode', 'manual');
                      
    plotHandles.az = axes('Parent', plotHandles.figure, 'Position', ...
                          [0.07 0.10 0.39 0.25], 'XLim', [0 10], ...
                          'XLimMode', 'manual');
                      
    plotHandles.aw = axes('Parent', plotHandles.figure, 'Position', ...
                          [0.55 0.10 0.39 0.85]);
                      
    % create dropdown
    plots = {'PlotPSD.m','PlotAmplitude.m'};
    plotHandles.currentPlotMenu = uicontrol('Parent', plotHandles.figure, ...
                                            'Style','popupmenu', ...
                                            'String', plots, ...
                                            'Position', [950 970 140 20], ...
                                            'Interruptible', 'off', ...
                                            'Tag', 'currentPlotMenu', ...
                                            'Callback', @dropdownCallback);
    
    % create browse button
    plotHandles.managePlotsButton = uicontrol('Parent', plotHandles.figure, ...
                                         'style', 'pushbutton', ...
                                         'String', 'Manage Plots', ...
                                         'Position', [1120 970 100 22], ...
                                         'Callback', @ManagePlotsButtonCallback);
    
    % create browse button's error text
    plotHandles.browseLoadError = uicontrol('Parent', plotHandles.figure, ...
                                            'style','text', ...
                                            'String','', ...
                                            'ForegroundColor', 'red', ...
                                            'FontSize', 12, 'Visible', 'off', ...
                                            'Position', [1220 969 133 22]);
                                        
    % create program quit button
    plotHandles.quitButton = uicontrol('Parent', plotHandles.figure, ...
                                       'style', 'pushbutton', ...
                                       'String', 'Quit Program', ...
                                       'Units', 'Normalized', ...
                                       'Callback', @quitButtonCallback, ...
                                       'Position', [0.01 0.965 0.047 0.022]);
                                        
    % plot spectra first so it'll look normal
    spectra = string(plotHandles.currentPlotMenu.String(plotHandles.currentPlotMenu.Value));
    plotHandles = setupSpectraPlot(spectra,plotHandles);
    
    % create XYZ line handles
    ytmp = zeros(1,numSamplesToDisplay);
    plotHandles.lnx = plot(plotHandles.ax,x,ytmp);
    plotHandles.lny = plot(plotHandles.ay,x,ytmp);
    plotHandles.lnz = plot(plotHandles.az,x,ytmp);

    % add XYZ axes properties
    plotHandles.ax.YLabel.String = 'Bx (nT)';
    plotHandles.ay.YLabel.String = 'By (nT)';
    plotHandles.az.YLabel.String = 'Bz (nT)';
    plotHandles.az.XLabel.String = 'Time (s)';

    % add XYZ line properties
    plotHandles.lnx.Color = 'red';
    plotHandles.lny.Color = 'green';
    plotHandles.lnz.Color = 'blue';
    plotHandles.lnx.Tag = 'lnx';
    plotHandles.lny.Tag = 'lny';
    plotHandles.lnz.Tag = 'lnz';
                                 
    % Other Data Fields
    plotHandles.closereq = 0;
    plotHandles = setupMiscdata(plotHandles, debugData);
    
    % store plotHandles for use in callbacks
    guidata(plotHandles.figure, plotHandles)
end

% dropdown menu callback
% Changes what the modular plot will show
function dropdownCallback(hObject, ~)
    global menuCallbackInvoked
    menuCallbackInvoked = 1;
    spectra = string(hObject.String(hObject.Value));
    plotHandles = guidata(hObject);
    plotHandles = setupSpectraPlot(spectra, plotHandles);
    guidata(hObject,plotHandles)
end

% Browse button callback
% Retrieves file, copies it to a temp directory,
% adds that to path, updates dropdown and graph
function browseFileCallback(hObject, ~)
    [FileName,FilePath ]= uigetfile('*.m');
    if (FileName ~= 0 & FileName ~= "")
        plotHandles = guidata(hObject);
        
        % find a temp directory that has write access
        temp = tempdir;

        % add that temp directory to MATLAB's search path for this session
        addpath(temp);

        % copy the selected file to temp directory
        [status,msg] = copyfile(FilePath, temp);
        if (~status)
            fprintf('Copy error: %s',msg);
        end
        
        % Add option to the dropdown, first in list
        plotHandles.currentPlotMenu.String = {FileName, ...
            plotHandles.currentPlotMenu.String{1:end}};
        
        % Have dropdown show it as the selected option
        plotHandles.currentPlotMenu.Value = 1;
        
        plotHandles = setupSpectraPlot(FileName,plotHandles);
        
        guidata(hObject,plotHandles)
    else
        disp('error or no plot selected');
    end
end

% Callback for when the quit button is pressed
function quitButtonCallback(hObject,~)
    global menuCallbackInvoked
    menuCallbackInvoked = 1;
    plotHandles = guidata(hObject);
    plotHandles.closereq = 1;
    guidata(hObject,plotHandles);
end

% Callback for when a key is pressed on the figure
function keyPressCallback(hObject, event)
    global menuCallbackInvoked
    menuCallbackInvoked = 1;
    plotHandles = guidata(hObject);
    key = event.Character;
    if(key == 'q')
        plotHandles.closereq = 1;
    else
        plotHandles.key = key;
    end
    guidata(hObject,plotHandles);
end

% Callback for when the manage plots button is pressed
% Creates a modal figure to delete and add plots
% Changes are enacted upon clicking OK
% No changes on Cancel
function ManagePlotsButtonCallback(hObject, event)
    plotHandles = guidata(hObject);
    plotHandles.plotsToDelete = {};
    
%     % modal
%     popUpFig = dialog('Name','Manage Spectra Plots');
    popUpFig = figure('Name','Manage Spectra Plots', ...
                      'NumberTitle', 'off', ...
                      'MenuBar', 'none');

     % left-hand area that holds plots from the dropdown
    currentPlotsList = uipanel('Parent', popUpFig, ...
                               'Title', 'Current Plots', ...
                               'FontSize', 18, ...
                               'BackgroundColor', 'white', ...
                               'Position', [.05 0.05 .45 .85]);

    uicontrol('Parent', popUpFig, ...
                         'String', 'Ok', ...
                         'Units', 'normalized', ...
                         'Callback', @okButtonCallback, ...
                         'Position', [.85 0.05 0.12 0.05]);

    uicontrol('Parent', popUpFig, ...
                             'String', 'Cancel', ...
                             'Units', 'normalized', ...
                             'Callback', @cancelButtonCallback, ...
                             'Position', [.7 0.05 0.12 0.05]);
     
    plots = plotHandles.currentPlotMenu.String;
    bottom_align = 0.92;
    for idx = 1:length(plots)
        uicontrol('Parent', currentPlotsList, ...
                  'Style', 'Text', ...
                  'String', string(plots(idx)), ...
                  'Units', 'normalized', ...
                  'FontSize', 12, ...
                  'BackgroundColor','white',...
                  'HorizontalAlignment', 'left', ...
                  'Tag', string(plots(idx)), ...
                  'Position', [.05 bottom_align 0.4 0.05]);

        uicontrol('Parent', currentPlotsList, ...
                   'String', 'Delete',...
                   'Units', 'normalized', ...
                   'UserData', string(plots(idx)), ...
                   'Position', [.6 bottom_align 0.3 0.05], ...
                   'Callback', @deleteCallback);

        bottom_align = bottom_align - 0.1;
    end
          
    % add plots to plotsToDelete's array
    % delete those GUI elements
    function deleteCallback(~, event)
        plotName = event.Source.UserData;
        answer = questdlg('Confirm delete?', 'Confirm deletion', ...
                         'No','Yes', 'No');
        if(strcmp(answer, 'Yes'))
            plotHandles.plotsToDelete = [plotHandles.plotsToDelete, plotName];
            delete(event.Source);
            selectionLabel = findobj('Tag', string(plotName));
            selectionLabel.Position(3) = 1;
            selectionLabel.String = strcat('Deleted', {' '}, selectionLabel.String);
            selectionLabel.FontAngle = 'italic';
            selectionLabel.HorizontalAlignment = 'center';
%             delete(findobj('Tag', string(plotName)));
            
            guidata(plotHandles.figure, plotHandles);
        end
    end
 
    % save changes, delete figure
    function okButtonCallback(~, ~)
        global menuCallbackInvoked
        menuCallbackInvoked = 1;
        plotHandles.okButton.Value = 1;
        delete(popUpFig);
        guidata(plotHandles.figure, plotHandles);
    end

    % don't save changes, just delete figure
    function cancelButtonCallback(~, ~)
         delete(popUpFig);
    end
         
 end

function [plotHandles] = setupMiscdata(plotHandles, debugData)
    uicontrol('style','text','String','PID', 'Position', [10 35 50 20]);
    plotHandles.pid = uicontrol('style','text','String','NaN','Position', [10 10 50 20]);
    
    uicontrol('style','text','String','PktLen','Position', [60 35 50 20]);
    plotHandles.packetlength = uicontrol('style','text','String','NaN','Position', [60 10 50 20]);
    
    uicontrol('style','text','String','FS','Position', [110 35 50 20]);
    plotHandles.fs = uicontrol('style','text','String','NaN','Position', [110 10 50 20]);
    
    uicontrol('style','text','String','PPS','Position', [160 35 50 20]);
    plotHandles.ppsoffset = uicontrol('style','text','String','NaN','Position', [160 10 50 20]);
    
    % housekeeping data labels
    mTextBoxHK0Label = uicontrol('style','text','Position', [210 35 50 20]);
    plotHandles.hk0 = uicontrol('style','text','String','NaN','Position', [210 10 50 20]);

    mTextBoxHK1Label = uicontrol('style','text','Position', [260 35 50 20]);
    plotHandles.hk1 = uicontrol('style','text','String','NaN','Position', [260 10 50 20]);
    
    % do the same as above ^^^ deleting the var
    mTextBoxHK2Label = uicontrol('style','text','Position', [310 35 50 20]);
    mTextBoxHK2 = uicontrol('style','text','String','NaN','Position', [310 10 50 20]);
    plotHandles.hk2 = mTextBoxHK2;
    
    mTextBoxHK3Label = uicontrol('style','text','Position', [360 35 50 20]);
    mTextBoxHK3 = uicontrol('style','text','String','NaN','Position', [360 10 50 20]);
    plotHandles.hk3 = mTextBoxHK3;
    
    mTextBoxHK4Label = uicontrol('style','text','Position', [410 35 50 20]);
    mTextBoxHK4 = uicontrol('style','text','String','NaN','Position', [410 10 50 20]);
    plotHandles.hk4 = mTextBoxHK4;
    
    mTextBoxHK5Label = uicontrol('style','text','Position', [460 35 50 20]);
    mTextBoxHK5 = uicontrol('style','text','String','NaN','Position', [460 10 50 20]);
    plotHandles.hk5 = mTextBoxHK5;
    
    mTextBoxHK6Label = uicontrol('style','text','Position', [510 35 50 20]);
    mTextBoxHK6 = uicontrol('style','text','String','NaN','Position', [510 10 50 20]);
    plotHandles.hk6 = mTextBoxHK6;
    
    mTextBoxHK7Label = uicontrol('style','text','Position', [560 35 50 20]);
    mTextBoxHK7 = uicontrol('style','text','String','NaN','Position', [560 10 50 20]);
    plotHandles.hk7 = mTextBoxHK7;
    
    uicontrol('style','text','String','HK8','Position', [610 35 50 20]);
    mTextBoxHK8 = uicontrol('style','text','String','NaN','Position', [610 10 50 20]);
    plotHandles.hk8 = mTextBoxHK8;
    
    uicontrol('style','text','String','HK9','Position', [660 35 50 20]);
    mTextBoxHK9 = uicontrol('style','text','String','NaN','Position', [660 10 50 20]);
    plotHandles.hk9 = mTextBoxHK9;
    
    uicontrol('style','text','String','HK10','Position', [710 35 50 20]);
    mTextBoxHK10 = uicontrol('style','text','String','NaN','Position', [710 10 50 20]);
    plotHandles.hk10 = mTextBoxHK10;
    
    uicontrol('style','text','String','HK11','Position', [760 35 50 20]);
    mTextBoxHK11 = uicontrol('style','text','String','NaN','Position', [760 10 50 20]);
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
    
    uicontrol('style','text','String','Board ID','Position', [810 35 50 20]);
    boardIDLabel = uicontrol('style','text','String','NaN','Position', [810 10 50 20]);
    plotHandles.boardid = boardIDLabel;
    
    uicontrol('style','text','String','Sensor ID','Position', [860 35 50 20]);
    sensorIDLabel = uicontrol('style','text','String','NaN','Position', [860 10 50 20]);
    plotHandles.sensorid = sensorIDLabel;
    
    uicontrol('style','text','String','CRC','Position', [910 35 50 20]);
    crcLabel = uicontrol('style','text','String','NaN','Position', [910 10 50 20]);
    plotHandles.crc = crcLabel;
    
    % Magnetic data test boxes.

    uicontrol('style','text','String','X Avg','Position', [960 35 50 20]);
    xavgLabel = uicontrol('style','text','String','NaN','Position', [960 10 50 20]);
    plotHandles.xavg = xavgLabel;
    
    uicontrol('style','text','String','X stddev','Position', [1010 35 50 20]);
    xstddevLabel = uicontrol('style','text','String','NaN','Position', [1010 10 50 20]);
    plotHandles.xstddev = xstddevLabel;
    
    uicontrol('style','text','String','Y Avg','Position', [1060 35 50 20]);
    yavgLabel = uicontrol('style','text','String','NaN','Position', [1060 10 50 20]);
    plotHandles.yavg = yavgLabel;
    
    uicontrol('style','text','String','Y stddev','Position', [1110 35 50 20]);
    ystddevLabel = uicontrol('style','text','String','NaN','Position', [1110 10 50 20]);
    plotHandles.ystddev = ystddevLabel;
    
    uicontrol('style','text','String','Z Avg','Position', [1160 35 50 20]);
    zavgLabel = uicontrol('style','text','String','NaN','Position', [1160 10 50 20]);
    plotHandles.zavg = zavgLabel;
    
    uicontrol('style','text','String','Z stddev','Position', [1210 35 50 20]);
    zstddevLabel = uicontrol('style','text','String','NaN','Position', [1210 10 50 20]);
    plotHandles.zstddev = zstddevLabel;
    
    % Amplitude Spectra Stuff

    uicontrol('style','text','String','X RMS','Position', [1260 35 50 20]);
    xampLabel = uicontrol('style','text','String','NaN','Position', [1260 10 50 20]);
    plotHandles.xamp = xampLabel;
    
    uicontrol('style','text','String','X Hz','Position', [1310 35 50 20]);
    xfreqLabel = uicontrol('style','text','String','NaN','Position', [1310 10 50 20]);
    plotHandles.xfreq = xfreqLabel;
    
    uicontrol('style','text','String','Y RMS','Position', [1360 35 50 20]);
    yampLabel = uicontrol('style','text','String','NaN','Position', [1360 10 50 20]);
    plotHandles.yamp = yampLabel;
    
    uicontrol('style','text','String','Y Hz','Position', [1410 35 50 20]);
    yfreqLabel = uicontrol('style','text','String','NaN','Position', [1410 10 50 20]);
    plotHandles.yfreq = yfreqLabel;
    
    uicontrol('style','text','String','Z RMS','Position', [1460 35 50 20]);
    zampLabel = uicontrol('style','text','String','NaN','Position', [1460 10 50 20]);
    plotHandles.zamp = zampLabel;
    
    uicontrol('style','text','String','Z Hz','Position', [1510 35 50 20]);
    zfreqLabel = uicontrol('style','text','String','NaN','Position', [1510 10 50 20]);
    plotHandles.zfreq = zfreqLabel;
end