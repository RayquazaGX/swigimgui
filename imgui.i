// SWIG-4.0.2 binding for Dear Imgui 1.84.2

// Notes:
//
//   Unsupported functions:
//     Functions taking function-pointers as parameters
//
//   Ignored functions:
//     ImVector<> - "You generally do NOT need to care or use this ever. But we need to make it available in imgui.h because some of our public structures are relying on it." (imgui.h)
//     Obsolete functions and types - "Please keep your copy of dear imgui up to date! Occasionally set '#define IMGUI_DISABLE_OBSOLETE_FUNCTIONS' in imconfig.h to stay ahead." (imgui.h)
//     Functions taking `va_list` as the last parameter whose names end with `V`. (Other functions taking `va_list` are not ignored.)
//
//   `va_list` related behaviours:
//    Functions like `void Text(const char* fmt, ...)` are binded using the default behaviour of SWIG, which is, skipping the `...` entirely.
//    e.g. In Lua, you call `imgui.Text(string.format("%s%d", "This is formatted in Lua instead.", 123))`.
//    Note that as listed above, functions like `void TextV(const char* fmt, va_list args)` are not binded (ignored) at all.
//
//    Lua: Functions whose names are `end`: According to the default behaviour of `SWIG`, they are renamed to `c_end`
//
//    Lua: All bindings now should be in Lua style: featuring multi-val return, LuaTable-CArray conversion, etc.
//    eg. `local isShown, isOpened = imgui.Begin("Window", isOpened, flags)`
//

%module imgui

%{
    #include "imgui.h"
%}

//------
// General tags
//------

%ignore PlotLines;
%ignore PlotHistogram;
%ignore ListBoxHeader;
%ignore ListBoxFooter;
%ignore OpenPopupContextItem;

%ignore TextV;
%ignore TextColoredV;
%ignore TextDisabledV;
%ignore TextWrappedV;
%ignore LabelTextV;
%ignore BulletTextV;
%ignore TreeNodeV;
%ignore TreeNodeExV;
%ignore SetTooltipV;
%ignore LogTextV;
%ignore ImGuiTextBuffer::appendfv;

%ignore Value(const char*, int);          // Use float version instead
%ignore Value(const char*, unsigned int); // Use float version instead
%ignore ImColor::ImColor(int, int, int);          // Use float version instead
%ignore ImColor::ImColor(int, int, int, int);     // Use float version instead

%rename(tobool) ImGuiOnceUponAFrame::operator bool;
%rename(toImU32) ImColor::operator ImU32;
%rename(toImVec4) ImColor::operator ImVec4;

%newobject ImGui::GetVersion;
%newobject ImGui::ImDrawList::CloneOutput;

//------
// Array type tags
//------

%include <carrays.i>
%array_functions(bool, BoolArray)
%array_functions(int, IntArray)
%array_functions(float, FloatArray)
%array_functions(char, CharArray)
%array_functions(unsigned int, UintArray)
%array_functions(unsigned char, UcharArray)
%array_functions(char*, CharPArray)
%array_functions(ImDrawVert, ImDrawVertArray)
%array_functions(ImFontGlyph, ImFontGlyphArray)
%array_functions(ImColor, ImColorArray)
%array_functions(ImGuiStorage, ImGuiStorageArray)
%array_functions(ImGuiViewport, ImGuiViewportArray)

//------
// Typemap tags + Import header
//------

%include <typemaps.i>

%rename(ShowDemoWindow_NoArgOut) ShowDemoWindow();       //Divide the overloads, so that SWIG can know whether it has argument out
%rename(ShowMetricsWindow_NoArgOut) ShowMetricsWindow(); //Divide the overloads, so that SWIG can know whether it has argument out
%rename(ShowAboutWindow_NoArgOut) ShowAboutWindow();     //Divide the overloads, so that SWIG can know whether it has argument out
%rename(Begin_NoArgOut) Begin(const char* name);         //Divide the overloads, so that SWIG can know whether it has argument out
%rename(BeginPopupModal_NoArgOut) BeginPopupModal(const char* name); //Divide the overloads, so that SWIG can know whether it has argument out
%rename(BeginTabItem_NoArgOut) BeginTabItem(const char* label);      //Divide the overloads, so that SWIG can know whether it has argument out

%apply bool* INOUT {bool* p_open, bool* p_visible, bool* p_selected};
%apply bool* INOUT {bool* v};
%apply int* INOUT {int* v, int v[2], int v[3], int v[4]};
%apply int* INOUT {int* v_current_min, int* v_current_max};
%apply float* INOUT {float* v, float v[2], float v[3], float v[4], float col[3], float col[4]};
%apply float* INOUT {float* v_current_min, float* v_current_max, float* v_rad};
%apply double* INOUT {double* v};
%apply int* INOUT {int* current_item};
%apply int* OUTPUT {int* out_items_display_start, int* out_items_display_end, int* out_width, int* out_height, int* out_bytes_per_pixel};
%apply SWIGTYPE** OUTPUT {unsigned char** out_pixels};
%apply SWIGTYPE** INOUT {char** remaining};

%apply int { size_t };

%include "imgui.h"

%clear bool* p_open, bool* p_visible, bool* p_selected;
%clear bool* v;
%clear int* v, int v[2], int v[3], int v[4];
%clear int* v_current_min, int* v_current_max;
%clear float* v, float v[2], float v[3], float v[4], float col[3], float col[4];
%clear float* v_current_min, float* v_current_max, float* v_rad;
%clear double* v;
%clear int* current_item;
%clear int* out_items_display_start, int* out_items_display_end, int* out_width, int* out_height, int* out_bytes_per_pixel;
%clear unsigned char** out_pixels;
%clear char** remaining;

%clear size_t;

//------
// Helper functions
//------
%inline %{
    bool _SWIGExtra_IMGUI_CHECKVERSION(){
        return IMGUI_CHECKVERSION();
    };
%}

//------
// Macros and aliases
//------

#ifdef SWIGLUA
%define REG_CONST(type, name)
    %constant type _SWIGExtra_##name = name;
    %luacode{imgui.name = imgui._SWIGExtra_##name}
%enddef
%define REG_ALIAS(dest, source)
    %luacode{imgui.dest = imgui.source}
%enddef
#endif
//floats
REG_CONST(float, FLT_MIN)
REG_CONST(float, FLT_MAX)
//swig extras
REG_ALIAS(IMGUI_CHECKVERSION, _SWIGExtra_IMGUI_CHECKVERSION)

//------
// Lua wrapper functions
//------

%luacode {
    local _original = imgui
    local _metatable = getmetatable(_original)
    local _swig = {}
    for k, v in pairs(_original) do rawset(_original, k, nil); rawset(_swig, k, v) end
    local _wrapper = setmetatable(_original, {
        __index = function(t,k)
            local v = _swig[k]
            rawset(t,k,v)
            return v
        end})
    _wrapper.swig = setmetatable(_swig, _metatable)

    do
        local function _mergeArgoutSplittedFuncs(name, argCheckIndex)
            return function(...)
                if select(argCheckIndex, ...) ~= nil then
                    return _swig[name](...)
                else
                    return _swig[name.."_NoArgOut"](...)
                end
            end
        end
        local _data = {
            "ShowDemoWindow", 1,
            "ShowMetricsWindow", 1,
            "ShowAboutWindow", 1,
            "Begin", 2,
            "BeginPopupModal", 2,
            "BeginTabItem", 2,
        }
        for i = 1, #_data, 2 do
            _wrapper[_data[i]] = _mergeArgoutSplittedFuncs(_data[i], _data[i+1])
        end
    end
}
