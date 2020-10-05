#SingleInstance, Force
#Persistent

CoordMode, Pixel, Relative
CoordMode, Mouse, Relative
SetControlDelay -1
#include Lib\Gdip_All.ahk

AikaClient := 154476
image := "img\test.png"
global AikaID
;x%itemX% y%itemY%
;ImageSearch, itemX, itemY, 1920, 11, 3285, 778, *%A_Index% img/tp.png

#Space::
getImageSize(image)

getImageSize(image){
	pToken := Gdip_StartUp()
	pBitmap := Gdip_CreateBitmapFromFile(image)
	Gdip_GetImageDimensions(pBitmap, w, h)
	Gdip_DisposeImage(pBitmap)
	Gdip_ShutDown(pToken)
	Coords = w, h
	MsgBox, % "Width: " w " Height: " h
}

#F1::
WinGet AikaID, , ahk_pid %AikaClient%
ImageSearch, itemX, itemY, 0, 0, 1920, 1080, *50 %image%
Coords = % "x" itemX " y" itemY
Random randCoordX, 10, 25
Random randCoordY, 5, 10
itemclickX := itemX + randCoordX
itemclickY := itemY + randCoordY
if (ErrorLevel = 0)
{
	;Random, mouseSpeed, 5, 10
	;Random, randSleep, 300, 1000
	;MouseMove itemclickX, itemclickY
	EquipUnequipItem(itemclickX, itemclickY)
	;ToolTip Found at (%itemX%`, %itemY%) with variation of %A_Index% 
}
if (ErrorLevel = 1)
	ToolTip Searching...
if (ErrorLevel = 2)
{
	if !(FileExist(image))
		ToolTIp Error! File doesn't exist!
	else 
		ToolTip, Error! There was a problem that prevented the command from conducting the search (i.e. failure to open the image file`, or a badly formatted option)
}


return

EquipUnequipItem(X, Y){
	ToolTIp Coords = x%X% y%Y%, , , 
	RandomMouseDelay()
	PostMessage, 0x201, 0, X&0xFFFF | Y<<16,, ahk_id %AikaID% ; WM_LBUTTONDOWN  
	PostMessage, 0x202, 0, X&0xFFFF | Y<<16,, ahk_id %AikaID% ; WM_LBUTTONUP  
	PostMessage, 0x203, 0, X&0xFFFF | Y<<16,, ahk_id %AikaID% ; WM_LBUTTONDBLCLCK 
	PostMessage, 0x202, 0, X&0xFFFF | Y<<16,, ahk_id %AikaID% ; WM_LBUTTONUP
	
	;RandomMouseDelay()
	;controlclick, x%X% y%Y%, ahk_id %AikaID%, , , 2, NA
	SetMouseDelay 0
	return
}

RandomSleep(){
	Random rand, 400, 800
	Sleep rand
	return
}

RandomMouseDelay(){
	Random rand, 200, 400
	SetMouseDelay 1000
	return
}

;PerformAction(image)

#F8::Reload
^Esc::ExitApp