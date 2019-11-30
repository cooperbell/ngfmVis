[Ax, f, ENBW] = welchAmpSpectrum( magData(1,:), assumedSamplingRate, nfft );
[Ay, f, ENBW] = welchAmpSpectrum( magData(2,:), assumedSamplingRate, nfft );
[Az, f, ENBW] = welchAmpSpectrum( magData(3,:), assumedSamplingRate, nfft );

[maxValy, maxIndexy] = max(Ay(3:nfft/2,:));
[maxValx, maxIndexx] = max(Ax(3:nfft/2,:));
[maxValz, maxIndexz] = max(Az(3:nfft/2,:));

handles.lnw(1).XData = f(3:nfft/2,:);
handles.lnw(1).YData = Ax(3:nfft/2,:);

handles.lnw(2).XData = f(3:nfft/2,:);
handles.lnw(2).YData = Ay(3:nfft/2,:);

handles.lnw(3).XData = f(3:nfft/2,:);
handles.lnw(3).YData = Az(3:nfft/2,:);

text(handles.aw, 0.11, 1.2e-4, ['ENBW = ', num2str(ENBW), ...
    ' Signal amplitude is correct. Noise floor varies with NFFT'], ...
    'BackgroundColor',[.7 .9 .7]);

set(handles.xamp,'String',sprintf('%3.3f',maxValx));
set(handles.yamp,'String',sprintf('%3.3f',maxValy));
set(handles.zamp,'String',sprintf('%3.3f',maxValz));

set(handles.xfreq,'String',sprintf('%3.3f',f(maxIndexx+2)));
set(handles.yfreq,'String',sprintf('%3.3f',f(maxIndexy+2)));
set(handles.zfreq,'String',sprintf('%3.3f',f(maxIndexz+2)));