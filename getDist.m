function [ dmatrix ] = getDist( properties )
%UNTITLED Cell tracker for n cells which can optionally draw the tracks
%   properties = properties data from tracker, ids = seq of cells to
%   track, animation = all frames with overlays
frames = length(properties);
dmatrix = {1:frames};
% seqCells = {length(properties{1}),1:frames};
disp(['start']);

%initialize with first image
frame = properties{1};
cells = length(frame);
distances(1:cells, 1:7) = 0; %distances(cell.ID, prev.ID, Euclid., x, y, size difference, convexity difference)
for j = 1:cells
    distances(j, 1) = j;
    distances(j, 2) = j;
    distances(j, 3) = 0;
    distances(j, 4) = properties{1}(j,2,:);
    distances(j, 5) = properties{1}(j,3,:);
    distances(j, 6) = 0;
    distances(j, 7) = 0;
    
%     seqCells(j, i) = j;
end

dmatrix{1} = distances;
clear distances;

disp(['end of itereation 1'])

%get differences per cell per frame
for i = 2:frames
    frame = properties{i};
    cells = length(frame);
    distances(1:cells, 1:7) = 0; % distances(cell.ID, prev.ID, Euclid., x, y, size difference, convexity difference)
    for j = 1:cells
        x = abs(properties{i}(j,2,:) - properties{i-1}(:,2,:));
        y = abs(properties{i}(j,3,:) - properties{i-1}(:,3,:));
        d = sqrt(x.^2+y.^2);
        prev_id = properties{i-1}(d==min(d),1,:);
        dSize = properties{i}(j,4,:) - properties{i-1}(prev_id,4,:);
        dConvex = properties{i}(j,5,:) - properties{i-1}(prev_id,5,:);
        
        distances(j, 1) = j;
        distances(j, 2) = prev_id;
        distances(j, 3) = min(d);
        distances(j, 4) = properties{i}(j,2,:);
        distances(j, 5) = properties{i}(j,3,:);
        distances(j, 6) = dSize;
        distances(j, 7) = dConvex;
        
%         if ismember(prev_id, seqCells(j-1,:) 
%             seqCells(j, i) = prev_id;
%         end
    end
    
    dmatrix{i} = distances;
    clear distances;
    disp(['end of iteration ' string(i)])
end
disp(['end'])

%%%TODO:
%track x/y for all lines per cell:
%output lines to animation sequence
%per animation iterate the line sequence

% target = dmatrix{1}(prp_mat{1}(:,1))

% name variables
% colNames = {'ID','prev_ID','Distance','x','y'};
% TTtt = array2table(t{1},'VariableNames',colNames);
end