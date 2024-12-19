% % List all connected webcams
% cameraList = webcamlist;
% 
% % Display the list of available camera names/IDs
% disp("Available cameras:");
% for i = 1:length(cameraList)
%     disp("Camera " + i + ": " + cameraList{i});
% end


% Initialize the camera
cam = webcam(2);  % If you have multiple cameras, specify the index like webcam(1)

% Create a loop to continuously capture frames
figure;
while ishandle(gcf)  % Loop until the figure window is closed
    % Capture a frame from the camera
    frame = snapshot(cam);

    % Detect ArUco markers in the frame
    [markerIds, markerCorners, detectedFamily] = readArucoMarker(frame);

    % If markers are detected, process and display them
    if ~isempty(markerIds)
        for i = 1:length(markerIds)
            % Get the corners of the detected marker
            corners = markerCorners(:, :, i);

            % Display the marker ID and family
            disp("Detected Marker ID: " + markerIds(i) + ", Family: " + detectedFamily(i));

            % Draw a polygon around the marker
            frame = insertShape(frame, "polygon", {corners}, 'Color', 'green', 'LineWidth', 3);

            % Calculate the center of the marker for text placement
            center = mean(corners, 1);
            % Display the marker ID at the center of the marker
            frame = insertText(frame, center, markerIds(i), 'FontSize', 20, 'BoxOpacity', 0.8);
        end
    end

    % Display the processed frame
    imshow(frame);
    drawnow;  % Update the display immediately
end

% Clean up: clear camera when done
clear cam;
