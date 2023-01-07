@ECHO OFF
SET "UAC_FILE=%TEMP%\WINDOWS_7_TRACK_UAC.VBS"
REG QUERY "HKEY_USERS\S-1-5-20" > NUL 2>&1 || (
    ECHO CreateObject^("Shell.Application"^).ShellExecute "%~0", "ELEVATED", "", "runas", 1 > "%UAC_FILE%" && "%UAC_FILE%" 
    EXIT /B
)
IF EXIST "%UAC_FILE%" DEL "%UAC_FILE%" /F /Q > NUL 2>&1

:: DEFEAT SYNC
::HKEY_CURRENT_USER\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\SyncMgr

:: DISABLE TRACKING
REG ADD "HKLM\SOFTWARE\Microsoft\COM3" /V "DisableAppDomainTracking" /D 1 /T REG_DWORD /F
	
:: DISABLE NGEN SERVICE
REG ADD "HKLM\SOFTWARE\Wow6432Node\Microsoft\.NETFramework" /V "EnableMultiproc" /D 0 /T REG_DWORD /F
REG ADD "HKLM\SOFTWARE\Wow6432Node\Microsoft\.NETFramework" /V "NGENUseService" /D 0 /T REG_DWORD /F
REG ADD "HKLM\SOFTWARE\Microsoft\.NETFramework" /V "NGENUseService" /D 0 /T REG_DWORD /F
REG ADD "HKLM\SOFTWARE\Microsoft\.NETFramework" /V "EnableMultiproc" /D 0 /T REG_DWORD /F
	
:: DISABLE CUSTOMER EXPERIENCE IMPROVEMENT PROGRAM
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\SQMClient\Windows" /V "CEIPEnable" /D 0 /T REG_DWORD /F
REG ADD "HKLM\SOFTWARE\Microsoft\SQMClient\Windows" /V "CEIPEnable" /D 0 /T REG_DWORD /F
REG ADD "HKLM\SOFTWARE\Microsoft\SQMClient\Windows" /V "CEIPSamplingRangeHigh" /D 0 /T REG_DWORD /F
REG ADD "HKLM\SOFTWARE\Microsoft\SQMClient\Windows" /V "CEIPSamplingRangeLow" /D 0 /T REG_DWORD /F

:: DISABLE AUTOMATIC WINDOWS UPDATES
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" /V "AUOptions" /D 2 /T REG_DWORD /F
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" /V "IncludeRecommendedUpdates" /D 0 /T REG_DWORD /F

:: DISABLE WINDOWS ERROR REPORTING
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\Windows Error Reporting" /V "Disabled" /D 1 /T REG_DWORD /F
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\Windows Error Reporting" /V "DontSendAdditionalData" /D 1 /T REG_DWORD /F
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\Windows Error Reporting" /V "LoggingDisabled" /D 1 /T REG_DWORD /F
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\Windows Error Reporting" /V "SendEFSFiles" /D 1 /T REG_DWORD /F
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\Windows Error Reporting\WMR" /V "Disable" /D 1 /T REG_DWORD /F

:: DISABLE WMI LOGS
REG ADD "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\AITEventLog" /V "Start" /D 4 /T REG_DWORD /F
REG ADD "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\Audio" /V "Start" /D 4 /T REG_DWORD /F
REG ADD "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\AutoLogger-Diagtrack-Listener" /V "Start" /D 4 /T REG_DWORD /F
REG ADD "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\Circular Kernel Context Logger" /V "Start" /D 4 /T REG_DWORD /F
REG ADD "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\DiagLog" /V "Start" /D 4 /T REG_DWORD /F
REG ADD "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\Microsoft-Windows-Setup" /V "Start" /D 4 /T REG_DWORD /F
REG ADD "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\NBSMBLOGGER" /V "Start" /D 4 /T REG_DWORD /F
REG ADD "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\NtfsLog" /V "Start" /D 4 /T REG_DWORD /F
REG ADD "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\PEAuthLog" /V "Start" /D 4 /T REG_DWORD /F
REG ADD "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\RAC_PS" /V "Start" /D 4 /T REG_DWORD /F
REG ADD "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\RdrLog" /V "Start" /D 4 /T REG_DWORD /F
REG ADD "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\ReadyBoot" /V "Start" /D 4 /T REG_DWORD /F
REG ADD "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\AITEventLog" /V "Start" /D 4 /T REG_DWORD /F
REG ADD "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\SQMLogger" /V "Start" /D 4 /T REG_DWORD /F
REG ADD "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\UBPM" /V "Start" /D 4 /T REG_DWORD /F
REG ADD "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\WdiContextLog" /V "Start" /D 4 /T REG_DWORD /F
REG ADD "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\WFP-IPsec Trace" /V "Start" /D 4 /T REG_DWORD /F

:: DISABLE DATA COLLECTION SERVICES
FOR %%A IN ( WMPNetworkSvc DiagTrack TrkWks MSDTC IEEtwCollectorService wercplsupport WerSvc ) DO (
	SC STOP "%%A"
	SC DELETE "%%A"
)

:: DISABLE DATA COLLECTION TASKS
FOR %%A IN (
	"\Microsoft\Windows\Application Experience\AitAgent"
	"\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser"
	"\Microsoft\Windows\Application Experience\ProgramDataUpdater"
	"\Microsoft\Windows\Autochk\Proxy"
	"\Microsoft\Windows\Customer Experience Improvement Program\Consolidator"
	"\Microsoft\Windows\Customer Experience Improvement Program\KernelCeipTask"
	"\Microsoft\Windows\Customer Experience Improvement Program\UsbCeip"
	"\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector"
	"\Microsoft\Windows\NetTrace\GatherNetworkInfo"
	"\Microsoft\Windows\RAC\RacTask"
	"\Microsoft\Windows\Windows Error Reporting\QueueReporting"
) DO (
	SCHTASKS /DELETE /TN %%A /F
)

ECHO.
ECHO.
ECHO Done! Press any key to close the script!
PAUSE>NUL&EXIT