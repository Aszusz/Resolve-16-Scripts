#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
;#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#Include gui_lib.ahk

; === GLOBAL VARIABLES ===

video_inactive := New SearchGuiElement("video-inactive.png")

s1 := New SearchGuiElement("\gui\video-panel\composite.png")
s2 := New SearchGuiElement("\gui\video-panel\transform.png")
s3 := New SearchGuiElement("\gui\video-panel\cropping.png")
s4 := New SearchGuiElement("\gui\video-panel\retime-and-scaling.png")

video_panel := [s1, s2, s3, s4]

; === MENU ===

Menu, ResolveMenu, Add, Import Desktop, ImportDesktopHandler
Menu, ResolveMenu, Add, Import Webcam, ImportWebcamHandler
Menu, ResolveMenu, Add,
Menu, ResolveMenu, Add, Zoom, ZoomHandler

#If WinActive("ahk_exe Resolve.exe")
    LWin::
        Menu, ResolveMenu, Show
    Return
#If

ImportWebcamHandler:
    ImportFiles("C:\Data\Videos\Courses\Working\Webcam")
    Return

ImportDesktopHandler:
    ImportFiles("C:\Data\Videos\Courses\Working\Desktop")
    Return

ZoomHandler:
    Zoom()
    


;=== HELPERS ===

ImportFiles(folder)
{
	Send, {Ctrl Down}i{Ctrl Up}
	WinWaitActive, Import Media
    Send, {F4}{Esc}{Del}
	SendInput, %folder%
    Send {Enter}
    Send, {Tab}{Tab}
    Send, {ctrl down}a{ctrl up}
    Send, {Enter}
}

Zoom()
{
    global video_inactive
    global video_panel

    start_pos := GetMousePosition()
    Send, {CtrlDown}9{CtrlUp}
    
    for i, element in video_panel
    {
        res := element.Find()
        if(res == False)
        {
            MsgBox, NotFound
        }
        Else
        {
            res.Print()
        }
    }
}