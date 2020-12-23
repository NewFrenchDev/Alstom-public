::Author G.LEMOING
::This script permit to run Autosaving-log.bat on the disk (root)

@echo off

::Check if any disk is inserted on the HMI workstation
:Check_disk
set Disk=E
if not exist "%Disk%:" set Disk=F
if not exist "%Disk%:" (
						echo No disk found... Put a disk on the workstation
						timeout /t 10 /nobreak
						goto Check_disk
						)

::Autosaving-Logs.bat path
set script_path=\\tsclient\%Disk%\Autosaving-Logs.bat

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
::SRV1A
schtasks /s ATSSRV1A /u %user% /p %password%  /create /tn "Saving logs on disk" /tr "%script_path%" /sc ONCE /sd 01/01/1990 /st 00:00 /F
schtasks /s ATSSRV1A /u %user% /p %password% /run /tn "Saving logs on disk" /I
::SRV2A
schtasks /s ATSSRV2A /u %user% /p %password%  /create /tn "Saving logs on disk" /tr "%script_path%" /sc ONCE /sd 01/01/1990 /st 00:00 /F
schtasks /s ATSSRV2A /u %user% /p %password% /run /tn "Saving logs on disk" /I

::End
echo Copy launched on each SRV!
timeout /t 5 /nobreak