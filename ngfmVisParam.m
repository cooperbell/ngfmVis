% Properties that correspond to app components
    global UIFigure;
    global GridLayout;        
    global RightPanel;
    global SourceEditFieldLabel;
    global SourceEditField;
    global InputDropDown;
%     InputLabel
    global BrowseButton
%     LogtoEditFieldLabel
    global LogtoEditField;
%     ConfigFileDropDownLabel
%     ConfigFileDropDown
%     BrowseButton_2
    global DropDown;
%     StartButton



UIFigure = uifigure('Visible', 'off');
UIFigure.AutoResizeChildren = 'off';
UIFigure.Position = [100 100 640 480];
UIFigure.Name = 'Input Parameters Page';
UIFigure.SizeChangedFcn = @updateAppLayout;


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

% Create SourceEditField
SourceEditField = uieditfield(RightPanel, 'text');
SourceEditField.ValueChangedFcn = @SourceBrowseButton;
SourceEditField.Position = [35 281 130 22];

% Create InputDropDown
InputDropDown = uidropdown(RightPanel);
InputDropDown.Items = {'Serial', 'File'};
InputDropDown.ValueChangedFcn = @CheckValue;
InputDropDown.Position = [35 364 100 22];
InputDropDown.Value = 'File';

% Create InputLabel
InputLabel = uilabel(RightPanel);
InputLabel.Position = [35 385 40 22];
InputLabel.Text = {'Input: '; ''};

% Create BrowseButton
BrowseButton = uibutton(RightPanel, 'push');
BrowseButton.ButtonPushedFcn = @SourceBrowseButton;
BrowseButton.Position = [209 281 100 22];
BrowseButton.Text = 'Browse';

% Create LogtoEditFieldLabel
LogtoEditFieldLabel = uilabel(RightPanel);
LogtoEditFieldLabel.Position = [39 224 47 22];
LogtoEditFieldLabel.Text = 'Log to: ';

% Create LogtoEditField
LogtoEditField = uieditfield(RightPanel, 'text');
LogtoEditField.Position = [35 203 130 22];

% Create ConfigFileDropDownLabel
ConfigFileDropDownLabel = uilabel(RightPanel);
ConfigFileDropDownLabel.Position = [35 140 66 22];
ConfigFileDropDownLabel.Text = 'Config File:';

% Create ConfigFileDropDown
ConfigFileDropDown = uidropdown(RightPanel);
ConfigFileDropDown.Items = {'mag_1.config'};
ConfigFileDropDown.ValueChangedFcn = @GetConfigFiles;
ConfigFileDropDown.Position = [35 119 130 22];
ConfigFileDropDown.Value = 'mag_1.config';

% Create BrowseButton_2
BrowseButton_2 = uibutton(RightPanel, 'push');
BrowseButton_2.ButtonPushedFcn = @LogToBrowse;
BrowseButton_2.Position = [209 203 100 22];
BrowseButton_2.Text = 'Browse';

% Create DropDown
DropDown = uidropdown(RightPanel);
DropDown.Visible = 'off';
DropDown.Position = [35 281 130 22];

% Create StartButton
StartButton = uibutton(RightPanel, 'push');
StartButton.ButtonPushedFcn = @StartButtonPushed;
StartButton.Position = [35 49 76 22];
StartButton.Text = 'Start';

% Show the figure after all components are created
UIFigure.Visible = 'on';



% Callback function: BrowseButton, SourceEditField
function SourceBrowseButton(src, ~)
    global UIFigure
    global SourceEditField;
    UIFigure.Visible = 'off'; 
    [FileName,FilePath ]= uigetfile('*.txt*');
    sourceFilePath = fullfile(FilePath, FileName);
    SourceEditField.Value = sourceFilePath;
    UIFigure.Visible = 'on'; 

end

% Button pushed function: BrowseButton_2
function LogToBrowse(app, event)
    global UIFigure
    global LogtoEditField;

    UIFigure.Visible = 'off'; 
    [FileName,FilePath ]= uigetfile('*.txt*');
    logToPath = fullfile(FilePath, FileName);
    LogtoEditField.Value = logToPath;
    UIFigure.Visible = 'on'; 
end

% Value changed function: InputDropDown
function CheckValue(src, event)
    global InputDropDown;
    global BrowseButton;
    global SourceEditField;
    global DropDown;

    value = InputDropDown.Value;
    if(strcmp(value, 'Serial'))
        DropDown.Visible = true;
        SourceEditField.Visible = false;
        BrowseButton.Visible = false;
        serialPorts = seriallist;
        DropDown.Items = serialPorts;
    end

    if(strcmp(value, 'File'))
        DropDown.Visible = false;
        SourceEditField.Visible = true;
        BrowseButton.Visible = true;
    end
end

% Value changed function: ConfigFileDropDown
function GetConfigFiles(app, event)
    %fileList = dir('*.config');
    %app.ConfigFileDropDown.Items = fileList;
end

% Button pushed function: StartButton
function StartButtonPushed(app, event)
    global SourceEditField
    global UIFigure;

    UIFigure.Visible = 'off';
    ngfmVis('file', SourceEditField.Value,'null');
    delete(UIFigure);

end

% Changes arrangement of the app based on UIFigure width
function updateAppLayout(app, event)
    global UIFigure;
    global GridLayout;
    global RightPanel;
    currentFigureWidth = UIFigure.Position(3);
    if(currentFigureWidth <= 576)
        % Change to a 2x1 grid
        GridLayout.RowHeight = {480, 480};
        GridLayout.ColumnWidth = {'1x'};
        RightPanel.Layout.Row = 2;
        RightPanel.Layout.Column = 1;
    else
        % Change to a 1x2 grid
        GridLayout.RowHeight = {'1x'};
        GridLayout.ColumnWidth = {12, '1x'};
        RightPanel.Layout.Row = 1;
        RightPanel.Layout.Column = 2;
    end
end