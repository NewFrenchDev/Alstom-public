cls
@echo off

:: This launch the script Restart-ATS.bat on the disk's root

if %COMPUTERNAME%==OCC_LCM_TCC1 goto Check_disk
if %COMPUTERNAME%==OCC_LCM_TCC2 (goto Check_disk) else goto Stop_script

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

echo Enter the user session:
set /p user=
echo Enter password:
set /p password=				

::Close HMI on TCC
echo Closing Client Builder
taskkill /F /IM "Client Builder.exe*" /T

::Check if another TCC is available on network
if %COMPUTERNAME%==OCC_LCM_TCC1 set Adress_Workstation2=OCC_LCM_TCC2
if %COMPUTERNAME%==OCC_LCM_TCC2 set Adress_Workstation2=OCC_LCM_TCC1  
  
echo Check if another TCC is available on network...
ping -w 2999 %Adress_Workstation2%
if %errorlevel%==1 (echo [%date%] [%time%] CONNECTION A %Adress_Workstation2% REFUSEE
                    goto Restart_machines)
if %errorlevel%==0 (echo [%date%] [%time%] CONNECTION A %Adress_Workstation2% OK !)

::Closing Client builder on the other TCC
taskkill /S %Adress_Workstation2% /U %user% /P %password% /IM "Client Builder.exe*" /T 


:Restart_machines
echo Restarting ATS machines now!

::Script path is indicated in each XML indicated below
::XML are necessary for this script because we need to put the script priority at 2 which is by default at 7 without using XML files
::With priority at 7 memory leaks are seen on processes started by the script
schtasks /s CER_LCM_SRV_A /u %user% /p %password%  /create /tn "run server" /XML run-SRV_A.xml /F 
schtasks /s CER_LCM_SRV_A /u %user% /p %password% /run /tn "run server" /I

schtasks /s CER_LCM_SRV1A /u %user% /p %password%  /create /tn "run server" /XML run-SRV1A.xml /F 
schtasks /s CER_LCM_SRV1A /u %user% /p %password% /run /tn "run server" /I

schtasks /s CER_LCM_SRV2A /u %user% /p %password%  /create /tn "run server" /XML run-SRV2A.xml /F 
schtasks /s CER_LCM_SRV2A /u %user% /p %password% /run /tn "run server" /I

schtasks /s CER_LCM_FEP1A /u %user% /p %password%  /create /tn "run fep" /XML run-FEP1A.xml /F 
schtasks /s CER_LCM_FEP1A /u %user% /p %password% /run /tn "run fep" /I

schtasks /s CER_LCM_FEP2A /u %user% /p %password%  /create /tn "run fep" /XML run-FEP2A.xml /F 
schtasks /s CER_LCM_FEP2A /u %user% /p %password% /run /tn "run fep" /I

schtasks /s CER_LCM_GTW_A /u %user% /p %password%  /create /tn "run gateway" /XML run-GTW_A.xml /F 
schtasks /s CER_LCM_GTW_A /u %user% /p %password% /run /tn "run gateway" /I

::Need to wait SRV restarting correctly before to login on HMI 
echo Waiting for SRV to restart... 
echo Opening Client Builder in... 
timeout /t 300 /nobreak
start "Client Builder" "C:\Program Files (x86)\Alstom\ICONIS\S2K\Bin\Client Builder\Client Builder.exe"
exit

::Do nothing if it's not a TCC
:Stop_script
echo "This script is only made for TCC! Exit in..."
timeout /t 5 /nobreak

