% NGFMPLOTINIT Sets up the GUI
%   Sets up the entire GUI and contains all the callbacks except for the hardware
%   commands, which is in ngfmHardCmd(). Utilizes guidata() and the
%   internally maintained structure handles to manipulate elements.
%
%   Subfunctions: DropdownCallback QuitButtonCallback keyPressCallback
%                 AddPlotButtonCallback DeletePlotButtonCallback
%                 setupHKData setupMiscdata
%
%   See also guidata ngfmHardwareCmd ngfmVis
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
                                        'UserData', ones(1, length(plots)),...
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
   
    % Hardware Command Tab
    handles = ngfmHardwareCmd(handles);
    
    % store handles for use in callbacks
    guidata(fig, handles)
end

function DropdownCallback(hObject, ~)
% DROPDOWNCALLBACK dropdown menu callback
% Changes what the modular plot will show
%
% See also NGFMPLOTINIT
    handles = guidata(hObject);
    spectra = string(hObject.String(hObject.Value));
    handles = setupSpectraPlot(spectra, handles); % should I be calling this here?
    guidata(hObject,handles)
end

function QuitButtonCallback(hObject,~)
% QUITBUTTONCALLBACK Callback for when the quit button is pressed
% Sets a flag 'closereq' to 1 so the main program can catch it
% and quit the program gracefully
%
% See also NGFMPLOTINIT
    handles = guidata(hObject);
    setappdata(handles.fig, 'closereq', 1);
end

function keyPressCallback(hObject, event)
% KEYPRESSCALLBACK Callback for when a key is pressed on the figure
% If 'q', quit the program through the 'closeRequest' route
% If '`', flip debug flag and titles respective to that change
% Else, send that key back so it can be sent over serial
%
% See also NGFMPLOTINIT
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

function AddPlotButtonCallback(hObject, ~)
% ADDPLOTBUTTONCALLBACK Callback for when the add plot button is pressed
% Brings up a file browser and upon clicking 'OK' queues that script to be 
% added to the dropdown, permanently or not. Brings up a warning on 
% duplicate script names
%
% See also NGFMPLOTINIT
    [FileName,FilePath ]= uigetfile('*.m');
    if (FileName ~= 0 & FileName ~= "")
        handles = guidata(hObject);
        % check to make sure it's not a duplicate
        if(~ismember(FileName, handles.currentPlotMenu.String))
            pos = handles.fig.Position;
            width = 300;
            height = 200;
            left = (pos(3)/2) - (width/2) + pos(1);
            up = (pos(4)/2) + (height/2) + pos(2);
            popUpFig = figure('Name','Add a plot', ...
                          'NumberTitle', 'off', ...
                          'Resize', 'off', ...
                          'MenuBar', 'none',...
                          'WindowStyle', 'modal', ...
                          'Position', [left up width height]);
                      
            % display selected file
            uicontrol('Parent', popUpFig, ...
                           'Style', 'edit', ...
                           'String', FileName, ...
                           'Enable', 'inactive', ...
                           'Units', 'normalized', ...
                           'FontSize', 10, ...
                           'Position', [0.05 0.85 0.4 0.1]);

            permanenceToggle = uicontrol('Parent', popUpFig, ...
                           'Style', 'radiobutton', ...
                           'String', 'Add permanently', ...
                           'Units', 'normalized', ...
                           'FontSize', 12, ...
                           'Position', [0.05 0.70 0.4 0.08]);

            % ok button
            uicontrol('Parent', popUpFig, ...
                                 'String', 'Ok', ...
                                 'Units', 'normalized', ...
                                 'Callback', @okButtonCallback, ...
                                 'Position', [0.05 0.095 0.2 0.1]);

            % cancel button
            uicontrol('Parent', popUpFig, ...
                                     'String', 'Cancel', ...
                                     'Units', 'normalized', ...
                                     'Callback', @(~,~) delete(popUpFig), ...
                                     'Position', [.28 0.095 0.2 0.1]);
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
end

function DeletePlotButtonCallback(hObject, ~)
% DELETEPLOTBUTTONCALLBACK Callback for when the delete plot button is pressed
% Brings up a small GUI window displaying the plots currently in the
% dropdown. if 'Delete' is pressed on any of them it
% queues that plot to be deleted at the end of ngfmPlotUpdate().
%
% See also NGFMPLOTINIT NGFMPLOTUPDATE
    handles = guidata(hObject);
    pos = handles.fig.Position;
    width = 300;
    height = 200;
    left = (pos(3)/2) - (width/2) + pos(1);
    up = (pos(4)/2) + (height/2) + pos(2);
    popUpFig = figure('Name','Delete a plot', ...
                          'NumberTitle', 'off', ...
                          'Resize', 'off', ...
                          'MenuBar', 'none',...
                          'Position', [left up width height]);
    popUpFig.WindowStyle = 'modal';
                      
    plotsDropdown = uicontrol('Parent', popUpFig, ...
                'Style','popupmenu', ...
                'String', handles.currentPlotMenu.String, ...
                'Units', 'Normalized', ...
                'Position', [.05 0.85 0.45 0.05]);             
           
    % delete button
    uicontrol('Parent', popUpFig, ...
                         'String', 'Delete', ...
                         'Units', 'normalized', ...
                         'Callback', @DeleteButtonCallback, ...
                         'Position', [0.05 0.095 0.2 0.1]);

    % cancel button
    uicontrol('Parent', popUpFig, ...
                             'String', 'Cancel', ...
                             'Units', 'normalized', ...
                             'Callback', @(~,~) delete(popUpFig), ...
                             'Position', [.28 0.095 0.2 0.1]);
                         
    function DeleteButtonCallback(~, ~)
        answer = questdlg('Confirm delete?', 'Confirm deletion', ...
                         'Yes','No', 'No');
        if(strcmp(answer, 'Yes'))
            setappdata(handles.fig, 'deletePlots', ...
                string(plotsDropdown.String(plotsDropdown.Value)));
            delete(popUpFig);
        end
    end
end

function [plotHandles] = setupHKData(plotHandles, xtmp, ytmp)
% SETUPHKDATA Sets up the house keeping data graphs on the second tab
%
% See also NGFMPLOTINIT
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
% SETUPMISCDATA Initalizes the GUI elements for the bottom row of
% miscellaneous data
%
% See also NGFMPLOTINIT    
    names = {'Heartbeat', 'Src Hz', 'PID', 'PktLen', 'FS', 'PPS', 'Board ID', 'Sensor ID', ...
             'CRC', 'X Avg', 'X stddev', 'Y Avg', 'Y stddev', 'Z Avg' ...
             'Z stddev', 'X RMS', 'X Hz', 'Y RMS', 'Y Hz', 'Z RMS', 'Z Hz'};
         
    miscData = {'hbeat', 'sourceHz', 'pid', 'packetlength', 'fs', 'ppsoffset', 'boardid', ...
                'sensorid', 'crc', 'xavg', 'xstddev', 'yavg', 'ystddev', ...
                'zavg', 'zstddev', 'xamp', 'xfreq', 'yamp', 'yfreq', ...
                'zamp', 'zfreq'};
    
    left = 0.13; up = 0.035; width = 0.038;  height = 0.02;
    for i = 1:length(miscData)
        % name
        uicontrol('Parent', plotHandles.tab1, 'style','text', ...
                  'String',names{i}, 'FontWeight', 'bold', ...
                  'Units', 'Normalized', ...
                  'Position', [left up width height]);
        % value
        plotHandles.(miscData{i}) = uicontrol('Parent', plotHandles.tab1, ...
            'style','text','String','NaN', 'Units', 'Normalized', ...
            'Position', [left (up-0.025) width height]);
        
        left = left+width;
    end
end