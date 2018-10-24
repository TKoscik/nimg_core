# Software Development Practices

The goal is to create a set of scripts and functions to automate neuroimaging processing using a standardized approach the is standardized and simple enough for "lay-user" interaction as well as flexible enough for easy debugging and paramter manipulation for power users.  

In general, scripts should follow [Google's Shell Style Guide](https://google.github.io/styleguide/shell.xml)

## User Stories
In constructing our software our first concern is desiging our code around how users will interact with it.
  * how will this software be used?
  * what parameters do users need to know to interact with software?
  * what sorts of output are the users expecting?
  * can users rely on default operations?
  * can users pick and choose and reorder processing modules?
  * can power users manipulate processing parameters easily and efficiently?

## Modularity
  * All software should be broken down into *single-purpose* chunks.
  * The order that modules should be applied shouldn't matter to the module itself (even though this might matter to the user)
  * Standardized user inputs
    * researcher root
    * project name
    * subject ID
    * session ID
    * previous module name
    * optional parameters (if not default)
  * Standardized communication between modules
  * Standardized outputs
    * Usage Logging"
        * append to appropriate sub-${subject}_ses-${session}.log
        ```
        ################################################################################
        module_description
        inputs:/Shared/researcher/nifti/1234/1810241305/sub-1234_ses-1810241305_T1w.nii.gz
        software: ${software_name}
        version: ${software_version}
        start_time:date +"%Y-%m-%d_%H-%M-%S"
        end_time:date +"%Y-%m-%d_%H-%M-%S"
        <blank_line>
        ```
