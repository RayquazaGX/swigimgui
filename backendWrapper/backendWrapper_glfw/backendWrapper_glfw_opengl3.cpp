// Modified from [the example provided with imgui](https://github.com/ocornut/imgui/blob/master/examples/example_glfw_opengl3/main.cpp)

#include "backendWrapper_glfw_opengl3.h"

#include "imgui.h"
#include "imgui_impl_glfw.h"
#include "imgui_impl_opengl3.h"
#include <stdio.h>
#if defined(IMGUI_IMPL_OPENGL_ES2)
#include <GLES2/gl2.h>
#endif
#include <GLFW/glfw3.h>

#if defined(_MSC_VER) && (_MSC_VER >= 1900) && !defined(IMGUI_DISABLE_WIN32_FUNCTIONS)
#pragma comment(lib, "legacy_stdio_definitions")
#endif

static void glfw_error_callback(int error, const char* description)
{
    fprintf(stderr, "Glfw Error %d: %s\n", error, description);
}

namespace ImGui_backendWrapper_Glfw {

    struct _Context{
        bool inited;
        GLFWwindow* window;
        const char* glsl_version;
        ImVec4 clear_color;
    };
    static struct _Context _context;

    int InitWindow(int width, int height, const char* title, ImGuiConfigFlags flags)
    {
        if(_context.inited)
            return 1;

        glfwSetErrorCallback(glfw_error_callback);
        if (!glfwInit())
            return 1;

#if defined(IMGUI_IMPL_OPENGL_ES2)
        // GL ES 2.0 + GLSL 100
        const char* glsl_version = "#version 100";
        glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 2);
        glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 0);
        glfwWindowHint(GLFW_CLIENT_API, GLFW_OPENGL_ES_API);
#elif defined(__APPLE__)
        // GL 3.2 + GLSL 150
        const char* glsl_version = "#version 150";
        glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
        glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 2);
        glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);  // 3.2+ only
        glfwWindowHint(GLFW_OPENGL_FORWARD_COMPAT, GL_TRUE);            // Required on Mac
#else
        // GL 3.0 + GLSL 130
        const char* glsl_version = "#version 130";
        glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
        glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 0);
        //glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);  // 3.2+ only
        //glfwWindowHint(GLFW_OPENGL_FORWARD_COMPAT, GL_TRUE);            // 3.0+ only
#endif

        GLFWwindow* window = glfwCreateWindow(width, height, title, NULL, NULL);
        if (window == NULL)
            return 1;
        glfwMakeContextCurrent(window);
        glfwSwapInterval(1); // Enable vsync

        IMGUI_CHECKVERSION();
        ImGui::CreateContext();

        ImGuiIO& io = ImGui::GetIO();
        io.ConfigFlags |= flags;

        ImGui::StyleColorsDark();
        ImGui_ImplGlfw_InitForOpenGL(window, true);
        ImGui_ImplOpenGL3_Init(glsl_version);

        _context.inited = true;
        _context.window = window;
        _context.glsl_version = glsl_version;
        _context.clear_color = ImVec4(0.45f, 0.55f, 0.60f, 1.00f);

        return 0;
    }

    GLFWwindow* GetWindow(){
        return _context.window;
    }

    const char *GetGLSLVersion(){
        return _context.glsl_version;
    }

    ImVec4& GetClearColor(){
        return _context.clear_color;
    }

    bool WindowShouldClose(){
        return glfwWindowShouldClose(_context.window);
    }

    void FrameBegin(){
        glfwPollEvents();
        ImGui_ImplOpenGL3_NewFrame();
        ImGui_ImplGlfw_NewFrame();
        ImGui::NewFrame();
    }

    void FrameEnd(){
        ImGui::Render();
        int display_w, display_h;
        glfwGetFramebufferSize(_context.window, &display_w, &display_h);
        glViewport(0, 0, display_w, display_h);
        glClearColor(
            _context.clear_color.x * _context.clear_color.w,
            _context.clear_color.y * _context.clear_color.w,
            _context.clear_color.z * _context.clear_color.w,
            _context.clear_color.w);
        glClear(GL_COLOR_BUFFER_BIT);
        ImGui_ImplOpenGL3_RenderDrawData(ImGui::GetDrawData());
        glfwSwapBuffers(_context.window);
    }

    void Shutdown(){
        ImGui_ImplOpenGL3_Shutdown();
        ImGui_ImplGlfw_Shutdown();
        ImGui::DestroyContext();
        glfwDestroyWindow(_context.window);
        glfwTerminate();
    }
}
