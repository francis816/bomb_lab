# bomb_lab
trying to defuse phase 1 - 6 by analyzing the x86-64 assembly code


## Phase 1 characteristics:
 - comparing strings 
 
 
## Phase 2 characteristics:
 - loop
 - pointer arithmetic

![](phase2.png)


## Phase 3 characteristics:
 - string input function sscanf and its parameters (1st = string, 2nd = string format, starting from 3rd = format specifier, pass in pointer)
 - jump table (switch statement)

![](phase3.png)


## Phase 4 characteristics:
 - string input function sscanf and its parameters (1st = string, 2nd = string format, starting from 3rd = format specifier, pass in pointer)
 - recursion

![](phase4.png)


## Phase 5 characteristics:
  - Canary to defect potential buffer overflow
  - Array and pointer arithmetic
  - Mapping index after masking the lower 4 bytes
    
![](phase5.png)


## Phase 6 characteristics:
  - linked-list, reverse linked-list
  - left and right pointer to swap number
    
![](phase6.png)


![](defused.png)
