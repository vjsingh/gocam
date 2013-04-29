%% Setup Variables

gridSize = 19; %Square

%imageFilename = 'board2.png';
%imageFilename = 'overhead1.jpg';
imageFilename = 'board1.jpg';

image = imread(strcat('./data/testset/', imageFilename));
image = im2double(image);
image = rgb2gray(image);

% For stones to be white or black
lowThreshold  = 0.3;
highThreshold = 0.65;

stoneRadiusLow = 10;
stoneRadiusHigh = 15;
stoneRadius = (stoneRadiusLow + stoneRadiusHigh) / 2;

% Margin that the outside GRID line must be from edge of BOARD
% (After projective transformation, we sometimes get lines at the edge
%  of the board, or on the outside of all the circles, if there are lots
%  of circles covering the outside grid line)
outsideGridLineMargin = 5;

%% Projective transformation given corners

newImageSize = 500; % Square
imshow(image);
% Corners are clockwise starting from topLeft
corners = ginput; % Uncomment to get corners input
corners = double(int64(corners));
%corners = [64 18; 454 32; 488 397; 13 381];
outputs = [0 0; newImageSize 0; newImageSize newImageSize; 0 newImageSize];
tform2 = maketform('projective', corners, outputs);
[projectedImage, xdata, ydata] = imtransform(image, tform2);

% Crop so we have just the game board
xShift = -int64(xdata(1));
yShift = -int64(ydata(1));
newCorners = [xShift yShift; xShift+newImageSize yShift; ...
              xShift yShift+newImageSize; ...
              xShift+newImageSize yShift+newImageSize];
cropRect = double([newCorners(1,1) newCorners(1,2) newImageSize newImageSize]);
projectedImage = imcrop(projectedImage, cropRect);
imshow(projectedImage);


%% Get Edges of Grid
numEdges = 50;
lines = getHoughLines(projectedImage, numEdges, 0.3)

close all

horizontalLines = getLinesByAngle(lines, 0, 1);
verticalLines   = getLinesByAngle(lines, 90, 10);
displayLinesOverlay(projectedImage, lines);
displayLinesOverlay(projectedImage, verticalLines);

topLine = getFarthestLine(horizontalLines, 'top');
bottomLine = getFarthestLine(horizontalLines, 'bottom');
leftLine = getFarthestLine(verticalLines, 'left');
rightLine = getFarthestLine(verticalLines, 'right');
borderLines = [topLine, bottomLine, leftLine, rightLine];

displayLinesOverlay(projectedImage, borderLines);
horLines = {};
verLines = {};
angleThreshold = 15;
for k = 1:length(lines)
    line = lines(k);    
    if (abs(line.theta) < angleThreshold)
        horLines{length(horLines) + 1} = line;
    else
        verLines{length(verLines) + 1} = line;
    end
end

corners = zeros(4, 2);
for k = 1:length(lines)
    line = lines(k);
    
end


%% Circles
%centers = circlefinder(image)
%figure, imshow(image); hold on; plot(162, 448, 'r+'); hold off;
%[r c rad] = circlefinder(image)
%[ys, xs, acc] = houghcircle(image, 10)
%[accum, circen, cirrad] = CircularHough_Grd(image, [5 25], 20, 13, 1);

radii = stoneRadiusLow:1:stoneRadiusHigh;
edges = edge(projectedImage, 'canny');
h = circle_hough(edges, radii, 'same', 'normalise');
peaks = circle_houghpeaks(h, radii, 'threshold', 3, 'nhoodxy', 21, 'nhoodr', 21, 'npeaks', 381);

% Display
imshow(edges);
hold on;
for peak = peaks 
[x, y] = circlepoints(peak(3)); 
plot(x+peak(1),y+peak(2), 'g-'); 
end
hold off

% Calculate radius based on circle radius'
circleRadiuss = peaks(3,:);
circleRadius  = int64(mean(circleRadiuss));

% Get max top/right/bottom/left circle
[val,pos]    = min(peaks(2,:));
topCircle    = [peaks(1, pos), peaks(2, pos)];

[val,pos]    = max(peaks(1,:));
rightCircle  = [peaks(1, pos), peaks(2, pos)];

[val,pos]    = max(peaks(2,:));
bottomCircle = [peaks(1, pos), peaks(2, pos)];

[val,pos]    = min(peaks(1,:));
leftCircle   = [peaks(1, pos), peaks(2, pos)];

%% Get grid positions

imageLength = length(projectedImage);
% Calculate grid 'edge' lines according to circle and line estimates
topY    = getExtremeBeyondThreshold( ...
           [topLine.point1(2) topCircle(2)], outsideGridLineMargin, 'min');
rightX  = getExtremeBeyondThreshold( ...
           [rightLine.point1(1) rightCircle(1)], imageLength - outsideGridLineMargin, 'max');   
bottomY = getExtremeBeyondThreshold( ...
           [bottomLine.point1(2) bottomCircle(2)], imageLength - outsideGridLineMargin, 'max');     
leftX   = getExtremeBeyondThreshold( ...
           [leftLine.point1(1) leftCircle(1)], outsideGridLineMargin, 'min');     

% Might be slightly different
gridLengthX = ((rightX - leftX) / (gridSize-1));
gridLengthY = ((bottomY - topY) / (gridSize-1));

gridSpots = [];
for i = leftX:gridLengthX:rightX
    for j = topY:gridLengthY:bottomY
        gridSpots = [gridSpots; i j];
    end
end
gridSpots = int64(gridSpots);

imshow(projectedImage)
hold on
plot(gridSpots(:,1), gridSpots(:,2), 'o')

%% Get stones
board = zeros(gridSize, gridSize) * 2; % 2 is 'no stone'

for i = 1:gridSize
    for j = 1:gridSize
        gridIndex = ((i-1)*19) + j;
        x = gridSpots(gridIndex, 1);
        y = gridSpots(gridIndex, 2);
        isStone = getIsStone(projectedImage, x, y, ...
            double(circleRadius/2), lowThreshold, highThreshold);
        board(i, j) = isStone;
    end 
end 

%% Write to file
writeFile(makeSGF(board), strcat(imageFilename, '.sgf'));


%% ----------------------------------------------
%            DEPRECATED CODE
%------------------------------------------------

%% Aligning Edges
% Based on http://stackoverflow.com/questions/5770818/how-to-align-image-matlab

% Hough 
numEdges = 100;
edges = edge(image, 'canny');
lines = getHoughLines(edges, numEdges, 0.3);
displayLinesOverlay(image, lines);

%Shearing transforms
slopes = vertcat(lines.point2) - vertcat(lines.point1);
slopes = slopes(:,2) ./ slopes(:,1);
TFORM = maketform('affine', [1 -slopes(1) 0 ; 0 1 0 ; 0 0 1]);
rotatedImage = imtransform(image, TFORM);
imshow(rotatedImage);

% Display
figure, imshow(edges);

% show accumulation matrix and peaks
%figure, imshow(imadjust(mat2gray(H)), [], 'XData',T, 'YData',R, 'InitialMagnification','fit')
%xlabel('\theta (degrees)'), ylabel('\rho');%, colormap(hot), colorbar
%hold on, plot(T(P(:,2)), R(P(:,1)), 'gs', 'LineWidth',2), hold off
%axis on, axis normal, hold on;
%colormap(hot)


%% Convert image to 3 colors
rotatedImage2 = rotatedImage;
rotatedImage2(rotatedImage2 < lowThreshold)  = 0;
rotatedImage2(rotatedImage2 > highThreshold) = 1;
rotatedImage2(rotatedImage2 >= lowThreshold & rotatedImage2 <= highThreshold) = 0.5;
imshow(rotatedImage2);
