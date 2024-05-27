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

@echo off

echo Setup is detecting Windows version...
ver | findstr /il "6\.1\." > nul
if %errorlevel% neq 0 (
  echo Microsoft Windows 8.1/10/11 detected.
  goto :WindowsElse
)
if %errorlevel% equ 0 (
  echo Microsoft Windows 7 [Version 6.1] detected.
  set WindowsVersion=7
  goto :Windows7
)
ver | findstr /il "6\.0\." > nul
if %errorlevel% neq 0 (
  echo Microsoft Windows 8.1/10/11 detected.
  goto :WindowsElse
)
if %errorlevel% equ 0 (
  echo Microsoft Windows Vista / Server 2008 [Version 6.0] detected.
  set WindowsVersion=6
  goto :Windows7
)
ver | findstr /il "5\.2\." > nul
if %errorlevel% neq 0 (
  echo Microsoft Windows 8.1/10/11 detected.
  goto :WindowsElse
)
if %errorlevel% equ 0 (
  echo Microsoft Windows Server 2003 [Version 5.2] detected.
  set WindowsVersion=5
  goto :WindowsNT
)
ver | findstr /il "5\.1\." > nul
if %errorlevel% neq 0 (
  echo Microsoft Windows 8.1/10/11 detected.
  goto :WindowsElse
)
if %errorlevel% equ 0 (
  echo Microsoft Windows XP [Version 5.1] detected.
  set WindowsVersion=5
  goto :WindowsNT
)
ver | findstr /il "5\.0" > nul
if %errorlevel% neq 0 (
  echo Microsoft Windows 8.1/10/11 detected.
  goto :WindowsElse
)
if %errorlevel% equ 0 (
  echo Microsoft Windows 2000 [Version 5.0] detected.
  set WindowsVersion=5
  goto :WindowsNT
)
:WindowsNT
echo Windows 2000/XP/2003 is not supported.
echo Press any key to exit...
pause >nul
exit

:Windows7
dism /unmount-wim /mountdir:d:\mount /commit
echo Press any key to exit...
pause >nul
exit

:WindowsElse
dism /unmount-image /mountdir:d:\mount /commit
dism /cleanup-mountpoints
echo Press any key to exit...
pause >nul
exit
