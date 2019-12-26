% Author: Luke Hermann
% Sets up command page and functionality

function ngfmHardwareCmd()

    fig = figure('Name', 'ngfmVis', 'NumberTitle','off', ...
                'WindowState', 'fullscreen', 'Tag', 'fig', ...
                'KeyPressFcn', @keyPressCallback);
    
    % Create ErrorNum
    ErrorNum = uicontrol('Parent',fig, 'style','text', ...
        'String','Error: Please enter a valid number', ...
        'Units','normalized', 'tag','ErrorNum', ...
        'HorizontalAlignment','center', 'FontSize',16, ...
        'ForegroundColor',[1 0 0], 'Visible','off', ...
        'Position',[0.39 0.9 0.25 0.03]);
    
    % Create ChannelLabel
    ChannelLabel = uicontrol('Parent',fig, 'style','text', ...
        'String','Channel', 'Units','normalized', 'FontSize',16, ...
        'HorizontalAlignment','center', 'Position',[0.20 0.85 0.04 0.03]);

    % Create XLabel
    XLabel = uicontrol('Parent',fig, 'style','text', 'String','X', ...
        'Units','normalized', 'HorizontalAlignment','center', ...
        'FontSize',16, 'Position',[0.35 0.8 0.04 0.03]);

    % Create YLabel
    YLabel = uicontrol('Parent',fig, 'style','text', 'String','Y', ...
        'Units','normalized', 'HorizontalAlignment','center', ...
        'FontSize',16, 'Position',[0.5 0.8 0.04 0.03]);

    % Create ZLabel
    ZLabel = uicontrol('Parent',fig, 'style','text', 'String','Z', ...
        'Units','normalized', 'HorizontalAlignment','center', ...
        'FontSize',16, 'Position',[0.65 0.8 0.04 0.03]);
    
    % Create CheckBoxX
    CheckBoxX = uicontrol('Parent',fig, 'style','checkbox', ...
        'Units','normalized', 'tag','CheckBoxX', ...
        'Position',[0.363 0.85 0.01 0.03]);

    % Create CheckBoxY
    CheckBoxY = uicontrol('Parent',fig, 'style', 'checkbox', ...
        'Units','normalized', 'tag','CheckBoxY', ...
        'Position',[0.513 0.85 0.01 0.03]);

    % Create CheckBoxZ
    CheckBoxZ = uicontrol('Parent',fig, 'style','checkbox', ...
        'Units','normalized', 'tag','CheckBoxZ', ...
        'Position',[0.663 0.85 0.01 0.03]);

    % Create ButtonGroup
    ButtonGroup = uibuttongroup('Parent', fig, 'Units', 'normalized', ...
        'tag', 'Buttongroup', 'Position', [0.35 0.625 0.1 0.1]);

    % Create StaticButton
    StaticButton = uicontrol('Parent', ButtonGroup, ...
        'style', 'radiobutton', 'String', 'Static', ...
        'Units', 'normalized', 'tag', 'StaticButton', 'FontSize', 14, ...
        'Value', true, 'Position', [0.15 0.2 0.7 0.2]);
    
    % Create DynamicButton
    DynamicButton = uicontrol('Parent', ButtonGroup, ...
        'style', 'radiobutton', 'String', 'Dynamic', ...
        'Units', 'normalized', 'tag', 'DynamicButton', 'FontSize', 14, ...
        'Position', [0.15 0.6 0.7 0.2]);

    % Create FeedBackLabel
    FeedBackLabel = uicontrol('Parent', fig, 'style', 'text', ...
        'String', 'FeedBack', 'Units', 'normalized', 'FontSize', 16, ...
        'HorizontalAlignment', 'center', 'Position', [0.2 0.66 0.05 0.03]);

    % Create IncDecSpinnerLabel
    IncDecSpinnerLabel = uicontrol('Parent', fig, 'style', 'text', ...
        'String', 'Inc/Dec', 'Units', 'normalized', 'FontSize', 16, ...
        'HorizontalAlignment', 'center', 'Position', [0.5 0.65 0.04 0.03]);

    % Create IncDecSpinner
    IncDecSpinner = uicontrol('Parent', fig, 'style', 'edit', ...
        'Units', 'normalized', 'tag', 'FBEdit', 'FontSize', 14, ...
        'String', '0', 'Position', [0.55 0.65 0.07 0.03]);

    % Create SendFeedbackButton
    SendFeedbackButton = uicontrol('Parent', fig, 'style', 'pushbutton', ...
        'String', 'Send Feedback', 'CallBack', @SendFBIncDec, ...
        'Units', 'normalized', 'FontSize', 13, ...
        'Position', [0.775 0.64 0.07 0.04]);
    
    % Create FeedBackCalibrationLabel
    FeedBackCalibrationLabel = uicontrol('Parent', fig, 'style', 'text', ...
        'String', 'FeedBack Calibration', 'Units', 'normalized', ...
        'HorizontalAlignment', 'center', 'FontSize', 16, ...
        'Position', [0.2 0.55 0.1 0.03]);

    % Create SendFBCalibButton
    SendFBCalibButton = uicontrol('Parent', fig, 'style', 'pushbutton', ...
        'String', 'Send FB Calib', 'Units', 'normalized', ...
        'CallBack', @SendFBCalib, 'FontSize', 13, ...
        'Position', [0.775 0.55 0.07 0.04]);

    % Create DeadspaceLabel
    DeadspaceLabel = uicontrol('Parent', fig, 'style', 'text', ...
        'String', 'Deadspace', 'Units', 'normalized', 'FontSize', 16, ...
        'Position', [0.2 0.45 0.055 0.03]);

    % Create IncDecSpinner_2Label
    IncDecSpinner_2Label = uicontrol('Parent', fig, 'style', 'text', ...
        'String', 'Inc/Dec', 'Units', 'normalized', 'FontSize', 16, ...
        'HorizontalAlignment', 'center', 'Position', [0.4 0.46 0.04 0.02]);

    % Create IncDecSpinner_2
    IncDecSpinner_2 = uicontrol('Parent', fig, 'style', 'edit', ...
        'Units', 'normalized', 'tag', 'deadField', 'FontSize', 14, ...
        'String', '0', 'Position', [0.45 0.45 0.07 0.03]);

    % Create SendDeadspaceButton
    SendDeadspaceButton = uicontrol('Parent', fig, 'style', 'pushbutton', ...
        'String', 'Send Deadspace', 'CallBack', @SendDeadspace, ...
        'Units', 'normalized', 'FontSize', 13, 'Position', [0.775 0.44 0.07 0.04]);

    % Create OffsetLabel
    OffsetLabel = uicontrol('Parent', fig, 'style', 'text', ...
        'String', 'PSU Offset', 'Units', 'normalized', 'FontSize', 16, ...
        'Position', [0.2 0.36 0.05 0.02]);

    % Create IncDecSpinner_3Label
    IncDecSpinner_3Label = uicontrol('Parent', fig, 'style', 'text', ...
        'String', 'Inc/Dec', 'Units', 'normalized', 'FontSize', 16, ...
        'HorizontalAlignment', 'center', 'Position', [0.4 0.36 0.04 0.02]);

    % Create IncDecSpinner_3
    IncDecSpinner_3 = uicontrol('Parent', fig, 'style', 'edit', ...
        'Units', 'normalized', 'tag', 'offsetField', 'FontSize', 14, ...
        'String', '0', 'Position', [0.45 0.35 0.07 0.03]);

    % Create SendOffsetButton
    SendOffsetButton = uicontrol('Parent', fig, 'style', 'pushbutton', ...
        'String', 'Send Offset', 'CallBack', @SendOffset, ...
        'Units', 'normalized', 'FontSize', 13, ...
        'Position', [0.775 0.345 0.07 0.04]);

    % Create TableLoadLabel
    TableLoadLabel = uicontrol('Parent', fig, 'style', 'text', ...
        'String', 'Table Load', 'Units', 'normalized', 'FontSize', 16, ...
        'HorizontalAlignment', 'center', 'Position', [0.2 0.25 0.05 0.03]);

    % Create AddressLabel
    AddressLabel = uicontrol('Parent', fig, 'style', 'text', ...
        'String', 'Address', 'Units', 'normalized', 'FontSize', 14, ...
        'HorizontalAlignment', 'center', 'Position', [0.4 0.29 0.04 0.02]);

    % Create DataLabel
    DataLabel = uicontrol('Parent', fig, 'style', 'text', ...
        'String', 'Data', 'Units', 'normalized', 'tag', 'dataCmd', ...
        'FontSize', 14, 'HorizontalAlignment', 'center', ...
        'Position', [0.55 0.29 0.03 0.02]);

    % Create SendTableLoadButton
    SendTableLoadButton = uicontrol('Parent', fig, 'style', 'pushbutton', ...
        'String', 'Send Table Load', 'CallBack', @SendTbLoad, ...
        'Units', 'normalized', 'FontSize', 13, ...
        'Position', [0.775 0.24 0.07 0.04]);

    % Create TableFileLabel
    TableFileLabel = uicontrol('Parent', fig, 'style', 'text', ...
        'String', 'Table File', 'Units', 'normalized', 'FontSize', 16, ...
        'HorizontalAlignment', 'center', 'Position', [0.2 0.15 0.04 0.02]);

    % Create EditField_6
    EditField_6 = uicontrol('Parent', fig, 'style', 'edit', ...
        'Units', 'normalized', 'tag', 'browseField', 'FontSize', 14, ...
        'Position', [0.375 0.15 0.09 0.0275]);

    % Create BrowseFileButton
    BrowseFileButton = uicontrol('Parent', fig, 'style', 'pushbutton', ...
        'String', 'Browse File', 'CallBack', @BrowseFileBtn, ...
        'Units', 'normalized', 'FontSize', 13, ...
        'Position', [0.47 0.15 0.07 0.0275]);

    % Create SendTableFileButton
    SendTableFileButton = uicontrol('Parent', fig, 'style', 'pushbutton', ...
        'String', 'Send Table File', 'CallBack', @SendTbFile, ...
        'Units', 'normalized', 'FontSize', 13, ...
        'Position', [0.775 0.14 0.07 0.04]);

    % Create EditFieldAdress
    EditFieldAddress = uicontrol('Parent', fig, 'style', 'edit', ...
        'Units', 'normalized', 'tag', 'AddrField', 'FontSize', 14, ...
        'String', '0x0000', 'HorizontalAlignment', 'center', ...
        'Position', [0.385 0.25 0.07 0.03]);

    % Create EditFieldData
    EditFieldData = uicontrol('Parent', fig, 'style', 'edit', ...
        'Units', 'normalized', 'tag', 'dataField', 'FontSize', 14, ...
        'String', '0x0000', 'HorizontalAlignment', 'center', ...
        'Position', [0.53 0.25 0.07 0.03]);

    % Create ErrorChannelLabel
    ErrorChannelLabel = uicontrol('Parent', fig, 'style', 'text', ...
    'String', 'Error: Please Select a Channel', 'Units', 'normalized', ...
    'tag', 'ErrorChannel', 'ForegroundColor', [1 0 0], 'Visible', 'off', ...
    'FontSize', 16, 'HorizontalAlignment', 'center', ...
    'Position', [0.39 0.9 0.25 0.03]);

    % Create TBAddDataLabel
    TBAddDataLabel = uicontrol('Parent', fig, 'style', 'text', ...
        'String', 'Error: Incorrect address or data entry', ...
        'Units', 'normalized', 'tag', 'ErrorLoad', 'FontSize', 16, ...
        'ForegroundColor', [1 0 0], 'Visible', 'off', ...
        'HorizontalAlignment', 'center', 'Position', [0.35 0.31 0.3 0.03]);

    % Create loadTBFileLabel
    loadTBFileLabel = uicontrol('Parent', fig, 'style', 'text', ...
        'String', 'Error: File contains incorrect data or entry', ...
        'Units', 'normalized', 'tag', 'ErrorData', 'FontSize', 16, ...
        'ForegroundColor', [1 0 0], 'Visible', 'off', ...
        'Position', [0.35 0.19 0.3 0.03]);

    % Create loadTBFileLabelError
    loadTBFileLabelError = uicontrol('Parent', fig, 'style', 'text', ...
        'String', 'Error: Incorrect file or file path', ...
        'Units', 'normalized', 'tag', 'ErrorFile', 'FontSize', 16, ...
        'ForegroundColor', [1 0 0], 'Visible', 'off', ...
        'Position', [0.4 0.19 0.2 0.03]);
    
    % Create EnteraCommandLabel
    EnteraCommandLabel = uicontrol('Parent', fig, 'style', 'text', ...
        'String', 'Enter a Command', 'Units', 'normalized', ...
        'FontSize', 16, 'Position', [0.2 0.04 0.09 0.04]);
    
    % Create EditField_7
    EditField_7 = uicontrol('Parent', fig, 'style', 'edit', ...
        'Units', 'normalized', 'FontSize', 14, ...
        'Position', [0.325 0.05 0.1 0.03]);

    % Create SendCommandButton
    SendCommandButton = uicontrol('Parent', fig, 'style', 'pushbutton', ...
        'String', 'Send Command', 'Units', 'normalized', ...
        'CallBack', @sendCommandBtn, 'FontSize', 13, ...
        'Position', [0.775 0.04 0.07 0.04]);
end


    % Check what channel is selecetd and return the value
    function arrChannel = checkChannel(hObject, eventData)
        handles = guidata(hObject);
        arr = get(handles.tab3, 'Children');
        xCheck = arr(37).Value;
        yCheck = arr(36).Value;
        zCheck = arr(35).Value;
        arrChannel = {};
        if(xCheck == 1 && yCheck == 1 && zCheck == 1)
            arrChannel = ['A'];
        else
            if(xCheck ==1)
                arrChannel = [arrChannel, 'X'];
            end
            if(yCheck == 1)
                arrChannel = [arrChannel, 'Y'];
            end
            if(zCheck == 1)
                arrChannel = [arrChannel, 'Z'];
            end
        end
    end

    % Button pushed function: SendFeedbackButton
    function SendFBIncDec(hObject, eventData)
        handles = guidata(hObject);
        arrChannel = checkChannel(hObject, eventData);
        channelCount = length(arrChannel);
        arr = get(handles.tab3, 'Children');
        key = getappdata(handles.fig, 'key');
        
        if(channelCount == 0)
            arr(7).Visible = 'on';
            return
        end
        if(strcmp(arr(7).Visible, 'on'))
            arr(7).Visible = 'off';
        end
        
        [num, tf] = str2num(arr(29).String);
        if(tf == 0)
            arr(43).Visible = 'on';
            return
        else
            arr(43).Visible = 'off';
        end
        
        bgHandle = get(arr(34), 'Children');
        while(channelCount ~= 0)
           key = [key, arrChannel(1)];
            arrChannel(1) = [];
            
            % Get if channel is static or dynmaic
            if(bgHandle(2).Value == 1)
                key = [key, 'S'];
            else
                key = [key, 'D'];
            end

            % Check if channel is inc/dec and send command
            if(str2num(arr(29).String) == 0)
                key = [key, '0'];

            elseif(str2num(arr(29).String) > 0)
                 counter = str2num(arr(29).String);
                while(counter > 0)
                    key = [key, 'I'];
                    counter = counter - 1;
                end

            else
                counter = str2num(arr(29).String);
                while(counter < 0)
                    key = [key, 'D'];
                    counter = counter + 1;
                end
            end
            channelCount = channelCount - 1;
        end
        
        setappdata(handles.fig, 'key', key);

    end

    % Button pushed function: SendFBCalibButton
    function SendFBCalib(hObject, eventData)
        handles = guidata(hObject);
        arrChannel = checkChannel(hObject, eventData);
        channelCount = length(arrChannel);
        arr = get(handles.tab3, 'Children');
        key = getappdata(handles.fig, 'key');
        
        if(channelCount == 0)
            arr(7).Visible = 'on';
            return
        end
        if(strcmp(arr(7).Visible, 'on'))
            arr(7).Visible = 'off';
        end
        
        while(channelCount > 0)
            key = [key, arrChannel(1)];
            arrChannel(1) = [];
            channelCount = channelCount - 1;
            key = [key, 'C'];
        end
        setappdata(handles.fig, 'key', key);
    end

    % Button pushed function: SendDeadspaceButton
    function SendDeadspace(hObject, eventData)
        handles = guidata(hObject);
    
        arrChannel = checkChannel(hObject, eventData);
        channelCount = length(arrChannel);
        arr = get(handles.tab3, 'Children');
        key = getappdata(handles.fig, 'key');

        if(channelCount == 0)
            arr(7).Visible = 'on';
            return
        end
        
        if(strcmp(arr(7).Visible, 'on'))
            arr(7).Visible = 'off';
        end
        
        [num, tf] = str2num(arr(23).String);
        if(tf == 0)
            arr(43).Visible = 'on';
            return
        else
            arr(43).Visible = 'off';
        end
        
        while(channelCount ~= 0)
           key = [key, arrChannel(1)];
            arrChannel(1) = [];
        
            if(str2num(arr(23).String) == 0)
                key = [key, 'G'];

            elseif(str2num(arr(23).String) > 0)
                 counter = str2num(arr(23).String);
                while(counter > 0)
                    key = [key, 'G'];
                    counter = counter - 1;
                end

            else
                counter = str2num(arr(23).String);
                if(counter < 0)
                    counter = counter + 255;
                    while(counter > 0)
                        key = [key, 'G'];
                        counter = counter - 1;
                    end
                end
                
            end
            channelCount = channelCount - 1;
        end
        setappdata(handles.fig, 'key', key);
    end

    % Button pushed function: SendOffsetButton
    function SendOffset(hObject, eventData)
        handles = guidata(hObject);
    
        arrChannel = checkChannel(hObject, eventData);
        channelCount = length(arrChannel);
        arr = get(handles.tab3, 'Children');
        key = getappdata(handles.fig, 'key');
        
        if(channelCount == 0)
            arr(7).Visible = 'on';
            return
        end
        if(strcmp(arr(7).Visible, 'on'))
            arr(7).Visible = 'off';
        end
        
        [num, tf] = str2num(arr(19).String);
        if(tf == 0)
            arr(43).Visible = 'on';
            return
        else
            arr(43).Visible = 'off';
        end
        
        while(channelCount ~= 0)
           key = [key, arrChannel(1)];
            arrChannel(1) = [];
        
            if(str2num(arr(19).String) == 0)
                return;

            elseif(str2num(arr(19).String) > 0)
                 counter = str2num(arr(19).String);
                while(counter > 0)
                    key = [key, 'P'];
                    counter = counter - 1;
                end

            else
                counter = str2num(arr(19).String);
                if(counter < 0)
                    counter = counter + 255;
                    while(counter > 0)
                        key = [key, 'P'];
                        counter = counter - 1;
                    end
                end
                
            end
            channelCount = channelCount - 1;
        end
        
        setappdata(handles.fig, 'key', key);

    end

    % Button pushed function: SendTableLoadButton
    function SendTbLoad(hObject, eventData)
        handles = guidata(hObject);
        arrChannel = checkChannel(hObject, eventData);
        channelCount = length(arrChannel);
        arr = get(handles.tab3, 'Children');

        key = getappdata(handles.fig, 'key');
        
        if(channelCount == 0)
            arr(7).Visible = 'on';
            return
        end
        if(strcmp(arr(7).Visible, 'on'))
            arr(7).Visible = 'off';
        end
        
       
        
        % Not valid Hexa
        if(validAddress(hObject, eventData, arr(9).String) == 0)
            arr(6).Visible = 'on';
            
            return
        elseif(validAddress(hObject, eventData, arr(8).String) == 0)
            arr(6).Visible = 'on';
            return
        else
            arr(6).Visible = 'off';
        end
        
        
        while(channelCount > 0)
            channelCount = channelCount - 1;
            key = [key, arrChannel(1)];
            arrChannel(1) = [];
            key = [key, arr(9).String];
            key = [key, arr(8).String];
            
        end

        setappdata(handles.fig, 'key', key);

    end

    % Button pushed function: SendTableFileButton
    function SendTbFile(hObject, eventData)
        handles = guidata(hObject);
        arrChannel = checkChannel(hObject, eventData);
        channelCount = length(arrChannel);
        arr = get(handles.tab3, 'Children');
        key = getappdata(handles.fig, 'key');

        if(channelCount == 0)
            arr(7).Visible = 'on';
            return
        end
        if(strcmp(arr(7).Visible, 'on'))
            arr(7).Visible = 'off';
        end
        
        if(strcmp(arr(4).Value, 'on'))
            arr(4).Visible = 'off';
        end
        
        try
        % Open excel file
            excelData = readtable(arr(12).String);
        catch
            arr(4).Visible = 'on';
            return
        end
        
        
        while(channelCount ~= 0)
            excelCount = 1;
            key = [key, arrChannel(1)];
            while(excelCount <= height(excelData))
                if(validAddress(hObject, eventData, excelData.('Address')(excelCount, 1)) == 0)
                    arr(4).Visible = 'on';
                    return
                end
                if(validAddress(hObject, eventData, excelData.('Data')(excelCount, 1)) == 0)
                    arr(4).Visible = 'on';
                    return
                end
                
                key = [key, excelData.('Address')(excelCount,1)];
                key = [key, excelData.('Data')(excelCount, 1)];
                excelCount = excelCount + 1;

            end
            arrChannel(1) = [];
            channelCount = channelCount - 1;
           
        end
        
        setappdata(handles.fig, 'key', key);

    end

    % Button pushed function: BrowseFileButton
    function BrowseFileBtn(hObject, eventData)
        handles = guidata(hObject);
        arr = get(handles.tab3, 'Children');

        [FileName,FilePath ]= uigetfile('*.xlsx*');
        sourceFilePath = fullfile(FilePath, FileName);
        arr(12).String = sourceFilePath;
        
        if(strcmp(arr(4).Visible, 'on'))
            arr(4).Visible = 'off';
        end
    end

    % Button pushed function: SendCommandButton
    function sendCommandBtn(hObject, eventData)
        handles = guidata(hObject);
        arrChannel = checkChannel(hObject, eventData);
        channelCount = length(arrChannel);
        arr = get(handles.tab3, 'Children');
        key = getappdata(handles.fig, 'key');

        if(channelCount == 0)
            arr(7).Visible = 'on';
            return
        end
        if(strcmp(arr(7).Visible, 'on'))
            arr(7).Visible = 'off';
        end
        
        commands = num2cell(arr(2).String);
        
        while(channelCount ~= 0)
            key = [key, arrChannel(1)];
            arrChannel(1) = [];
            commandCounter = 1;
            while(commandCounter <= length(commands))
                key = [key, commands(commandCounter)];
                commandCounter = commandCounter + 1;
            end
            
            channelCount = channelCount - 1;
        end
        
        setappdata(handles.fig, 'key', key);
        
        
    end


    function tf = validAddress(hObject, eventData, str)
        handles = guidata(hObject);
        newstr = string(str);
        
        if(strncmpi(str, "0x", 2) == 0)
            return
        end
        str = newstr{1}(3:end);
        
        if(length(str) ~= 4)
            tf = 0;
            return
        end
        
        t = isstrprop(str, 'xdigit');

        if(nnz(~t) > 0)
            tf = 0;
        else
            tf = 1;
        end

    end
