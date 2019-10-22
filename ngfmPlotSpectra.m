% global spectra;
% global plots;

spectra = getappdata(plotHandles.figure, 'spectra');
plots = getappdata(plotHandles.figure, 'plots');

% Spectra plot setup
subplot('position', [0.55 0.10 0.39 0.85]);

% graph plot
try
    run(spectra)
catch exception
    % remove spectra from list
    idx = find(strcmp(plots, spectra));
    plots(idx) = [];
    
    % update app data
    setappdata(plotHandles.figure, 'spectra', string(plots(1)));
    setappdata(plotHandles.figure, 'plots', plots);
    
    % update dropdown
    plotHandles.current_plot_menu.String = plots;
    plotHandles.current_plot_menu.Value = 1;
    
    % show thrown error
    warning(exception.identifier, 'Unable to load plot, %s', exception.message)
end 
