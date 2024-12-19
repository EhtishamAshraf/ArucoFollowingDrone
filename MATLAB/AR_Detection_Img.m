% Code to detect Aruco Marker from an Image

I = imread("marker_1.png");

[markerIds, markerCorners, detectedFamily] = readArucoMarker(I);

if isempty(markerIds)
    disp('No marker detected.');
else
    disp("Detected Marker ID: " + markerIds(1));
    disp("Marker Family: " + detectedFamily(1));

    % Get the corners of the first detected marker
    corners = markerCorners(:, :, 1);

    % Draw the polygon around the detected marker
    I = insertShape(I, "polygon", {corners}, 'Color', 'red', 'LineWidth', 3);

    % Display the marker ID in the center of the marker
    center = mean(corners, 1);  % Calculate the center point of the marker
    I = insertText(I, center, markerIds(1), 'FontSize', 20, 'BoxOpacity', 0.8);

    imshow(I);
end
