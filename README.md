# ArUco Marker Detection and Tracking using AR Drone
This repository contains an algorithm to Track the Aruco Marker with AR Drone 2.0 using PID Controller. Python has been used for programming the drone with ps_drone library. To open the ps_drone website: [click here](https://www.playsheep.de/drone/downloads.html) 

**The ps_drone library has been updated with a custom move_all() function for smooth movement of the drone.**

### Demo Video
You can watch the demo video of AR Drone tracking the Aruco Marker in real world by clicking on the below image

[![Watch the video](https://github.com/EhtishamAshraf/ArucoFollowingDrone/blob/c25abcaccf74ba185d958678957f8a6b36fb66d2/Images/drone_jungle.png)](https://youtu.be/UkY-DLqm0hI)

## Algorithm's Logic
The flow of the project is as follows:
1. Detect the Aruco Marker using **cv2.aruco.detectMarkers** function
2. Get the corner points of the Aruco --- These corners will be later used to get the center point of the Aruco Marker
3. Get the Position and Orientation of the Aruco Marker using **cv2.aruco.estimatePoseSingleMarkers** --- The translational 
   vector will be later used to get the distance of the Aruco Marker from the Drone.
4. Get the center of the Drone's camera
5. Calculate the Error, the errors in the X, Y, and Z axes can be calculated as follows:
   
      A.   Error in the X-axis: Error_x = CameraCenterX - MarkerCenterX
      
      B.   Error in the Y-axis: Error_y = CameraCenterY - MarkerCenterY
      
      C.   Error in the Z-axis: Error_z = Distance - 1.75
      
      - **Error_x**: The horizontal difference between the camera's center (`CameraCenterX`) and the marker's center (`MarkerCenterX`).
      - **Error_y**: The vertical difference between the camera's center (`CameraCenterY`) and the marker's center (`MarkerCenterY`).
      - **Error_z**: The difference between the actual distance to the marker (`Distance`) and the desired distance (`1.75` meters).

These errors are used to accurtely track the Aruco Marker.

#### Calculating Distance to the Marker

The distance to the ArUco marker is calculated using the translation vector (`tvec`). The distance is derived as the Euclidean norm of the `tvec`, which represents the position of the marker relative to the camera:
![distance of the aruco](https://github.com/EhtishamAshraf/ArucoFollowingDrone/blob/4e5d59b21460ec55a24e7cb632fc79da25173535/Images/distance_formula.png)

where; `tvec_x`, `tvec_y`, `tvec_z` are the X, Y, Z components of the translation vector (`tvec`).


#### Calculating the center of the Aruco Marker
The center of the Aruco Marker can be calculated by taking the average of all the corners.

![aruco center](https://github.com/EhtishamAshraf/ArucoFollowingDrone/blob/4e5d59b21460ec55a24e7cb632fc79da25173535/Images/aruco_center.png)

The block diagram of the system is shown below.
![block diagram](https://github.com/EhtishamAshraf/ArucoFollowingDrone/blob/b0d19a1f7c5dd784b1484c347183dc4f639fa1e5/Images/FLowchart.png)


## Hardware Setup
The system's hardware is shown below

![Hardware Setup](https://github.com/EhtishamAshraf/ArucoFollowingDrone/blob/c25abcaccf74ba185d958678957f8a6b36fb66d2/Images/drone_setup.png)

## Results
The ps_drone library only works with python2, so make sure to install pip and numpy, and opencv for python2

### MATLAB
During the first phase of the project, the algorithm was tested on MATLAB. **Camera Calibrator** app of MATLAB was used for camera calibration in MATLAB

![Matlab](https://github.com/EhtishamAshraf/ArucoFollowingDrone/blob/9aec3f104a6cf0c5605f08d6cd623814ee3e3d72/Images/Matlab_Aruco.png)

### PYTHON
Then during the second phase, python was used to control the Drone and detect the Aruco Marker

![Python](https://github.com/EhtishamAshraf/ArucoFollowingDrone/blob/9aec3f104a6cf0c5605f08d6cd623814ee3e3d72/Images/Python_Aruco.png)

#### Scripts
1. Calibrate the camera with: drone_calibration.py
2. Check if the drone is working with: Drone_takeoff.py
3. Check if the drone's camera is working fine with: DroneCamera.py
4. Detect and Track the Aruco with Drone with: Drone_ArucoTracking.py
   
Run the scripts as: python2 <script_name>.py
