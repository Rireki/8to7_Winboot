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
:start
@echo off
ver | findstr /il "6\.0\." > nul
if %errorlevel% equ 0 (
  echo Windows Vista detected. Will be checking whether Windows ADK 8.1/10 is installed. >nul
  set WindowsVersion=6
  goto :adkcheck
)
  ver | findstr /il "6\.1\." > nul
  if %errorlevel% equ 0 (
  echo Windows 7 detected. Will be checking whether Windows ADK 8.1/10 is installed. >nul
  set WindowsVersion=6
  goto :adkcheck
)
:adkcheck
@echo off
if exist "C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\x86\DISM\dism.exe" (
    echo Windows ADK 10 is installed. Will be using ADK 10 dism.exe instead... >nul
    goto :WindowsADK10
)
if exist "C:\Program Files (x86)\Windows Kits\8.1\Assessment and Deployment Kit\Deployment Tools\x86\DISM\dism.exe" (
    echo Windows ADK 8.1 is installed. Will be using ADK 8.1 dism.exe instead... >nul
    goto :WindowsADK81
) else (
echo Windows ADK 8.1/10 is not detected. Will be using native dism.exe instead.. >nul
)

:next
@echo off
echo Setup is detecting Windows version...
ver | findstr /il "5\.0" > nul
if %errorlevel% equ 0 (
  echo Windows 2000 detected.
  set WindowsVersion=5
  goto :WindowsNT
)
ver | findstr /il "5\.1\." > nul
if %errorlevel% equ 0 (
  echo Windows XP detected.
  set WindowsVersion=5
  goto :WindowsNT
)
ver | findstr /il "5\.2\." > nul
if %errorlevel% equ 0 (
  echo Windows Server 2003 detected.
  set WindowsVersion=5
  goto :WindowsNT
)
ver | findstr /il "6\.0\." > nul
if %errorlevel% equ 0 (
  echo Windows Vista detected.
  set WindowsVersion=Vista
  goto :Windows7
)
  ver | findstr /il "6\.1\." > nul
  if %errorlevel% equ 0 (
  echo Windows 7 detected.
  set WindowsVersion=7
  goto :Windows7
)
  ver | findstr /il "6\.2\." > nul
  if %errorlevel% equ 0 (
  echo Windows 8 detected.
  set WindowsVersion=8
  goto :WindowsElse
)
  ver | findstr /il "6\.3\." > nul
  if %errorlevel% equ 0 (
  echo Windows 8.1 etected.
  set WindowsVersion=10
  goto :WindowsElse
)
  ver | findstr /il "10\.0" > nul
  if %errorlevel% equ 0 (
  echo Windows 10/11 detected.
  set WindowsVersion=10
  goto :WindowsElse
)

:WindowsNT
@echo off
echo Windows 2000/XP/2003 is not supported.
echo Press any key to exit...
pause >nul
exit

:Windows7
@echo off
dism /unmount-wim /mountdir:d:\mount /commit
echo Press any key to exit...
pause >nul
exit

:WindowsElse
@echo off
dism /unmount-image /mountdir:d:\mount /commit
dism /cleanup-mountpoints
echo Press any key to exit...
pause >nul
exit

:WindowsADK81
@echo off
"C:\Program Files (x86)\Windows Kits\8.1\Assessment and Deployment Kit\Deployment Tools\x86\DISM\dism.exe" /unmount-image /mountdir:d:\mount /commit
"C:\Program Files (x86)\Windows Kits\8.1\Assessment and Deployment Kit\Deployment Tools\x86\DISM\dism.exe" /cleanup-mountpoints
echo Press any key to exit...
pause >nul
exit

:WindowsADK10
@echo off
"C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\x86\DISM\dism.exe" /unmount-image /mountdir:d:\mount /commit
"C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\x86\DISM\dism.exe" /cleanup-mountpoints
echo Press any key to exit...
pause >nul
exit
