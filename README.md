# 8to7_Winboot
Changing Windows 8.x boot.wim to match Windows 7's UI.
I created this because I'm lazy to do everything manually, so I extracted all the necessary files from Win7's boot.wim and uploaded it here.
Then I wrote a cmd batch script with my minimal skills.
# How to use
- Download the repository, then place the extracted files on D:. Your D: should be filled with those 4 files.
- Create a folder named "mount" without the brackets on D:.
- Place Windows 8.x boot.wim on D:
- Run SCRIPT.BAT, then after it's done, then run SCRIPT2.BAT.
- Your Windows 8.x boot.wim will resemble Windows 7's boot.wim when booted.
# Scenario for using this script
I used this script for converting Windows 8.x boot.wim to resemble Windows 7's boot.wim, so when I create a bootable USB, it'll show Windows 7's familiar setup ui instead.
Why I do that? Windows 7 original setup didn't support install.wim as an ESD, but Windows 8.1 setup (boot.wim) supports it.
