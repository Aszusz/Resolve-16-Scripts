#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
;#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#Include gui_lib.ahk

; === GLOBAL VARIABLES ===

inspector_type_area := new Rect(new Point(1545, 79), new Dimensions(248, 37))
inspector_scroll_point := new Point(1710, 300)

complex_video := new UiElement(A_ScriptDir . "\gui\inspector\complex-video.png")
complex_audio := new UiElement(A_ScriptDir . "\gui\inspector\complex-audio.png")
simple_video := new UiElement(A_ScriptDir . "\gui\inspector\simple-video.png")
simple_audio := new UiElement(A_ScriptDir . "\gui\inspector\simple-audio.png")


; === FUNCTIONS ===

InspectorScrollTop()
{
    global inspector_scroll_point

    MouseMoveAbsolute(inspector_scroll_point)

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