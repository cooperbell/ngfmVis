index = linspace(0,secondsToDisplay,numSamplesToDisplay);
subplot('position', [0.11 0.70 0.39 0.25]);
plotHandles.px = plot(index, magData(1,numSamplesToStore-numSamplesToDisplay+1:numSamplesToStore), 'red');
% set(gca,'YTickLabel',num2str(get(gca,'YTick').'));
% L = get(gca,'XLim');
% set(gca,'XTick',linspace(L(1),L(2),NumXTicks))
% L = get(gca,'YLim');
% set(gca,'YTick',linspace(L(1),L(2),NumYTicks))
ylabel('Bx (nT');

subplot('position', [0.11 0.40 0.39 0.25]);
plotHandles.py = plot(index, magData(2,numSamplesToStore-numSamplesToDisplay+1:numSamplesToStore), 'green');
% set(gca,'YTickLabel',num2str(get(gca,'YTick').'));
% L = get(gca,'XLim');
% set(gca,'XTick',linspace(L(1),L(2),NumXTicks))
% L = get(gca,'YLim');
% set(gca,'YTick',linspace(L(1),L(2),NumYTicks))
ylabel('By (nT');

subplot('position', [0.11 0.10 0.39 0.25]);
plotHandles.pz = plot(index, magData(3,numSamplesToStore-numSamplesToDisplay+1:numSamplesToStore), 'blue');
% set(gca,'YTickLabel',num2str(get(gca,'YTick').'));
% L = get(gca,'XLim');
% set(gca,'XTick',linspace(L(1),L(2),NumXTicks))
% L = get(gca,'YLim');
% set(gca,'YTick',linspace(L(1),L(2),NumYTicks))
ylabel('Bz (nT');
xlabel('Time (s)');