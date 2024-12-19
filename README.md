# ArUco Marker Detection and Tracking using AR Drone
This repository contains an algorithm to Track the Aruco Marker with AR Drone 2.0 using PID Controller. Python has been used for programming the drone with ps_drone library. To open the ps_drone website: [click here](https://www.playsheep.de/drone/downloads.html) 


### Demo Video
You can watch the demo video of AR Drone tracking the Aruco Marker in real world by clicking on the below image

[![Watch the video](https://github.com/EhtishamAshraf/ArucoFollowingDrone/blob/b0d19a1f7c5dd784b1484c347183dc4f639fa1e5/Images/drone.png)](https://youtu.be/UkY-DLqm0hI)

## Algorithm's Logic
The flow of the project is as follows:
1. Detect the Aruco Marker using **cv2.aruco.detectMarkers** function
2. Get the corner points of the Aruco --- These corners will be later used to get the center point of the Aruco Marker
3. Get the Position and Orientation of the Aruco Marker using **cv2.aruco.estimatePoseSingleMarkers** --- The translational 
   vector will be later used to get the distance of the Aruco Marker from the Drone.
4. Get the center of the Drone's camera
5. Error can be calculated as:
   
## Calculating Error for Marker Alignment

The errors in the X, Y, and Z axes can be calculated as follows:

### Formula:
\[
\text{Error}_x = \text{CameraCenterX} - \text{MarkerCenterX}
\]
\[
\text{Error}_y = \text{CameraCenterY} - \text{MarkerCenterY}
\]
\[
\text{Error}_z = \text{Distance} - 1.75
\]

### Explanation:
- **Error\(_x\)**: The horizontal difference between the camera's center (\(CameraCenterX\)) and the marker's center (\(MarkerCenterX\)).
- **Error\(_y\)**: The vertical difference between the camera's center (\(CameraCenterY\)) and the marker's center (\(MarkerCenterY\)).
- **Error\(_z\)**: The difference between the actual distance to the marker (\(Distance\)) and the desired distance (\(1.75\) meters).

These errors can be used for alignment and feedback control in robotics or vision-based navigation systems.


#### Calculating Distance to the Marker

The distance to the ArUco marker is calculated using the translation vector (`tvec`). The distance is derived as the Euclidean norm of the `tvec`, which represents the position of the marker relative to the camera:

\[
\text{Distance} = \sqrt{tvec_x^2 + tvec_y^2 + tvec_z^2}
\]

Where:
- \(tvec_x\), \(tvec_y\), \(tvec_z\) are the X, Y, Z components of the translation vector (`tvec`).

---

#### Calculating the Center of the Marker

The marker's center is calculated as the mean of the corner coordinates. Each marker has 4 corners, represented as a 4x2 array of (x, y) coordinates. The formula for the marker center:

\[
\text{CenterX} = \frac{\text{Corner1}_x + \text{Corner2}_x + \text{Corner3}_x + \text{Corner4}_x}{4}
\]

\[
\text{CenterY} = \frac{\text{Corner1}_y + \text{Corner2}_y + \text{Corner3}_y + \text{Corner4}_y}{4}
\]

Where:
- \(\text{Corner1}_x, \text{Corner2}_x, \text{Corner3}_x, \text{Corner4}_x\) are the x-coordinates of the marker's corners.
- \(\text{Corner1}_y, \text{Corner2}_y, \text{Corner3}_y, \text{Corner4}_y\) are the y-coordinates of the marker's corners.

---

   
![block diagram](https://github.com/EhtishamAshraf/ArucoFollowingDrone/blob/b0d19a1f7c5dd784b1484c347183dc4f639fa1e5/Images/FLowchart.png)



## Hardware Setup
![Hardware Setup](https://github.com/EhtishamAshraf/ArucoFollowingDrone/blob/b0d19a1f7c5dd784b1484c347183dc4f639fa1e5/Images/Image1.jpg)

