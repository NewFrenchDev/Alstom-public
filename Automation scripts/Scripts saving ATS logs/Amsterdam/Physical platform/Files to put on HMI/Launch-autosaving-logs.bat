::Author G.LEMOING
::This script permit to run Autosaving-log.bat on the disk (root)

@echo off

::Check if any disk is inserted on the HMI workstation
:Check_disk
set Disk=E
if not exist "%Disk%:" set Disk=F
if not exist "%Disk%:" (
						echo No disk found... insert a disk on the workstation
						timeout /t 10 /nobreak
						echo.
						echo.
						goto Check_disk
						)

::Autosaving-Logs.bat path
set script_path=%Disk%:\Autosaving-Logs.bat
set network_script_path=\\tsclient\%Disk%\Autosaving-Logs.bat

if not exist "%script_path%"   (
								echo Autosaving-Logs.bat is not on %Disk%:\
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
schtasks /s CER_LCM_SRV_A /u %user% /p %password%  /create /tn "Saving logs on disk" /tr "%network_script_path%" /sc ONCE /sd 01/01/1990 /st 00:00 /F
schtasks /s CER_LCM_SRV_A /u %user% /p %password% /run /tn "Saving logs on disk" /I
::SRV1A
schtasks /s CER_LCM_SRV1A /u %user% /p %password%  /create /tn "Saving logs on disk" /tr "%network_script_path%" /sc ONCE /sd 01/01/1990 /st 00:00 /F
schtasks /s CER_LCM_SRV1A /u %user% /p %password% /run /tn "Saving logs on disk" /I
::SRV2A
schtasks /s CER_LCM_SRV2A /u %user% /p %password%  /create /tn "Saving logs on disk" /tr "%network_script_path%" /sc ONCE /sd 01/01/1990 /st 00:00 /F
schtasks /s CER_LCM_SRV2A /u %user% /p %password% /run /tn "Saving logs on disk" /I


echo Copy launched on each SRV!
timeout /t 5 /nobreak
exit