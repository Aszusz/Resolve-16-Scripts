#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
;#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#Include resolve_helper.ahk

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
    panel := GetCurrentPanel()
    MsgBox % panel
    
    


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