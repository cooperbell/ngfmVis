% Author: David Miles
% Modified by: Cooper Bell 11/27/2019
% Sets up GUI. Contains all callbacks
function [fig] = ngfmPlotInit()
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
    handles.tab3 = uitab(tabgp,'Title','Hardware Commands', 'Tag', 'tab3');

                            
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
                                 
    % app data
    setappdata(fig, 'closereq', 0);
    setappdata(fig, 'key', []);
    setappdata(fig, 'addPlot', []);
    setappdata(fig, 'permanenceFlag', 0);
    setappdata(fig, 'deletePlots', {});
    setappdata(fig, 'debugData', 0);
    setappdata(fig, 'hkAxes', {'hk0', 'hk1', 'hk2', 'hk3', 'hk4', ...
                               'hk5', 'hk6', 'hk7', 'hk8', 'hk9', ...
                               'hk10', 'hk11'});
                           
    setappdata(fig, 'hkTitles', {'+1V2', 'TSens', 'TRef', 'TBrd', ...
                                 'V+', 'VIn', 'Ref/2', 'IIn', 'HK8', ...
                                 'HK9', 'HK10', 'HK11'});
                             
    setappdata(fig, 'hkLines', {'lnHK0', 'lnHK1', 'lnHK2', 'lnHK3', 'lnHK4', ...
                               'lnHK5', 'lnHK6', 'lnHK7', 'lnHK8', 'lnHK9', ...
                               'lnHK10', 'lnHK11'});
    
    % Other Data Fields
    handles = setupMiscdata(handles);
    
    % Housekeeping data graphs
    ytmp = zeros(1,hkPacketsToDisplay);
    handles = setupHKData(handles, hkX, ytmp);
   
    %Hardware Command
    ngfmHardwareCmd(fig, handles);
    
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
% Sets a flag 'closereq' to 1 so the main program can catch it
% and quit the program gracefully
function QuitButtonCallback(hObject,~)
    handles = guidata(hObject);
    setappdata(handles.fig, 'closereq', 1);
end

% Callback for when a key is pressed on the figure
% If 'q', quit the program through the 'closereq' route
% If '`', flip debug flag and titles respective to that change
% Else, send that key back so it can be sent over serial
function keyPressCallback(hObject, event)
    handles = guidata(hObject);
    key = event.Character;
    if(key == 'q')
        setappdata(handles.fig, 'closereq', 1);
    elseif(key == '`')
        hkAxes = getappdata(handles.fig, 'hkAxes');
        hkTitles = getappdata(handles.fig, 'hkTitles');
        
        % flip debug data flag
        debugData = ~getappdata(handles.fig, 'debugData');
        setappdata(handles.fig, 'debugData', debugData);
        
        % reset titles
        if(debugData)
            for i = 1:8
                handles.(hkAxes{i}).Title.String = upper(hkAxes{i});
            end
        else
            for i = 1:8
                handles.(hkAxes{i}).Title.String = hkTitles{i};
            end
        end
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

    hkAxes = getappdata(plotHandles.fig, 'hkAxes');
    hkTitles = getappdata(plotHandles.fig, 'hkTitles');
    hkLines = getappdata(plotHandles.fig, 'hkLines');
    
    % column 1            
    plotHandles.hk0 = axes('Parent', plotHandles.tab2, 'Position', [0.05 0.80 0.25 0.15], ...
                            'XLim', [0 60], 'XLimMode', 'manual');

    plotHandles.hk1 = axes('Parent', plotHandles.tab2, 'Position', [0.05 0.55 0.25 0.15], ...
                            'XLim', [0 60], 'XLimMode', 'manual');

    plotHandles.hk2 = axes('Parent', plotHandles.tab2, 'Position', [0.05 0.3 0.25 0.15], ...
                            'XLim', [0 60], 'XLimMode', 'manual');

    plotHandles.hk3 = axes('Parent', plotHandles.tab2, 'Position', [0.05 0.05 0.25 0.15], ...
                            'XLim', [0 60], 'XLimMode', 'manual');


    % column 2                    
    plotHandles.hk4 = axes('Parent', plotHandles.tab2, 'Position', [0.36 0.80 0.25 0.15], ...
                            'XLim', [0 60], 'XLimMode', 'manual');

    plotHandles.hk5 = axes('Parent', plotHandles.tab2, 'Position', [0.36 0.55 0.25 0.15], ...
                            'XLim', [0 60], 'XLimMode', 'manual');

    plotHandles.hk6 = axes('Parent', plotHandles.tab2, 'Position', [0.36 0.3 0.25 0.15], ...
                            'XLim', [0 60], 'XLimMode', 'manual');

    plotHandles.hk7 = axes('Parent', plotHandles.tab2, 'Position', [0.36 0.05 0.25 0.15], ...
                            'XLim', [0 60], 'XLimMode', 'manual');


    % column 3                    
    plotHandles.hk8 = axes('Parent', plotHandles.tab2, 'Position', [0.67 0.80 0.25 0.15], ...
                            'XLim', [0 60], 'XLimMode', 'manual');

    plotHandles.hk9 = axes('Parent', plotHandles.tab2, 'Position', [0.67 0.55 0.25 0.15], ...
                            'XLim', [0 60], 'XLimMode', 'manual');

    plotHandles.hk10 = axes('Parent', plotHandles.tab2, 'Position', [0.67 0.3 0.25 0.15], ...
                            'XLim', [0 60], 'XLimMode', 'manual');

    plotHandles.hk11 = axes('Parent', plotHandles.tab2, 'Position', [0.67 0.05 0.25 0.15], ...
                            'XLim', [0 60], 'XLimMode', 'manual');
       
    % create line handles             
    for i = 1:length(hkLines)
         plotHandles.(hkLines{i}) = plot(plotHandles.(hkAxes{i}), xtmp, ytmp);
    end
    
    % axes properties
    for i = 1:length(hkAxes)
        plotHandles.(hkAxes{i}).Title.String = hkTitles{i};
        plotHandles.(hkAxes{i}).XLabel.String = 'Packets ago';
    end
end

function [plotHandles] = setupMiscdata(plotHandles)
    names = {'PID', 'PktLen', 'FS', 'PPS', 'Board ID', 'Sensor ID', ...
             'CRC', 'X Avg', 'X stddev', 'Y Avg', 'Y stddev', 'Z Avg' ...
             'Z stddev', 'X RMS', 'X Hz', 'Y RMS', 'Y Hz', 'Z RMS', 'Z Hz'};
         
    miscData = {'pid', 'packetlength', 'fs', 'ppsoffset', 'boardid', ...
                'sensorid', 'crc', 'xavg', 'xstddev', 'yavg', 'ystddev', ...
                'zavg', 'zstddev', 'xamp', 'xfreq', 'yamp', 'yfreq', ...
                'zamp', 'zfreq',};
    
    leftJustify = 340;
    for i = 1:19
        uicontrol('Parent', plotHandles.tab1, 'style','text', ...
                  'String',names{i}, 'FontWeight', 'bold', ...
                  'Position', [leftJustify 35 50 20]);
        plotHandles.(miscData{i}) = uicontrol('Parent', plotHandles.tab1, ...
            'style','text','String','NaN','Position', [leftJustify 10 50 20]);
        leftJustify = leftJustify+50;
    end
end