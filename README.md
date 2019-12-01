# ngfmVis
Data visualizer for magnetometers developed by the University of Iowa's Space Physics program

## How to Run
### Dependencies
- At least MATLAB 2019a (that's what I used to implement all the changes)
- MATLAB's [Parallel Computing Toolbox](https://www.mathworks.com/products/parallel-computing.html)
- A file of captured data or a device connected over serial that sends data in the specified format

#### Change your parallel preferences
- In the bottom left of MATLAB, you will see an icon with 4 gray bars, click on that then click on 'Parallel Preferences'
- Change your 'Preferred number of workers in parallel workers in a parallel pool' to 1

### Run
- In MATLAB's console, type `ngfmVis()` with or without arguments.
- Arguments are as follows:
  - Input: either `serial` or `file`
  - Source: based on input, serial port or file location, respectively
  - Logging: file name or `null` for no logging
  
