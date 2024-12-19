% Initialize the camera
cam = webcam(1);  % Specify webcam index if needed, e.g., webcam(2)

% Create a figure for displaying the video
figure;

% Initialize a structure to store positions of detected markers
markerPositions = containers.Map('KeyType', 'double', 'ValueType', 'any');

while ishandle(gcf)  % Run until the figure window is closed
    % Capture a frame from the camera
    frame = snapshot(cam);

    % Detect ArUco markers in the frame
    [markerIds, markerCorners, detectedFamily] = readArucoMarker(frame);

    % If markers are detected, update tracking information
    if ~isempty(markerIds)
        for i = 1:length(markerIds)
            % Get the current marker's ID and its corner points
            markerId = markerIds(i);
            corners = markerCorners(:, :, i);

            % Calculate the center position of the marker for tracking
            center = mean(corners, 1);

            % Update marker position history
            if isKey(markerPositions, markerId)
                % Append new position to the marker's position history
                markerPositions(markerId) = [markerPositions(markerId); center];
            else
                % Initialize a new history for this marker
                markerPositions(markerId) = center;
            end

            % Draw the tracked path by connecting all previous positions
            positionHistory = markerPositions(markerId);
            for j = 2:size(positionHistory, 1)
                frame = insertShape(frame, "Line", ...
                    [positionHistory(j-1, :) positionHistory(j, :)], ...
                    'Color', 'yellow', 'LineWidth', 2);
            end

            % Draw a polygon around the marker
            frame = insertShape(frame, "polygon", {corners}, 'Color', 'green', 'LineWidth', 3);

            % Display the marker ID at the center
            frame = insertText(frame, center, markerId, 'FontSize', 20, 'BoxOpacity', 0.8);
        end
    end

    % Display the frame with tracking annotations
    imshow(frame);

    % Update the display
    drawnow;
end

% Clean up by releasing the camera resource
clear cam;
