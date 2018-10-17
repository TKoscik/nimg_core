### We want all scripts to have a way to parse input arguments, feed this info downstream to other functions  
  ## getopts  
  
  ```
  while getopts "input arguments" OPTION  
  do 
    case $OPTION in  
      argument)  
         action  
         ;;  
     esac  
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
    case $OPTION in  
      a)  
        somevariable=$OPTARG    
        ;;  
      b)
        someothervariable=1
        ;; 
     esac  
  done 
  
  In the script, you would now have two variables, $somevariable and $somevariable2 such that:  
    somevariable=input  
    somevariable2=1  
 ```
  
  Let's say that argument "-a" could be used more than once  
  
  ```  
  Input to script:
  
    testscript.sh -a input -a input2 -a input3  
    
  In the getopts section:
  
  while getopts "a:" OPTION  
  do  
    case $OPTION in 
      a)  
        somevariable=`echo $somevariable $OPTARG`
        ;;  
    esac  
  done  
  
  somevariable would now be "input input2 input3"  
  
  create an array from the variable and index by position:
  
  testarray=($somevaraible)  
  echo ${testarray[2]}
  
    would produce "input2"  
 ```
  
  ##get_opt1  
  
  * Rather than limit to indidiual characters for arguments (e.g.: "-a"), one could sue words  
  
```

  Input to script:
  
    testscript.sh --variable1=input1 --variable2=input2 --roi=roi1 --roi=roi2 --roi=roi3
    
  In the script (rather than getopts):  
  
  
  get_opt1() {
    arg=$(echo $1 | sed 's/=.*//')
    echo $arg
  }  
  
  get_arg1() {
    if [ X"`echo $1 | grep '='`" = X ] ; then
	echo "Option $1 requires an argument" 1>&2
	exit 1
    else
	arg=`echo $1 | sed 's/.*=//'`
	if [ X$arg = X ] ; then
	    echo "Option $1 requires an argument" 1>&2
	    exit 1
	fi
	echo $arg
    fi
  }  
  
  while [ $# -ge 1 ] ; do  
    iarg=$(get_opt1 $1);  
    case "$iarg} in  
      --input1)  
        variable1=$(get_arg1 $1);  
        export variable1; 
        shift;;  
      --input2)  
        variable2=${get_arg1 $1);
        export variable2;  
        shift;;  
      --roi)  
        roiLIst=`echo $roiList $(get_arg1 $1)`;  
        export roiList;
        shift;;       
      esac  
    done  
    
    variable1=input1  
    variable2=input2  
    roiList=roi1 roi2 roi3
``` 
