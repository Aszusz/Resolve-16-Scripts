#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#Include Gdip_All.ahk


; === CLASSES ===

Class Point
{
    __New(x, y)
    {
        this.x := x,
        this.y := y,
    }

    Print()
    {
        MsgBox % "Point: " this.x ", " this.y
    }
}



Class Dimensions
{
    __New(width, height)
    {
        this.width := width
        this.height := height
    }

    Print()
    {
        MsgBox % "Dimensions: " this.width ", " this.height
    }
}



Class SearchGuiElement
{
    __New(filename)
    {
        this.fullPath := GetPath(filename)      
        this.dimensions := GetDimensions(this.fullPath) 
    }

    Find()
    {
        corner := FindOnFullScreen(this.fullPath)
        if(corner != False)
        {
            Return new FoundGuiElement(this, corner)
        }
        Else
        {
            return False
        }
    }

    Print()
    {
        msg := "SearchGuiElement: " . this.fullPath
        msg := msg . "`ndimensions: " . this.dimensions.width . ", " this.dimensions.height
        MsgBox % msg
    }
}



Class FoundGuiElement
{
    __New(element, corner)
    {
        this.element := element
        this.corner := corner
    }

    GetCenter()
    {
        x := this.corner.x + 0.5 * this.element.dimensions.width
        y := this.corner.y + 0.5 * this.element.dimensions.height
        Return new Point(x, y)
    }

    Print()
    {
        msg := "SearchGuiElement: " . this.element.fullPath
        msg := msg . "`ndimensions: " . this.element.dimensions.width . ", " this.element.dimensions.height
        msg := msg . "`ncorner: " . this.corner.x . ", " this.corner.y
        MsgBox % msg
    }
}



;=== HELPERS ===

GetPath(filename)
{
    Return A_ScriptDir . "\gui\" . filename
}

GetDimensions(path)
{
    pToken := Gdip_StartUp()        
    pBitmap := Gdip_CreateBitmapFromFile(path)
    Gdip_GetImageDimensions(pBitmap, w, h)
    Gdip_DisposeImage(pBitmap)
    Gdip_ShutDown(pToken)
        
    Return New Dimensions(w, h)
}

FindOnFullScreen(path)
{
    ImageSearch, found_x, found_y, 0, 0, 1980, 1020, %path%
    if (ErrorLevel = 2)
        MsgBox, Cannot conduct search
    else if (ErrorLevel = 1)
        Return false
    else
        Return new Point(found_x, found_y)
}

GetMousePosition()
{
    MouseGetPos, x, y
    Return new Point(x, y)
}

MouseMove(point)
{
    MouseMove, point.x, point.y, 0
}

MouseClick(point)
{
    MouseClick, left, point.x, point.y, 1, 0
}