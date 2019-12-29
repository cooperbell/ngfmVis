% NGFMVISPARAM A GUI for providing input arguments to ngfmVis
function UIFigure = ngfmVisParam()

    % create figure
    UIFigure = uifigure;
    UIFigure.AutoResizeChildren = 'off';
    UIFigure.Position = [100 100 640 480];
    UIFigure.Name = 'Input Parameters Page';
    UIFigure.Resize = 'off';
    S.figure = UIFigure;

    % Add grid layout to figure
    GridLayout = uigridlayout(UIFigure);
    GridLayout.ColumnWidth = {12, '1x'};
    GridLayout.RowHeight = {'1x'};
    GridLayout.ColumnSpacing = 0;
    GridLayout.RowSpacing = 0;
    GridLayout.Padding = [0 0 0 0];
    GridLayout.Scrollable = 'on';

    RightPanel = uipanel(GridLayout);
    RightPanel.Layout.Row = 1;
    RightPanel.Layout.Column = 2;

    % Create SourceEditFieldLabel
    TitleLabel = uilabel(RightPanel);
    TitleLabel.Position = [230 430 250 40];
    TitleLabel.Text = 'Input Parameters ';
    TitleLabel.FontSize = 24;
    S.SourceEditFieldLabel = TitleLabel;
    

    % Create SourceEditFieldLabel
    SourceEditFieldLabel = uilabel(RightPanel);
    SourceEditFieldLabel.Position = [35 302 50 22];
    SourceEditFieldLabel.Text = 'Source: ';
    S.SourceEditFieldLabel = SourceEditFieldLabel;

    % Create SourceEditField
    SourceEditField = uieditfield(RightPanel, 'text');
    SourceEditField.ValueChangedFcn = @SourceBrowseButton;
    SourceEditField.Position = [35 281 130 22];
    S.SourceEditField = SourceEditField;

    % Create InputDropDown
    InputDropDown = uidropdown(RightPanel);
    InputDropDown.Items = {'Serial', 'File'};
    InputDropDown.ValueChangedFcn = @CheckValue;
    InputDropDown.Position = [35 364 100 22];
    InputDropDown.Value = 'File';
    S.InputDropDown = InputDropDown;

    % Create InputLabel
    InputLabel = uilabel(RightPanel);
    InputLabel.Position = [35 385 40 22];
    InputLabel.Text = {'Input: '; ''};
    S.InputLabel = InputLabel;

    % Create BrowseButton
    BrowseButton = uibutton(RightPanel, 'push');
    BrowseButton.ButtonPushedFcn = @SourceBrowseButton;
    BrowseButton.Position = [209 281 100 22];
    BrowseButton.Text = 'Browse';
    S.BrowseButton = BrowseButton;

    % Create LogtoEditFieldLabel
    LogtoEditFieldLabel = uilabel(RightPanel);
    LogtoEditFieldLabel.Position = [39 224 47 22];
    LogtoEditFieldLabel.Text = 'Log to: ';
    S.LogtoEditFieldLabel = LogtoEditFieldLabel;

    % Create LogtoEditField
    LogtoEditField = uieditfield(RightPanel, 'text');
    LogtoEditField.Position = [35 203 130 22];
    S.LogtoEditField = LogtoEditField;
    
    % create log to supporting text
    logToSupportingText = uilabel(RightPanel);
    logToSupportingText.Position = [37 180 220 22];
    logToSupportingText.Text = 'Leave empty for autogenerated name';
    logToSupportingText.FontAngle = 'italic';
    S.logToSupportingText = logToSupportingText;
    
    % Create button for not logging
    noLogButton = uibutton(RightPanel, 'push');
    noLogButton.ButtonPushedFcn = @LogToBrowse;
    noLogButton.Position = [209 203 100 22];
    noLogButton.Text = "Don't Log";
    S.noLogButton = noLogButton;

    % Create ConfigFileDropDownLabel
    ConfigFileDropDownLabel = uilabel(RightPanel);
    ConfigFileDropDownLabel.Position = [35 140 66 22];
    ConfigFileDropDownLabel.Text = 'Config File:';
    S.ConfigFileDropDownLabel = ConfigFileDropDownLabel;

    % Create ConfigFileDropDown
    ConfigFileDropDown = uidropdown(RightPanel);
    ConfigFileDropDown.Position = [35 119 130 22];
    fileList = dir('*.xml');
    numFiles = size(fileList);
    files = {};
    for i = 1:numFiles(1)
        files = [files, fileList(i).name];
    end
    ConfigFileDropDown.Items = files;
    S.ConfigFileDropDown = ConfigFileDropDown;

    % Create DropDown
    DropDown = uidropdown(RightPanel);
    DropDown.Visible = 'off';
    DropDown.Position = [35 281 130 22];
    S.DropDown = DropDown;

    % Create StartButton
    StartButton = uibutton(RightPanel, 'push');
    StartButton.ButtonPushedFcn = @StartButtonPushed;
    StartButton.Position = [35 49 76 22];
    StartButton.Text = 'Start';
    S.StartButton = StartButton;
    
    % save for use in callbacks
    guidata(S.figure, S)
    
    drawnow;


    % Callback function: BrowseButton, SourceEditField
    function SourceBrowseButton(hObject, ~)
        handles = guidata(hObject);
        handles.figure.Visible = 'off'; 
        
        [FileName,FilePath]= uigetfile('*.txt*');
        sourceFilePath = fullfile(FilePath, FileName);
        handles.SourceEditField.Value = sourceFilePath;
        handles.figure.Visible = 'on';
    end

    % Button pushed function: noLogButton
    function LogToBrowse(hObject, ~)
        handles = guidata(hObject);
        handles.LogtoEditField.Value = 'null';
    end

    % Value changed function: InputDropDown
    function CheckValue(hObject, ~)
        handles = guidata(hObject);

        value = handles.InputDropDown.Value;
        if(strcmp(value, 'Serial'))
            handles.DropDown.Visible = true;
            handles.SourceEditField.Visible = false;
            handles.BrowseButton.Visible = false;
            serialPorts = seriallist;
            handles.DropDown.Items = serialPorts;
        end

        if(strcmp(value, 'File'))
            handles.DropDown.Visible = false;
            handles.SourceEditField.Visible = true;
            handles.BrowseButton.Visible = true;
        end
    end

    % Button pushed function: StartButton
    function StartButtonPushed(hObject, ~)
        handles = guidata(hObject);
        source = handles.SourceEditField.Value;
        if (~isempty(source))
            inputSelect = handles.InputDropDown.Value;
            logTo = handles.LogtoEditField.Value;
            % TODO
    %         %configFile = handles.ConfigFileDropDown.Value;
            setappdata(handles.figure, 'params', {lower(inputSelect), source, logTo});
            %TODO
            % setappdata(handles.figure, 'params', {lower(inputSelect), source, logTo, configFile});
            handles.figure.Visible = 'off';
        else
            uialert(handles.figure, "You must select a source", "Error");
        end
       
    end
end