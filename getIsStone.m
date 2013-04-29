% 0 black, 1 white, 2 neither
% Based off http://www.mathworks.com/matlabcentral/newsreader/view_thread/280868
function [isStone] = getIsStone(image, xc, yc, r, lowThreshold, highThreshold)

isStone = 2;

% Engine
%y=1:size(image,1);
%x=1:size(image,2);
%[X Y]=meshgrid(x,y);

% This assume the circle falls *entirely* inside the image
%R2 = (X-xc).^2+(Y-yc).^2;
%c = contourc(x,y,R2,[0 0]+r^2);
%c = round(c(:,2:end)); % pixels located ~ on circle
%imagec = image(sub2ind(size(image),c(2,:),c(1,:))); % extract value
[x y] = circlepoints(r);
pixelSum = 0;
for i=1:length(x)
    for j=1:length(y)
        circleX = x(i);
        circleY = y(j);
        pixelSum = pixelSum + image(xc+circleX,yc+circleY);
    end
end
    
%val = mean(imagec) % mean
val = pixelSum / (length(x) * length(y)); % mean

if val < lowThreshold
    isStone = 0;
elseif val > highThreshold
    isStone = 1;
end