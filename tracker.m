function [seqCells, coords, target_coords, target_coordsfull, target_test] = tracker(d_matrix, prop_matrix, anim, seq)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

frames = length(d_matrix);
seqCells(1:length(d_matrix{1}),1:frames) = 0;
seqCells(:,1) = 1:length(d_matrix{1});
coords = {1:frames};
coords_fr(1:3, 1:length(prop_matrix{1})) = 0; %coords_fr([x, y], cell.ID)
coords_fr(1,:) = 1:length(prop_matrix{1});
coords_fr(2,:) = prop_matrix{1}(:,2);
coords_fr(3,:) = prop_matrix{1}(:,3);
coords{1} = coords_fr;
clear coords_fr;

for frame = 2:frames
    features = d_matrix{frame};
    props = prop_matrix{frame};
    cells = length(features);
    coords_fr(1:3, 1:cells) = 0; %coords_fr([x, y], cell.ID)
    prev_length = length(seqCells);
    c = 1;
    for i = 1:cells
        curr_id = features(i,1,:);
        prev_id = features(i,2,:);
        if prev_id ~= 0 
            seqCells(prev_id, frame) = curr_id; %assign current id to existing cell if previous id is found
        else
            seqCells(prev_length+c, frame) = curr_id; %assign this id to a new cell
            c = c+1;
        end
    end
    coords_fr(1,:) = 1:cells;
    coords_fr(2,:) = prop_matrix{frame}(:,2);
    coords_fr(3,:) = prop_matrix{frame}(:,3);
    coords{frame} = coords_fr;
    clear coords_fr;
end

seqCells(:,frames+1) = 0;
for i = 1:length(seqCells)
    seqCells(i,frames+1) = sum(seqCells(i,:,:)==0)-1; %count the amount of zeros: 0 zeros means a cell exists in EVERY FRAME
end

% CELLS THAT ARE POSSIBLE TARGETS:
target = seqCells(seqCells(:,11)==0);
target = target(1:10);
target_tracked = seqCells(target,:);
target_coords = {1:frames};
for i = 1:frames
    target_coords{i} = coords{i}(:,target_tracked(:,i));
end

target_coordsfull = cell2mat(target_coords);


% CREATE FULL TABLE WITH DATA
cells = length(target);
nrows = cells * frames;
idseq = target_tracked(1:10,1);
target_test(1:nrows, 1:9) = 0; %target_test(ID_start, ID_tracked, x, y, size, convexity, dist, dist_total, speed_mean)
target_test(1:nrows, 1) = repelem(idseq,frames); %assign ID_start

c = 1;
for i = 1:frames
    rows = 10*i;
    target_id = target_tracked(i, 1:10)' %get ID_tracked
    target_id2 = target_tracked(1:10,i) %get ID_tracked for one frame
    target_test(c:rows, 2) = target_id; %assign ID_tracked
    for j = 1:cells
        c2 = 10*(j-1) + i;
        target_props = prop_matrix{i}(target_id2(j), 2:5) %get x, y, Size and Convexity
        target_test(c2, 3:6) = target_props; %assign x, y, Size and Convexity per cell per frame
    end
    c = c+10;
end

end


%% TODO: DRAW PATH OF CELLS
% get indices per cell sequence
% counterx(1:10,1:10) = 0;
% countery(1:10,1:10) = 0;
% cz = 1;
% for c = [2,5,8,11,14,17,20,23,26,29]
%     cx = c;
%     cy = c+1;
%     for i = 0:9;
%         counterx(i+1,cz) = cx + i*30;
%         countery(i+1,cz) = cy + i*30;
%     end
%     cz = cz+1;
% end
% 
% 
% % draw paths
% test = cell2mat(target_coords);
% testoverlay = anim;
% for i = 1:9
%     for cell = 1:10
%         c = i+1;
%         cx1 = counterx((i),cell);
%         cx2 = counterx((i),cell);
%         cy1 = countery((i+1),cell);
%         cy2 = countery((i+1),cell);
%         testoverlay{c} = drawline(testoverlay{c}, [round(test(cx1)),round(test(cy1))],[round(test(cx2)),round(test(cy2))], 255);
%     end
% end