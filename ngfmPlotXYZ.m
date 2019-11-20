index = linspace(0,secondsToDisplay,numSamplesToDisplay);
subplot('position', [0.11 0.70 0.39 0.25]);
plotHandles.px = plot(index, magData(1,numSamplesToStore-numSamplesToDisplay+1:numSamplesToStore), 'red');
ylabel('Bx (nT');

subplot('position', [0.11 0.40 0.39 0.25]);
plotHandles.py = plot(index, magData(2,numSamplesToStore-numSamplesToDisplay+1:numSamplesToStore), 'green');
ylabel('By (nT');

subplot('position', [0.11 0.10 0.39 0.25]);
plotHandles.pz = plot(index, magData(3,numSamplesToStore-numSamplesToDisplay+1:numSamplesToStore), 'blue');
ylabel('Bz (nT');
xlabel('Time (s)');