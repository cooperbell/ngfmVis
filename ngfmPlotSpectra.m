subplot('position', [0.55 0.10 0.39 0.85]);
M(spectra);
run(M(spectra))

% if (strcmp(spectra,'psd'))
%     PlotPSD;
% else
%     run('PlotAmplitude.m')
%     %PlotAmplitude;
% end