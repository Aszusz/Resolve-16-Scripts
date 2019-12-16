#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
;#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#Include gui_lib.ahk

; === GLOBAL VARIABLES ===

inspector_type_area := new Rect(new Point(1545, 79), new Dimensions(248, 37))
inspector_area := new Rect(new Point(1500, 79), new Dimensions(420, 622))
max_scrolls := 20

complex_video := new UiElement(A_ScriptDir . "\gui\inspector\complex-video.png")
complex_audio := new UiElement(A_ScriptDir . "\gui\inspector\complex-audio.png")
simple_video := new UiElement(A_ScriptDir . "\gui\inspector\simple-video.png")
simple_audio := new UiElement(A_ScriptDir . "\gui\inspector\simple-audio.png")

video_inactive := new UiElement(A_ScriptDir . "\gui\video-inactive.png")
audio_inactive := new UiElement(A_ScriptDir . "\gui\audio-inactive.png")

tp_header_collpased := new UiElement(A_ScriptDir . "\gui\video-panel\tp-header-collapsed.png")
tp_header_expanded := new UiElement(A_ScriptDir . "\gui\video-panel\tp-header-expanded.png")
tp_zoom_active := new UiElement(A_ScriptDir . "\gui\video-panel\tp-zoom-active.png")
tp_zoom_inactive := new UiElement(A_ScriptDir . "\gui\video-panel\tp-zoom-inactive.png")
transform_panel := new Panel(tp_header_collpased, tp_header_expanded, tp_zoom)


; === FUNCTIONS ===

InspectorScrollTop()
{
    global inspector_area

    MouseMoveAbsolute(inspector_area.GetCenter())

    Loop, 15
    {
        Send {WheelUp}
        Sleep, 1
    }
}

OpenInspector()
{
    Send ^{9}
}

GetInspectorType()
{
    global inspector_type_area
    global complex_video, complex_audio, simple_video, simple_audio

    if(complex_video.FindIn(inspector_type_area))
    {
        Return "COMPLEX_VIDEO"
    }
    else if(complex_audio.FindIn(inspector_type_area))
    {
        Return "COMPLEX_AUDIO"
    }
    else if(simple_video.FindIn(inspector_type_area))
    {
        Return "SIMPLE_VIDEO"
    }
    else if(simple_audio.FindIn(inspector_type_area))
    {
        Return "SIMPLE_AUDIO"
    }
    else
    {
        Return "NO_INSPECTOR"
    }
}

AssertVideo()
{
    global inspector_area, video_inactive

    type := GetInspectorType()

    if(type == "COMPLEX_AUDIO")
    {
        rect := video_inactive.FindIn(inspector_area)
        point := rect.GetCenter()
        MouseLeftClickAbsolute(point)
        InspectorScrollTop()
    }

    if(type == "COMPLEX_AUDIO" || type == "COMPLEX_VIDEO" || type == "SIMPLE_VIDEO")
    {
        Return True
    }
    else
    {
        Return False
    }
}

AssertAudio()
{
    global inspector_area, audio_inactive

    type := GetInspectorType()

    if(type == "COMPLEX_VIDEO")
    {
        rect := audio_inactive.FindIn(inspector_area)
        point := rect.GetCenter()
        MouseLeftClickAbsolute(point)
        InspectorScrollTop()
    }

    if(type == "COMPLEX_VIDEO" || type == "COMPLEX_AUDIO" || type == "SIMPLE_AUDIO")
    {
        Return True
    }
    else
    {
        Return False
    }
}

ExpandTransformPanel()
{
    global inspector_area, max_scrolls
    global tp_header_collpased, tp_header_expanded
    
    scrollPoint := inspector_area.GetCenter()
    MouseMoveAbsolute(scrollPoint)

    scrolls := 0
    collapsed := tp_header_collpased.FindIn(inspector_area)
    expanded := tp_header_expanded.FindIn(inspector_area)
    While(!collapsed && !expanded && scrolls < max_scrolls) 
    {            
        Send, {WheelDown}
        scrolls++     
        collapsed := tp_header_collpased.FindIn(inspector_area)
        expanded := tp_header_expanded.FindIn(inspector_area)       
    } 

    if(collapsed)
    {
        MouseLeftDoubleClickAbsolute(collapsed.GetCenter())
        Sleep, 500
    }
}

SelectZoomX()
{
    global inspector_area, max_scrolls
    global tp_zoom_active, tp_zoom_inactive

    scrolls := 0
    active := tp_zoom_active.FindIn(inspector_area)
    inactive := tp_zoom_inactive.FindIn(inspector_area)
    While(!active && !inactive && scrolls < max_scrolls) 
    {          
        Send, {WheelDown}
        scrolls++     
        active := tp_zoom_active.FindIn(inspector_area)
        inactive := tp_zoom_inactive.FindIn(inspector_area)     
    }

    zoom_label := new Point(0,0)
    if(inactive)
    {
        zoom_label := inactive.GetCenter()
    }
    else if(active)
    {
        zoom_label := active.GetCenter()
    }
    else
    {
        Throw, Exception("Cannot Find Label")
    }

    zoom_x := new Point(zoom_label.left + 65, zoom_label.top)
    MouseLeftClickAbsolute(zoom_x)
}

Transform(zoom, position_x, position_y)
{
    Send % zoom
    Send {Enter}
    Send {Tab 5}
    Send % position_x
    Send {Enter}
    Send {Tab}
    Send % position_y
    Send {Enter}
}

Crop(left, right, top, bottom)
{
    Send {Tab 28}
    Send % left
    Send {Enter}
    Send {Tab 4}
    Send % right
    Send {Enter}
    Send {Tab 4}
    Send % top
    Send {Enter}
    Send {Tab 4}
    Send % bottom
    Send {Enter}
}