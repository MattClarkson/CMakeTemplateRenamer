CMakeTemplateRenamer
====================
This is a project, just to facilitate creating new projects from the following templates:
* [CMakeCatch2](https://github.com/MattClarkson/CMakeCatch2) which shows a reasonable layout for a C++ project that uses CMake to build and Catch to test.
* [CMakeCatchMPI](https://github.com/MattClarkson/CMakeCatchMPI) same as above, but mostly MPI examples.
* [CMakeCatchTemplate](https://github.com/MattClarkson/CMakeCatchTemplate) which is a more complete project, including a Meta-Build for downloading dependencies, Travis and Appveyor integration, and for the Python enthusiast, demonstrates how to write Python extensions in C++, and deploy them to PyPi as binary wheels. 

Credits
-------

This project was developed as a teaching aid for UCL's ["Research Computing with C++"](http://rits.github-pages.ucl.ac.uk/research-computing-with-cpp/)
course developed by [Dr. James Hetherington](http://www.ucl.ac.uk/research-it-services/people/james)
and [Dr. Matt Clarkson](https://iris.ucl.ac.uk/iris/browse/profile?upi=MJCLA42).

Usage
-----

You need to run the following commands inside a bash shell. We normally generate our new projects on Linux/Mac. On Windows, try using git-bash.exe, or ask a colleage who is a Linux/Mac developer to do it for you. From the above list, if we wanted to create a new project based on the template project `CMakeCatchTemplate`, we would:
```
git clone https://github.com/MattClarkson/CMakeTemplateRenamer.git
git clone https://github.com/MattClarkson/CMakeCatchTemplate.git
CMakeTemplateRenamer/rename.sh CMakeCatchTemplate 
```
and answer the questions as they come. You end up with a new project, that has the features described in CMakeCatchTemplate.

