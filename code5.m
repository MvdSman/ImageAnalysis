%run('C:\Program Files\DIPimage 2.9\dipstart.m') % run the following command in Windows devices
run('E:\Program Files\MATLAB\R2018a\toolbox\DIPimage 2.9\dipstart.m') % run the following command in Windows devices
%dipimage % uncomment (ctrl-T) to open dipimage GUI
%close all % to close all 6 figures dipimage initialises

% 5.1
% E:\Program Files\MATLAB\IAM\IA_images file location Mark PC
numfiles = 30;
seq = cell(1, numfiles);
files = dir('*ctrl*.*');
for i = 1:numfiles
  myfilename = files(i).name;
  seq{i} = readim(myfilename);
  seq{i} = seq{i}{1};
end
clearvars myfilename;
ctrlseq = seq; % control sequence
clear seq;

seq = cell(1, numfiles);
files = dir('*EGF*.*');
for i = 1:numfiles
  myfilename = files(i).name;
  seq{i} = readim(myfilename);
  seq{i} = seq{i}{1};
end
clearvars myfilename numfiles i;
mutseq = seq; % mutant sequence
clear seq files;

[prop_matC, animC, labsC] = getProps(ctrlseq);
d_matC = getDist(prop_matC);
d_mat2C = cellFilter(d_matC);
[cell_seqsC, cell_coordsC, target_testC, target_overlayC] = tracker(d_mat2C, prop_matC, animC, ctrlseq);

[prop_matM, animM, labsM] = getProps(mutseq);
d_matM = getDist(prop_matM);
d_mat2M = cellFilter(d_matM);
[cell_seqsM, cell_coordsM, target_testM, target_overlayM] = tracker(d_mat2M, prop_matM, animM, mutseq);

for i = 1:length(target_overlayC)
  tracks{i} = target_overlayC{i}{1};
end
dipToGif(tracks, 'tracks_control.gif', 0.1)

for i = 1:length(target_overlayM)
  tracks{i} = target_overlayM{i}{1};
end
dipToGif(tracks, 'tracks_mutant.gif', 0.1)
