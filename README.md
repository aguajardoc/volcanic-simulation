## Volcanic Simulation

MATLAB app that graphically simulates the projectile motion of volcanic rock expelled from a volcano based on the model of air resistance proportional to the square of the velocity, assuming the projectiles are spheres with a drag coefficient of 0.5. 

The default values in the app correspond to conditions present at the peak of the Popocatépetl in Mexico; code is commented to reflect sources for such values.

The following values can be changed accordingly to suit users' needs:

- Spherical projectile diameter in meters
  
- Air density in kg m^-3
  
- Drag coefficient

- Initial position (x,y)

- Angle at launch in degrees

- Initial velocity in m/s

- Projectile mass in kg

- Simulation duration in seconds

- Minimum height in meters

- Step size in seconds

The app features a hold button to superimpose multiple trajectories at once, a reset button to return to default values, a "start simulation" button which acts according to the state of the hold button, and a "start random simulation" button that acts upon a selected number of projectiles.

This app was designed as a final project during my first semester at university. The course was taught in Spanish, so all elements of the app are implemented in Spanish.

## How to run

### 1. Download the .mlapp file
Although both files contain the same code, only the mlapp file can execute the code as a MATLAB App.

### 2. Open the latest version of MATLAB
### 3. Click on "Design App" within the "APPS" tab
### 4. Open the .mlapp file on the left side of the App Designer
### 5. Press F5 to run
### 6. Play with the app's features ;)

## Note 
The code.m file allows visualization of the code without downloading the .mlapp file
