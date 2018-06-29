% run('C:\Program Files\DIPimage 2.9\dipstart.m') % run the following command in Windows devices
% run('E:\Program Files\MATLAB\R2018a\toolbox\DIPimage 2.9\dipstart.m') % run the following command in Windows devices
% dipimage % uncomment (ctrl-T) to open dipimage GUI
% close all % to close all 6 figures dipimage initialises

% 6.1

% Preallocation
n_images = 58;
[absolute_blue, relative_blue] = deal(zeros(1,n_images));
[images, filt, masked, m] = deal(cell(1, n_images));
[texture, measurements] = deal(zeros(n_images, 4));


% Read files
numfiles = 58;
pf = 'w8t1t2_d7_';
sf = '.tif';
for i = 1:numfiles
%     index = num2str(i);
    originals{i} = readim(strcat(pf, num2str(i), sf));
end
clearvars pf sf i;
% originals{1} % test
% use linear stretch to view the images

for i = 1:numfiles
    % 6.1
    filt{i} = threshold(originals{i}{3}, 'isodata', Inf);
    filt{i} = bclosing(filt{i}, 2, -1, -1);
    
    % 6.3
    % Size and color measurements
    % Column values of [measurements] matrix: 
    % 1: Size; 
    % 2: Perimeter; 
    % 3: Blueness(absolute);  
    % 4: Blueness(relative);
    % 5: Elongation
    % 6: Assigned class (K-means) based on shape/blueness
    % 7: Assigned class (K-means) based on texture

    m{i} = measure(squeeze(filt{i}),[],{'Size','Perimeter','Feret','ConvexArea','P2A','PodczeckShapes','Convexity'},[],Inf,0,0);
    [measurements(i,1), index] = max(m{i}.Size);
    measurements(i,2) = max(m{i}.Perimeter);
    R = measure(filt{i},originals{i}{1},{'Mean','Sum'},[],Inf,0,0);
    G = measure(filt{i},originals{i}{2},{'Mean','Sum'},[],Inf,0,0);
    B = measure(filt{i},originals{i}{3},{'Mean','Sum'},[],Inf,0,0);
    measurements(i,3) = max(B.Sum);
    measurements(i,4) = measurements(i,3)/(max(R.Sum) + max(G.Sum) + max(B.Sum));
    measurements(i,5) = m{i}.PodczeckShapes(5,index);
    
end


% Clustering
species = kmeans(measurements, 3);
species2 = kmeans(texture, 3);
measurements = [measurements species];
measurements = [measurements species2];


% 6.2
figure
for i = 1:numfiles
    subplot(4,15,i); %
    imshow(dip_array(filt{i})*255);
    drawnow
end
