% NGFMPLOTUPDATE Updates the GUI elements.
%   By using the internally managed handles structure, the GUI elements are
%   updated by way of manipulating the data for a specific GUI element in
%   the handles structure. It does this for all the graphs, misc data,
%   dropdowns, and hardware commands. Once all the new data has been set,
%   guidata() is called again to save it to the handles struct to be used
%   later on and in callbacks.
%
%   Input arguments:
%       - fig: The GUI figure object
%       - dataPacket: Strcuture of the data packet
%       - magData: Array to update the X, Y, Z graphs
%       - hkData: Array of housekeeping data
%
%   Output arguments:
%       - fig: The GUI figure object
%       - closereq: Flag indicating if the program needs to close
%       - key: Character or cell array of hardware commands to send, if any
%       - debugData: Flag
%
%   Subfunctions: updateHKData updateMiscData deletePlots addPlot
%
% See also NGFMPLOTUPDATE>UPDATEHKDATA NGFMPLOTUPDATE>UPDATEMISCDATA 
% NGFMPLOTUPDATE>DELETEPLOTS NGFMPLOTUPDATE>ADDPLOT GUIDATA, PLOTAMPLITUDE, PLOTPSD
function [fig, closereq, key, debugData] = ngfmPlotUpdate(fig, dataPacket, magData, hkData)
    ngfmLoadConstants;
    handles = guidata(fig);
    
    % update XYZ graphs
    set(handles.lnx,'XData',x,'YData',magData(1,numSamplesToStore-numSamplesToDisplay+1:numSamplesToStore));
    set(handles.lny,'XData',x,'YData',magData(2,numSamplesToStore-numSamplesToDisplay+1:numSamplesToStore));
    set(handles.lnz,'XData',x,'YData',magData(3,numSamplesToStore-numSamplesToDisplay+1:numSamplesToStore));

    % update spectra
    spectra = handles.currentPlotMenu.String(handles.currentPlotMenu.Value);
    try
        % set current figure back to ngfmVis for if it's ever different
        set(0, 'currentfigure', handles.fig);
        run(string(spectra));
    catch exception
       % print thrown error to console
        warning(exception.identifier, 'Unable to load plot, %s', exception.message)
        
        % display error
        warndlg(sprintf('Unable to load plot, %s', exception.message), 'Warning', 'modal');
        
        % don't delete, just remove from dropdown
        plotsIdx = find(strcmp(handles.currentPlotMenu.String, spectra));
        handles.currentPlotMenu.String(plotsIdx) = [];
        
        
        handles.currentPlotMenu.Value = 1;
        spectra = string(handles.currentPlotMenu.String(handles.currentPlotMenu.Value));
        handles = setupSpectraPlot(spectra,handles);
    end
    
    % update hk data
    handles = updateHKData(handles, hkX, hkData, hkPacketsToDisplay);
    
    % update misc data
    handles = updateMiscData(handles, magData, dataPacket, ...
        getappdata(handles.fig,'debugData'), numSamplesToStore, ...
        numSamplesToDisplay);
    
    % save handles struct changes
    guidata(handles.fig, handles);
    
    % update figures and process callbacks
    drawnow;
    
    % check addPlot
    % can this just happen in the callback?
    if(~isempty(getappdata(handles.fig, 'addPlot')))
        handles = guidata(handles.fig);
        handles = addPlot(handles, ...
                          getappdata(handles.fig, 'addPlot'), ...
                          getappdata(handles.fig, 'permanenceFlag'));
                      
        % reset values
        setappdata(handles.fig, 'addPlot', []);
        setappdata(handles.fig, 'permanenceFlag', 0);
                      
        % save handles struct changes
        guidata(handles.fig, handles);
    end
    
    % check deletePlots
    if(~isempty(getappdata(handles.fig, 'deletePlots')))
        handles = guidata(handles.fig);
        handles = deletePlots(handles, ...
                              getappdata(handles.fig, 'deletePlots'));
                          
        % reset values
        setappdata(handles.fig, 'deletePlots', {});
        
        % save handles struct changes
        guidata(handles.fig, handles);
    end
    
    % set up outputs
    fig = handles.fig;
    closereq = getappdata(handles.fig, 'closereq');
    key = getappdata(handles.fig, 'key'); setappdata(handles.fig, 'key', []);
    debugData = getappdata(handles.fig, 'debugData');
end

function [plotHandles] = updateHKData(plotHandles, hkX, hkData, hkPacketsToDisplay)
% UPDATEHKDATA update the hk line handles
% Scale Y Axis bounds by 5% of it's max and min values for easier viewing
%
% See also NGFMPLOTUPDATE

    hkLines = getappdata(plotHandles.fig, 'hkLines');
    hkAxes = getappdata(plotHandles.fig, 'hkAxes');
    
    % update line handles' x and y arrays
    for i = 1:length(hkLines)
        set(plotHandles.(hkLines{i}),'XData',hkX,'YData', hkData(i,1:hkPacketsToDisplay));
    end
    
    % apply Y Axis label scaling
    for i = 1:length(hkAxes)
        [S, L] = bounds(hkData(i,:));
        if(L > S)
            plotHandles.(hkAxes{i}).YLim = [(S/1.05), (L*1.05)];
        end
    end
end

function [plotHandles] = updateMiscData(plotHandles,magData,dataPacket,debugData,numSamplesToStore,numSamplesToDisplay)
% UPDATEMISCDATA Update the values of the miscellaneous data
% Print some elements based on the debug data flag
%
% See also NGFMPLOTUPDATE

    plotHandles.xavg.String = sprintf('%5.3f',mean(magData(1,numSamplesToStore-numSamplesToDisplay+1:numSamplesToStore)));
    plotHandles.yavg.String = sprintf('%5.3f',mean(magData(2,numSamplesToStore-numSamplesToDisplay+1:numSamplesToStore)));
    plotHandles.zavg.String = sprintf('%5.3f',mean(magData(3,numSamplesToStore-numSamplesToDisplay+1:numSamplesToStore)));
    plotHandles.xstddev.String = sprintf('%5.3f',std(magData(1,numSamplesToStore-numSamplesToDisplay+1:numSamplesToStore)));
    plotHandles.ystddev.String = sprintf('%5.3f',std(magData(2,numSamplesToStore-numSamplesToDisplay+1:numSamplesToStore)));
    plotHandles.zstddev.String = sprintf('%5.3f',std(magData(3,numSamplesToStore-numSamplesToDisplay+1:numSamplesToStore)));

    if (debugData)
        plotHandles.pid.String = sprintf('%02X',dataPacket.pid);
        plotHandles.packetlength.String = sprintf('%04X',dataPacket.packetlength);
        plotHandles.fs.String = sprintf('%04X',dataPacket.fs);
        plotHandles.ppsoffset.String = sprintf('%08X',dataPacket.ppsoffset);
        plotHandles.boardid.String = sprintf('%04X',dataPacket.boardid);
        plotHandles.sensorid.String = sprintf('%04X',dataPacket.sensorid);
        plotHandles.crc.String = sprintf('%04X',dataPacket.crc);
    else
        plotHandles.pid.String = sprintf('%d',dataPacket.pid);
        plotHandles.packetlength.String = sprintf('%d',dataPacket.packetlength);
        plotHandles.fs.String = sprintf('%d',dataPacket.fs);
        plotHandles.ppsoffset.String = sprintf('%d',dataPacket.ppsoffset);
        plotHandles.boardid.String = sprintf('%d',dataPacket.boardid);
        plotHandles.sensorid.String = sprintf('%d',dataPacket.sensorid);
        plotHandles.crc.String = sprintf('%04X',dataPacket.crc);
    end
end

function [plotHandles] = deletePlots(plotHandles, plots)
% DELETEPLOTS Remove the plotting script file from the dropdown and 
% spectraPlots folder
%
% See also NGFMPLOTUPDATE

    for idx = 1:length(plots)
        plotFilePath = fullfile('spectraPlots', string(plots(idx)));
        delete(plotFilePath);

        % remove from dropdown
        plotsIdx = find(strcmp(plotHandles.currentPlotMenu.String, plots(idx)));
        plotHandles.currentPlotMenu.String(plotsIdx) = [];
    end
     
    plotHandles.currentPlotMenu.Value = 1;
    spectra = string(plotHandles.currentPlotMenu.String(plotHandles.currentPlotMenu.Value));
    plotHandles = setupSpectraPlot(spectra,plotHandles);
end
 
function [plotHandles] = addPlot(plotHandles, file, permanenceFlag)
% ADDPLOT Add plotting script to dropdown
% If permanenceFlag == false, add to temp dir to be used only this session
% Else, add to spectraPlots folder
%
% See also NGFMPLOTUPDATE

        % break up file into componenets to use
        [~,name,ext] = fileparts(file);
        FileName = strcat(name,ext);
        dir = 'spectraPlots';
        
        % put file in temp dir if user didn't click permanence
        if (~permanenceFlag)
            % find a temp directory that has write access
            dir = tempdir;

            % add that temp directory to MATLAB's search path for this session
            addpath(dir);
        end
        

        % copy the selected file to temp directory
        [status,msg] = copyfile(file, dir);
        if (~status)
            fprintf('Copy error: %s',msg);
        end

        % Add option to the dropdown, first in list
        plotHandles.currentPlotMenu.String = {FileName, ...
            plotHandles.currentPlotMenu.String{1:end}};
        
        % Have dropdown show it as the selected option
        plotHandles.currentPlotMenu.Value = 1;
        plotHandles = setupSpectraPlot(FileName,plotHandles);
end