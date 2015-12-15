#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
;SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#SingleInstance, force

Process,Close,Ahk2Exe.exe
Process,Close,ManiacsImagePad.exe

Compiler=D:\Program Files\AutoHotkey\Compiler\
;source=%~dp0

FileAppend,
(
@echo on

cd "%Compiler%"
move mpress.exe mpress_exe
move upx.exe upx_exe
Ahk2exe.exe /in "%A_ScriptDir%\ManiacsImagePad.ahk" /icon "%A_ScriptDir%\Data\tray.ico"
move mpress_exe mpress.exe
move upx_exe upx.exe

), build.bat


Process,Close,Ahk2Exe.exe
Process,Close,ManiacsImagePad.exe

RunWait build.bat

FileDelete, %A_ScriptDir%\build.bat
return
