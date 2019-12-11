#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
;#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#Include gui_lib.ahk

; === GLOBAL VARIABLES ===

video_active := New UiElement(A_ScriptDir . "\gui\video-active.png")
audio_active := New UiElement(A_ScriptDir . "\gui\audio-active.png")

composite := New UiElement(A_ScriptDir . "\gui\video-panel\composite.png")
transformation := New UiElement(A_ScriptDir . "\gui\video-panel\transform.png")
cropping := New UiElement(A_ScriptDir . "\gui\video-panel\cropping.png")
dynamic_zoom := New UiElement(A_ScriptDir . "\gui\video-panel\dynamic-zoom.png")
stabilization := New UiElement(A_ScriptDir . "\gui\video-panel\stabilization.png")
retime_and_scaling := New UiElement(A_ScriptDir . "\gui\video-panel\retime-and-scaling.png")
lens_correction := New UiElement(A_ScriptDir . "\gui\video-panel\lens-correction.png")

video_panel := [composite, transformation, cropping, dynamic_zoom, stabilization, retime_and_scaling, lens_correction]

clip_volume := New UiElement(A_ScriptDir . "\gui\audio-panel\clip-volume.png")
clip_pan := New UiElement(A_ScriptDir . "\gui\audio-panel\clip-pan.png")
clip_pitch := New UiElement(A_ScriptDir . "\gui\audio-panel\clip-pitch.png")
clip_equalizer := New UiElement(A_ScriptDir . "\gui\audio-panel\clip-equalizer.png")
freq := New UiElement(A_ScriptDir . "\gui\audio-panel\freq.png")

audio_panel := [clip_volume, clip_pan, clip_pitch, clip_equalizer, freq]

inspector_area := Rect.FromPoints(new Point(1500, 100), new Point(1920, 650))
full_screen := new Rect(new Point(0,0), new Dimensions(1920, 1080))



; === FUNCTIONS ===

FindAny(elements)
{
    global inspector_area

    for i, element in elements
    {
        ;MsgBox % .ToString()
        r := element.FindIn(inspector_area)
        if(r)
        {
            Return true
        }
    }
    Return false
}

GetCurrentPanel()
{
    global inspector_area, video_active, audio_active, video_panel, audio_panel

    if(video_active.FindIn(inspector_area))
    {
        Return "COMPOUND_VIDEO"
    }
    else if(audio_active.FindIn(inspector_area))
    {
        Return "COMPOUND_AUDIO"
    }
    else if(FindAny(video_panel))
    {
        Return "SIMPLE_VIDEO"
    }
    else if(FindAny(audio_panel))
    {
        Return "SIMPLE_AUDIO"
    }
    else
    {
        Throw Exception("Inspector is not active")
    }
}