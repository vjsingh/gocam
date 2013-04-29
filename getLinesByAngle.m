% Angle is angle of the line you want
% I use theta of the line segments, which should be 90 deg. off
function[goodLines] = getLinesByAngle(lines, angle, threshold) 
desiredAngle = abs(angle - 90);

angleOfLineIsGood = ( (abs([lines.theta]) < (desiredAngle + threshold)) ...
    & (abs([lines.theta]) > (desiredAngle - threshold)) )
goodLines = lines(angleOfLineIsGood);
