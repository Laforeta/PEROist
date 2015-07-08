@ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION ENABLEEXTENSIONS
SET ME=%~n0
SET PARENT=%~dp0

ECHO Preparing...
DEL /q *.hack.swf > nul 2>&1
CALL CLEANUP > nul 2>&1

ECHO Importing files...
MKDIR temp
COPY *.swf temp

CALL EXTRACT > extract.log 2>&1
CALL SCALE 2> scale.log
CALL REPLACE > replace.log 2>&1

ECHO Exporting files...
COPY %parent%temp\*.hack.swf %parent%

CD %PARENT%
ECHO Saving log to log_lastrun.txt...
COPY extract.log + scale.log + replace.log log_lastrun.txt > nul 2>&1
ECHO Removing temporary files...
CALL CLEANUP > nul 2>&1

ENDLOCAL

ECHO ----------------
ECHO ~~Run Complete~~
ECHO ----------------
PAUSE