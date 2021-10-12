local ig = require "imgui"
local wrapper = require "imgui_backendWrapper"

wrapper.InitWindow(1280, 720, "Dear ImGui GLFW+OpenGL3 example")

local io = ig.GetIO()
local fonts = io.Fonts
fonts:AddFontDefault()
fonts:AddFontFromFileTTF("../../imgui/misc/fonts/Roboto-Medium.ttf", 16)
fonts:AddFontFromFileTTF("../../imgui/misc/fonts/Cousine-Regular.ttf", 15)
fonts:AddFontFromFileTTF("../../imgui/misc/fonts/DroidSans.ttf", 16)
fonts:AddFontFromFileTTF("../../imgui/misc/fonts/ProggyTiny.ttf", 10)
-- assert(fonts:AddFontFromFileTTF("c:\\Windows\\Fonts\\ArialUni.ttf", 18, nil, fonts:GetGlyphRangesJapanese()))

local show_demo_window, show_another_window = true, false
local clear_color = ig.ImVec4AsFloatP(wrapper.GetClearColor())
local f, counter = 0, 0
local ok

while not wrapper.WindowShouldClose() do
    wrapper.FrameBegin()

    if show_demo_window then
        show_demo_window = ig.ShowDemoWindow(show_demo_window)
    end

    ig.Begin("Hello, world!")

    ig.Text("This is some useful text.")
    ok, show_demo_window = ig.Checkbox("Demo Window", show_demo_window)
    ok, show_another_window = ig.Checkbox("Another Window", show_another_window)

    ok, f = ig.SliderFloat("float", f, 0, 1)
    ok = ig.ColorEdit3("clear color", clear_color)

    if ig.Button("button") then
        counter = counter + 1
    end
    ig.SameLine()
    ig.Text(string.format("counter = %d", counter))

    ig.Text(string.format("Application average %.3f ms/frame (%.1f FPS)", 1000 / io.Framerate, io.Framerate))

    ig.End()

    if show_another_window then
        ok, show_another_window = ig.Begin("Another Window", show_another_window)
        ig.Text("Hello from another window!")
        if ig.Button("Close Me") then
            show_another_window = false
        end
        ig.End()
    end

    wrapper.FrameEnd()
end
wrapper.Shutdown()
