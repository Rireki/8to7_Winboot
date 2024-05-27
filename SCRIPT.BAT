@echo off 

:: BatchGotAdmin
:-------------------------------------
REM  --> Check for permissions
    IF "%PROCESSOR_ARCHITECTURE%" EQU "amd64" (
>nul 2>&1 "%SYSTEMROOT%\SysWOW64\cacls.exe" "%SYSTEMROOT%\SysWOW64\config\system"
) ELSE (
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
)

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params= %*
    echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %params:"=""%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
:--------------------------------------
@ECHO OFF >nul
title WIN8TOWIN7BOOT >NUL
ECHO ===========WIN8BOOT TO WIN7BOOT INTEGRATION SCRIPT===========
ECHO Windows Vista and later is required.
ECHO Place everything in this folder to D: including this script
ECHO Now we shall mount the wim image first.
ECHO Press any key to continue, if the requirement is not fulfilled then please close this cmd window.
pause >nul
ver | findstr /il "6\.1\." > nul
if %errorlevel% neq 0 (
  echo Microsoft Windows 8.1/10/11 detected.
  goto :Windows6
)
if %errorlevel% equ 0 (
  echo Microsoft Windows 7 [Version 6.1] detected.
  set WindowsVersion=7
  goto :Windows6
)
ver | findstr /il "6\.0\." > nul
if %errorlevel% neq 0 (
  echo Microsoft Windows 8.1/10/11 detected.
  goto :Windows6
)
if %errorlevel% equ 0 (
  echo Microsoft Windows Vista / Server 2008 [Version 6.0] detected.
  goto :Windows6

ver | findstr /il "5\.2\." > nul
if %errorlevel% neq 0 (
  echo Microsoft Windows 8.1/10/11 detected.
  goto :Windows6
)
if %errorlevel% equ 0 (
  echo Microsoft Windows Server 2003 [Version 5.2] detected.
  set WindowsVersion=5
  goto :WindowsNT
)
ver | findstr /il "5\.1\." > nul
if %errorlevel% neq 0 (
  echo Microsoft Windows 8.1/10/11 detected.
  goto :Windows6
)
if %errorlevel% equ 0 (
  echo Microsoft Windows XP [Version 5.1] detected.
  set WindowsVersion=5
  goto :WindowsNT
)
ver | findstr /il "5\.0" > nul
if %errorlevel% neq 0 (
  echo Microsoft Windows 8.1/10/11 detected.
  goto :Windows6
)
if %errorlevel% equ 0 (
  echo Microsoft Windows 2000 [Version 5.0] detected.
  set WindowsVersion=5
  goto :WindowsNT
)

:WindowsNT
echo Windows 2000/XP/2003 is not supported.
pause
exit

:Windows6
d:
mkdir mount
dism /mount-wim /wimfile:d:\boot.wim /index:2 /mountdir:d:\mount
d:
cd mount
cd sources
takeown /f ARUNIMG.dll
takeown /f spwizimg.dll
icacls ARUNIMG.dll /grant *S-1-5-32-544:F
icacls spwizimg.dll /grant *S-1-5-32-544:F
cd ..
cd windows
cd winsxs
cd amd64_microsoft-windows-i..dia-branding-client_31bf3856ad364e35_6.3.9600.16384_none_9c3ac73247f26d18
takeown /f ARUNIMG.dll
takeown /f spwizimg.dll
icacls ARUNIMG.dll /grant *S-1-5-32-544:F
icacls spwizimg.dll /grant *S-1-5-32-544:F
copy /y d:\ARUNIMG.dll D:\mount\sources
copy /y d:\spwizimg.dll D:\mount\sources
copy /y d:\ARUNIMG.dll D:\windows\winsxs\amd64_microsoft-windows-i..dia-branding-client_31bf3856ad364e35_6.3.9600.16384_none_9c3ac73247f26d18
copy /y d:\spwizimg.dll D:\windows\winsxs\amd64_microsoft-windows-i..dia-branding-client_31bf3856ad364e35_6.3.9600.16384_none_9c3ac73247f26d18
echo ========================================
ECHO Please start SCRIPT2 in order to commit changes to boot.wim
ECHO Press any key to exit...
pause >nul
taskkill /f /im cmd.exe
