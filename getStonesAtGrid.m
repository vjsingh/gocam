% Takes image and 19x19 (nxn) array of grid positions on image
% 
function[board] = getStonesAtGrid(image, gridPoss)

board = zeros(19, 19);
board(:, :) = 2;

for i = 1:length(gridPoss)
    for j = 1:length(gridPoss)
        gridPos = gridPoss(i, j);