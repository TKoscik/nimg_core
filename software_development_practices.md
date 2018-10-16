# Software Development Practices

The goal is to create a set of scripts and functions to automate neuroimaging processing using a standardized approach the is standardized and simple enough for "lay-user" interaction as well as flexible enough for easy debugging and paramter manipulation for power users.  

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
        date_of_use: ${YYYY-MM-DD_HH-MM-SS}
        module_name: ${module_name}
        module_version: ${module_version}
        parameters: ${default_parameters_or_optional_changes}
        software_used: ${software_name1}
        software_version: ${software_version1}
        software_used: ${software_name2}
        software_version: ${software_version2}
        <blank_line>
        ```
