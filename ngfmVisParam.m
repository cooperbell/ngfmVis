% NGFMVISPARAM A GUI for providing input arguments to ngfmVis
function UIFigure = ngfmVisParam()
    % create figure
    UIFigure = uifigure('AutoResizeChildren', 'off', 'Resize', 'off', ...
        'Name', 'NgfmVis Input Parameters', 'Position', [100 100 640 480]);
    S.figure = UIFigure;

    % Add grid layout to figure
    GridLayout = uigridlayout('Parent', UIFigure, 'RowHeight', {'1x'}, ...
        'ColumnWidth', {12, '1x'}, 'ColumnSpacing', 0, 'RowSpacing', 0, ...
        'Padding', [0 0 0 0]);

    leftPanel = uipanel(GridLayout);
    leftPanel.Layout.Row = 1;
    leftPanel.Layout.Column = 2;

    % Create Page title 
    uilabel('Parent', leftPanel, 'Text', 'Input Parameters', ...
        'FontSize', 24, 'Position', [230 430 250 40]);
    
    % Create Input Label
    uilabel('Parent', leftPanel, 'Text', {'Input: '; ''}, ...
        'Position', [35 385 40 22]);
    
    % Create Input DropDown
    inputDropDown = uidropdown('Parent', leftPanel, ...
        'Items', {'Serial', 'File'}, 'ValueChangedFcn', @CheckValue, ...
        'Value', 'File', 'Position', [35 364 100 22]);
    S.inputDropDown = inputDropDown;
    
    % Create Source Label
    uilabel('Parent', leftPanel, 'Text', 'Source:', ...
        'Position', [35 302 50 22]);

    % Create Source Edit Field
    sourceEditField = uieditfield('Parent', leftPanel, ...
        'Position',[35 281 130 22]);
    S.sourceEditField = sourceEditField;

    % Create browse button
    browseButton = uibutton('Parent', leftPanel, 'Text', 'Browse', ...
        'ButtonPushedFcn', @SourceBrowseButton, 'Position', [209 281 100 22]);
    S.browseButton = browseButton;

    % Create Log to Label
    uilabel('Parent', leftPanel, 'Text', 'Log to:', ...
        'Position', [39 224 47 22]);

    % Create logTo Edit Field
    logToEditField = uieditfield('Parent', leftPanel, ...
        'Position', [35 203 130 22]);
    S.logToEditField = logToEditField;
    
    % create log to supporting text
    uilabel('Parent', leftPanel, 'FontAngle', 'italic', ...
        'Text', 'Leave empty for autogenerated name', ...
        'Position', [37 180 220 22]);
    
    % Create button for not logging
    uibutton('Parent', leftPanel, 'ButtonPushedFcn', @noLogButtonCallback, ...
        'Text', "Don't Log", 'Position', [209 203 100 22]);

    % Create StartButton
    uibutton('Parent', leftPanel, 'ButtonPushedFcn', @StartButtonPushed, ...
        'Text', 'Start', 'Position', [35 49 76 22]);
    
    % save for use in callbacks
    guidata(S.figure, S)
    
    drawnow;


    % Callback function: browseButton, sourceEditField
    function SourceBrowseButton(hObject, ~)
        handles = guidata(hObject);
        handles.figure.Visible = 'off'; 
        
        [FileName,FilePath]= uigetfile('*.txt*');
        sourceFilePath = fullfile(FilePath, FileName);
        handles.sourceEditField.Value = sourceFilePath;
        handles.figure.Visible = 'on';
    end

    % Button pushed function: noLogButton
    function noLogButtonCallback(hObject, ~)
        handles = guidata(hObject);
        handles.logToEditField.Value = 'null';
    end

    % Value changed function: inputDropDown
    function CheckValue(hObject, ~)
        handles = guidata(hObject);

        value = handles.inputDropDown.Value;
        if(strcmp(value, 'Serial'))
            handles.DropDown.Visible = true;
            handles.sourceEditField.Visible = false;
            handles.browseButton.Visible = false;
            serialPorts = seriallist;
            handles.DropDown.Items = serialPorts;
        end

        if(strcmp(value, 'File'))
            handles.DropDown.Visible = false;
            handles.sourceEditField.Visible = true;
            handles.browseButton.Visible = true;
        end
    end

    % Button pushed function: StartButton
    function StartButtonPushed(hObject, ~)
        handles = guidata(hObject);
        source = handles.sourceEditField.Value;
        if (~isempty(source))
            inputSelect = handles.inputDropDown.Value;
            logTo = handles.logToEditField.Value;
            setappdata(handles.figure, 'params', {lower(inputSelect), source, logTo});
            handles.figure.Visible = 'off';
        else
            uialert(handles.figure, "You must select a source", "Error");
        end
       
    end
end