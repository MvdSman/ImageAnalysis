run('C:\Program Files\DIPimage 2.9\dipstart.m') % run the following command in Windows devices
% run('E:\Program Files\MATLAB\R2018a\toolbox\DIPimage 2.9\dipstart.m') % run the following command in Windows devices
% dipimage % uncomment (ctrl-T) to open dipimage GUI
% close all % to close all 6 figures dipimage initialises

% 5.1
numfiles = 10;
seq = cell(1, numfiles);
for i = 1:numfiles
  myfilename = sprintf('MTLn3-ctrl000%d.png', i-1);
  seq{i} = readim(myfilename);
  seq{i} = seq{i}{1};
end
clearvars myfilename numfiles;
[prop_mat anim] = getProps(seq, 1);
d_mat = getDist(prop_mat, 1, anim);
d_mat2 = cellFilter(d_mat);
[cell_seqs, cell_coords, target_coords, target_coordsfull, target_test] = tracker(d_mat2,prop_mat,anim,seq);
