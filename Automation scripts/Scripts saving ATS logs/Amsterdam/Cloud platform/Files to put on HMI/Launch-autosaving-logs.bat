::Schedule a task on each VM in order to execute the script Autosaving-Logs.bat
@echo off

::Autosaving-Logs.bat path
set script_path=\\OCC_LCM_TCC1\ArchivesFirstShared\Autosaving-Logs.bat

if not exist "%script_path%"   (
								echo Autosaving-Logs.bat is not in \\OCC_LCM_TCC1\ArchivesFirstShared\
								echo Exit in...
								timeout /t 5 /nobreak
								exit
								)

::Credentials                              
echo Enter the user session: 
set /p user=
echo Enter the password:
set /p password=

::Schedule tasks on each remote computer in purpose to run the script on each of them
::SRV_A
schtasks /s CER_LCM_SRV_A /u %user% /p %password%  /create /tn "Saving logs on disk" /tr "%script_path%" /sc ONCE /sd 01/01/1990 /st 00:00 /F
schtasks /s CER_LCM_SRV_A /u %user% /p %password% /run /tn "Saving logs on disk" /I
::SRV1A
schtasks /s CER_LCM_SRV1A /u %user% /p %password%  /create /tn "Saving logs on disk" /tr "%script_path%" /sc ONCE /sd 01/01/1990 /st 00:00 /F
schtasks /s CER_LCM_SRV1A /u %user% /p %password% /run /tn "Saving logs on disk" /I
::SRV2A
schtasks /s CER_LCM_SRV2A /u %user% /p %password%  /create /tn "Saving logs on disk" /tr "%script_path%" /sc ONCE /sd 01/01/1990 /st 00:00 /F
schtasks /s CER_LCM_SRV2A /u %user% /p %password% /run /tn "Saving logs on disk" /I

::End
echo Copy launched on each SRV!
timeout /t 5 /nobreak