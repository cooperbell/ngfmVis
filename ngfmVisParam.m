function ngfmVisParam()

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

    % Create ConfigFileDropDownLabel
    ConfigFileDropDownLabel = uilabel(RightPanel);
    ConfigFileDropDownLabel.Position = [35 140 66 22];
    ConfigFileDropDownLabel.Text = 'Config File:';
    S.ConfigFileDropDownLabel = ConfigFileDropDownLabel;

    % Create ConfigFileDropDown
    ConfigFileDropDown = uidropdown(RightPanel);
    ConfigFileDropDown.Items = {'config.txt'};
    ConfigFileDropDown.ValueChangedFcn = @GetConfigFiles;
    ConfigFileDropDown.Position = [35 119 130 22];
    ConfigFileDropDown.Value = 'config.txt';
    S.ConfigFileDropDown = ConfigFileDropDown;

    % Create BrowseButton_2
    BrowseButton_2 = uibutton(RightPanel, 'push');
    BrowseButton_2.ButtonPushedFcn = @LogToBrowse;
    BrowseButton_2.Position = [209 203 100 22];
    BrowseButton_2.Text = 'Browse';
    S.BrowseButton_2 = BrowseButton_2;

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
        
        [FileName,FilePath ]= uigetfile('*.txt*');
        sourceFilePath = fullfile(FilePath, FileName);
        handles.SourceEditField.Value = sourceFilePath;
        handles.figure.Visible = 'on';
    end

    % Button pushed function: BrowseButton_2
    function LogToBrowse(hObject, ~)
        handles = guidata(hObject);
        handles.figure.Visible = 'off'; 
        [FileName,FilePath ]= uigetfile('*.txt*');
        logToPath = fullfile(FilePath, FileName);
        handles.LogtoEditField.Value = logToPath;
        handles.figure.Visible = 'on'; 
    end

    % Value changed function: InputDropDown
    function CheckValue(hObject, ~)
        handles = guidata(hObject);

        value = hObject.InputDropDown.Value;
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

    % Value changed function: ConfigFileDropDown
    function GetConfigFiles(hObject, eventdata)
        %fileList = dir('*.config');
        %app.ConfigFileDropDown.Items = fileList;
    end

    % Button pushed function: StartButton
    function StartButtonPushed(hObject, ~)
        handles = guidata(hObject);
        source = handles.SourceEditField.Value;
        inputSelect = handles.InputDropDown.Value;
        logTo = handles.LogtoEditField.Value;
        if(strcmp(logTo, ''))
            logTo = 'null';
        end
        setappdata(handles.figure, 'params', {lower(inputSelect), source, logTo});
        handles.figure.Visible = 'off';
    end
end