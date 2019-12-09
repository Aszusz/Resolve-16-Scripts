#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
;#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#Include gui_lib.ahk

; === GLOBAL VARIABLES ===

video_inactive := New SearchGuiElement("video-inactive.png")

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

    start_pos := GetMousePosition()
    Send, {CtrlDown}9{CtrlUp}
    v2 := video_inactive.Find()
    if(v2 != False)
    {
        center := v2.GetCenter()
        MouseClick(center)
    }
    Else
    {
        MsgBox, Not Found
    }
}