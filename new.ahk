#NoEnv
#Include resolve_helper.ahk
#Include gui_lib.ahk

SendMode Input
SetWorkingDir %A_ScriptDir%
CoordMode, ToolTip, Client
CoordMode, Pixel, Client
CoordMode, Mouse, Client
CoordMode, Caret, Client
CoordMode, Menu, Client



; === MENU ===

Menu, ResolveMenu, Add, Import Desktop, ImportDesktopHandler
Menu, ResolveMenu, Add, Import Webcam, ImportWebcamHandler
Menu, ResolveMenu, Add,
Menu, ResolveMenu, Add, Test, TestHandler

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

TestHandler:
    Test()
    
    


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

Test()
{
    start := GetMousePosition()
    OpenInspector()
    InspectorScrollTop()
    type := GetInspectorType()
    MouseMoveAbsolute(start)
}