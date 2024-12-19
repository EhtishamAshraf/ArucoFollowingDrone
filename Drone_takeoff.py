
# Drone take-off and land

import time
import ps_drone                # Imports the PS-Drone-API

drone = ps_drone.Drone()       # Initializes the PS-Drone-API
drone.startup()                # Connects to the drone and starts subprocesses

drone.setSpeed(0.2)            # Sets default moving speed to 1.0 (=100%)
drone.takeoff()                # Drone starts
time.sleep(2.5)                # Gives the drone time to start

print("Drone taking off with a speed of: ", drone.setSpeed())

drone.stop()                   # Drone stops
time.sleep(2)

drone.land()                   # Drone lands