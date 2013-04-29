% Board is nxn
% 0/1/2 for Black/White/None
function[sgfStr] = makeSGF(board)

sgfStr   = '(;AB';
whiteStr = 'AW';      % Do separately and then concat together

for i = 1:length(board)
    for j = 1:length(board)
        currPiece = board(i, j);
        row = char(i + 96);
        col = char(j + 96);
        posIndex = strcat('[', col, row, ']');
        if (currPiece == 0)
            sgfStr = strcat(sgfStr, posIndex);
        elseif (currPiece == 1)
            whiteStr = strcat(whiteStr, posIndex);
        end
    end
end

sgfStr = strcat(sgfStr, whiteStr, ')');