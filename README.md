# ngfmVis
Data visualizer for magnetometers developed by the University of Iowa's Space Physics program

## How to Run
### Dependencies
- At least MATLAB 2019a (that's what I used to implement all the changes)
- MATLAB's [Parallel Computing Toolbox](https://www.mathworks.com/products/parallel-computing.html)
- A file of captured data or a device connected over serial that sends data in the specified format
  - i.e. [capture09102019.txt](https://github.com/cooperbell/ngfmVis/blob/master/capture09102019.txt)
  - [Data packet format](https://github.com/cooperbell/ngfmVis/blob/master/resources/NGFM_Packet_Definition%20V1.xlsx)

### Run
- In MATLAB's console, type `ngfmVis()` with or without arguments.
  - Arguments are as follows:
    - Input: either `serial` or `file`
    - Source: based on input, serial port or file location, respectively
    - Logging: filename.txt, `''` for timestamp.txt, or `null` for no logging
  - Example: `ngfmVis('file','capture09102019.txt','null');`
  
