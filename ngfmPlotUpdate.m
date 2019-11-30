function [fig, closereq, key] = ngfmPlotUpdate(fig, dataPacket, magData, hkData, debugData)
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
    
    % update misc data
    handles = updateMiscData(handles,magData,dataPacket,hkData,debugData,numSamplesToStore,numSamplesToDisplay);
    
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
    
    % set up outputs
    fig = handles.fig;
    closereq = getappdata(handles.fig, 'closereq');
    key = getappdata(handles.fig, 'key');
end

function [plotHandles] = updateMiscData(plotHandles,magData,dataPacket,hkData,debugData,numSamplesToStore,numSamplesToDisplay)
    % update hk data
    set(plotHandles.xavg,'String',sprintf('%5.3f',mean(magData(1,numSamplesToStore-numSamplesToDisplay+1:numSamplesToStore))));
    set(plotHandles.yavg,'String',sprintf('%5.3f',mean(magData(2,numSamplesToStore-numSamplesToDisplay+1:numSamplesToStore))));
    set(plotHandles.zavg,'String',sprintf('%5.3f',mean(magData(3,numSamplesToStore-numSamplesToDisplay+1:numSamplesToStore))));

    set(plotHandles.xstddev,'String',sprintf('%5.3f',std(magData(1,numSamplesToStore-numSamplesToDisplay+1:numSamplesToStore))));
    set(plotHandles.ystddev,'String',sprintf('%5.3f',std(magData(2,numSamplesToStore-numSamplesToDisplay+1:numSamplesToStore))));
    set(plotHandles.zstddev,'String',sprintf('%5.3f',std(magData(3,numSamplesToStore-numSamplesToDisplay+1:numSamplesToStore))));


    if (debugData)
        set(plotHandles.pid,'String',sprintf('%02X',dataPacket.pid));
        set(plotHandles.packetlength,'String',sprintf('%04X',dataPacket.packetlength));
        set(plotHandles.fs,'String',sprintf('%04X',dataPacket.fs));
        set(plotHandles.ppsoffset,'String',sprintf('%08X',dataPacket.ppsoffset));
        set(plotHandles.hk0,'String',sprintf('%04X',dataPacket.hk(1)));
        set(plotHandles.hk1,'String',sprintf('%04X',dataPacket.hk(2)));
        set(plotHandles.hk2,'String',sprintf('%04X',dataPacket.hk(3)));
        set(plotHandles.hk3,'String',sprintf('%04X',dataPacket.hk(4)));
        set(plotHandles.hk4,'String',sprintf('%04X',dataPacket.hk(5)));
        set(plotHandles.hk5,'String',sprintf('%04X',dataPacket.hk(6)));
        set(plotHandles.hk6,'String',sprintf('%04X',dataPacket.hk(7)));
        set(plotHandles.hk7,'String',sprintf('%04X',dataPacket.hk(8)));
        set(plotHandles.hk8,'String',sprintf('%04X',dataPacket.hk(9)));
        set(plotHandles.hk9,'String',sprintf('%04X',dataPacket.hk(10)));
        set(plotHandles.hk10,'String',sprintf('%04X',dataPacket.hk(11)));
        set(plotHandles.hk11,'String',sprintf('%04X',dataPacket.hk(12)));
        set(plotHandles.boardid,'String',sprintf('%04X',dataPacket.boardid));
        set(plotHandles.sensorid,'String',sprintf('%04X',dataPacket.sensorid));
        set(plotHandles.crc,'String',sprintf('%04X',dataPacket.crc));
    else
        set(plotHandles.pid,'String',sprintf('%d',dataPacket.pid));
        set(plotHandles.packetlength,'String',sprintf('%d',dataPacket.packetlength));
        set(plotHandles.fs,'String',sprintf('%d',dataPacket.fs));
        set(plotHandles.ppsoffset,'String',sprintf('%d',dataPacket.ppsoffset));

        set(plotHandles.hk0,'String',sprintf('%4.2f',hkData(1)));
        set(plotHandles.hk1,'String',sprintf('%4.2f',hkData(2)));
        set(plotHandles.hk2,'String',sprintf('%4.2f',hkData(3)));
        set(plotHandles.hk3,'String',sprintf('%4.2f',hkData(4)));
        set(plotHandles.hk4,'String',sprintf('%4.2f',hkData(5)));
        set(plotHandles.hk5,'String',sprintf('%4.2f',hkData(6)));
        set(plotHandles.hk6,'String',sprintf('%4.2f',hkData(7)));
        set(plotHandles.hk7,'String',sprintf('%4.2f',hkData(8)));
        set(plotHandles.hk8,'String',sprintf('%2.2f',hkData(9)));
        set(plotHandles.hk9,'String',sprintf('%2.2f',hkData(10)));
        set(plotHandles.hk10,'String',sprintf('%2.2f',hkData(11)));
        set(plotHandles.hk11,'String',sprintf('%2.2f',hkData(12)));
        set(plotHandles.boardid,'String',sprintf('%d',dataPacket.boardid));
        set(plotHandles.sensorid,'String',sprintf('%d',dataPacket.sensorid));
        set(plotHandles.crc,'String',sprintf('%04X',dataPacket.crc));
    end
end

function [plotHandles] = deletePlots(plotHandles, plots)
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
    
    % reset deletePlots struct value
    plotHandles.deletePlots.plots = {};
end
 
function [plotHandles] = addPlot(plotHandles, file, permanenceFlag)
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