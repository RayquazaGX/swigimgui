%module imgui_backendWrapper

#ifdef SWIGIMGUI_BACKEND_glfw_opengl3
%{
    #include "backendWrapper_glfw_opengl3.h"
%}
%include "backendWrapper_glfw_opengl3.h"
#endif
