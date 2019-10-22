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
    warning(exception.identifier, 'Unable to load plot, %s', exception.message)
end 
