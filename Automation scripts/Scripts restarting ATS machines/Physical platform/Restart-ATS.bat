cls
@echo off
						
:: This Script is use for
:: Restart Client Builder on TCC1 and TCC2 & all ATS machines (SRV,GTW,FEP)
:: Kill process on a specific ATS machine and restart it

:Check_computer
if %COMPUTERNAME%==CER_LCM_SRV_A goto Kill_ATS_Process
if %COMPUTERNAME%==CER_LCM_SRV1A goto Kill_ATS_Process
if %COMPUTERNAME%==CER_LCM_SRV2A goto Kill_ATS_Process
if %COMPUTERNAME%==CER_LCM_FEP1A goto Kill_ATS_Process
if %COMPUTERNAME%==CER_LCM_FEP2A goto Kill_ATS_Process
if %COMPUTERNAME%==CER_LCM_GTW_A (goto Kill_ATS_Process) else goto Stop_script

::Kill processes on ATS machines
:Kill_ATS_Process
echo Kill DBLoader, S2K, TABServer
taskkill /f /im StarterW*
taskkill /f /im DBLoader*
taskkill /f /im S2KServer*
taskkill /f /im TABServer*
taskkill /f /im OPCHMI_*

::Start processes on ATS machines
echo Start StarterW in ...
timeout /t 5 /nobreak
start "StarterW" "D:\IconisTM4\Starter\StarterW.exe" /NORMAL 
exit

::Do nothing if it's not an ATS machine
:Stop_script
echo "This script is only made for ATS machines! Exit in..."
timeout /t 5 /nobreak

