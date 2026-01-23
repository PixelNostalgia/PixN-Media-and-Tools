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
echo ........................Updating Files........................
echo ..............................................................
echo ...........Please wait, this may take a few minutes...........
echo ..............................................................
echo.

for /R %%i in (*.xml) do cscript replace.vbs "%%i" "R:\RETROBAT\" "X:\Games\RetroBat\" > nul
cls
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
echo .................Done!  Press any key to exit.................
echo ..............................................................
pause > nul 2>&1
