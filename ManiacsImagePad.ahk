#NoEnv
#SingleInstance, force

If !pToken := Gdip_Startup()
	{
	MsgBox, 48, gdiplus error!, Gdiplus failed to start. Please ensure you have gdiplus on your system
	ExitApp
	}
SysGet, VirtualWidth, 78
SysGet, VirtualHeight, 79

Tempfile=%A_Temp%\imagelist.tmp
Interval=30

GuimaxW:=480
GuimaxH:=480
BNx:=GuimaxW-20
BNy:=GuimaxH-20
;%GuimaxW%
;%GuimaxH%
; 托盤菜單
If A_IsCompiled=1
	Menu, tray, NoStandard
Menu, Tray, Icon,%A_scriptdir%\Data\tray.ico,, 1
Menu, tray, add
Loop, %A_WorkingDir%\Data\*, 2, 0
	{
	Menu, tray, add, %A_LoopFileName%, IndexImage
	}
Menu, tray, add
Menu, tray, add, 检查更新, Update
Menu, tray, add, 退出, WinClose

;OnMessage(0xF, "WM_PAINT")
OnMessage(0x201, "WM_LBUTTONDOWN")

Gui, +LastFound +Toolwindow +AlwaysonTop -Caption -SysMenu -Resize
Gui, Add, Picture, x0 y0 w%GuimaxW% h%GuimaxH% vStaticImage, %A_WorkingDir%\Data\Logo.png
Gui, Add, Button, x12 y10 w100 h30 vButton5s g5s, 5 秒
Gui, Add, Button, x122 y10 w100 h30 vButton10s g10s, 10秒
Gui, Add, Button, x232 y10 w100 h30 vButton20s g20s, 20 秒
Gui, Add, Button, x342 y10 w100 h30 vButton30s g30s, 30秒
Gui, Add, Button, x12 y60 w100 h30 vButton1m g1m, 1 分钟
Gui, Add, Button, x122 y60 w100 h30 vButton2m g2m, 2 分钟
Gui, Add, Button, x232 y60 w100 h30 vButton3m g3m, 3 分钟
Gui, Add, Button, x342 y60 w100 h30 vButton5m g5m, 5 分钟
Gui, Add, Button, x12 y110 w100 h30 vButton10m g10m, 10 分钟
Gui, Add, Button, x122 y110 w100 h30 vButton15m g15m, 15 分钟
Gui, Add, Button, x232 y110 w100 h30 vButton20m g20m, 20 分钟
Gui, Add, Button, x342 y110 w100 h30 vButton30m g30m, 30 分钟
Gui, Add, Button, x342 y160 w100 h30 vButtont2t gt2t, 不定时
Gui, Add, Button, x%BNx% y%BNy% w20 h20 vButtonNext gSetIntervalTime, >
Gui, Add, Button, x%BNx% y0 w20 h20 vButtonFull gFullScreen, +
Gui, Add, Button, x%BNx% y0 w20 h20 vButtonRestore gGuiEscape, -

/* 
Gui, Add, Button, x12 y160 w100 h30 vButton13 gSG_Button hwnd_Button13, Button
Gui, Add, Button, x122 y160 w100 h30 vButton14 gSG_Button hwnd_Button14, Button
Gui, Add, Button, x232 y160 w100 h30 vButton15 gSG_Button hwnd_Button15, Button
Gui, Add, Button, x342 y160 w100 h30 vButton16 gSG_Button hwnd_Button16, Button
 */
Gui, Show, x0 y0 w%GuimaxW% h%GuimaxH%, ManiacsImagePad
gosub, HideTimeButton
GuiControl,Hide,ButtonNext
GuiControl,Hide,ButtonFull
GuiControl,Hide,ButtonRestore
Return

5s:
	Interval=5
	GuiControl,Show,ButtonFull
	gosub, SetIntervalTime
	Return

10s:
	Interval=10
	GuiControl,Show,ButtonFull
	gosub, SetIntervalTime
	Return

20s:
	Interval=20
	GuiControl,Show,ButtonFull
	gosub, SetIntervalTime
	Return

30s:
	Interval=30
	GuiControl,Show,ButtonFull
	gosub, SetIntervalTime
	Return

1m:
	Interval=60
	GuiControl,Show,ButtonFull
	gosub, SetIntervalTime
	Return

2m:
	Interval=120
	GuiControl,Show,ButtonFull
	gosub, SetIntervalTime
	Return

3m:
	Interval=180
	GuiControl,Show,ButtonFull
	gosub, SetIntervalTime
	Return

5m:
	Interval=300
	GuiControl,Show,ButtonFull
	gosub, SetIntervalTime
	Return

10m:
	Interval=600
	GuiControl,Show,ButtonFull
	gosub, SetIntervalTime
	Return

15m:
	Interval=900
	GuiControl,Show,ButtonFull
	gosub, SetIntervalTime
	Return

20m:
	Interval=1200
	GuiControl,Show,ButtonFull
	gosub, SetIntervalTime
	Return

30m:
	Interval=1800
	GuiControl,Show,ButtonFull
	gosub, SetIntervalTime
	Return

t2t:
	Interval=0
	GuiControl,Show,ButtonFull
	gosub, SetIntervalTime
	Return

ShowTimeButton:
	GuiControl,Show,Button5s
	GuiControl,Show,Button10s
	GuiControl,Show,Button20s
	GuiControl,Show,Button30s
	GuiControl,Show,Button1m
	GuiControl,Show,Button2m
	GuiControl,Show,Button3m
	GuiControl,Show,Button5m
	GuiControl,Show,Button10m
	GuiControl,Show,Button15m
	GuiControl,Show,Button20m
	GuiControl,Show,Button30m
	GuiControl,Show,Buttont2t
	GuiControl,Hide,ButtonNext
	;GuiControl,Hide,ButtonFull
	Return

HideTimeButton:
	GuiControl,Hide,Button5s
	GuiControl,Hide,Button10s
	GuiControl,Hide,Button20s
	GuiControl,Hide,Button30s
	GuiControl,Hide,Button1m
	GuiControl,Hide,Button2m
	GuiControl,Hide,Button3m
	GuiControl,Hide,Button5m
	GuiControl,Hide,Button10m
	GuiControl,Hide,Button15m
	GuiControl,Hide,Button20m
	GuiControl,Hide,Button30m
	GuiControl,Hide,Buttont2t
	GuiControl,Show,ButtonNext
	;GuiControl,Show,ButtonFull
	Return

IndexImage:
	gosub, ShowTimeButton
	FileDelete, %Tempfile%
	WriteTimes=0
	Loop, %A_WorkingDir%\Data\%A_ThisMenuItem%\*.*, 0, 0
		{
		If A_LoopFileExt in png,gif,jpg,bmp,tif
			{
			;msgbox,%A_LoopFileExt%
			FileAppend, %A_LoopFileName%`n, %Tempfile%
			WriteTimes:=WriteTimes+1
			}
		}
	IfNotExist %Tempfile%
		{
		MsgBox,16,错误！,在此目录下找不到支持的图片格式！
		reload
		}

	Return

SetIntervalTime:
	gosub, HideTimeButton
	If Interval=0
	{
	gosub, ManiacsReadImage
	}
	else
	{
	gosub, ManiacsReadImage
	Time:= Interval*1000
	SetTimer, ManiacsReadImage, %Time%
	}
	Return

ManiacsReadImage:
	Random, Randomimage, 1, %WriteTimes% ; 下载地址总数
	FileReadLine, CurrentImage, %Tempfile%, %Randomimage%
	StringRight, ImageFormatName, CurrentImage, 4
	StringLower, ImageFormatName, ImageFormatName
;msgbox,%ImageFormatName%
	If ImageFormatName in .bmp,.png ;(ImageFormatName=.bmp)||(ImageFormatName=.png)
		{
		;msgbox, %A_WorkingDir%\Data\%A_ThisMenuItem%\%CurrentImage%
		imageloc=%A_WorkingDir%\Data\%A_ThisMenuItem%\%CurrentImage%
		}
	else
		{
		FileCopy, %A_WorkingDir%\Data\%A_ThisMenuItem%\%CurrentImage%, %A_Temp%\%CurrentImage%.tmp ,1
		imageloc=%A_Temp%\%CurrentImage%.tmp
		}
;msgbox,%imageloc%
	If !pBitmap := Gdip_CreateBitmapFromFile(imageloc)
		{
		MsgBox,16,错误！,pBitmap 错误！
		reload
		}

	Width := Gdip_GetImageWidth(pBitmap)
	Height := Gdip_GetImageHeight(pBitmap)

;	Width=%Width%
;	Height=%Height%


	;yy:=(480-Height)/2


	;msgbox, %xx% %yy%

	if (Height > Width) || (Height = Width)
		{
		if Height>%GuimaxH%
			{

			xx:=(GuimaxW-(Width/Height)*GuimaxW)/2
			StringReplace,xx,xx,-,,All
			yy:=(GuimaxH-(Height/Width)*GuimaxH)/2
			StringReplace,yy,yy,-,,All
			GuiControl,move,StaticImage,x%xx% y0
			GuiControl,,StaticImage, *w-1 *h%GuimaxH% %A_WorkingDir%\Data\%A_ThisMenuItem%\%CurrentImage%

			}
		else
			{
			xx:=(GuimaxW-Width)/2
			StringReplace,xx,xx,-,,All
			yy:=(GuimaxH-Height)/2
			StringReplace,yy,yy,-,,All
			GuiControl,move,StaticImage,x%xx% y%yy%
			GuiControl,,StaticImage, *w0 *h0 %A_WorkingDir%\Data\%A_ThisMenuItem%\%CurrentImage%
			}
		}
	/* 
	else if Width > %Height%
		{
		if Width>480
		GuiControl,,StaticImage,*w480 *h-1 %A_WorkingDir%\Data\%A_ThisMenuItem%\%CurrentImage%
		if Width<480
		GuiControl,,StaticImage,*w0 *h0 %A_WorkingDir%\Data\%A_ThisMenuItem%\%CurrentImage%
		}
	 */
	else if Height < Width
		{
		if Width>%GuimaxW%
			{
			xx:=(GuimaxW-(Width/Height)*GuimaxW)/2
			StringReplace,xx,xx,-,,All
			yy:=(GuimaxH-(Height/Width)*GuimaxH)/2
			StringReplace,yy,yy,-,,All
			GuiControl,move,StaticImage,x0 y%yy%
			GuiControl,,StaticImage, *w%GuimaxW% *h-1 %A_WorkingDir%\Data\%A_ThisMenuItem%\%CurrentImage%

			}
		else
			{
			xx:=(GuimaxW-Width)/2
			StringReplace,xx,xx,-,,All
			yy:=(GuimaxH-Height)/2
			StringReplace,yy,yy,-,,All
			GuiControl,move,StaticImage,x%xx% y%yy%
			GuiControl,,StaticImage, *w0 *h0 %A_WorkingDir%\Data\%A_ThisMenuItem%\%CurrentImage%
			}
		}
		Return


Update:
	; please retain the original links and related notes.
	run https://github.com/millionart/ManiacsImagePad/releases
	return
/* 
GuiSize:
	WinGet,ControlList,ControlList
	Loop,Parse,ControlList,`n
	ControlMove,%A_LoopField%,, ,A_GuiWidth,A_GuiHeight
	return

Cancel:
	Gui, Minimize
	return
 */

FullScreen:
	GuiControl,Hide,ButtonFull
	GuiControl,Show,ButtonRestore
	GuimaxW=%VirtualWidth%
	GuimaxH=%VirtualHeight%
	;msgbox,%VirtualWidth% %VirtualHeight%
	BNx:=GuimaxW-20
	BNy:=GuimaxH-20
	GuiControl,move,ButtonNext,x%BNx% y%BNy%
	GuiControl,move,ButtonRestore,x%BNx% y0
	Gui, Maximize
	gosub, SetIntervalTime
	;%VirtualWidth%, %VirtualHeight%
	return

GuiEscape:
	GuiControl,Hide,ButtonRestore
	GuiControl,Show,ButtonFull
	GuimaxW=480
	GuimaxH=480
	BNx:=GuimaxW-20
	BNy:=GuimaxH-20
	GuiControl,move,ButtonNext,x%BNx% y%BNy%
	GuiControl,move,ButtonRestore,x%BNx% y0
	Gui, Restore
	gosub, SetIntervalTime
	return

GuiClose:
WinClose:
	ExitApp
	return

WM_LBUTTONDOWN()
	{
	If A_Gui = 1
		PostMessage, 0xA1, 2 ; WM_NCLButtonDOWN
	}

/* 
WSTR(ByRef w, s)
	{
		VarSetCapacity(w, StrLen(s)*2+1)
		DllCall("MultiByteToWideChar", "uint", 0, "uint", 0, "str", s, "int", -1, "uint", &w, "int", StrLen(s)+1)
		Return &w
	}

RECTWIDTH(ByRef rcCLient)
	{
		Return NumGet(rcClient, 8)-NumGet(rcClient, 0)  ; Right-left
	}

RECTHEIGHT(ByRef rcClient)
	{
		Return NumGet(rcClient, 12)-NumGet(rcCLient, 4) ; Bottom-top
	}
 */
#include %A_scriptdir%\Gdip.ahk