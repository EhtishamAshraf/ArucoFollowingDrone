
% Load camera parameters from calibration
data = load("AR_cameraParams.mat");
intrinsics = data.AR_cameraParams.Intrinsics;

% Define ArUco marker properties
markerSizeInMM = 100;
markerFamily = "DICT_4X4_250";

% Set up the webcam
cam = webcam(); % Connect to your webcam; use webcam("ID") if you have multiple cameras

% Create a figure window to display video frames
figure;
hold on;

% Main loop for continuous video capture and marker detection
while true
    % Capture a frame from the webcam
    I = snapshot(cam);
    
    % Resize if the current image size does not match the expected size
    expectedSize = intrinsics.ImageSize;
    if ~isequal(size(I, 1:2), expectedSize)
        I = imresize(I, expectedSize);
        [height, width, ~] = size(I);  % Get the size of the image

        % Calculate the center coordinates of the camera
        camera_centerX = width / 2;
        camera_centerY = height / 2;
        % Display the center coordinates
        disp(['Center of the camera: (' num2str(camera_centerX) ', ' num2str(camera_centerY) ')']);
    
    else
        [height, width, ~] = size(I);  % Get the size of the image

        % Calculate the center coordinates of the camera
        camera_centerX = width / 2;
        camera_centerY = height / 2;
        % Display the center coordinates
        disp(['Center of the camera: (' num2str(camera_centerX) ', ' num2str(camera_centerY) ')']);

    end
    
    % Undistort the captured image
    [I, camIntrinsics] = undistortImage(I, intrinsics);
    
    % Detect ArUco markers and estimate their poses
    try
        [ids, locs, poses] = readArucoMarker(I, camIntrinsics, markerSizeInMM);
    catch ME
        disp('Error detecting markers or calculating poses. Skipping this frame.');
        disp(ME.message);
        continue;
    end
    
    % Check if any markers are detected
    if ~isempty(ids) && ~isempty(locs) && ~isempty(poses)
        % Display detected marker IDs and number of poses
        fprintf("Detected Marker IDs: ");
        fprintf("%d ", ids); % Display each ID on the same line
        fprintf("\nNumber of Poses Detected: %d\n", length(poses));

        % Origin and axes vectors for the object coordinate system
        worldPoints = [0 0 0; markerSizeInMM/2 0 0; 0 markerSizeInMM/2 0; 0 0 markerSizeInMM/2];
        
        for i = 1:length(poses)

            corners = locs(:, :, i);

            % Ensure locs is sufficiently large to prevent bounds errors
            if size(locs, 3) >= i
                % Draw detection boundary around each marker
                I = insertShape(I, "Polygon", corners, "Color", "red", "LineWidth", 5);
            end

            % Calculate the center position of the marker for tracking
            marker_center = mean(corners, 1);
            marker_centerX = marker_center(1);
            marker_centerY = marker_center(2);
            radius = 15;
            I = insertShape(I, "FilledCircle", [marker_center, radius], "Color", "red", "Opacity", 0.6);
                        
            disp(['Center of the marker: (' num2str(marker_centerX) ', ' num2str(marker_centerY) ')']);

            % Calculate the distance to the marker using the translation vector in poses
            % Extract the translation vector tvec from the pose object
            tvec = poses(i).Translation; % 1x3 vector [x, y, z]
            distance = norm(tvec); % Calculate Euclidean distance

            disp(['Distance between Camera and Aruco Tag :' num2str(distance) 'mm']);

            % Display the distance on the image near the marker
            position = locs(1, :, i)-35; % Position to place the text
            I = insertText(I, position, sprintf('%.2f mm', distance), ...
                           "BoxColor", "yellow", "TextColor", "black", "FontSize", 16);
            
            % Get image coordinates for axes if pose information is valid
            if ~isempty(poses(i))
                imagePoints = world2img(worldPoints, poses(i), camIntrinsics);
                
                % Draw axes lines to indicate pose if imagePoints is valid
                if size(imagePoints, 1) >= 4
                    axesPoints = [imagePoints(1,:) imagePoints(2,:);
                                  imagePoints(1,:) imagePoints(3,:);
                                  imagePoints(1,:) imagePoints(4,:)];
                    I = insertShape(I, "Line", axesPoints, "Color", ["red", "green", "blue"], "LineWidth", 3);
                end
            end
            
            error_x = camera_centerX - marker_centerX;
            error_y = camera_centerY - marker_centerY;

            disp(['Error in [x] and [y]: (' num2str(error_x) ', ' num2str(error_y) ')']);

            if error_x > 0
                disp(['Aruco Marker is on the "Right" of the Camera']);
            elseif error_x < 0
                disp(['Aruco Marker is on the "Left" of the Camera']);
            end

            if error_y > 0
                disp(['Aruco Marker is on the "Top" of the Camera']);
            elseif error_y < 0
                disp(['Aruco Marker is on the "Bottom" of the Camera']);
            end
        end
    else
        disp('No markers detected in this frame.');
    end
    
    % Display the processed frame with overlay
    imshow(I);
    
    % Allow a brief pause for display refresh (may help with smoothness)
    % pause(0.0001); 
    
    % Check if figure has been closed to exit the loop
    if ~isvalid(gcf)
        break;
    end
end

% Clean up: clear webcam object after the loop
clear cam;