function [  ] = dipToGif( imageCell, fileName, time)
%dipToGif imageCell: cell array of dipimages, fileName: 'something.gif'
%   time: recommended to 0.1 (that's miliseconds)

for i = 1:numel(imageCell)
    imageCell{i} = uint8(imageCell{i});
    if i == 1
%// For 1st image, start the 'LoopCount'.
        imwrite(imageCell{i},fileName,'gif','LoopCount',Inf,'DelayTime',time);
    else
        imwrite(imageCell{i},fileName,'gif','WriteMode','append','DelayTime',time);
    end
end
end