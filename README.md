# ngfmVis
Data visualizer for magnetometers developed by the University of Iowa's Space Physics program

## How to Run
### Dependencies
- At least MATLAB 2019a (that's what I used to implement all the changes)
- MATLAB's [Parallel Computing Toolbox](https://www.mathworks.com/products/parallel-computing.html)
- A file of captured data or a device connected over serial that sends data in the specified format

### Run
- In MATLAB's console, type `ngfmVis()` with or without arguments.
- Arguments are as follows:
  - Input: either `serial` or `file`
  - Source: based on input, serial port or file location, respectively
  - Logging: filename.extension, '' for timestamp.txt, or `null` for no logging
  
