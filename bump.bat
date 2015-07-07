@ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION
SET ME=%~n0
SET PARENT=%~dp0
ECHO This script will bump the "last-modified" timestamp of .hack.swf files to the current computer time. 
ECHO OFF
FOR /R %parent%kcs\resources\ %%f IN (*.hack.swf) DO COPY "%%f" + null "%%f"
FOR /R %parent%kcs\sound\ %%f IN (*.hack.mp3) DO COPY "%%f" + null "%%f"

ENDLOCAL 
ECHO Bump Completed
REM PAUSE