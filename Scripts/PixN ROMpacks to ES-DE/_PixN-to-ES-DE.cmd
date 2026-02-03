@echo off
echo                             ___
echo                           ,"---".
echo                           :     ;
echo                            `-.-'
echo                             ^| ^|
echo                             ^| ^|
echo                             ^| ^|
echo                          _.-\_/-._
echo                       _ / ^|     ^| \ _
echo                      / /   `---'   \ \
echo                     /  `-----------'  \
echo                    /,-""-.       ,-""-.\
echo                   ( i-..-i       i-..-i )
echo                   ^|`^|    ^|-------^|    ^|'^|
echo                   \ `-..-'  ,=.  `-..-'/
echo                    `--------^|=^|-------'
echo                             ^| ^|
echo                             \ \
echo                              ) )
echo                             / /
echo                            ( (
echo ..............................................................
echo .........Welcome to another Team Pixel Nostalgia Tool.........
echo ..............................................................
echo ...........This script will prepare an RGS ROMpack............
echo ......................for use with ES-DE......................
echo ..............................................................

REM Version 1.00

ping -n 4 127.0.0.1 > nul
cls

for %%i in (%CD%) do set SystemFolderName=%%~ni
echo.
robocopy media\thumbnails ES-DE\downloaded_media\%SystemFolderName%\3dboxes /XF *-0?.*
echo.
robocopy media\box2d ES-DE\downloaded_media\%SystemFolderName%\covers /XF *-0?.*
echo.
robocopy media\fanarts ES-DE\downloaded_media\%SystemFolderName%\fanart /XF *-0?.*
echo.
robocopy media\marquee ES-DE\downloaded_media\%SystemFolderName%\marquees /XF *-0?.*
echo.
robocopy media\images ES-DE\downloaded_media\%SystemFolderName%\screenshots /XF *-0?.*
echo.
robocopy media\titles ES-DE\downloaded_media\%SystemFolderName%\titlescreens /XF *-0?.*
echo.
robocopy media\cartridges ES-DE\downloaded_media\%SystemFolderName%\physicalmedia /XF *-0?.*

mkdir ES-DE\gamelists
mkdir ES-DE\gamelists\%SystemFolderName%
echo.
copy gamelist.xml ES-DE\gamelists\%SystemFolderName%\gamelist.xml
echo.
echo Converting fanart please wait...
echo.
for /R %%i in (ES-DE\downloaded_media\%SystemFolderName%\fanart\*.png) do _ffmpeg -y -i "%%i" -preset ultrafast "%%~dpni.jpg" >nul 2>&1
ping -n 2 127.0.0.1 > nul
del /Q "ES-DE\downloaded_media\%SystemFolderName%\fanart\*.png" >nul 2>&1
ping -n 2 127.0.0.1 > nul

echo.
echo Would you like to also copy the ROMs to the new folder?
echo.
choice /T 60 /C YN /D Y
if %errorlevel%==1 goto yes1
if %errorlevel%==2 goto no1

:yes1
echo.
echo You selected YES, ROMs will now be copied...
echo.
mkdir ES-DE\roms\%SystemFolderName%
copy *.* ES-DE\roms\%SystemFolderName%
ping -n 2 127.0.0.1 > nul
del /Q ES-DE\roms\%SystemFolderName%\_info.txt >nul 2>&1
del /Q ES-DE\roms\%SystemFolderName%\gamelist.xml >nul 2>&1
del /Q ES-DE\roms\%SystemFolderName%\gamelist*.xml >nul 2>&1
del /Q ES-DE\roms\%SystemFolderName%\_ffmpeg.exe >nul 2>&1
del /Q ES-DE\roms\%SystemFolderName%\_PixN-to-ES-DE.cmd >nul 2>&1
del /Q ES-DE\roms\%SystemFolderName%\_Remove-Duplicates-K-JPG.ps1 >nul 2>&1
del /Q ES-DE\roms\%SystemFolderName%\_Remove-Duplicates-K-PNG.ps1 >nul 2>&1
echo.
goto NEXT1

:no1
echo.
echo You selected NO, ROMs will NOT be copied...
echo.
ping -n 2 127.0.0.1 > nul

:NEXT1
echo.
echo Would you like to reduce the resolution and size of the video snaps?
echo.
echo Useful if using ES-DE on an Android device such as a phone
echo (Videos cropped to 15 seconds and a resolution of 320x240)
echo.
choice /T 60 /C YN /D N
if %errorlevel%==1 goto yes2
if %errorlevel%==2 goto no2

:yes2
echo.
echo You selected YES, video snaps will now be optimised during ...
echo.
mkdir ES-DE\downloaded_media\%SystemFolderName%\videos
for /R %%i in (media\videos\*.MP4) do _ffmpeg -i "%%i" -hide_banner -loglevel info -ss 00:00:00 -to 00:00:15 -vf "fade=t=in:st=0:d=2,fade=t=out:st=13:d=2,scale=320:240,fps=30" -af "afade=t=in:st=0:d=2,afade=t=out:st=13:d=2" -c:v:0 h264 -b:v 350k -y "ES-DE\downloaded_media\%SystemFolderName%\videos\%%~ni.mp4"
echo.
goto NEXT2

:no2
echo.
echo You selected NO, video snaps will NOT be optimised before being copied...
echo.
robocopy media\videos ES-DE\downloaded_media\%SystemFolderName%\videos /XF *-0?.*
ping -n 2 127.0.0.1 > nul

:NEXT2


echo.
echo Scanning for and removing duplicate images...
echo.
echo Running...
echo.
powershell -ExecutionPolicy Bypass -File "_Remove-Duplicates-K-JPG.ps1"
echo.
ping -n 2 127.0.0.1 > nul
powershell -ExecutionPolicy Bypass -File "_Remove-Duplicates-K-PNG.ps1"
echo.

REM Resizing images to better sizes for Android...

echo.
echo Would you like to reduce the size of the artwork?
echo.
echo Useful if using ES-DE on an Android device such as a phone
echo.
choice /T 60 /C YN /D N
if %errorlevel%==1 goto yes3
if %errorlevel%==2 goto END

:yes3
mkdir ES-DE\downloaded_media\%SystemFolderName%\covers-temp
for %%i in (ES-DE\downloaded_media\%SystemFolderName%\covers\*.png) do _ffmpeg -i "%%i" -vf scale=600:-1 -y "ES-DE\downloaded_media\%SystemFolderName%\covers-temp\%%~ni.png"
ping -n 2 127.0.0.1 > nul
for %%i in (ES-DE\downloaded_media\%SystemFolderName%\covers\*.jpg) do _ffmpeg -i "%%i" -vf scale=600:-1 -y "ES-DE\downloaded_media\%SystemFolderName%\covers-temp\%%~ni.jpg"
ping -n 2 127.0.0.1 > nul
rmdir /S /Q ES-DE\downloaded_media\%SystemFolderName%\covers
ping -n 2 127.0.0.1 > nul
move "ES-DE\downloaded_media\%SystemFolderName%\covers-temp" "ES-DE\downloaded_media\%SystemFolderName%\covers"
ping -n 2 127.0.0.1 > nul

mkdir ES-DE\downloaded_media\%SystemFolderName%\screenshots-temp
for %%i in (ES-DE\downloaded_media\%SystemFolderName%\screenshots\*.png) do _ffmpeg -i "%%i" -vf scale=640:-1 -y "ES-DE\downloaded_media\%SystemFolderName%\screenshots-temp\%%~ni.png"
ping -n 2 127.0.0.1 > nul
for %%i in (ES-DE\downloaded_media\%SystemFolderName%\screenshots\*.jpg) do _ffmpeg -i "%%i" -vf scale=640:-1 -y "ES-DE\downloaded_media\%SystemFolderName%\screenshots-temp\%%~ni.jpg"
ping -n 2 127.0.0.1 > nul
rmdir /S /Q ES-DE\downloaded_media\%SystemFolderName%\screenshots
ping -n 2 127.0.0.1 > nul
move "ES-DE\downloaded_media\%SystemFolderName%\screenshots-temp" "ES-DE\downloaded_media\%SystemFolderName%\screenshots"
ping -n 2 127.0.0.1 > nul

mkdir ES-DE\downloaded_media\%SystemFolderName%\titlescreens-temp
for %%i in (ES-DE\downloaded_media\%SystemFolderName%\titlescreens\*.png) do _ffmpeg -i "%%i" -vf scale=640:-1 -y "ES-DE\downloaded_media\%SystemFolderName%\titlescreens-temp\%%~ni.png"
ping -n 2 127.0.0.1 > nul
for %%i in (ES-DE\downloaded_media\%SystemFolderName%\titlescreens\*.jpg) do _ffmpeg -i "%%i" -vf scale=640:-1 -y "ES-DE\downloaded_media\%SystemFolderName%\titlescreens-temp\%%~ni.jpg"
ping -n 2 127.0.0.1 > nul
rmdir /S /Q ES-DE\downloaded_media\%SystemFolderName%\titlescreens
ping -n 2 127.0.0.1 > nul
move "ES-DE\downloaded_media\%SystemFolderName%\titlescreens-temp" "ES-DE\downloaded_media\%SystemFolderName%\titlescreens"
ping -n 2 127.0.0.1 > nul

mkdir ES-DE\downloaded_media\%SystemFolderName%\fanart-temp
for %%i in (ES-DE\downloaded_media\%SystemFolderName%\fanart\*.png) do _ffmpeg -i "%%i" -vf scale=960:-1 -y "ES-DE\downloaded_media\%SystemFolderName%\fanart-temp\%%~ni.png"
ping -n 2 127.0.0.1 > nul
for %%i in (ES-DE\downloaded_media\%SystemFolderName%\fanart\*.jpg) do _ffmpeg -i "%%i" -vf scale=960:-1 -y "ES-DE\downloaded_media\%SystemFolderName%\fanart-temp\%%~ni.jpg"
ping -n 2 127.0.0.1 > nul
rmdir /S /Q ES-DE\downloaded_media\%SystemFolderName%\fanart
ping -n 2 127.0.0.1 > nul
move "ES-DE\downloaded_media\%SystemFolderName%\fanart-temp" "ES-DE\downloaded_media\%SystemFolderName%\fanart"
ping -n 2 127.0.0.1 > nul

:END
echo.
echo ..............................................................
echo .................Done!  Press any key to exit.................
echo ..............................................................
pause > nul 2>&1
