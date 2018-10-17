### We want all scripts to have a way to parse input arguments, feed this info downstream to other functions  
  ## getopts  
  
  ```
  while getopts "input arguments" OPTION  
  do  
    argument)  
      action  
      ;;  
  done  
  ```
  
  * If the argument has further input  
    * use "argument:" in the input arguments section  
    * assign a variable with $OPTARG  
  * If the argument is only a flag (no further input)  
    * use "argument" in the input arguments setion  
    * A variable may still be assigned, but there is no value assigned from input to the script  
   
  For example, with a script, called testscript.sh, with two arguments "-a" and "-b," where "-a" expects some other value  
  
  ```
  Input to script:
  
    testscript.sh -a input -b  
    
  In the getopts section:
  
  while getopts "a:b" OPTION  
  do  
    a)  
      somevariable=$OPTARG    
      ;;  
    b)
      someothervariable=1
      ;;  
  done 
  
  In the script, you would now have two variables, $a and $b such that:  
    a=input  
    b=1  
 ```
  
  
