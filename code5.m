% run('C:\Program Files\DIPimage 2.9\dipstart.m') % run the following command in Windows devices
% run('E:\Program Files\MATLAB\R2018a\toolbox\DIPimage 2.9\dipstart.m') % run the following command in Windows devices
% dipimage % uncomment (ctrl-T) to open dipimage GUI
% close all % to close all 6 figures dipimage initialises

% 5.1
% E:\Program Files\MATLAB\IAM\IA_images file location Mark PC
numfiles = 30;
ctrlseq = cell(1, numfiles); % control sequence
mutseq = cell(1, numfiles); % mutant sequence
filesC = dir('*ctrl*.*');
filesM = dir('*EGF*.*');
% images input iterations
for i = 1:numfiles
  myfilenameC = filesC(i).name;
  myfilenameM = filesM(i).name;
  ctrlseq{i} = readim(myfilenameC);
  ctrlseq{i} = ctrlseq{i}{1};
  mutseq{i} = readim(myfilenameM);
  mutseq{i} = mutseq{i}{1};
end
clearvars myfilenameC myfilenameM filesC filesM numfiles i;

% control
[prop_matC, animC, labsC] = getProps(ctrlseq);
d_matC = getDist(prop_matC);
d_mat2C = cellFilter(d_matC);
[cell_seqsC, cell_coordsC, target_testC, target_overlayC] = tracker(d_mat2C, prop_matC, animC, ctrlseq);

%mutant
[prop_matM, animM, labsM] = getProps(mutseq);
d_matM = getDist(prop_matM);
d_mat2M = cellFilter(d_matM);
[cell_seqsM, cell_coordsM, target_testM, target_overlayM] = tracker(d_mat2M, prop_matM, animM, mutseq);

% dipimages to gifs iterations
for i = 1:length(target_overlayC)
  tracks1{i} = target_overlayC{i}{1};
  tracks2{i} = target_overlayM{i}{1};
end
dipToGif(tracks1, 'tracks_control.gif', 0.1)
dipToGif(tracks2, 'tracks_mutant.gif', 0.1)
