# swigimgui #

[SWIG](http://www.swig.org/) binding for [Dear ImGui](https://github.com/ocornut/imgui)

This repo genertates Dear ImGui bindings to other languages (eg. Lua), by providing a `imgui.i` SWIG interface file.

> SWIG is a software development tool that connects programs written in C and C++ with a variety of high-level programming languages (C#, Java, Lua, Python, Ruby, ...)

> Dear ImGui: Bloat-free Graphical User interface for C++ with minimal dependencies

## Current Status ##

- SWIG 4.0.2
- ImGui 1.85 master branch
    - `imconfig.h` (or customized IMGUI_USER_CONFIG)
    - `imgui.h`
- Supported languages:
    - [x] Lua
- Supported backends:
    - [x] none (You can compile the project without a backend)
    - [x] `glfw_opengl` (for demonstrating how to add support for a particular backend. See files in the `backendWrapper` folder.)

## Build ##

This provided build method requires [`xmake`](https://github.com/xmake-io/xmake#installation) and [`SWIG`](http://www.swig.org/download.html) installed.

```sh
xmake config --menu # Config the project using a terminal ui. You choose a target language and other options in the menu `Project Configuration`.
xmake               # Build with saved configs.
```

## Example ##

### Lua ###

```lua

-- To run this example, you need to config and build the repo with a working backend, eg.:
--   ```sh
--   xmake config --backend="glfw_opengl3" --language="lua" --lua_flavor="luajit"
--   xmake
--   ```
-- Then add the library into search path when starting Lua or LuaJIT. eg.:
--   ```sh
--   luajit -e "package.cpath=package.cpath..';./build/linux/x86_64/release/swigimgui_lua.so'" "example.lua"
--   ```

-- Load the modules from the library.
local ig = require "imgui"
local wrapper = require "imgui_backendWrapper"
local showDemo = true

-- Create a ImGui and backend context by initializing a window.
wrapper.InitWindow(1280, 720, "Dear ImGui GLFW+OpenGL3 example")

-- Main loop.
while not wrapper.WindowShouldClose() do

    -- Begin a new backend rendering frame.
    wrapper.FrameBegin()

    -- Do any ImGui or backend stuffs.
    if showDemo then
        showDemo = ig.ShowDemoWindow(showDemo)
    end
    ig.Begin("Hello, world!")
    ig.Text("This is some useful text.")
    ig.End()

    -- Apply and render the ImGui draw list, and end the frame.
    wrapper.FrameEnd()
end

-- Destroy the ImGui and backend context.
wrapper.Shutdown()

```

## Performance Notes ##

- Because the module contains a large number(hundreds) of symbols binded, for some languages(Lua) a wrapper on top of the generated SWIG module has been added, providing only a small set of symbols when the module imported, and only automatically adding needed symbols on demand, thus saving searching time. See file `imgui.i`.
    - The original unwrapped module is still accessible in these languages. eg. `imgui.swig` in Lua.
- Interops are expensive. Here are some tips to save interop counts:
    - If a simple struct instance is to be modified many times (eg. C++ `ImVec2` value calculated inside a loop):
        - It might not be a good idea to use the struct fields directly in complex calculations, because SWIG wraps the getter and setter functions to contain implicit C/C++ <-> script type conversions. Instead, if needed, copy the fields as local types, and after calculations copy back the results to the struct instance.
        - `ImVec2AsFloatP`, `ImVec4AsFloatP`, `FloatPAsImVec2`, `FloatPAsImVec4` are added as helper functions inside `imgui.swig` and usable for binding target languages.
    - You can modify the binding file to contain you own C/C++ functions to possibly prevent some interops happen, and generate bindings of them for your need.

## Pull Requests are welcomed ##

Would be nicer if this repo can be a collection featuring Ruby/Python/... bindings as well!

## LICENSE ##

MIT
