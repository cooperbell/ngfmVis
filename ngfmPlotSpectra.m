global spectra;
global plots;

% Spectra plot setup
subplot('position', [0.55 0.10 0.39 0.85]);

% graph plot
try
    run(spectra)
catch exception
    % remove spectra from list
    index = find(strcmp(plots, spectra));
    plots(index) = [];
    spectra = string(plots(1));
    plotHandles.current_plot_menu.String = plots;
    plotHandles.current_plot_menu.Value = 1;
    
    % show thrown error
    warning(exception.identifier, 'Unable to load plot, %s', exception.message)
end 
