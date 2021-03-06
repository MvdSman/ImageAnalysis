% run('C:\Program Files\DIPimage 2.9\dipstart.m') % run the following command in Windows devices
% run('E:\Program Files\MATLAB\R2018a\toolbox\DIPimage 2.9\dipstart.m') % run the following command in Windows devices
% dipimage % uncomment (ctrl-T) to open dipimage GUI
% close all % to close all 6 figures dipimage initialises

% Read files
numfiles = 58;
pf = 'w8t1t2_d7_';
sf = '.tif';
for i = 1:numfiles
    originals{i} = readim(strcat(pf, num2str(i), sf));
end
clearvars pf sf;
% originals{1} % test
% use linear stretch to view the images

% 6.1 (segmentation)
for i = 1:numfiles
    orig_filtered{i} = threshold(originals{i}{3}, 'isodata', Inf);
    orig_filtered{i} = bclosing(orig_filtered{i}, 2, -1, -1);
end

% 6.2 (4*15 panel)
figure
for i = 1:numfiles
    subplot(4,15,i); %
    imshow(dip_array(orig_filtered{i})*255);
    drawnow
end

% 6.3 (properties matrix)
for i = 1:numfiles
    % https://diplib.github.io/diplib-docs/classdip_1_1MeasurementTool.html
    % Size and color properties
    % Column values of properties matrix: 
    % 1: Size; 
    % 2: Perimeter; 
    % 3: Blueness(absolute);  
    % 4: Blueness(relative);
    % 5: Elongation

    m{i} = measure(squeeze(orig_filtered{i}),[],{'Size','Perimeter','Feret','ConvexArea','P2A','PodczeckShapes','Convexity'},[],Inf,0,0);
    properties(i,1) = max(m{i}.Size);
    properties(i,2) = max(m{i}.Perimeter);
    R = measure(orig_filtered{i},originals{i}{1},{'Mean','Sum'},[],Inf,0,0);
    G = measure(orig_filtered{i},originals{i}{2},{'Mean','Sum'},[],Inf,0,0);
    B = measure(orig_filtered{i},originals{i}{3},{'Mean','Sum'},[],Inf,0,0);
    properties(i,3) = max(B.Sum);
    properties(i,4) = properties(i,3)/(max(R.Sum) + max(G.Sum) + max(B.Sum));
    properties(i,5) = m{i}.PodczeckShapes(5);
end

clearvars R G B index i;
