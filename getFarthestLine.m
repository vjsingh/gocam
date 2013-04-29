function[line] = getFarthestLine(lines, direction)

% Matlab reshape nonsense
% Turn row vector into dx2 matrix
point1Points = reshape([lines.point1], [2 length([lines.point1]) / 2])';
point2Points = reshape([lines.point2], [2 length([lines.point2]) / 2])';
point1Xs = point1Points(:, 1);
point1Ys = point1Points(:, 2);
point1Xs = point1Points(:, 1);
point1Ys = point1Points(:, 2);


% TODO: Take into account both points
if (strcmp(direction, 'top'))
    [maxVal, index] = min(point1Ys);
elseif (strcmp(direction, 'bottom'))
    [maxVal, index] = max(point1Ys);
elseif (strcmp(direction, 'left'))
    [maxVal, index] = min(point1Xs);
elseif (strcmp(direction, 'right'))
    [maxVal, index] = max(point1Xs);
else
    'error, invalid argument in getFarthestLine'
end

line = lines(index);