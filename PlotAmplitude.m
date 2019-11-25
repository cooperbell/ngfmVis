[Ax, f, ENBW] = welchAmpSpectrum( magData(1,:), assumedSamplingRate, nfft );
[Ay, f, ENBW] = welchAmpSpectrum( magData(2,:), assumedSamplingRate, nfft );
[Az, f, ENBW] = welchAmpSpectrum( magData(3,:), assumedSamplingRate, nfft );

[maxValy, maxIndexy] = max(Ay(3:nfft/2,:));
[maxValx, maxIndexx] = max(Ax(3:nfft/2,:));
[maxValz, maxIndexz] = max(Az(3:nfft/2,:));

plotHandles.lnw(1).XData = f(3:nfft/2,:);
plotHandles.lnw(1).YData = Ax(3:nfft/2,:);

plotHandles.lnw(2).XData = f(3:nfft/2,:);
plotHandles.lnw(2).YData = Ay(3:nfft/2,:);

plotHandles.lnw(3).XData = f(3:nfft/2,:);
plotHandles.lnw(3).YData = Az(3:nfft/2,:);

text(plotHandles.aw, 0.11, 1.2e-4, ['ENBW = ', num2str(ENBW), ...
    ' Signal amplitude is correct. Noise floor varies with NFFT'], ...
    'BackgroundColor',[.7 .9 .7]);

set(plotHandles.xamp,'String',sprintf('%3.3f',maxValx));
set(plotHandles.yamp,'String',sprintf('%3.3f',maxValy));
set(plotHandles.zamp,'String',sprintf('%3.3f',maxValz));

set(plotHandles.xfreq,'String',sprintf('%3.3f',f(maxIndexx+2)));
set(plotHandles.yfreq,'String',sprintf('%3.3f',f(maxIndexy+2)));
set(plotHandles.zfreq,'String',sprintf('%3.3f',f(maxIndexz+2)));