function [ t_proc ] = cellFilter( t )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
t_proc = {1:length(t)};
for frame = 1:length(t)
    A = t{frame}(:,2);
    [uniqueA i j] = unique(A,'first');
    indexToDupes = find(not(ismember(1:numel(A),i)));
    udupA = unique(A(indexToDupes));
    A(ismember(A,udupA));

    differences(1:length(A),1:6) = 0;
    for i = 1:length(A)
        if ismember(t{frame}(i,2),udupA)
            dist = t{frame}(i,3);
            dSiz =  t{frame}(i,6);
            dConv =  t{frame}(i,7);
            feature = sum([abs(dist), abs(dSiz), abs(dConv)]);
            differences(i,:) = [i, t{frame}(i,2), dist, dSiz, dConv, feature];
        end
    end

    d2 = differences(differences(:,1)~=0,:);
    d2 = sortrows(d2, [1,6]);

    [uniqueB i j] = unique(d2(:,2),'first');
    d3 = d2(i,:); %
    d_dup = d2(not(ismember(d2(:,1),d3(:,1))),:);

    t_proc{frame} = t{frame};
    t_proc{frame}(d_dup(:,1),2) = 0;
end
end

