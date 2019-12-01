plotHandles.fig = figure('Name', 'Housekeeping Data', 'NumberTitle','off', ...
                'WindowState', 'fullscreen', 'Tag', 'hkFig');
           
% plotHandles = struct('hk0',[],'hk1',[],'hk2',[],'hk3',[],'hk4',[], ...
%                      'hk5',[],'hk6',[],'hk7',[],'hk8',[],'hk9',[], ...
%                      'hk10',[],'hk11',[]);
%                  
% leftJustify = {0.05,0.36,0.67};
% upJustify = {0.80,0.55,0.3,0.05};
% width = 0.25;
% height = 0.15;
% 
% for i = 1:12
%     
% end
            
% column 1            
plotHandles.hk0 = axes('Parent', plotHandles.fig, 'Position', [0.05 0.80 0.25 0.15], ...
                        'XLim', [0 60], 'XLimMode', 'manual');
                    
plotHandles.hk1 = axes('Parent', plotHandles.fig, 'Position', [0.05 0.55 0.25 0.15], ...
                        'XLim', [0 60], 'XLimMode', 'manual');
                    
plotHandles.hk2 = axes('Parent', plotHandles.fig, 'Position', [0.05 0.3 0.25 0.15], ...
                        'XLim', [0 60], 'XLimMode', 'manual');
                    
plotHandles.hk3 = axes('Parent', plotHandles.fig, 'Position', [0.05 0.05 0.25 0.15], ...
                        'XLim', [0 60], 'XLimMode', 'manual');
                    
                    
% column 2                    
plotHandles.hk4 = axes('Parent', plotHandles.fig, 'Position', [0.36 0.80 0.25 0.15], ...
                        'XLim', [0 60], 'XLimMode', 'manual');
                    
plotHandles.hk5 = axes('Parent', plotHandles.fig, 'Position', [0.36 0.55 0.25 0.15], ...
                        'XLim', [0 60], 'XLimMode', 'manual');
                    
plotHandles.hk6 = axes('Parent', plotHandles.fig, 'Position', [0.36 0.3 0.25 0.15], ...
                        'XLim', [0 60], 'XLimMode', 'manual');
                    
plotHandles.hk7 = axes('Parent', plotHandles.fig, 'Position', [0.36 0.05 0.25 0.15], ...
                        'XLim', [0 60], 'XLimMode', 'manual');

                    
% column 3                    
plotHandles.hk8 = axes('Parent', plotHandles.fig, 'Position', [0.67 0.80 0.25 0.15], ...
                        'XLim', [0 60], 'XLimMode', 'manual');
                    
plotHandles.hk9 = axes('Parent', plotHandles.fig, 'Position', [0.67 0.55 0.25 0.15], ...
                        'XLim', [0 60], 'XLimMode', 'manual');
                    
plotHandles.hk10 = axes('Parent', plotHandles.fig, 'Position', [0.67 0.3 0.25 0.15], ...
                        'XLim', [0 60], 'XLimMode', 'manual');
                    
plotHandles.hk11 = axes('Parent', plotHandles.fig, 'Position', [0.67 0.05 0.25 0.15], ...
                        'XLim', [0 60], 'XLimMode', 'manual');
                   

% create line handles
xtmp = linspace(1,60,60);
ytmp = zeros(1,60);
plotHandles.lnHK0 = plot(plotHandles.hk0, xtmp, ytmp);
plotHandles.lnHK1 = plot(plotHandles.hk1, xtmp, ytmp);
plotHandles.lnHK2 = plot(plotHandles.hk2, xtmp, ytmp);
plotHandles.lnHK3 = plot(plotHandles.hk3, xtmp, ytmp);
plotHandles.lnHK4 = plot(plotHandles.hk4, xtmp, ytmp);
plotHandles.lnHK5 = plot(plotHandles.hk5, xtmp, ytmp);
plotHandles.lnHK6 = plot(plotHandles.hk6, xtmp, ytmp);
plotHandles.lnHK7 = plot(plotHandles.hk7, xtmp, ytmp);
plotHandles.lnHK8 = plot(plotHandles.hk8, xtmp, ytmp);
plotHandles.lnHK9 = plot(plotHandles.hk9, xtmp, ytmp);
plotHandles.lnHK10 = plot(plotHandles.hk10, xtmp, ytmp);
plotHandles.lnHK11 = plot(plotHandles.hk11, xtmp, ytmp);

% axes properties
plotHandles.hk0.Title.String = '+1V2';
plotHandles.hk1.Title.String = 'TSens';
plotHandles.hk2.Title.String = 'TRef';
plotHandles.hk3.Title.String = 'TBrd';
plotHandles.hk4.Title.String = 'V+';
plotHandles.hk5.Title.String = 'VIn';
plotHandles.hk6.Title.String = 'Ref/2';
plotHandles.hk7.Title.String = 'IIn';
plotHandles.hk8.Title.String = 'HK8';
plotHandles.hk9.Title.String = 'HK9';
plotHandles.hk10.Title.String = 'HK10';
plotHandles.hk11.Title.String = 'HK11';

plotHandles.hk0.XLabel.String = 'Seconds ago';