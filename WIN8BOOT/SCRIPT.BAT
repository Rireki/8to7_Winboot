@ECHO OFF >nul
title WIN8TOWIN7BOOT >NUL
ECHO ===========WIN8BOOT TO WIN7BOOT INTEGRATION SCRIPT===========
ECHO Place everything in this folder to D: including this script
ECHO Now we shall mount the wim image first.
ECHO Press any key to continue, if the requirement is not fulfilled then please close this cmd window.
pause >nul
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
ECHO Press any key to continue...
taskkill /f /im cmd.exe
