function [ properties, animation, labeled ] = getProps( sequence, bool_draw )
%UNTITLED Cell tracker for n cells which can optionally draw the tracks
%   sequence = image cells, bool_draw draw trace or not
layers = length(sequence);
properties = {1:layers};
animation = {1:layers};
labeled = {1:layers};


%run with all other images in sequence
for i = 1:layers
    im = sequence{i};
    
    %threshold image
    [t_triangle,thres_triangle] = threshold(im,'triangle',Inf);
    t_triangle_open = opening(t_triangle,5,'elliptic');
    
    %get edges of objects and overlay
    t_dilated = dilation(t_triangle_open,3,'elliptic');
    t_edge = t_dilated-t_triangle_open;
    overlay1 = overlay(im, t_edge);
    
    %et extended maximum with percentile 95 and overlay
    perc_t_triangle_open = percentile(im*(im*t_triangle_open > 0), 95);
    t_emax = im > perc_t_triangle_open;
    overlay2 = overlay(overlay1, t_emax);

    %use grey-weighted distance to get brightest points
    [t_gw,t_dist] = gdt(t_triangle_open,im,3);
    t_distbin = t_dist > percentile(t_dist, 95);
    overlay3 = overlay(overlay1, t_distbin);

    %label centers and get properties
    t_lab = label(t_distbin,Inf,0,0);
    props(1:max(t_lab), 1:5) = 0; %props(cell.ID, x, y, size, convexity)
    msr = measure(t_lab,[],{'Size', 'Convexity'});
    
    for j = 1:max(t_lab)
        if length(findcoord(t_lab == j)) > 2
            x = mean(findcoord(t_lab == j));
        else
            x = findcoord(t_lab == j);
        end
        props(j, 1) = j;
        props(j, 2) = x(1);
        props(j, 3) = x(2);
        props(j, 4) = msr.Size(j);
        props(j, 5) = msr.Convexity(j);
    end
    
    %save
    properties{i} = props;
    animation{i} = overlay3;
    labeled{i} = t_lab;
    clear props;
end
end
