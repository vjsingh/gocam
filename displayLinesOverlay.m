function [] = displayLinesOverlay(image, lines)

% show image with lines overlayed, and the aligned/rotated image
figure
imshow(image), hold on
for k = 1:length(lines)
    xy = [lines(k).point1; lines(k).point2];
    plot(xy(:,1), xy(:,2), 'g.-', 'LineWidth',2);
end, hold off
%subplot(122), imshow(rotatedImage)