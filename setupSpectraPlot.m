function [plotHandles] = setupSpectraPlot(spectra,plotHandles)
    ngfmLoadConstants;
    xtmp = zeros(8190,1);
    ytmp = linspace(0,50,8190)';
    if(strcmp(spectra,'PlotAmplitude.m'))
        plotHandles.lnw = loglog(plotHandles.aw,xtmp,ytmp,'red',xtmp,ytmp,'green',xtmp,ytmp,'blue');
        legend('X', 'Y', 'Z' );

        plotHandles.aw.YLabel.String = 'Amplitude (nT RMS)';
        plotHandles.aw.XLabel.String = 'Fequency (Hz)';
        grid(plotHandles.aw, 'on');
        axis(plotHandles.aw, [0.1 assumedSamplingRate/2 1e-2 1e4]);
    elseif(strcmp(spectra,'PlotPSD.m'))
        plotHandles.lnw = loglog(plotHandles.aw,xtmp,ytmp,'red',xtmp,ytmp,'green',xtmp,ytmp,'blue', ...
            xtmp,ytmp,xtmp,ytmp,xtmp,ytmp,xtmp,ytmp,xtmp,ytmp, ...
            xtmp,ytmp,xtmp,ytmp,xtmp,ytmp,xtmp,ytmp,xtmp,ytmp, ...
            xtmp,ytmp,xtmp,ytmp,xtmp,ytmp,xtmp,ytmp,xtmp,ytmp, ...
            xtmp,ytmp,xtmp,ytmp,xtmp,ytmp);
        h=legend('X', 'Y', 'Z', ... 
            '$$\textrm{100 pT}/\sqrt{\textrm{Hz}}$$', ...
            '$$\textrm{50 pT}/\sqrt{\textrm{Hz}}$$', ...
            '$$\textrm{20 pT}/\sqrt{\textrm{Hz}}$$', ...
            '$$\textrm{17 pT}/\sqrt{\textrm{Hz}}$$', ...
            '$$\textrm{15 pT}/\sqrt{\textrm{Hz}}$$', ...
            '$$\textrm{13 pT}/\sqrt{\textrm{Hz}}$$', ...
            '$$\textrm{12 pT}/\sqrt{\textrm{Hz}}$$', ...
            '$$\textrm{11 pT}/\sqrt{\textrm{Hz}}$$', ...
            '$$\textrm{10 pT}/\sqrt{\textrm{Hz}}$$', ...
            '$$\textrm{9 pT}/\sqrt{\textrm{Hz}}$$', ...
            '$$\textrm{8 pT}/\sqrt{\textrm{Hz}}$$', ...
            '$$\textrm{7 pT}/\sqrt{\textrm{Hz}}$$', ...
            '$$\textrm{6 pT}/\sqrt{\textrm{Hz}}$$', ...
            '$$\textrm{5 pT}/\sqrt{\textrm{Hz}}$$', ...
            '$$\textrm{4 pT}/\sqrt{\textrm{Hz}}$$', ...
            '$$\textrm{3 pT}/\sqrt{\textrm{Hz}}$$', ...
            '$$\textrm{2 pT}/\sqrt{\textrm{Hz}}$$', ...
            '$$\textrm{1 pT}/\sqrt{\textrm{Hz}}$$');
        set(h,'Interpreter','LaTex')
        plotHandles.aw.XLabel.String = 'Frequency (Hz)';
        plotHandles.aw.YLabel.Interpreter = 'LaTex';
        plotHandles.aw.YLabel.String = '$$\textrm{PSD }nT^2/Hz$$';
        grid(plotHandles.aw, 'on');
        axis(plotHandles.aw, [0.1 assumedSamplingRate/2 1e-6 1e1]);
    else
        % custom plot, reset graph
        plotHandles.aw.XLabel.String = '';
        plotHandles.aw.YLabel.String = '';
        plotHandles.aw.YLabel.Interpreter = 'tex';
        grid(plotHandles.aw, 'off');
        axis(plotHandles.aw, [0 10 0 10]);
        s = findobj('tag','legend');
        delete(s)
        plotHandles.lnw = plot(0,0);
    end
end