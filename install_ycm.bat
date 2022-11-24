@echo off

rem ## disable QuickEdit of Console.
reg add HKEY_CURRENT_USER\Console /v QuickEdit /t REG_DWORD /d 00000000 /f
cd %USERPROFILE%\.vim\plugged\YouCompleteMe
%USERPROFILE%\vimrc\bin\win32\python39\python.exe install.py --all
Pause
