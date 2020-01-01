[Px, f, ENBW] = welchPSDSpectrum( magData(1,:), assumedSamplingRate, nfft );
[Py, f, ENBW] = welchPSDSpectrum( magData(2,:), assumedSamplingRate, nfft );
[Pz, f, ENBW] = welchPSDSpectrum( magData(3,:), assumedSamplingRate, nfft );

ref500pt = ((0.500)^2)./f;
ref300pt = ((0.300)^2)./f;
ref200pt = ((0.200)^2)./f;
ref100pt = ((0.100)^2)./f;
ref50pt = ((0.050)^2)./f;
ref30pt = ((0.030)^2)./f;
ref20pt = ((0.020)^2)./f;
ref17pt = ((0.017)^2)./f;
ref15pt = ((0.015)^2)./f;
ref13pt = ((0.013)^2)./f;
ref12pt = ((0.012)^2)./f;
ref11pt = ((0.011)^2)./f;
ref10pt = ((0.010)^2)./f;
ref9pt = ((0.009)^2)./f;
ref8pt = ((0.008)^2)./f;
ref7pt = ((0.007)^2)./f;
ref6pt = ((0.006)^2)./f;
ref5pt = ((0.005)^2)./f;
ref4pt = ((0.004)^2)./f;
ref3pt = ((0.003)^2)./f;
ref2pt = ((0.002)^2)./f;
ref1pt = ((0.001)^2)./f;

% update line data
handles.lnw(1).XData = f(3:nfft/2,:);
handles.lnw(1).YData = Px(3:nfft/2,:);

handles.lnw(2).XData = f(3:nfft/2,:);
handles.lnw(2).YData = Py(3:nfft/2,:);

handles.lnw(3).XData = f(3:nfft/2,:);
handles.lnw(3).YData = Pz(3:nfft/2,:);

handles.lnw(4).XData = f(3:nfft/2,:);
handles.lnw(4).YData = ref100pt(3:nfft/2,:);

handles.lnw(5).XData = f(3:nfft/2,:);
handles.lnw(5).YData = ref50pt(3:nfft/2,:);

handles.lnw(6).XData = f(3:nfft/2,:);
handles.lnw(6).YData = ref20pt(3:nfft/2,:);

handles.lnw(7).XData = f(3:nfft/2,:);
handles.lnw(7).YData = ref17pt(3:nfft/2,:);

handles.lnw(8).XData = f(3:nfft/2,:);
handles.lnw(8).YData = ref15pt(3:nfft/2,:);

handles.lnw(9).XData = f(3:nfft/2,:);
handles.lnw(9).YData = ref13pt(3:nfft/2,:);

handles.lnw(10).XData = f(3:nfft/2,:);
handles.lnw(10).YData = ref12pt(3:nfft/2,:);

handles.lnw(11).XData = f(3:nfft/2,:);
handles.lnw(11).YData = ref11pt(3:nfft/2,:);

handles.lnw(12).XData = f(3:nfft/2,:);
handles.lnw(12).YData = ref10pt(3:nfft/2,:);

handles.lnw(13).XData = f(3:nfft/2,:);
handles.lnw(13).YData = ref9pt(3:nfft/2,:);

handles.lnw(14).XData = f(3:nfft/2,:);
handles.lnw(14).YData = ref8pt(3:nfft/2,:);

handles.lnw(15).XData = f(3:nfft/2,:);
handles.lnw(15).YData = ref7pt(3:nfft/2,:);

handles.lnw(16).XData = f(3:nfft/2,:);
handles.lnw(16).YData = ref6pt(3:nfft/2,:);

handles.lnw(17).XData = f(3:nfft/2,:);
handles.lnw(17).YData = ref5pt(3:nfft/2,:);

handles.lnw(18).XData = f(3:nfft/2,:);
handles.lnw(18).YData = ref4pt(3:nfft/2,:);

handles.lnw(19).XData = f(3:nfft/2,:);
handles.lnw(19).YData = ref3pt(3:nfft/2,:);

handles.lnw(20).XData = f(3:nfft/2,:);
handles.lnw(20).YData = ref2pt(3:nfft/2,:);

handles.lnw(21).XData = f(3:nfft/2,:);
handles.lnw(21).YData = ref1pt(3:nfft/2,:);