CMakeTemplateRenamer
====================
This is a project, just to facilitate creating new projects from the following templates:
* [CMakeCatch2](https://github.com/MattClarkson/CMakeCatch2) which shows a reasonable layout for a C++ project, with no Meta-Build for dependencies, that uses CMake to build and Catch to test.
* [CMakeCatchTemplate](https://github.com/MattClarkson/CMakeCatchTemplate) which is a larger project, including a Meta-Build for downloading dependencies, Travis and Appveyor integration, and for the Python enthusiast, demonstrates how to write Python extensions in C++, and deploy them to PyPi as binary wheels. 

Credits
-------

This project was developed as a teaching aid for UCL's ["Research Computing with C++"](http://rits.github-pages.ucl.ac.uk/research-computing-with-cpp/)
course developed by [Dr. James Hetherington](http://www.ucl.ac.uk/research-it-services/people/james)
and [Dr. Matt Clarkson](https://iris.ucl.ac.uk/iris/browse/profile?upi=MJCLA42).


Usage
-----

You need to run the following commands inside a bash shell. We normally generate
our new projects on Linux/Mac. On Windows, try using git-bash.exe, or ask a colleage 
who is a Linux/Mac developer to do it for you. For example, to
create a new project based on the template project `CMakeCatchTemplate`, do:
```
git clone https://github.com/MattClarkson/CMakeTemplateRenamer.git
git clone --recursive https://github.com/MattClarkson/CMakeCatchTemplate.git
```
Then this command to generate your new project.
```
CMakeTemplateRenamer/rename.sh A B C D E F G H [optional I]
```
Where:
 * A: is the folder you want to clone.
 * B: is the new folder name you want to create.
 * C: is the new project name all in CamelCase.
 * D: is new project name all in lowercase.
 * E: is new project name all in UPPERCASE.
 * F: is a short 1 line description, in double quotes.
 * G: is the new namespace without :: specifiers.
 * H: is either Y or N, meaning yes/no to drop the git history.
 * I: if specified is the new python module name.
  
So, as a more illustrative example:
```
CMakeTemplateRenamer/rename.sh CMakeCatchTemplate BananaMaker BananaMaker bananamaker BANANAMAKER "BananaMaker is a package for making Bananas." bm N bananamakerpython
```
Will result in cloning CMakeCatchTemplate into BananaMaker and all files or strings being swapped as follows:
* CMakeCatchTemplate to BananaMaker
* MyProject          to BananaMaker
* myproject          to bananamaker
* MYPROJECT          to BANANAMAKER
* \"A software package for whatever.\" to \"BananaMaker is a package for making Bananas.\" 
* mp:: to bm::
* and the git history will be dropped
* and if specified the new python module will be called bananamakerpython

The reason for having CamelCase, lowercase and UPPERCASE is due to different naming conventions for
shell script variables, file names etc.

This script will work similarly for the other named template projects. 
You end up with a new project, that has all the features of your chosen template.


Runtime
-------

The script is a bit basic. When renaming CMakeCatchTemplate for example,
it could easily take 20-60 minutes or so to run.
