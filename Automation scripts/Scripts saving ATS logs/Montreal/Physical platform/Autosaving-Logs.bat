::Author G.LEMOING
::This script serve to copy logs on the disk inserted on HMI workstation

@echo off
color 0F

::Use for incrementation in FOR loop without this the incrementation is not working
setlocal EnableDelayedExpansion

::Check if 7z is installed on computer if not launch the .exe
set Path_7z=C:\Program Files\7-Zip
if not exist "%Path_7z%" start "7z" D:\DataPrep\PATCH\Tools\7z1900-x64.exe

::Indicate zip extension
set zip_ext=7z

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::START GET COMPUTER INFORMATION:::::::::::::::::::::::::::::::::::::::::::::::::::
::Information in order to create folders
set server_name=%COMPUTERNAME%
set server_name=%server_name:ATS=%

::Path to file where is indicated the ATS current version
REM set file_ATS_version=D:\Dataprep\Version\SCMAVersion_Integration.xml

REM set ATS_version=
REM for /f "skip=1 tokens=1-2" %%A in (%file_ATS_version%) do ( 
															REM set ATS_version=%%B
															REM goto ending
															REM )
REM :ending
REM for /f "tokens=1-2 delims==" %%A in ("%ATS_version%") do set ATS_version=%%B
REM set ATS_version=%ATS_version:"=%

::Date
set date=%DATE%
set date_ROBOCOPY=
for /F "tokens=1-2 delims= " %%A in ("%date%") do set date=%%B
for /F "tokens=1-3 delims=/" %%A in ("%date%") do set date_ROBOCOPY=%%C%%A%%B
set date=%date:/=-%
set date=%date: =_%

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::END GET COMPUTER INFORMATION:::::::::::::::::::::::::::::::::::::::::::::::::::




::::::::::::::::::::::::::::::::::::::::::::::::::::START NETWORK ACCESS::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:Check_disk
::Get the correct network access by checking disk
set NETWORK_ACCESS=\\tsclient
echo This script is copying automatically playback on your disk

Echo Checking if disk available on E
set Disk=E
if exist "%NETWORK_ACCESS%\%Disk%" (
							  echo files are going to be copy on disk E 
							  goto Rename_network_access
							  )
Echo Disk E was not found
echo Checking if disk available on F
set Disk=F 
if exist "%NETWORK_ACCESS%\%Disk%" (
								echo files are going to be copy on disk E
								goto Rename_network_access
							  )

Echo No disk found insert a disk...
timeout /t 10 /nobreak
goto Check_disk
							 																					
:Rename_network_access
set NETWORK_ACCESS=\\tsclient\%Disk%

:::::::::::::::::::::::::::::::::::::::::::::::::::::END NETWORK ACCESS::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		

		
:Start_copy
::Copy Playback,IconisAppl,IconisBin,Caches,PerfLogs and Archiving 
 
::Source folders to copy
if %COMPUTERNAME%==SRV2A (set Source_Archiving=D:\IconisTM4\Archiving_LV2) else set Source_Archiving=D:\IconisTM4\Archiving
set Source_Playback=D:\IconisTM4\PlayBack
set Source_Perflogs=D:\IconisTM4\PerfLogs
set Source_IconisAppl=D:\IconisTM4\IconisAppl
set Source_IconisBin=D:\IconisTM4\IconisBin 
set Source_Log=D:\IconisTM4\Log
set Source_Cache=C:\ProgramData\Alstom\ICONIS\S2K\Server\Settings and Caches

::Folder to stock files from Playback folder (current day)
set Temp_playback=D:\IconisTM4\Playback_%date%

::Destination folder
set Destination_Folder=%NETWORK_ACCESS%\Backup_ATS\%workstation%\%date%\%Folder_Name%\%server_name%

::Zipping folder and files
set Playback_zip=D:\Playback_%date%.%zip_ext%


Echo.  
Echo.  
Echo zipping...

::Zip IconisBin and IconisAppl
"C:\Program Files\7-Zip\7z.exe" a -mx7 "D:\IconisTM4\IconisBin.%zip_ext%" "D:\IconisTM4\IconisBin"
"C:\Program Files\7-Zip\7z.exe" a -mx7 "D:\IconisTM4\IconisAppl.%zip_ext%" "D:\IconisTM4\IconisAppl"
::Create temporary folder for Logs and Perflogs then zip them
ROBOCOPY "%Source_Log%" "D:\IconisTM4\Log_%date%" /ETA /mir /MAXLAD:1
ROBOCOPY "%Source_Perflogs%" "D:\IconisTM4\PerfLogs_%date%" /ETA /mir /MAXLAD:1
"C:\Program Files\7-Zip\7z.exe" a -mx7 "D:\IconisTM4\Log_%date%.%zip_ext%" "D:\IconisTM4\Log_%date%"	
"C:\Program Files\7-Zip\7z.exe" a -mx7 "D:\IconisTM4\PerfLogs_%date%.%zip_ext%" "D:\IconisTM4\PerfLogs_%date%"	
::Zip cache
"C:\Program Files\7-Zip\7z.exe" a -mx7 "C:\ProgramData\Alstom\ICONIS\S2K\Server\Settings and Caches\Cache.%zip_ext%" "%Source_Cache%\*.CSLoading"
::Create temporary folder for playback and zip it
ROBOCOPY "%Source_Playback%" "%Temp_playback%" /ETA /mir /MAXLAD:%date_ROBOCOPY%
"C:\Program Files\7-Zip\7z.exe" a -mx7 "%Playback_zip%" "%Temp_playback%"

Echo.
Echo.
Echo zipping done!


::Copy folders on disk
ROBOCOPY "D:\IconisTM4" "%Destination_Folder%" *.%zip_ext% /MOV /ETA  
ROBOCOPY D:\ "%Destination_Folder%" *.%zip_ext% /MOV /ETA
ROBOCOPY "%Source_Cache%" "%Destination_Folder%" *.%zip_ext% /MOV /ETA  

::Waiting message
Echo.
Echo.
Echo Wait for the confirmation message before to remove the disk!

::Display hidden folders
attrib -h -r -s /s /d %NETWORK_ACCESS%\Backup_ATS\*.*

::Delete all temporary folders
if exist %Temp_playback% rmdir %Temp_playback% /S /Q
if exist "D:\IconisTM4\Log_%date%" rmdir "D:\IconisTM4\Log_%date%" /S /Q
if exist "D:\IconisTM4\PerfLogs_%date%" rmdir "D:\IconisTM4\PerfLogs_%date%" /S /Q

echo Copy done! 
echo Exit in...
timeout /t 10 /nobreak
exit