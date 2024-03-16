# contour_tracking

The functionality of variable and function names is annotated throughout the program. The main purpose is to implement a UUV (Unmanned Underwater Vehicle) performing a fixed-distance patrol and tracking task around an island.

Below is a list of each function in the program, with specific details as follows:

1. **main**
   - Function Content and Purpose: The main execution program for the task. It includes variable definition, variable container initialization, detection of unknown boundaries using a sonar model, local map construction, prediction of contour turning points, replanning, and drawing based on variables.
2. **multiSonar**
   - Function Content and Purpose: Represents a multi-beam forward-looking sonar detection model in the form of rays.
3. **probepoint**
   - Function Content and Purpose: Retrieves the coordinates of detection points.
4. **Rasterize_1** / **reverse_Rasterize**
   - Function Content and Purpose: Rasterizes detection point coordinates. The reverse_Rasterize function is the inverse transformation.
5. **bresenham_2d**
   - Function Content and Purpose: Rasterization of straight lines.
6. **bayes_11**
   - Function Content and Purpose: Sonar probability processing.
7. **map_state_change**
   - Function Content and Purpose: Movement of the local map.
8. **HGS**, **hgs_main**, **initialization**, **Get_Functions_HGS**
   - Function Content and Purpose: Planning algorithm functions.
9. **replan_fitness**, **replan_fitness_compute**
   - Function Content and Purpose: Replanning judgment methods.
13. **realdist_compute**
    - Function Content and Purpose: Computes the real-time distance between UUV and the contour.
14. **complex_wall**, **concave_wall**, **concave1_wall**, **convex_wall**, **dafudao**, **gangchi**
    - Functions Content and Purpose: Models for constructing the map.



**Note:** UUV models and controllers are not provided, The user needs to customize the implementation of the following function before successfully executing the simulation.

`PIDu2/PIDh2`：pid controllers for velocity control and heading control.

`uuvmodelThrustRudder`：dynamic model for underactuated uuv. 

`realThruster1/realThruster2`: actuator model for left and right thruster. 

