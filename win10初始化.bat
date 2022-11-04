%1 mshta vbscript:CreateObject("Shell.Application").ShellExecute("cmd.exe","/c %~s0 ::","","runas",1)(window.close)&&exit

@ECHO OFF & PUSHD "%~DP0" && CD /D "%~DP0"
IF NOT EXIST "X:\Windows\System32\Config\System" REG QUERY "HKU\S-1-5-19" >NUL 2>&1
IF NOT %ERRORLEVEL% EQU 0 powershell.exe -windowstyle hidden -noprofile "Start-Process '%~dpnx0' -Verb RunAs" 2>NUL&EXIT


rem 正在释放核心驱动文件
echo y|copy Drivers\sysdiag_win10.sys "%WinDir%\System32\drivers\" >NUL 2>NUL
echo y|copy Drivers\hrwfpdrv_win10.sys "%WinDir%\System32\drivers\" >NUL 2>NUL


rem 正在创建系统服务项目...
sc create hrwfpdrv binpath= "%WinDir%\System32\drivers\hrwfpdrv.sys" type= kernel start= demand error= normal >NUL 2>NUL
sc create sysdiag binpath= "%WinDir%\System32\drivers\sysdiag.sys" type= kernel start= demand error= normal depend= FltMgr group= "PNP_TDI" >NUL 2>NUL
reg add "HKLM\SYSTEM\CurrentControlSet\Services\sysdiag" /f /v "ImagePath" /t REG_EXPAND_SZ /d "system32\DRIVERS\sysdiag_win10.sys" >NUL 2>NUL
reg add "HKLM\SYSTEM\CurrentControlSet\Services\hrwfpdr" /f /v "ImagePath" /t REG_EXPAND_SZ /d "system32\DRIVERS\hrwfpdrv_win10.sys" >NUL 2>NUL
reg add "HKLM\SYSTEM\CurrentControlSet\Services\sysdiag" /f /v "Start" /t reg_dword /d "1" >NUL 2>NUL
reg add "HKLM\SYSTEM\CurrentControlSet\Services\hrwfpdr" /f /v "Start" /t reg_dword /d "1" >NUL 2>NUL
reg add "HKLM\SYSTEM\CurrentControlSet\Services\sysdiag" /f /v "Group" /d "PNP_TDI" >NUL 2>NUL
reg add "HKLM\SYSTEM\CurrentControlSet\Services\sysdiag\Instances" /f /v "DefaultInstance" /d "sysdiag" >NUL 2>NUL
reg add "HKLM\SYSTEM\CurrentControlSet\Services\sysdiag\Instances\sysdiag" /f /v "Altitude" /d "324600" >NUL 2>NUL
reg add "HKLM\SYSTEM\CurrentControlSet\Services\sysdiag\Instances\sysdiag" /f /v "Flags" /t reg_dword /d "0" >NUL 2>NUL

rem 启动火绒剑的驱动服务...
sc start sysdiag >NUL 2>NUL
sc start hrwfpdrv >NUL 2>NUL

EXIT