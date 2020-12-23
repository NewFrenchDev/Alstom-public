@Echo OFF 

::Script for copying logs on SRV. 

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
set server_name=%server_name:CER_LCM_=%

set file_ATS_version=D:\Dataprep\Version\SCMAVersion_Integration.xml

set ATS_version=
for /f "skip=1 tokens=1-2" %%A in (%file_ATS_version%) do ( 
															set ATS_version=%%B
															goto ending
															)
:ending
for /f "tokens=1-2 delims==" %%A in ("%ATS_version%") do set ATS_version=%%B
set ATS_version=%ATS_version:"=%

::Date
set date=%DATE%
set date_ROBOCOPY=
for /F "tokens=1-2 delims= " %%A in ("%date%") do set date=%%B
for /F "tokens=1-3 delims=/" %%A in ("%date%") do set date_ROBOCOPY=%%C%%A%%B
set date=%date:/=-%
set date=%date: =_%

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::END GET COMPUTER INFORMATION:::::::::::::::::::::::::::::::::::::::::::::::::::




::::::::::::::::::::::::::::::::::::::::::::::::::::START GET NETWORK ACCESS::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

::ON CLOUD PLATFORM
set NETWORK_ACCESS=\\OCC_LCM_TCC1\ArchivesFirstShared

:::::::::::::::::::::::::::::::::::::::::::::::::::::END GET NETWORK ACCESS::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		

		
::Copy Playback,IconisAppl,IconisBin,Caches,PerfLogs and Archiving 
::Source folders to copy
set Source_Archiving=D:\IconisTM4\Archiving
set Source_Playback=D:\IconisTM4\PlayBack
set Source_Perflogs=D:\IconisTM4\PerfLogs
set Source_IconisAppl=D:\IconisTM4\IconisAppl
set Source_IconisBin=D:\IconisTM4\IconisBin 
set Source_Log=D:\IconisTM4\Log
set Source_Cache=C:\ProgramData\Alstom\ICONIS\S2K\Server\Settings and Caches

::Folder to stock files from Playback folder (Current day)
set Temp_playback=D:\IconisTM4\Playback_%date%

::Destination folder
set Destination_Folder=%NETWORK_ACCESS%\Backup_ATS\%workstation%\%ATS_version%\%date%\%Folder_Name%\%server_name%

::Zipping folder and files
set Playback_zip=D:\Playback_%date%.%zip_ext%


Echo.  
Echo.  
Echo zipping...

"C:\Program Files\7-Zip\7z.exe" a -mx7 "D:\IconisTM4\IconisBin.%zip_ext%" "D:\IconisTM4\IconisBin"
"C:\Program Files\7-Zip\7z.exe" a -mx7 "D:\IconisTM4\IconisAppl.%zip_ext%" "D:\IconisTM4\IconisAppl"	
ROBOCOPY "%Source_Log%" "D:\IconisTM4\Log_%date%" /ETA /mir /MAXLAD:1
ROBOCOPY "%Source_Perflogs%" "D:\IconisTM4\PerfLogs_%date%" /ETA /mir /MAXLAD:1
"C:\Program Files\7-Zip\7z.exe" a -mx7 "D:\IconisTM4\Log_%date%.%zip_ext%" "D:\IconisTM4\Log_%date%"	
"C:\Program Files\7-Zip\7z.exe" a -mx7 "D:\IconisTM4\PerfLogs_%date%.%zip_ext%" "D:\IconisTM4\PerfLogs_%date%"	
"C:\Program Files\7-Zip\7z.exe" a -mx7 "C:\ProgramData\Alstom\ICONIS\S2K\Server\Settings and Caches\Cache.%zip_ext%" "%Source_Cache%\*.CSLoading"
ROBOCOPY "%Source_Playback%" "%Temp_playback%" /ETA /mir /MAXLAD:%date_ROBOCOPY%
"C:\Program Files\7-Zip\7z.exe" a -mx7 "%Playback_zip%" "%Temp_playback%"

Echo.
Echo.
Echo zipping done!


::Copy folders on network folder
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