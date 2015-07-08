@ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION ENABLEEXTENSIONS
SET ME=%~n0
SET PARENT=%~dp0

REM Remove temporary files if a previoius run had aborted. 
CALL CLEANUP


MKDIR temp
COPY *.swf temp

CALL EXTRACT
CALL SCALE
CALL REPLACE

COPY %parent%temp\*.hack.swf %parent%

CD %PARENT%
CALL CLEANUP

ECHO All Done