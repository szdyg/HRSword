%1 mshta vbscript:CreateObject("Shell.Application").ShellExecute("cmd.exe","/c %~s0 ::","","runas",1)(window.close)&&exit

cd /d "%~dp0"

sc stop sysdiag
sc stop hrwfpdrv
sc delete sysdiag
sc delete hrwfpdrv

reg delete "HKLM\SYSTEM\CurrentControlSet\Services\sysdiag" /f
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\hrwfpdr" /f

rem «Î÷ÿ∆Ù

pause