// SWIG-4.0.2 binding for Dear Imgui 1.84.2

// Notes:
//
//   Unsupported functions:
//     Functions taking function-pointers as parameters
//     ImVector<> - "You generally do NOT need to care or use this ever. But we need to make it available in imgui.h because some of our public structures are relying on it." (imgui.h)
//
//   Ignored functions:
//     Some operator overrides (`operator new`, `operator delete`)
//     Functions from nested structures
//     Obsolete functions and types - "Please keep your copy of dear imgui up to date! Occasionally set '#define IMGUI_DISABLE_OBSOLETE_FUNCTIONS' in imconfig.h to stay ahead." (imgui.h)
//     Functions taking `va_list` as the last parameter whose names end with `V` (Other functions taking `va_args` are not ignored)
//
//   Renamed functions:
//     All languages: Combo_itemsSeperatedByZeros <- Combo(const char* label, int* current_item, const char* items_separated_by_zeros, int popup_max_height_in_items = -1);
//     All languages: Combo_itemsGetter <- Combo(const char* label, int* current_item, bool(*items_getter)(void* data, int idx, const char** out_text), void* data, int items_count, int popup_max_height_in_items = -1);
//     All languages: ListBox_itemsGetter <- ListBox(const char* label, int* current_item, bool (*items_getter)(void* data, int idx, const char** out_text), void* data, int items_count, int height_in_items = -1);
//     All languages: GetColorU32_ImU32 <- GetColorU32(ImU32 col);
//     Lua: Functions whose names are `end`: They are renamed to `c_end` because `end` is a Lua keyword
//     Lua: Type conversion operators: They are renamed to `toXXX` (`tobool`, `toImU32`, ...)
//
//   Shadowed functions:
//     Lua: Shadowed because float number is preferred: Value(const char*, int), Value(const char*, unsigned int)
//     Lua: Shadowed because float number is preferred: ImColor::ImColor(int, int, int), ImColor::ImColor(int, int, int, int)
//
//   `va_list` related behaviours:
//    Functions like `void Text(const char* fmt, ...)` are binded using the default behaviour of SWIG, which is, skipping the `...` entirely.
//    e.g. In Lua, you call `imgui.Text(string.format("%s%d", "This is formatted in Lua instead.", 123))`.
//    Note that as listed above, functions like `void TextV(const char* fmt, va_list args)` are not binded (ignored) at all.
//
//    Lua: All bindings now should be in Lua style: featuring multi-val return, etc.
//    eg. `local isShown, isOpened = imgui.Begin("Window", isOpened, flags)`
//

%module imgui

%luacode {
    local _moduleName = "imgui"
    local _swig = _G[_moduleName]
    _G[_moduleName] = nil
}

%{
    #include "imgui.h"
%}

//------
// General tags
//------

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

%ignore operator new(size_t, ImNewWrapper, void*);   // Ignored because SWIG doesn't support this operator
%ignore operator delete(void*, ImNewWrapper, void*); // Ignored because SWIG doesn't support this operator
%ignore ImGuiTextFilter::ImGuiTextRange; // Ignored because SWIG doesn't support nested structs
%ignore ImGuiStorage::ImGuiStoragePair;  // Ignored because SWIG doesn't support nested structs
#ifdef SWIGLUA
%ignore Value(const char*, int);          // Always use float version instead
%ignore Value(const char*, unsigned int); // Always use float version instead
%ignore ImColor::ImColor(int, int, int);          // Always use float version instead
%ignore ImColor::ImColor(int, int, int, int);     // Always use float version instead
%rename(c_end) end;
%rename(tobool) ImGuiOnceUponAFrame::operator bool;
%rename(toImU32) ImColor::operator ImU32;
%rename(toImVec4) ImColor::operator ImVec4;
#endif

%ignore Selectable(const char* label, bool selected = false, ImGuiSelectableFlags flags = 0, const ImVec2& size = ImVec2(0, 0)); // Always use `p_selected` version instead
%ignore MenuItem(const char* label, const char* shortcut = NULL, bool selected = false, bool enabled = true); // Always use `p_selected` version instead
%rename(RadioButton_shortcut) RadioButton(const char* label, int* v, int v_button);
%rename(CollapsingHeader_shortcut) CollapsingHeader(const char* label, ImGuiTreeNodeFlags flags = 0);

%rename(Combo_itemsSeperatedByZeros) Combo(const char* label, int* current_item, const char* items_separated_by_zeros, int popup_max_height_in_items = -1);
%rename(Combo_itemsGetter) Combo(const char* label, int* current_item, bool(*items_getter)(void* data, int idx, const char** out_text), void* data, int items_count, int popup_max_height_in_items = -1);
%rename(ListBox_itemsGetter) ListBox(const char* label, int* current_item, bool (*items_getter)(void* data, int idx, const char** out_text), void* data, int items_count, int height_in_items = -1);
%rename(GetColorU32_ImU32) GetColorU32(ImU32 col);

%newobject ImGui::GetVersion;
%newobject ImGui::ImDrawList::CloneOutput;

%immutable ImGuiIO::IniFilename;
%immutable ImGuiIO::LogFilename;
%immutable ImGuiIO::BackendPlatformName;
%immutable ImGuiIO::BackendRendererName;
%immutable ImDrawList::_OwnerName;

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

//-- Compactify default args of most of the overload functions, so that SWIG can successfully apply `argout` typemaps to overcome arg type checks of overloads; except for the cases where the count of `argout` arguments is uncertain
%feature("compactdefaultargs");
%feature("compactdefaultargs", "0") ShowDemoWindow;
%feature("compactdefaultargs", "0") ShowMetricsWindow;
%feature("compactdefaultargs", "0") ShowAboutWindow;
%feature("compactdefaultargs", "0") Begin;
%feature("compactdefaultargs", "0") BeginPopupModal;
%feature("compactdefaultargs", "0") BeginTabItem;

//-- Split some of the overload functions, so that SWIG can know how many args is for `in` and `argout` typemaps
%rename(ShowDemoWindow_0) ShowDemoWindow();
%rename(ShowDemoWindow_1) ShowDemoWindow(bool*);
%rename(ShowMetricsWindow_0) ShowMetricsWindow();
%rename(ShowMetricsWindow_1) ShowMetricsWindow(bool*);
%rename(ShowAboutWindow_0) ShowAboutWindow();
%rename(ShowAboutWindow_1) ShowAboutWindow(bool*);
%rename(Begin_1) Begin(const char*);
%rename(Begin_2) Begin(const char*, bool*);
%rename(Begin_3) Begin(const char*, bool*, ImGuiWindowFlags);
%rename(BeginPopupModal_1) BeginPopupModal(const char*);
%rename(BeginPopupModal_2) BeginPopupModal(const char*, bool*);
%rename(BeginPopupModal_3) BeginPopupModal(const char*, bool*, ImGuiWindowFlags);
%rename(BeginTabItem_1) BeginTabItem(const char*);
%rename(BeginTabItem_2) BeginTabItem(const char*, bool*);
%rename(BeginTabItem_3) BeginTabItem(const char*, bool*, ImGuiTabItemFlags);

%apply bool* INOUT {bool* p_open, bool* p_visible, bool* p_selected};
%apply bool* INOUT {bool* v};
%apply int* INOUT {int* v};
%apply int* INOUT {int* v_current_min, int* v_current_max};
%apply float* INOUT {float* v};
%apply float* INOUT {float* v_current_min, float* v_current_max, float* v_rad};
%apply double* INOUT {double* v};
%apply int* INOUT {int* current_item};
%apply int* OUTPUT {int* out_items_display_start, int* out_items_display_end, int* out_width, int* out_height, int* out_bytes_per_pixel};
%apply SWIGTYPE** OUTPUT {unsigned char** out_pixels};

%apply int { size_t };

%include "imgui.h"

%clear bool* p_open, bool* p_visible, bool* p_selected;
%clear bool* v;
%clear int* v;
%clear int* v_current_min, int* v_current_max;
%clear float* v;
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
    }

    float* ImVec2AsFloatP(ImVec2* vec){
        return (float*) vec;
    }
    float* ImVec4AsFloatP(ImVec4* vec){
        return (float*) vec;
    }
    ImVec2* FloatPAsImVec2(float* p){
        return (ImVec2*) p;
    }
    ImVec4* FloatPAsImVec4(float* p){
        return (ImVec4*) p;
    }

%}

//------
// Macros and aliases
//------

#ifdef SWIGLUA
%define REG_CONST(type, name)
    %constant type _SWIGExtra_##name = name;
    %luacode{_swig.name = _swig._SWIGExtra_##name}
%enddef
%define REG_ALIAS(dest, source)
    %luacode{_swig.dest = _swig.source}
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
    local _wrapper = {}
    local _metatable = getmetatable(_swig)
    for k, v in pairs(_swig) do
        rawset(_swig, k, nil)
        rawset(_wrapper, k, v)
    end
    _wrapper, _swig = _swig, _wrapper
    setmetatable(_wrapper, {
        __index = function(t,k)
            local v = _swig[k]
            rawset(t,k,v)
            return v
        end})
    setmetatable(_swig, _metatable)
    _wrapper.swig = _swig
    package.loaded[_moduleName] = _wrapper

    do
        local function _mergeSplittedFuncs(name)
            return function(...)
                local n = select('#', ...)
                local resolved = string.format("%s_%d", name, n)
                if _swig[resolved] then
                    return _swig[resolved](...)
                else
                    return _swig[name](...)
                end
            end
        end
        local _data = {
            "ShowDemoWindow",
            "ShowMetricsWindow",
            "ShowAboutWindow",
            "Begin",
            "BeginPopupModal",
            "BeginTabItem",
        }
        for i = 1, #_data do
            _wrapper[_data[i]] = _mergeSplittedFuncs(_data[i])
        end
    end

    do
        local function _mergeShortcutFuncs(name, argIndex, thatArgOriginalType)
            return function(...)
                local arg = select(argIndex, ...)
                if type(arg) == thatArgOriginalType then
                    return _swig[name](...)
                else
                    return _swig[name.."_shortcut"](...)
                end
            end
        end
        local _data = {
            "RadioButton", 2, "boolean",
            "CollapsingHeader", 2, "boolean",
        }
        for i = 1, #_data, 3 do
            _wrapper[_data[i]] = _mergeShortcutFuncs(_data[i], _data[i+1], _data[i+2])
        end
    end
}
