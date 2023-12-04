@echo off
chcp 65001 > nul 2>&1

setlocal

rem Установите путь к вашему BAT-файлу
set "batFilePath=%~dp0StartRDP.bat"

rem Установите путь к ярлыку
set "shortcutPath=%userprofile%\Desktop\StartRDP.lnk"

rem Создайте ярлык
powershell.exe -Command "$WshShell = New-Object -ComObject WScript.Shell; $Shortcut = $WshShell.CreateShortcut('%shortcutPath%'); $Shortcut.TargetPath = '%batFilePath%'; $Shortcut.Save()"

echo Ярлык создан на рабочем столе.
pause
