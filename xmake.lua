add_rules("mode.release", "mode.debug")
set_languages("cxx11")

option("backend")
    set_showmenu(true)
    set_category("target_backend")
    set_default("none")
    set_values("none", "glfw_opengl3")
option_end()

option("language")
    set_showmenu(true)
    set_category("target_binding_language")
    set_default("lua")
    set_values("lua")
option_end()

option("lua_flavor")
    set_showmenu(true)
    set_category("lua_options/lua_flavor")
    set_default("luajit")
    set_values("luajit", "lua5.1", "lua5.2", "lua5.3", "lua5.4")
option_end()

if is_config("backend", "glfw.*") then
    add_requires("glfw", {configs={glfw_include="es3"}})
end

if is_config("language", "lua.*") then
    if is_config("lua_flavor", "luajit.*") then
        add_requires("luajit 2.1.0-beta3")
    elseif is_config("lua_flavor", "lua5%.1.*") then
        add_requires("lua 5.1")
    elseif is_config("lua_flavor", "lua5%.2.*") then
        add_requires("lua 5.2")
    elseif is_config("lua_flavor", "lua5%.3.*") then
        add_requires("lua 5.3")
    elseif is_config("lua_flavor", "lua5%.4.*") then
        add_requires("lua 5.4")
    end
end

local function getPlatformDefineSymbols()
    return (
        is_plat("windows") and {"-D_WIN32"}
        or is_plat("linux") and {"-D__linux__"}
        or is_plat("macosx") and {"-D__APPLE__"}
        or is_plat("android") and {"-D__ANDROID__"}
        or is_plat("iphoneos") and {"-D__APPLE__", "-DTARGET_OS_IOS"}
    )
end

target("swigimgui")
    set_kind("phony")
    set_default(true)

    before_build(function(target)
        if not is_config("language", "lua.*") then
            cprint("${yellow underline}Bindings to the target language are not implemented! Doing nothing. Please point to a implemented target with `xmake f --language=xxx`. ${clear}")
        end
    end)

    if is_config("language", "lua.*") then
        add_deps("swigimgui_lua")
    end
target_end()

target("swigimgui_lua")
    set_kind("shared")
    set_default(false)

    add_rules("swig.cpp", {moduletype = "lua"})
    if is_config("lua_flavor", "luajit.*") then
        add_packages("luajit")
    elseif is_config("lua_flavor", "lua.*") then
        add_packages("lua")
    end

    local imguiDefs = {"-DIMGUI_DISABLE_OBSOLETE_FUNCTIONS"}
    local swigflags = {"-no-old-metatable-bindings", "-Iimgui", "-Iimgui/backends"}
    table.join2(swigflags, imguiDefs)
    table.join2(swigflags, getPlatformDefineSymbols())

    before_build(function()
        swigflags[#swigflags+1] = "-DSWIGIMGUI_BACKEND_"..get_config("backend")
    end)

    add_includedirs("imgui")
    add_files("imgui/*.cpp")
    add_files("imgui.i", {swigflags = swigflags})

    add_includedirs("imgui/backends")
    if is_config("backend", ".*glfw.*") then
        add_files("imgui/backends/imgui_impl_glfw.cpp")
    end
    if is_config("backend", ".*opengl3.*") then
        add_files("imgui/backends/imgui_impl_opengl3.cpp")
    end

    if is_config("backend", "glfw_.*") then
        add_packages("glfw")
        swigflags[#swigflags+1] = "-IbackendWrapper/backendWrapper_glfw"
        add_includedirs("backendWrapper/backendWrapper_glfw")
        add_files("backendWrapper/backendWrapper_glfw/backendWrapper_$(backend).cpp")
        add_files("backendWrapper/backendWrapper_glfw/backendWrapper_glfw.i", {swigflags = swigflags})
    else
        -- Can add more backend supports here
    end

    add_cxflags(table.unpack(imguiDefs))

target_end()
