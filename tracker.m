function [seqCells, coords, target_coords, target_coordsfull, target_test, testoverlay] = tracker(d_matrix, prop_matrix, anim, seq)
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
%for frame = 2:3
    features = d_matrix{frame};
    props = prop_matrix{frame};
    cells = length(features);
    coords_fr(1:3, 1:cells) = 0; %coords_fr([x, y], cell.ID)
    prev_length = length(seqCells);
    c = 1;
    for i = 1:cells
        curr_id = features(i,1,:);
        prev_id = features(i,2,:);
        index_id = seqCells(:, frame-1) == prev_id;
        if prev_id ~= 0 
            seqCells(index_id, frame) = curr_id; %assign current id to existing cell if previous id is found
        else
            seqCells(prev_length+c, frame) = curr_id; %assign this id to a new cell
            c = c+1;
        end
        clear index_id;
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

%% CELLS THAT ARE POSSIBLE TARGETS:
target = seqCells(seqCells(:,11)==0);
target = target(1:10);
target_tracked = seqCells(target,:);
target_coords = {1:frames};
for i = 1:frames
    target_coords{i} = coords{i}(:,target_tracked(:,i));
end

target_coordsfull = cell2mat(target_coords);


%% CREATE FULL TABLE WITH DATA
cells = length(target);
nrows = cells * frames;
idseq = target_tracked(1:cells,1);
target_test(1:nrows, 1:11) = 0; %target_test(ID_start, ID_tracked, x, y, size, convexity, Euclid dist, dSize, dConvexity, dist_total, speed_mean)
target_test(1:nrows, 1) = repelem(idseq,frames); %assign ID_start

c = 1;
for i = 1:frames
    rows = cells*i;
    target_id = target_tracked(i, 1:cells)'; %get ID_tracked
    target_id2 = target_tracked(1:cells,i); %get ID_tracked for one frame
    target_test(c:rows, 2) = target_id; %assign ID_tracked
    for j = 1:cells
        c2 = cells*(j-1) + i;
        target_props = prop_matrix{i}(target_id2(j), 2:5); %get x, y, Size and Convexity
        target_test(c2, 3:6) = target_props; %assign x, y, Size and Convexity per cell per frame
        target_props = d_matrix{i}(target_id2(j), [3,6,7]); %get Euclid dist, dSize and dConvexity
        target_test(c2, 7:9) = target_props; %assign Euclid dist, dSize and dConvexity per cell per frame
    end
    c = c+cells;
end

groups = findgroups(target_test(:, 1)); %group the matrix per tracked cell: list of target ID groups
meanDist = splitapply(@mean,target_test(:,7), groups); %apply function to value per group (mean per cell)

c = 0;
for i = 1:(frames*cells)
    if mod(i-1,10) == 0
        c = c+1; %cell identifier
    else
        target_test(i, 10) = target_test(i-1, 10) + target_test(i, 7); % total dist = previous dist + current dist
    end
    target_test(i, 11) = meanDist(c); %assign mean distance
end


% % draw paths
testoverlay = anim;
for cell = 1:cells
    groupid = groups==cell;
    coords = target_test(groupid, [3,4]);
    coords2 = [coords(1,1), coords(1, 2)];
    for i = 2:frames
        cx1 = coords(i, 1);
        cx2 = coords(i-1, 1);
        cy1 = coords(i, 2);
        cy2 = coords(i-1, 2);
        coords2 = [coords2; [cx1, cy1]];
        
%         c = i+1;
%         if i == 1
%             testoverlay{c} = drawline(testoverlay{i}, [round(cx1),round(cy1)],[round(cx2),round(cy2)], 255);
%         else
        testoverlay{i} = drawpolygon(testoverlay{i}, coords2);
%         end
    end
end



%% Draw labels
% testoverlay = anim;
% for cell = 1:cells
%     groupid = groups==cell;
%     coords = target_test(groupid, [3,4]);
%     for i = 1:frames
%         cx = coords(i, 1);
%         cy = coords(i, 2);
%         cx1 = cx - 1;
%         cx2 = cx + 1;
%         cy1 = cy - 1;
%         cy2 = cy - 1;
%         testoverlay{i} = overlay(testoverlay{i}, rectangle('Position',[cx1 cy1 cx2 cy2]));
%     end
% end




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




%line([coords(1,1),coords(2,1),coords(3,1),coords(4,1),coords(5,1),coords(6,1),coords(7,1),coords(8,1),coords(9,1),coords(10,1)],[coords(1,2),coords(2,2),coords(3,2),coords(4,2),coords(5,2),coords(6,2),coords(7,2),coords(8,2),coords(9,2),coords(10,2)])