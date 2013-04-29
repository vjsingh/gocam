function [lines] = getHoughLines(image, numEdges, threshold)

edges = edge(image, 'canny');
[H T R] = hough(edges);
P = houghpeaks(H, numEdges, 'threshold', ceil(0.2*max(H(:))));
%P = houghpeaks(H, numEdges);
lines = houghlines(edges, T, R, P); 