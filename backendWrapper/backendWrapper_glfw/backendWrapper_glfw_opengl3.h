#pragma once
#include "imgui.h"
#include <GLFW/glfw3.h>

namespace ImGui_backendWrapper_Glfw {
    int InitWindow(int width, int height, const char* title, ImGuiConfigFlags flags = 0);
    GLFWwindow* GetWindow();
    const char *GetGLSLVersion();
    ImVec4& GetClearColor();
    bool WindowShouldClose();
    void FrameBegin();
    void FrameEnd();
    void Shutdown();
}
