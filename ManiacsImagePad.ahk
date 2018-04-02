#NoEnv
#SingleInstance, force

If !pToken:= Gdip_Startup()
{
	MsgBox, 48, gdiplus error!, Gdiplus failed to start. Please ensure you have gdiplus on your system
	ExitApp
}
SysGet, virtualWidth, 78
SysGet, virtualHeight, 79

Tempfile=%A_Temp%\imagelist.tmp
interval:=30

guiMaxWidth:=480
guiMaxHeight:=480
BNx:=guiMaxWidth-20
BNy:=guiMaxHeight-20

If A_IsCompiled
	Menu, tray, NoStandard
Menu, Tray, Icon,%A_scriptdir%\Data\tray.ico,, 1
Menu, tray, add
Loop, %A_WorkingDir%\Data\*, 2, 0
{
	Menu, tray, add, %A_LoopFileName%, IndexImage, +Radio
}
Menu, tray, add
Menu, tray, add, 检查更新, Update
Menu, tray, add, 退出, WinClose

OnMessage(0x201, "WM_LBUTTONDOWN")

Gui, +LastFound +Toolwindow +AlwaysonTop -Caption -SysMenu -Resize
Gui, Add, Picture, x0 y0 w%guiMaxWidth% h%guiMaxHeight% vstaticImage, %A_WorkingDir%\Data\Logo.png
Gui, Add, Button, x22 y10 w100 h30 vButton5s g5s, 5 秒
Gui, Add, Button, x+10 yp wp hp vButton10s g10s, 10 秒
Gui, Add, Button, x+10 yp wp hp vButton20s g20s, 20 秒
Gui, Add, Button, x+10 yp wp hp vButton30s g30s, 30 秒
Gui, Add, Button, x22 y+20 wp hp vButton1m g1m, 1 分钟
Gui, Add, Button, x+10 yp wp hp vButton2m g2m, 2 分钟
Gui, Add, Button, x+10 yp wp hp vButton3m g3m, 3 分钟
Gui, Add, Button, x+10 yp wp hp vButton5m g5m, 5 分钟
Gui, Add, Button, x22 y+20 wp hp vButton10m g10m, 10 分钟
Gui, Add, Button, x+10 yp wp hp vButton15m g15m, 15 分钟
Gui, Add, Button, x+10 yp wp hp vButton20m g20m, 20 分钟
Gui, Add, Button, x+10 yp wp hp vButton30m g30m, 30 分钟
Gui, Add, Button, xp y+20 wp hp vButtont2t gt2t, 不定时
Gui, Add, Button, x%BNx% y%BNy% w20 h20 vButtonNext gSetintervalTime, >
Gui, Add, Button, xp y0 wp hp vButtonFull gFullScreen, +
Gui, Add, Button, xp yp wp hp vButtonRestore gGuiEscape, -

ShowHideTimeButton(0)
Gui, Show, x0 y0 w%guiMaxWidth% h%guiMaxHeight%, ManiacsImagePad

GuiControl,Hide,ButtonNext
GuiControl,Hide,ButtonFull
GuiControl,Hide,ButtonRestore
Return

5s:
SetintervalTime(5)
Return

10s:
SetintervalTime(10)
Return

20s:
SetintervalTime(20)
Return

30s:
SetintervalTime(30)
Return

1m:
SetintervalTime(60)
Return

2m:
SetintervalTime(120)
Return

3m:
SetintervalTime(180)
Return

5m:
SetintervalTime(300)
Return

10m:
SetintervalTime(600)
Return

15m:
SetintervalTime(900)
Return

20m:
SetintervalTime(1200)
Return

30m:
SetintervalTime(1800)
Return

t2t:
SetintervalTime(0)
Return


IndexImage:
	Loop, %A_WorkingDir%\Data\*, 2, 0
	{
		Menu, tray, UnCheck, %A_LoopFileName%,
	}
	Menu, tray, Check, %A_ThisMenuItem%
	Gosub, ManiacsReadImage
	ShowHideTimeButton(1)
	FileDelete, %Tempfile%

	Loop, %A_WorkingDir%\Data\%A_ThisMenuItem%\*.*, 0, 0
	{
		If A_LoopFileExt in png,gif,jpg,bmp,tif
		{
			FileAppend, %A_LoopFileName%`n, %Tempfile%
			maxImageNumber:=A_Index
		}
	}

	IfNotExist %Tempfile%
	{
		MsgBox,16,错误！,在此目录下找不到支持的图片格式！
		reload
	}
	Return

ManiacsReadImage:
	previousLine:=currentLine

	If (maxImageNumber>1)
	{
		Loop, 
		{
			Random, currentLine, 1, %maxImageNumber%
		}Until (currentLine!=previousLine)
	}
	Else
	{
		currentLine:=1
		GuiControl,Hide,ButtonNext
	}


	FileReadLine, currentImage, %Tempfile%, %currentLine%

	findDotPos:=InStr(currentImage, ".",, -1)
	fileFormat:=SubStr(currentImage, findDotPos)
	StringLower, fileFormat, fileFormat

	If fileFormat in .bmp,.png
	{
		imageloc=%A_WorkingDir%\Data\%A_ThisMenuItem%\%currentImage%
	}
	else
	{
		FileCopy, %A_WorkingDir%\Data\%A_ThisMenuItem%\%currentImage%, %A_Temp%\%currentImage%.tmp ,1
		imageloc=%A_Temp%\%currentImage%.tmp
	}

	If !pBitmap := Gdip_CreateBitmapFromFile(imageloc)
	{
		Try
		{
			fileHash:=File_Hash("%A_WorkingDir%\Data\%A_ThisMenuItem%\%currentImage%", "MD5")
			FileCreateDir, %A_WorkingDir%\Broken Images
			FileMove, %A_WorkingDir%\Data\%A_ThisMenuItem%\%currentImage%, %A_WorkingDir%\Broken Images\%fileHash% %currentImage%, 1
		}
		Gosub, ManiacsReadImage
	}

	imageWidth:= Gdip_GetImageWidth(pBitmap)
	imageHeight:= Gdip_GetImageHeight(pBitmap)

	xx:=Abs((guiMaxWidth-(imageWidth/imageHeight)*guiMaxWidth)/2)
	yy:=Abs((guiMaxHeight-(imageHeight/imageWidth)*guiMaxHeight)/2)

	if (imageHeight>=imageWidth) && (imageHeight>guiMaxHeight)
	{
		GuiControl,move,staticImage,x%xx% y0
		GuiControl,,staticImage, *w-1 *h%guiMaxHeight% %A_WorkingDir%\Data\%A_ThisMenuItem%\%currentImage%
	}
	else If (imageHeight<imageWidth) && (imageWidth>guiMaxWidth)
	{
		GuiControl,move,staticImage,x0 y%yy%
		GuiControl,,staticImage, *w%guiMaxWidth% *h-1 %A_WorkingDir%\Data\%A_ThisMenuItem%\%currentImage%
	}
	else
	{
		xx:=Abs((guiMaxWidth-imageWidth)/2)
		yy:=Abs((guiMaxHeight-imageHeight)/2)

		GuiControl,move,staticImage,x%xx% y%yy%
		GuiControl,,staticImage, *w0 *h0 %A_WorkingDir%\Data\%A_ThisMenuItem%\%currentImage%
	}
	Return


Update:
	; please retain the original links and related notes.
	run https://github.com/millionart/ManiacsImagePad/releases
	return

FullScreen:
	guiMaxWidth:=virtualWidth
	guiMaxHeight:=virtualHeight
	BNx:=guiMaxWidth-20
	BNy:=guiMaxHeight-20
	guiMax:=1

	GuiControl,Hide,ButtonFull
	GuiControl,Show,ButtonRestore
	GuiControl,move,ButtonNext,x%BNx% y%BNy%
	GuiControl,move,ButtonRestore,x%BNx% y0
	Gui, Maximize
	SetintervalTime()
	return

GuiEscape:
	guiMaxWidth:=480
	guiMaxHeight:=480
	BNx:=guiMaxWidth-20
	BNy:=guiMaxHeight-20
	guiMax:=0

	GuiControl,Show,ButtonFull
	GuiControl,Hide,ButtonRestore
	GuiControl,move,ButtonNext,x%BNx% y%BNy%
	GuiControl,move,ButtonRestore,x%BNx% y0
	Gui, Restore
	SetintervalTime()
	return

GuiClose:
WinClose:
	ExitApp
	return

ShowHideTimeButton(show)
{
	display:=show>0?"Show":"Hide"
	GuiControl,%display%,Button5s
	GuiControl,%display%,Button10s
	GuiControl,%display%,Button20s
	GuiControl,%display%,Button30s
	GuiControl,%display%,Button1m
	GuiControl,%display%,Button2m
	GuiControl,%display%,Button3m
	GuiControl,%display%,Button5m
	GuiControl,%display%,Button10m
	GuiControl,%display%,Button15m
	GuiControl,%display%,Button20m
	GuiControl,%display%,Button30m
	GuiControl,%display%,Buttont2t
	display:=show<1?"Show":"Hide"
	GuiControl,%display%,ButtonNext
}

SetintervalTime(interval:=-1)
{
	global
	If (interval>-1) && (guiMax!=1)
		GuiControl,Show,ButtonFull

	ShowHideTimeButton(0)
	gosub, ManiacsReadImage

	If (interval>0)
		SetTimer, ManiacsReadImage, % interval*1000
}

WM_LBUTTONDOWN()
{
	If A_Gui = 1
		PostMessage, 0xA1, 2
}

#include %A_scriptdir%\Gdip.ahk
#include %A_scriptdir%\FileHelperAndHash.ahk