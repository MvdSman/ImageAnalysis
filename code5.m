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

%% images input iterations
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

% mutant
[prop_matM, animM, labsM] = getProps(mutseq);
d_matM = getDist(prop_matM);
d_mat2M = cellFilter(d_matM);
[cell_seqsM, cell_coordsM, target_testM, target_overlayM] = tracker(d_mat2M, prop_matM, animM, mutseq);

%% dipimages to gifs iterations
for i = 1:length(target_overlayC)
  tracks1{i} = target_overlayC{i}{1};
  tracks2{i} = target_overlayM{i}{1};
end
dipToGif(tracks1, 'tracks_control.gif', 0.1)
dipToGif(tracks2, 'tracks_mutant.gif', 0.1)

%% export data to csv
csvwrite('data_control.csv', target_testC);
csvwrite('data_mutant.csv', target_testM);

%% summarise data

[~,Ci,~] = unique(Cgroups,'first'); %get index of first instance of each cell
[~,Mi,~] = unique(Mgroups,'first'); %get index of first instance of each cell
Cgroups = findgroups(target_testC(:, 1)); %group the matrix per tracked cell: list of target ID groups
Mgroups = findgroups(target_testM(:, 1)); %group the matrix per tracked cell: list of target ID groups

%meanDistC = splitapply(@mean,target_testC(:,7), Cgroups); %apply function
%to value per group (mean per cell). gets mean distance per cell

% get mean of mean distances to compare mutant with control
meanDistC = mean(target_testC(Ci,11));
meanDistM = mean(target_testM(Mi,11));

boxplot(target_testC(:,7),Cgroups)
title('Distance per frame by tracked cell')
suptitle('Control group')
xlabel('Tracked cell')
ylabel('Distance')
width=500;
height=400;
set(gcf,'Position',[50,50,width,height])
saveas(gcf,'meanDistC.png');

boxplot(target_testM(:,7),Mgroups)
title('Distance per frame by tracked cell')
suptitle('Mutant group')
xlabel('Tracked cell')
ylabel('Distance')
width=500;
height=400;
set(gcf,'Position',[50,50,width,height])
saveas(gcf,'meanDistM.png');

% get mean convexity of all cells throughout time to compare mutant with control
meanConvC = mean(target_testC(:,6));
meanConvM = mean(target_testM(:,6));

boxplot(target_testC(:,6),Cgroups)
title('Convexity per frame by tracked cell')
suptitle('Control group')
xlabel('Tracked cell')
ylabel('Convexity')
width=500;
height=300;
set(gcf,'Position',[50,50,width,height])
saveas(gcf,'meanConvC.png');

target_testM2 = target_testM(:,6);
target_testM2(target_testM2==0) = nan;
boxplot(target_testM2,Mgroups)
title('Convexity per frame by tracked cell')
suptitle('Mutant group')
xlabel('Tracked cell')
ylabel('Convexity')
width=500;
height=300;
set(gcf,'Position',[50,50,width,height])
saveas(gcf,'meanConvM.png');

% get mean size of all cells throughout time to compare mutant with control
meanSizeC = mean(target_testC(:,5));
meanSizeM = mean(target_testM(:,5));

boxplot(target_testC(:,5),Cgroups)
title('Size per frame by tracked cell')
suptitle('Control group')
xlabel('Tracked cell')
ylabel('Size')
width=500;
height=300;
set(gcf,'Position',[50,50,width,height])
saveas(gcf,'meanSizeC.png');

target_testM2 = target_testM(:,5);
target_testM2(target_testM2==0) = nan;
boxplot(target_testM2,Mgroups)
title('Size per frame by tracked cell')
suptitle('Mutant group')
xlabel('Tracked cell')
ylabel('Size')
width=500;
height=300;
set(gcf,'Position',[50,50,width,height])
saveas(gcf,'meanSizeM.png');

% get all datapoints to compare correlation of speed, convexity and size
alldata = [[zeros(length(target_testC),1) target_testC];[ones(length(target_testM),1) target_testM]];
allcells = findgroups(alldata(:, 2)); % get group of each cell
allgroups = findgroups(alldata(:, 1)); % get group of each group

% create multiple small histograms
subplot(3,4,1);
alldata2 = alldata(:,7);
alldata2(alldata2==0) = nan;
hist(alldata2,35)
title('Convexity')

subplot(3,4,2);
hist(alldata(:,8),35)
title('Distance')

subplot(3,4,3);
hist(alldata(:,12),35)
title('Distance mean')

subplot(3,4,4);
hist(alldata(:,6),35)
title('Size')

subplot(3,4,5);
alldata2 = alldata(allgroups==1,7);
alldata2(alldata2==0) = nan;
hist(alldata2,35)
title('Convexity control')

subplot(3,4,6);
hist(alldata(allgroups==1,8),35)
title('Distance control')

subplot(3,4,7);
hist(alldata(allgroups==1,12),35)
title('Distance mean control')

subplot(3,4,8);
hist(alldata(allgroups==1,6),35)
title('Size control')

subplot(3,4,9);
alldata2 = alldata(allgroups==2,7);
alldata2(alldata2==0) = nan;
hist(alldata2,35)
title('Convexity mutant')

subplot(3,4,10);
hist(alldata(allgroups==2,8),35)
title('Distance mutant')

subplot(3,4,11);
hist(alldata(allgroups==2,12),35)
title('Distance mean mutant')

subplot(3,4,12);
hist(alldata(allgroups==2,6),35)
title('Size mutant')

width=650;
height=450;
set(gcf,'Position',[50,50,width,height])
saveas(gcf,'smallMultiples.png');

[R, P] = corrcoef(alldata(:,[6, 7, 8, 12])); % get correlation matrix size, conv, dist, mean_dist and p-values

scatter(alldata(:,6),alldata(:,8))
title('Distance against Size for all cells')
xlabel('Size')
ylabel('Distance')
width=500;
height=500;
set(gcf,'Position',[50,50,width,height])
saveas(gcf,'scatAllDistSize.png');

scatter(alldata(:,6),alldata(:,8))
hold on
plot(fittedmodel1)
title('Distance against Size for all cells')
xlabel('Size')
ylabel('Distance')
width=500;
height=500;
set(gcf,'Position',[50,50,width,height])
saveas(gcf,'scatDistSizeFitted.png');
hold off

gscatter(alldata(:,6),alldata(:,8), allgroups) % scatterplot per group
title('Distance against Size for all cells in either control or mutant group')
xlabel('Size')
ylabel('Mean distance')
width=500;
height=500;
set(gcf,'Position',[50,50,width,height])
saveas(gcf,'scatAllGroupedDistSize.png');
