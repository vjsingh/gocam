function [ fb,h ] = create_filter_bank( orientations, sigmas )
no=numel(orientations);
ns=numel(sigmas);
fb=cell(no,ns);


%must return a cell and a figure handle
h=figure, subplot(ns, no, ns*no); %use subplot to show the filters


%================================
%create filter bank at 
%multiple scales and orientations
%================================
hSize = [3 3];
for j=1:ns
    sigma = sigmas(j);
    gaussFilter = fspecial('gaussian', hSize, sigma);
    sobelFilter = fspecial('sobel');
    filter = conv2(gaussFilter, sobelFilter);
    for i=1:no
        rotatedFilter = imrotate(filter, orientations(i));
        fb{i, j} = rotatedFilter;
        p = ((j - 1) * no) + i;
        h = subplot(ns, no,  p);
        imagesc(rotatedFilter);
        colormap(gray);
    end
end
h = get(h, 'parent'); %Export entire figure
end



