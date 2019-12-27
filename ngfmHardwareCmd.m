% Author: Luke Hermann
% Sets up command page and functionality
function plotHandles = ngfmHardwareCmd(plotHandles)
    % ----- Channels -------------------------------------------
    
    % Create ChannelLabel
    uicontrol('Parent', plotHandles.tab3, 'style', 'text', ...
        'String', 'Channel', 'Units', 'normalized', 'FontSize', 16, ...
        'HorizontalAlignment', 'center', 'Position', [0.20 0.85 0.04 0.03]);

    % Create XLabel
    uicontrol('Parent', plotHandles.tab3, 'style', 'text', 'String', 'X', ...
        'Units', 'normalized', 'HorizontalAlignment', 'center', ...
        'FontSize', 16, 'Tag', 'XLabel', 'Position', [0.35 0.8 0.04 0.03]);

    % Create YLabel
    uicontrol('Parent', plotHandles.tab3, 'style', 'text', 'String', 'Y', ...
        'Units', 'normalized', 'HorizontalAlignment', 'center', ...
        'FontSize', 16, 'Position', [0.5 0.8 0.04 0.03]);

    % Create ZLabel
    uicontrol('Parent', plotHandles.tab3, 'style', 'text', 'String', 'Z', ...
        'Units', 'normalized', 'HorizontalAlignment', 'center', ...
        'FontSize', 16, 'Position', [0.65 0.8 0.04 0.03]);
    
    % Create CheckBoxX
    plotHandles.CheckBoxX = uicontrol('Parent', plotHandles.tab3, 'style', 'checkbox', ...
        'Units', 'normalized', 'tag', 'CheckBoxX', ...
        'Position', [0.363 0.85 0.01 0.03]);

    % Create CheckBoxY
    plotHandles.CheckBoxY = uicontrol('Parent', plotHandles.tab3, 'style', 'checkbox', ...
        'Units', 'normalized', 'tag', 'CheckBoxY', ...
        'Position', [0.513 0.85 0.01 0.03]);

    % Create CheckBoxZ
    plotHandles.CheckBoxZ = uicontrol('Parent',plotHandles.tab3, 'style','checkbox', ...
        'Units', 'normalized', 'tag', 'CheckBoxZ', ...
        'Position', [0.663 0.85 0.01 0.03]);
    
    
    % ----- Send Feeback -------------------------------------------

    % Create ButtonGroup
    plotHandles.ButtonGroup = uibuttongroup('Parent', plotHandles.tab3, 'Units', 'normalized', ...
        'tag', 'Buttongroup', 'Position', [0.35 0.625 0.1 0.1]);

    % Create StaticButton
    plotHandles.StaticButton = uicontrol('Parent', plotHandles.ButtonGroup, ...
        'style', 'radiobutton', 'String', 'Static', ...
        'Units', 'normalized', 'tag', 'StaticButton', 'FontSize', 14, ...
        'Value', true, 'UserData', 'S', 'Position', [0.15 0.2 0.7 0.2]);
    
    % Create DynamicButton
    plotHandles.DynamicButton = uicontrol('Parent', plotHandles.ButtonGroup, ...
        'style', 'radiobutton', 'String', 'Dynamic', ...
        'Units', 'normalized', 'tag', 'DynamicButton', 'FontSize', 14, ...
        'UserData', 'D', 'Position', [0.15 0.6 0.7 0.2]);

    % Create FeedBackLabel
    uicontrol('Parent', plotHandles.tab3, 'style', 'text', ...
        'String', 'FeedBack', 'Units', 'normalized', 'FontSize', 16, ...
        'HorizontalAlignment', 'center', 'Position', [0.2 0.66 0.05 0.03]);

    % Create IncDecSpinnerLabel
    uicontrol('Parent', plotHandles.tab3, 'style', 'text', ...
        'String', 'Inc/Dec', 'Units', 'normalized', 'FontSize', 16, ...
        'HorizontalAlignment', 'center', 'Position', [0.5 0.65 0.04 0.03]);

    % Create feedbackIncDec
    plotHandles.feedbackIncDec = uicontrol('Parent', plotHandles.tab3, 'style', 'edit', ...
        'Units', 'normalized', 'tag', 'FBEdit', 'FontSize', 14, ...
        'String', '0', 'Position', [0.55 0.65 0.07 0.03]);

    % Create SendFeedbackButton
    uicontrol('Parent', plotHandles.tab3, 'style', 'pushbutton', ...
        'String', 'Send Feedback', 'CallBack', @FeedbackBtnCallback, ...
        'Units', 'normalized', 'FontSize', 13, ...
        'Position', [0.775 0.64 0.07 0.04]);
    
    
    % ----- Feedback Calibration -----------------------------------------
    
    % Create FeedBackCalibrationLabel
    uicontrol('Parent', plotHandles.tab3, 'style', 'text', ...
        'String', 'FeedBack Calibration', 'Units', 'normalized', ...
        'HorizontalAlignment', 'center', 'FontSize', 16, ...
        'Position', [0.2 0.55 0.1 0.03]);

    % Create SendFBCalibButton
    uicontrol('Parent', plotHandles.tab3, 'style', 'pushbutton', ...
        'String', 'Send FB Calib', 'Units', 'normalized', ...
        'CallBack', @SendFBCalib, 'FontSize', 13, ...
        'Position', [0.775 0.55 0.07 0.04]);
    
    
    % ----- Deadspace -----------------------------------------

    % Create Deadspace Label
    uicontrol('Parent', plotHandles.tab3, 'style', 'text', ...
        'String', 'Deadspace', 'Units', 'normalized', 'FontSize', 16, ...
        'Position', [0.2 0.45 0.055 0.03]);

    % Create Deadspace Inc/Dec label
    uicontrol('Parent', plotHandles.tab3, 'style', 'text', ...
        'String', 'Inc/Dec', 'Units', 'normalized', 'FontSize', 16, ...
        'HorizontalAlignment', 'center', 'Position', [0.4 0.46 0.04 0.02]);

    % Create IncDec edit field
    plotHandles.deadspaceIncDec = uicontrol('Parent', plotHandles.tab3, 'style', 'edit', ...
        'Units', 'normalized', 'tag', 'deadField', 'FontSize', 14, ...
        'String', '0', 'Position', [0.45 0.45 0.07 0.03]);

    % Create SendDeadspaceButton
    uicontrol('Parent', plotHandles.tab3, 'style', 'pushbutton', ...
        'String', 'Send Deadspace', 'CallBack', @SendDeadspace, ...
        'Units', 'normalized', 'FontSize', 13, 'Position', [0.775 0.44 0.07 0.04]);
    
    
    % ----- PSU Offset -----------------------------------------

    % Create PSU Offset Label
    uicontrol('Parent', plotHandles.tab3, 'style', 'text', ...
        'String', 'PSU Offset', 'Units', 'normalized', 'FontSize', 16, ...
        'Position', [0.2 0.36 0.05 0.02]);

    % Create PSU Offset Inc/Dec Label
    uicontrol('Parent', plotHandles.tab3, 'style', 'text', ...
        'String', 'Inc/Dec', 'Units', 'normalized', 'FontSize', 16, ...
        'HorizontalAlignment', 'center', 'Position', [0.4 0.36 0.04 0.02]);

    % Create IncDecSpinner_3
    plotHandles.offsetIncDec = uicontrol('Parent', plotHandles.tab3, 'style', 'edit', ...
        'Units', 'normalized', 'tag', 'offsetField', 'FontSize', 14, ...
        'String', '0', 'Position', [0.45 0.35 0.07 0.03]);

    % Create SendOffsetButton
    uicontrol('Parent', plotHandles.tab3, 'style', 'pushbutton', ...
        'String', 'Send Offset', 'CallBack', @SendOffset, ...
        'Units', 'normalized', 'FontSize', 13, ...
        'Position', [0.775 0.345 0.07 0.04]);
    
    
    % ----- Table Load -----------------------------------------

    % Create TableLoadLabel
    uicontrol('Parent', plotHandles.tab3, 'style', 'text', ...
        'String', 'Table Load', 'Units', 'normalized', 'FontSize', 16, ...
        'HorizontalAlignment', 'center', 'Position', [0.2 0.25 0.05 0.03]);

    % Create AddressLabel
    uicontrol('Parent', plotHandles.tab3, 'style', 'text', ...
        'String', 'Address', 'Units', 'normalized', 'FontSize', 14, ...
        'HorizontalAlignment', 'center', 'Position', [0.4 0.29 0.04 0.02]);

    % Create DataLabel
    uicontrol('Parent', plotHandles.tab3, 'style', 'text', ...
        'String', 'Data', 'Units', 'normalized', 'tag', 'dataCmd', ...
        'FontSize', 14, 'HorizontalAlignment', 'center', ...
        'Position', [0.55 0.29 0.03 0.02]);
    
    % Create EditFieldAdress
    plotHandles.tableAddress = uicontrol('Parent', plotHandles.tab3, 'style', 'edit', ...
        'Units', 'normalized', 'tag', 'AddrField', 'FontSize', 14, ...
        'String', '0x0000', 'HorizontalAlignment', 'center', ...
        'Position', [0.385 0.25 0.07 0.03]);

    % Create EditFieldData
    plotHandles.tableData = uicontrol('Parent', plotHandles.tab3, 'style', 'edit', ...
        'Units', 'normalized', 'tag', 'dataField', 'FontSize', 14, ...
        'String', '0x0000', 'HorizontalAlignment', 'center', ...
        'Position', [0.53 0.25 0.07 0.03]);

    % Create SendTableLoadButton
    uicontrol('Parent', plotHandles.tab3, 'style', 'pushbutton', ...
        'String', 'Send Table Load', 'CallBack', @SendTbLoad, ...
        'Units', 'normalized', 'FontSize', 13, ...
        'Position', [0.775 0.24 0.07 0.04]);
    
    
    % ----- Table File -----------------------------------------

    % Create TableFileLabel
    uicontrol('Parent', plotHandles.tab3, 'style', 'text', ...
        'String', 'Table File', 'Units', 'normalized', 'FontSize', 16, ...
        'HorizontalAlignment', 'center', 'Position', [0.2 0.15 0.04 0.02]);

    % Create EditField_6
    plotHandles.browseField = uicontrol('Parent', plotHandles.tab3, 'style', 'edit', ...
        'Units', 'normalized', 'tag', 'browseField', 'FontSize', 14, ...
        'Position', [0.375 0.15 0.09 0.0275]);

    % Create BrowseFileButton
    uicontrol('Parent', plotHandles.tab3, 'style', 'pushbutton', ...
        'String', 'Browse File', 'CallBack', @BrowseFileBtn, ...
        'Units', 'normalized', 'FontSize', 13, ...
        'Position', [0.47 0.15 0.07 0.0275]);

    % Create SendTableFileButton
    uicontrol('Parent', plotHandles.tab3, 'style', 'pushbutton', ...
        'String', 'Send Table File', 'CallBack', @SendTbFile, ...
        'Units', 'normalized', 'FontSize', 13, ...
        'Position', [0.775 0.14 0.07 0.04]);
    
    
    % ----- Enter Command -----------------------------------------
    
    % Create EnteraCommandLabel
    uicontrol('Parent', plotHandles.tab3, 'style', 'text', ...
        'String', 'Enter a Command', 'Units', 'normalized', ...
        'FontSize', 16, 'Position', [0.2 0.04 0.09 0.04]);
    
    % Create Command EditField
    plotHandles.commandEditField = uicontrol('Parent', plotHandles.tab3, 'style', 'edit', ...
        'Units', 'normalized', 'FontSize', 14, ...
        'Position', [0.325 0.05 0.1 0.03]);

    % Create SendCommandButton
    uicontrol('Parent', plotHandles.tab3, 'style', 'pushbutton', ...
        'String', 'Send Command', 'Units', 'normalized', ...
        'CallBack', @sendCommandBtn, 'FontSize', 13, ...
        'Position', [0.775 0.04 0.07 0.04]);
    
    % ----- Error Text -----------------------------------------
    
    plotHandles.errorLabel = uicontrol('Parent', plotHandles.tab3, 'style', 'text', ...
        'Units', 'normalized', 'tag', 'ErrorChannel', ...
        'ForegroundColor', [1 0 0], 'FontSize', 16, ...
        'HorizontalAlignment', 'center', 'Position', [0.39 0.9 0.25 0.03]);

    % Create TBAddDataLabel
    plotHandles.TBAddDataLabel = uicontrol('Parent', plotHandles.tab3, 'style', 'text', ...
        'String', 'Error: Incorrect address or data entry', ...
        'Units', 'normalized', 'tag', 'ErrorLoad', 'FontSize', 16, ...
        'ForegroundColor', [1 0 0], 'Visible', 'off', ...
        'HorizontalAlignment', 'center', 'Position', [0.35 0.31 0.3 0.03]);

    % Create loadTBFileLabel
    uicontrol('Parent', plotHandles.tab3, 'style', 'text', ...
        'String', 'Error: File contains incorrect data or entry', ...
        'Units', 'normalized', 'tag', 'ErrorData', 'FontSize', 16, ...
        'ForegroundColor', [1 0 0], 'Visible', 'off', ...
        'Position', [0.35 0.19 0.3 0.03]);

    % Create loadTBFileLabelError
    plotHandles.loadTBFileLabelError = uicontrol('Parent', plotHandles.tab3, ...
        'style', 'text', 'String', 'Error: Incorrect file or file path', ...
        'Units', 'normalized', 'tag', 'ErrorFile', 'FontSize', 16, ...
        'ForegroundColor', [1 0 0], 'Visible', 'off', ...
        'Position', [0.4 0.19 0.2 0.03]);
end

% Send Feedback Button Callback
function FeedbackBtnCallback(hObject, ~)
    handles = guidata(hObject);
    arrChannel = checkChannel(handles);
    displayError(handles, '');
    arr = {};

    if(isempty(arrChannel))
        displayError(handles, 'Error: Please select a channel');
        return
    end

    [num] = str2double(handles.feedbackIncDec.String);
    if(isnan(num))
        displayError(handles, 'Error: Please enter a number');
        return
    end

    if(num > 0)
        state = 'I';
    else
        num = abs(num);
        state = 'D';
    end

    for i = 1:length(arrChannel)
        arr = [arr, arrChannel(i)];
        arr = [arr, handles.ButtonGroup.SelectedObject.UserData];
        if(num == 0)
            arr = [arr, '0'];
        else
            for j = 1:num
                arr = [arr, state];
            end
        end
    end

    setappdata(handles.fig, 'key', arr);

end

% Send Feedback Calibration Button Callback
function SendFBCalib(hObject, ~)
    handles = guidata(hObject);
    arrChannel = checkChannel(handles);
    displayError(handles, '');
    arr = {};

    if(isempty(arrChannel))
        displayError(handles, 'Error: Please select a channel');
        return
    end

    % for each selected channel, add a C
    for i = 1:length(arrChannel)
        arr = [arr, arrChannel(i)];
        arr = [arr, 'C'];
    end

    setappdata(handles.fig, 'key', arr);
end

% Send Deadspace Button Callback
function SendDeadspace(hObject, ~)
    handles = guidata(hObject);
    arrChannel = checkChannel(handles);
    displayError(handles, '');
    arr = {};

    if(isempty(arrChannel))
        displayError(handles, 'Error: Please select a channel');
        return
    end

    [num] = str2double(handles.deadspaceIncDec.String);
    if(isnan(num) || num == 0)
        displayError(handles, ...
            'Error: Please enter a positive or negative number');
        return
    end

    if(num < 0)
        num = num + 255;
    end

    % for each selected channel, add specific number of G's
    for i = 1:length(arrChannel)
        arr = [arr, arrChannel(i)];
        for j = 1:num
            arr = [arr, 'G'];
        end
    end
    setappdata(handles.fig, 'key', arr);
end

% Send Offset Button Callback
function SendOffset(hObject, ~)
    handles = guidata(hObject);
    arrChannel = checkChannel(handles);
    displayError(handles, '');
    arr = {};

    if(isempty(arrChannel))
        displayError(handles, 'Error: Please select a channel');
        return
    end

    [num] = str2double(handles.offsetIncDec.String);
    if(isnan(num) || num == 0)
        displayError(handles, ...
            'Error: Please enter a positive or negative number');
        return
    end

    if(num < 0)
        num = num + 255;
    end

    % for each selected channel, add specific number of P's
    for i = 1:length(arrChannel)
        arr = [arr, arrChannel(i)];
        for j = 1:num
            arr = [arr, 'P'];
        end
    end
    setappdata(handles.fig, 'key', arr);
end

% Send Table Load Button Callback
function SendTbLoad(hObject, ~)
    handles = guidata(hObject);
    arrChannel = checkChannel(handles);
    displayError(handles, '');
    handles.TBAddDataLabel.Visible = 'off';
    arr = {};

    % check if no channel selected
    if(isempty(arrChannel))
        displayError(handles, 'Error: Please select a channel');
        return
    end

    % check if addr and data hex values are valid
    if(~validHex(handles.tableAddress.String) || ...
       ~validHex(handles.tableData.String))
        handles.TBAddDataLabel.Visible = 'on';
        return
    end

    % create key array 
    for i = 1:length(arrChannel)
        arr = [arr, arrChannel(i), handles.tableAddress.String, ...
            handles.tableData.String];
    end
    setappdata(handles.fig, 'key', arr);
end

% Send Table File Button Callback
function SendTbFile(hObject, ~)
    handles = guidata(hObject);
    arrChannel = checkChannel(handles);
    displayError(handles, '');
    handles.loadTBFileLabelError.Visible = 'off';
    arr = {};

    % check if no channel selected
    if(isempty(arrChannel))
        displayError(handles, 'Error: Please select a channel');
        return
    end

    % try to read excel file
    try
        excelData = readtable(handles.browseField.String);
    catch
        handles.loadTBFileLabelError.Visible = 'on';
        return
    end

    for i = 1:length(arrChannel)
        arr = [arr, arrChannel(i)];
        for j = 1:height(excelData)
            % check if addr and data hex values are valid
            if(~validHex(excelData.('Address')(j, 1)) || ...
               ~validHex(excelData.('Data')(j, 1)))
                handles.loadTBFileLabelError.Visible = 'on';
                return
            end

            % create key array 
            arr = [arr, excelData.('Address')(j,1), ...
                    excelData.('Data')(j, 1)];
        end
    end       
    setappdata(handles.fig, 'key', arr);
end

% Browse File Callback
function BrowseFileBtn(hObject, ~)
    handles = guidata(hObject);
    handles.loadTBFileLabelError.Visible = 'off';

    a = {'*.csv;*.txt;*.dat;*.xls;*.xlsb;*.xlsm;*.xlsx;*.xltm;*.xltx;*.ods'};
    [FileName, FilePath] = uigetfile(a);
    handles.browseField.String = fullfile(FilePath, FileName);
end

% Send Command Button Callback
function sendCommandBtn(hObject, ~)
    handles = guidata(hObject);
    arrChannel = checkChannel(handles);
    displayError(handles, '');
    arr = {};

    % check if no channel selected
    if(isempty(arrChannel))
        displayError(handles, 'Error: Please select a channel');
        return
    end

    commands = num2cell(handles.commandEditField.String);

    % create key array 
    for i = 1:length(arrChannel)
        arr = [arr, arrChannel(i)];
        for j = 1:length(commands)
            arr = [arr, commands(j)];
        end
    end      
    setappdata(handles.fig, 'key', arr);
end

% Return selected channels
function arrChannel = checkChannel(plotHandles)
    arrChannel = {};
    if(plotHandles.CheckBoxX.Value == 1 && ...
            plotHandles.CheckBoxY.Value == 1 && ...
            plotHandles.CheckBoxZ.Value == 1)
        arrChannel = 'A';
    else
        if(plotHandles.CheckBoxX.Value == 1)
            arrChannel = [arrChannel, 'X'];
        end
        if(plotHandles.CheckBoxY.Value == 1)
            arrChannel = [arrChannel, 'Y'];
        end
        if(plotHandles.CheckBoxZ.Value == 1)
            arrChannel = [arrChannel, 'Z'];
        end
    end
end

% Display and hide error that shows at the top of the page
function displayError(plotHandles, errorString)
    plotHandles.errorLabel.String = errorString;
end

% Check if str is a valid 4-digit hexadecimal value
function valid = validHex(str)
    newstr = string(str);

    if(~strncmpi(str, "0x", 2))
        valid = 0;
        return
    end
    str = newstr{1}(3:end);

    if(length(str) ~= 4)
        valid = 0;
        return
    end

    t = isstrprop(str, 'xdigit');

    if(nnz(~t) > 0)
        valid = 0;
    else
        valid = 1;
    end
end
