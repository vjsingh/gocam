function [masks,masks_h]=gen_oriented_masks(g_orients,g_radii)
no=numel(g_orients);
nr=numel(g_radii);
%for each o and r, generate a PAIR of masks (left and right)
masks=cell(nr,no,2);

%for visualization, use subplot to show the masks
masks_h=figure, subplot(nr, no*2, nr*no*2); 

%================================
%create mask pairs at 
%multiple scales and orientations
%================================
for i=1:nr
    radius = g_radii(i);
    diameter = 2*radius;
    origin = radius + 0.5;
    circle = zeros(diameter, diameter);
    for x=1:diameter
        for y=1:diameter
            myDistance = distance(x, y, origin, origin);
            if myDistance <= radius
                circle(x, y) = 1;
            end
        end
    end
    circle = [circle(:, 1:radius) zeros(diameter, radius)];
    
    % Double the number of orientations, so 2 loops for each pair
    % On odd js, make left mask. On evens, do right
    for j=1:(no*2)
        realJ = uint8(j/2); % The orientation we're actually at, round up
        isLeftSide = false;
        if (mod(j, 2) == 1)
            isLeftSide = true;
        end
        orientation = g_orients(realJ); 
        rotatedMask = imrotate(circle, orientation);
        if (isLeftSide)
            masks{i, realJ, 1} = rotatedMask;
        else
            rotatedMask = imrotate(rotatedMask, 180);
            masks{i, realJ, 2} = rotatedMask;
        end
        
        p = ((i - 1) * no * 2) + j;
        masks_h = subplot(nr, no*2, p);
        imagesc(rotatedMask);
        colormap(gray);
    end
end

masks_h = get(masks_h, 'parent'); %Export entire figure

end
