%run('C:\Program Files\DIPimage 2.9\dipstart.m') % run the following command in Windows devices
run('E:\Program Files\MATLAB\R2018a\toolbox\DIPimage 2.9\dipstart.m') % run the following command in Windows devices
dipimage % uncomment (ctrl-T) to open dipimage GUI
close all % to close all 6 figures dipimage initialises

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
[cell_seqsC, cell_coordsC, target_coordsC, target_coordsfullC, target_testC, target_overlayC] = tracker(d_mat2C, prop_matC, animC, ctrlseq);
