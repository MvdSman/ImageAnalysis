function [ t_proc ] = cellFilter( t )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
t_proc = {1:length(t)}; %t_proc(ID, ID_prev, Euclidean dist, x, y, dSize, dConv, feature
for frame = 1:length(t)
    A = t{frame}(:,2); % all previous IDs
    B = t{frame}(:,1); % all current IDs
    [~, i, ~] = unique(A,'first'); % all unique first IDs
    indexToDupes = find(not(ismember(1:numel(A),i))); % indices of duplicate IDs
    udupA = unique(A(indexToDupes)); % unique duplicate IDs
    A(ismember(A,udupA));

    differences(1:length(B),1:6) = 0;
    for i = 1:length(B)
        if ismember(A(i),udupA)
            dist = t{frame}(i,3);
            dSize =  t{frame}(i,6);
            dConv =  t{frame}(i,7);
            feature = sum([abs(dist), abs(dSize), abs(dConv)]);
            differences(i,:) = [i, t{frame}(i,2), dist, dSize, dConv, feature];
        end
    end

    d2 = differences(differences(:,1)~=0,:);
    d2 = sortrows(d2, [2,6]);
    clear differences;
    
    [~, i, ~] = unique(d2(:,2),'first');
    d3 = d2(i,:);
    d_dup = d2(not(ismember(d2(:,1),d3(:,1))),:);

    t_proc{frame} = t{frame};
    t_proc{frame}(d_dup(:,1),2) = 0;
end
end

