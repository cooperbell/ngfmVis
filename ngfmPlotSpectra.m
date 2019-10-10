% Spectra plot setup
subplot('position', [0.55 0.10 0.39 0.85]);
global spectra;
% graph plot
run(spectra)


% % open file
% read_fid = fopen('/Users/cooperbell/Misc/external_script/PlotPSD1.m');
% 
% % make temp folder
% tmp = tempname;
% mkdir(tmp);
% 
% % Write MATLAB code to a file in the folder.
% newFile = fullfile(tmp,'ANewFile.m');
% write_fid = fopen(newFile,'w');
% 
% % read file and write to temp file in our directory
% tline = fgets(read_fid);
% while ischar(tline)
%     fprintf(write_fid,tline);
%     tline = fgets(read_fid);
% end
% fclose(read_fid);
% fclose(write_fid);
% 
% %Run the script.
% 
% run(newFile)
% 
% % if (strcmp(spectra,'psd'))
% %     PlotPSD;
% % else
% %     run('PlotAmplitude.m')
% %     %PlotAmplitude;
% % end