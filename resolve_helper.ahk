#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
;#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#Include gui_lib.ahk

Class Panel
{
    __New(header_collapsed, header_expanded, first_item)
    {
        this.header_collapsed := header_collapsed
        this.header_expanded := header_expanded
        this.first_item := first_item
    }

    ScrollIntoView(area, max_scrolls)
    {
        scrollPoint := area.GetCenter()
        MouseMoveAbsolute(scrollPoint)

        scrolls := 0
        collapsed := this.header_collapsed.FindIn(area)
        expanded := this.header_expanded.FindIn(area)
        While(!collapsed && !expanded && scrolls < max_scrolls) 
        {            
            Send, {WheelDown}
            scrolls++     
            collapsed := this.header_collapsed.FindIn(area)
            expanded := this.header_expanded.FindIn(area)       
        } 

        if(collapsed)
        {
            MouseLeftClickAbsolute(collapsed.GetCenter())
            MouseLeftClickAbsolute(collapsed.GetCenter())
            Sleep, 1000
        }

        first_item := this.first_item.FindIn(area)
        While(!first_item && scrolls < max_scrolls) 
        {            
            Send, {WheelDown}
            scrolls++     
            first_item := this.first_item.FindIn(area)       
        }

        Return first_item
    }
}

; === GLOBAL VARIABLES ===

inspector_type_area := new Rect(new Point(1545, 79), new Dimensions(248, 37))
inspector_area := new Rect(new Point(1500, 79), new Dimensions(420, 622))

complex_video := new UiElement(A_ScriptDir . "\gui\inspector\complex-video.png")
complex_audio := new UiElement(A_ScriptDir . "\gui\inspector\complex-audio.png")
simple_video := new UiElement(A_ScriptDir . "\gui\inspector\simple-video.png")
simple_audio := new UiElement(A_ScriptDir . "\gui\inspector\simple-audio.png")

video_inactive := new UiElement(A_ScriptDir . "\gui\video-inactive.png")
audio_inactive := new UiElement(A_ScriptDir . "\gui\audio-inactive.png")

tp_header_collpased := new UiElement(A_ScriptDir . "\gui\video-panel\tp-header-collapsed.png")
tp_header_expanded := new UiElement(A_ScriptDir . "\gui\video-panel\tp-header-expanded.png")
tp_zoom := new UiElement(A_ScriptDir . "\gui\video-panel\tp-zoom.png")
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

TransformClip(zoom, position_x, position_y)
{
    global transform_panel, inspector_area

    panel := transform_panel.ScrollIntoView(inspector_area, 20)
    if(panel)
    {
        zoom := panel.GetCenter()
        MouseMoveAbsolute(zoom)
        ;MouseLeftClickAbsolute(zoom)
        ;Send, zoom
    }
}

FindTransformPanel()
{
    global transform_panel, inspector_area

    panel := transform_panel.first_item.FindIn(inspector_area)
    MsgBox % panel.ToString()
}