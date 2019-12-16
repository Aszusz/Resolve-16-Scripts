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
Menu, ResolveMenu, Add, Large Left, VideoLargeLeftHandler
Menu, ResolveMenu, Add, Large Right, VideoLargeRightHandler
Menu, ResolveMenu, Add, Large Center, VideoLargeCenterHandler
Menu, ResolveMenu, Add,
Menu, ResolveMenu, Add, Small Left, VideoSmallLeftHandler
Menu, ResolveMenu, Add, Small Right, VideoSmallRightHandler
Menu, ResolveMenu, Add, Small Center, VideoSmallCenterHandler
Menu, ResolveMenu, Add,
Menu, ResolveMenu, Add, Reset To Default, ResetToDefaultHandler

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

; Large Video

VideoLargeLeftHandler:
    SetVideoParameters("1.25", "-240", "0", "0", "0", "0", "0")
    Return

VideoLargeRightHandler:
    SetVideoParameters("1.25", "240", "0", "0", "0", "0", "0")
    Return

VideoLargeCenterHandler:
    SetVideoParameters("1.25", "0", "0", "0", "0", "0", "0")
    Return

; Small Video

VideoSmallLeftHandler:
    SetVideoParameters("0.25", "710", "-395", "320", "0", "0", "0")
    Return

VideoSmallRightHandler:
    SetVideoParameters("0.25", "790", "-395", "0", "320", "0", "0")
    Return

VideoSmallCenterHandler:
    SetVideoParameters("0.25", "750", "-395", "160", "160", "0", "0")
    Return

; Default

ResetToDefaultHandler:
    SetVideoParameters("1.0", "0", "0", "0", "0", "0", "0")
    Return
    
    


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

SetVideoParameters(zoom, position_x, position_y, left, right, top, bottom)
{
    start := GetMousePosition()
    OpenInspector()
    InspectorScrollTop()
    if(AssertVideo())
    {
        ExpandTransformPanel()
        SelectZoomX()
        Transform(zoom, position_x, position_y)
        Crop(left, right, top, bottom)
    }
    MouseMoveAbsolute(start)
}