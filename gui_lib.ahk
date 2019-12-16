#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#Include Gdip_All.ahk



; === CLASSES ===

Class Point
{
    __New(left, top)
    {
        this.left := left,
        this.top := top,
    }

    ToString()
    {
        Return "Point: " this.left ", " this.top
    }
}

Class Dimensions
{
    __New(width, height)
    {
        this.width := width
        this.height := height
    }

    ToString()
    {
        Return "Dimensions: " this.width ", " this.height
    }
}

Class Rect
{
    __New(leftTop, dimensions)
    {
        this.leftTop := leftTop
        this.dimensions := dimensions
    }

    FromPoints(leftTop, rightBottom)
    {
        width := rightBottom.left - leftTop.left
        height := rightBottom.top - leftTop.top
        Return new Rect(leftTop, new Dimensions(width, height))
    }

    GetRightBottom()
    {
        x := this.leftTop.left + this.dimensions.width
        y := this.leftTop.top + this.dimensions.height
        Return new Point(x, y)
    }

    GetCenter()
    {
        x := this.leftTop.left + 0.5 * this.dimensions.width
        y := this.leftTop.top + 0.5 * this.dimensions.height
        Return new Point(x, y)
    }

    ToString()
    {
        msg := "Rect: " . this.leftTop.left . ", " . this.leftTop.top
        msg := msg . ", " . this.dimensions.width ", " . this.dimensions.height
        Return msg
    }
}

Class UiElement
{
    __New(path)
    {
        this.path := path
        this.dimensions := GetDimensions(path)
    }

    FindIn(area)
    {
        leftTop := FindImage(this.path, area)
        if(leftTop)
        {
            Return new Rect(leftTop, this.dimensions)
        }
        else
        {
            Return false
        }
    }

    ToString()
    {
        Return this.path
    }
}



;=== FUNCTIONS ===

GetMousePosition()
{
    MouseGetPos, left, top
    Return new Point(left, top)
}

MouseMoveAbsolute(point)
{
    MouseMove, point.left, point.top   
}

MouseLeftClickAbsolute(point)
{
    MouseClick, left, point.left, point.top, 1, 0
}

GetDimensions(path)
{
    pToken := Gdip_StartUp()        
    pBitmap := Gdip_CreateBitmapFromFile(path)
    Gdip_GetImageDimensions(pBitmap, width, height)
    Gdip_DisposeImage(pBitmap)
    Gdip_ShutDown(pToken)
        
    Return New Dimensions(width, height)
}

FindImage(path, area)
{
    left := area.leftTop.left
    top := area.leftTop.top
    right := area.GetRightBottom().left
    bottom := area.GetRightBottom().top

    try
    {
        ImageSearch, found_x, found_y, left, top, right, bottom, %path%
    }
    catch e
    {
        e.Message := "Cannot conduct search on: " path
        throw e
    }
    
    if (ErrorLevel = 1)
    {
        Return false
    }
    else
    {
        Return new Point(found_x, found_y)
    }
}

FindImageFullScreen(path)
{
    Return FindImage(path, new Rect(new Point(0,0), new Dimensions(1920,1080)))
}