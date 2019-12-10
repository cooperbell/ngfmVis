% Author: Luke Hermann
% Sets up command page and functionality

function ngfmSimpleCmd(hObject, plotHandles)
    
    % Create ErrorNum
    ErrorNum = uicontrol('Parent', plotHandles.tab3, 'style', 'text', 'String', 'Error: Please enter a valid number', 'Units', 'normalized', 'tag', 'ErrorNum');
    ErrorNum.HorizontalAlignment = 'center';
    ErrorNum.FontSize = 16;
    ErrorNum.ForegroundColor = [1 0 0];
    ErrorNum.Visible = 'off';
    ErrorNum.Position = [0.39 0.9 0.25 0.03];
    
    % Create ChannelLabel
    ChannelLabel = uicontrol('Parent', plotHandles.tab3, 'style', 'text', 'String', 'Channel', 'Units', 'normalized');
    ChannelLabel.HorizontalAlignment = 'center';
    ChannelLabel.FontSize = 16;
    ChannelLabel.Position = [0.20 0.85 0.04 0.03];

    % Create SimpleCommandsPageLabel
    SimpleCommandsPageLabel = uicontrol('Parent', plotHandles.tab3, 'style', 'text', 'String', 'Hardware Commands Page', 'Units', 'normalized');
    SimpleCommandsPageLabel.FontSize = 24;
    SimpleCommandsPageLabel.FontWeight = 'bold';
    SimpleCommandsPageLabel.Position = [0.415 0.95 0.2 0.04];

    % Create XLabel
    XLabel = uicontrol('Parent', plotHandles.tab3, 'style', 'text', 'String', 'X', 'Units', 'normalized');
    XLabel.HorizontalAlignment = 'center';
    XLabel.FontSize = 16;
    XLabel.Position = [0.35 0.8 0.04 0.03];

    % Create YLabel
    YLabel = uicontrol('Parent', plotHandles.tab3, 'style', 'text', 'String', 'Y', 'Units', 'normalized');
    YLabel.HorizontalAlignment = 'center';
    YLabel.FontSize = 16;
    YLabel.Position = [0.5 0.8 0.04 0.03];

    % Create ZLabel
    ZLabel = uicontrol('Parent', plotHandles.tab3, 'style', 'text', 'String', 'Z', 'Units', 'normalized');
    ZLabel.HorizontalAlignment = 'center';
    ZLabel.FontSize = 16;
    ZLabel.Position = [0.65 0.8 0.04 0.03];
    
    % Create CheckBoxX
    CheckBoxX = uicontrol('Parent', plotHandles.tab3, 'style', 'checkbox', 'Units', 'normalized', 'tag', 'CheckBoxX');
    CheckBoxX.Position = [0.363 0.85 0.01 0.03];

    % Create CheckBoxY
    CheckBoxY = uicontrol('Parent', plotHandles.tab3, 'style', 'checkbox', 'Units', 'normalized', 'tag', 'CheckBoxY');
    CheckBoxY.Position = [0.513 0.85 0.01 0.03];

    % Create CheckBoxZ
    CheckBoxZ = uicontrol('Parent', plotHandles.tab3, 'style', 'checkbox', 'Units', 'normalized', 'tag', 'CheckBoxZ');
    CheckBoxZ.Position = [0.663 0.85 0.01 0.03];

    % Create ButtonGroup
    ButtonGroup = uibuttongroup('Parent', plotHandles.tab3, 'Units', 'normalized', 'tag', 'Buttongr');
    ButtonGroup.Position = [0.35 0.625 0.1 0.1];
    
    % Create ErrorNum
    ErrorNum2 = uicontrol('Parent', plotHandles.tab3, 'style', 'text', 'String', 'Error: Please enter a valid number', 'Units', 'normalized');
    ErrorNum2.HorizontalAlignment = 'center';
    ErrorNum2.FontSize = 16;
    ErrorNum2.ForegroundColor = [1 0 0];
    ErrorNum2.Visible = 'off';
    ErrorNum2.Position = [0.39 0.9 0.25 0.03];
    
    % Create ErrorNum
    ErrorNum3 = uicontrol('Parent', plotHandles.tab3, 'style', 'text', 'String', 'Error: Please enter a valid number', 'Units', 'normalized');
    ErrorNum3.HorizontalAlignment = 'center';
    ErrorNum3.FontSize = 16;
    ErrorNum3.ForegroundColor = [1 0 0];
    ErrorNum3.Visible = 'off';
    ErrorNum3.Position = [0.39 0.9 0.25 0.03];

    % Create StaticButton
    StaticButton = uicontrol('Parent', ButtonGroup, 'style', 'radiobutton', 'String', 'Static', 'Units', 'normalized', 'tag', 'StaticButton');
    StaticButton.Position = [0.15 0.2 0.7 0.2];
    StaticButton.FontSize = 14;
    StaticButton.Value = true;
    
    % Create DynamicButton
    DynamicButton = uicontrol('Parent', ButtonGroup, 'style', 'radiobutton', 'String', 'Dynamic', 'Units', 'normalized', 'tag', 'DynamicButton');
    DynamicButton.FontSize = 14;
    DynamicButton.Position = [0.15 0.6 0.7 0.2];

    % Create FeedBackLabel
    FeedBackLabel = uicontrol('Parent', plotHandles.tab3, 'style', 'text', 'String', 'FeedBack', 'Units', 'normalized');
    FeedBackLabel.HorizontalAlignment = 'center';
    FeedBackLabel.FontSize = 16;
    FeedBackLabel.Position = [0.2 0.66 0.05 0.03];

    % Create IncDecSpinnerLabel
    IncDecSpinnerLabel = uicontrol('Parent', plotHandles.tab3, 'style', 'text', 'String', 'Inc/Dec', 'Units', 'normalized');
    IncDecSpinnerLabel.HorizontalAlignment = 'center';
    IncDecSpinnerLabel.FontSize = 16;
    IncDecSpinnerLabel.Position = [0.5 0.65 0.04 0.03];

    % Create IncDecSpinner
    IncDecSpinner = uicontrol('Parent', plotHandles.tab3, 'style', 'edit', 'Units', 'normalized', 'tag', 'FBEdit');
    IncDecSpinner.Position = [0.55 0.65 0.07 0.03];
    IncDecSpinner.FontSize = 14;
    IncDecSpinner.String = '0';

    % Create SendFeedbackButton
    SendFeedbackButton = uicontrol('Parent', plotHandles.tab3, 'style', 'pushbutton', 'String', 'Send Feedback', 'CallBack', @SendFBIncDec, 'Units', 'normalized');
    SendFeedbackButton.FontSize = 13;
    SendFeedbackButton.Position = [0.775 0.64 0.07 0.04];
    
    % Create FeedBackCalibrationLabel
    FeedBackCalibrationLabel = uicontrol('Parent', plotHandles.tab3, 'style', 'text', 'String', 'FeedBack Calibration', 'Units', 'normalized');
    FeedBackCalibrationLabel.HorizontalAlignment = 'center';
    FeedBackCalibrationLabel.FontSize = 16;
    FeedBackCalibrationLabel.Position = [0.2 0.55 0.1 0.03];

    % Create SendFBCalibButton
    SendFBCalibButton = uicontrol('Parent', plotHandles.tab3, 'style', 'pushbutton', 'String', 'Send FB Calib', 'Units', 'normalized', 'CallBack', @SendFBCalib);
    SendFBCalibButton.FontSize = 13;
    SendFBCalibButton.Position = [0.775 0.55 0.07 0.04];

    % Create DeadspaceLabel
    DeadspaceLabel = uicontrol('Parent', plotHandles.tab3, 'style', 'text', 'String', 'Deadspace', 'Units', 'normalized');
    DeadspaceLabel.FontSize = 16;
    DeadspaceLabel.Position = [0.2 0.45 0.055 0.03];

    % Create IncDecSpinner_2Label
    IncDecSpinner_2Label = uicontrol('Parent', plotHandles.tab3, 'style', 'text', 'String', 'Inc/Dec', 'Units', 'normalized');
    IncDecSpinner_2Label.HorizontalAlignment = 'center';
    IncDecSpinner_2Label.FontSize = 16;
    IncDecSpinner_2Label.Position = [0.4 0.46 0.04 0.02];

    % Create IncDecSpinner_2
    IncDecSpinner_2 = uicontrol('Parent', plotHandles.tab3, 'style', 'edit', 'Units', 'normalized', 'tag', 'deadField');
    IncDecSpinner_2.Position = [0.45 0.45 0.07 0.03];
    IncDecSpinner_2.FontSize = 14;
    IncDecSpinner_2.String = '0';

    % Create SendDeadspaceButton
    SendDeadspaceButton = uicontrol('Parent', plotHandles.tab3, 'style', 'pushbutton', 'String', 'Send Deadspace', 'CallBack', @SendDeadspace, 'Units', 'normalized');
    SendDeadspaceButton.FontSize = 13;
    SendDeadspaceButton.Position = [0.775 0.44 0.07 0.04];

    % Create OffsetLabel
    OffsetLabel = uicontrol('Parent', plotHandles.tab3, 'style', 'text', 'String', 'PSU Offset', 'Units', 'normalized');
    OffsetLabel.FontSize = 16;
    OffsetLabel.Position = [0.2 0.36 0.05 0.02];

    % Create IncDecSpinner_3Label
    IncDecSpinner_3Label = uicontrol('Parent', plotHandles.tab3, 'style', 'text', 'String', 'Inc/Dec', 'Units', 'normalized');
    IncDecSpinner_3Label.FontSize = 16;
    IncDecSpinner_3Label.HorizontalAlignment = 'center';
    IncDecSpinner_3Label.Position = [0.4 0.36 0.04 0.02];

    % Create IncDecSpinner_3
    IncDecSpinner_3 = uicontrol('Parent', plotHandles.tab3, 'style', 'edit', 'Units', 'normalized', 'tag', 'offsetField', 'tag', 'offsetField', 'FontSize', 14);
    IncDecSpinner_3.Position = [0.45 0.35 0.07 0.03];
    IncDecSpinner_3.String = '0';

    % Create SendOffsetButton
    SendOffsetButton = uicontrol('Parent', plotHandles.tab3, 'style', 'pushbutton', 'String', 'Send Offset', 'CallBack', @SendOffset, 'Units', 'normalized');
    SendOffsetButton.FontSize = 13;
    SendOffsetButton.Position = [0.775 0.345 0.07 0.04];

    % Create TableLoadLabel
    TableLoadLabel = uicontrol('Parent', plotHandles.tab3, 'style', 'text', 'String', 'Table Load', 'Units', 'normalized');
    TableLoadLabel.FontSize = 16;
    TableLoadLabel.HorizontalAlignment = 'center';
    TableLoadLabel.Position = [0.2 0.25 0.05 0.03];

    % Create AddressLabel
    AddressLabel = uicontrol('Parent', plotHandles.tab3, 'style', 'text', 'String', 'Address', 'Units', 'normalized');
    AddressLabel.FontSize = 14;
    AddressLabel.HorizontalAlignment = 'center';
    AddressLabel.Position = [0.4 0.29 0.04 0.02];

    % Create DataLabel
    DataLabel = uicontrol('Parent', plotHandles.tab3, 'style', 'text', 'String', 'Data', 'Units', 'normalized', 'tag', 'dataCmd');
    DataLabel.HorizontalAlignment = 'center';
    DataLabel.FontSize = 14;
    DataLabel.Position = [0.55 0.29 0.03 0.02];


    % Create SendTableLoadButton
    SendTableLoadButton = uicontrol('Parent', plotHandles.tab3, 'style', 'pushbutton', 'String', 'Send Table Load', 'CallBack', @SendTbLoad, 'Units', 'normalized');
    SendTableLoadButton.FontSize = 13;
    SendTableLoadButton.Position = [0.775 0.24 0.07 0.04];


    % Create TableFileLabel
    TableFileLabel = uicontrol('Parent', plotHandles.tab3, 'style', 'text', 'String', 'Table File', 'Units', 'normalized');
    TableFileLabel.HorizontalAlignment = 'center';
    TableFileLabel.FontSize = 16;
    TableFileLabel.Position = [0.2 0.15 0.04 0.02];

    % Create EditField_6
    EditField_6 = uicontrol('Parent', plotHandles.tab3, 'style', 'edit', 'Units', 'normalized', 'tag', 'browseField');
    EditField_6.FontSize = 14;
    EditField_6.Position = [0.375 0.15 0.09 0.0275];

    % Create BrowseFileButton
    BrowseFileButton = uicontrol('Parent', plotHandles.tab3, 'style', 'pushbutton', 'String', 'Browse File', 'CallBack', @BrowseFileBtn, 'Units', 'normalized');
    BrowseFileButton.FontSize = 13;
    BrowseFileButton.Position = [0.47 0.15 0.07 0.0275];

    % Create SendTableFileButton
    SendTableFileButton = uicontrol('Parent', plotHandles.tab3, 'style', 'pushbutton', 'String', 'Send Table File', 'CallBack', @SendTbFile, 'Units', 'normalized');
    SendTableFileButton.FontSize = 13;
    SendTableFileButton.Position = [0.775 0.14 0.07 0.04];

    % Create EditFieldAdress
    EditFieldAddress = uicontrol('Parent', plotHandles.tab3, 'style', 'edit', 'Units', 'normalized', 'tag', 'AddrField');
    EditFieldAddress.HorizontalAlignment = 'center';
    EditFieldAddress.Position = [0.385 0.25 0.07 0.03];
    EditFieldAddress.FontSize = 14;
    EditFieldAddress.String = '0x0000';

    % Create EditFieldData
    EditFieldData = uicontrol('Parent', plotHandles.tab3, 'style', 'edit', 'Units', 'normalized', 'tag', 'dataField');
    EditFieldData.HorizontalAlignment = 'center';
    EditFieldData.Position = [0.53 0.25 0.07 0.03];
    EditFieldData.FontSize = 14;
    EditFieldData.String = '0x0000';

    % Create ErrorChannelLabel
    ErrorChannelLabel = uicontrol('Parent', plotHandles.tab3, 'style', 'text', 'String', 'Error: Please Select a Channel', 'Units', 'normalized', 'tag', 'ErrorChannel');
    ErrorChannelLabel.HorizontalAlignment = 'center';
    ErrorChannelLabel.FontSize = 16;
    ErrorChannelLabel.ForegroundColor = [1 0 0];
    ErrorChannelLabel.Visible = 'off';
    ErrorChannelLabel.Position = [0.39 0.9 0.25 0.03];

    % Create TBAddDataLabel
    TBAddDataLabel = uicontrol('Parent', plotHandles.tab3, 'style', 'text', 'String', 'Error: Incorrect address or data entry', 'Units', 'normalized', 'tag', 'ErrorLoad');
    TBAddDataLabel.HorizontalAlignment = 'center';
    TBAddDataLabel.FontSize = 16;
    TBAddDataLabel.ForegroundColor = [1 0 0];
    TBAddDataLabel.Visible = 'off';
    TBAddDataLabel.Position = [0.35 0.31 0.3 0.03];

    % Create loadTBFileLabel
    loadTBFileLabel = uicontrol('Parent', plotHandles.tab3, 'style', 'text', 'String', 'Error: File contains incorrect data or entry', 'Units', 'normalized', 'tag', 'ErrorData');
    loadTBFileLabel.FontSize = 16;
    loadTBFileLabel.ForegroundColor = [1 0 0];
    loadTBFileLabel.Visible = 'off';
    loadTBFileLabel.Position = [0.35 0.19 0.3 0.03];

    % Create loadTBFileLabelError
    loadTBFileLabelError = uicontrol('Parent', plotHandles.tab3, 'style', 'text', 'String', 'Error: Incorrect file or file path', 'Units', 'normalized', 'tag', 'ErrorFile');
    loadTBFileLabelError.FontSize = 16;
    loadTBFileLabelError.ForegroundColor = [1 0 0];
    loadTBFileLabelError.Visible = 'off';
    loadTBFileLabelError.Position = [0.4 0.19 0.2 0.03];
    
    % Create EnteraCommandLabel
    EnteraCommandLabel = uicontrol('Parent', plotHandles.tab3, 'style', 'text', 'String', 'Enter a Command', 'Units', 'normalized');
    EnteraCommandLabel.FontSize = 16;
    EnteraCommandLabel.Position = [0.2 0.04 0.09 0.04];
    
    % Create EditField_7
    EditField_7 = uicontrol('Parent', plotHandles.tab3, 'style', 'edit', 'Units', 'normalized');
    EditField_7.Position = [0.325 0.05 0.1 0.03];
    EditField_7.FontSize = 14;

    % Create SendCommandButton
    SendCommandButton = uicontrol('Parent', plotHandles.tab3, 'style', 'pushbutton', 'String', 'Send Command', 'Units', 'normalized', 'CallBack', @sendCommandBtn);
    SendCommandButton.FontSize = 13;
    SendCommandButton.Position = [0.775 0.04 0.07 0.04];
        
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
