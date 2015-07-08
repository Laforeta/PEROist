@ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION ENABLEEXTENSIONS
SET ME=%~n0
SET PARENT=%~dp0

REM Remove temporary files if a previoius run had aborted. 
CALL CLEANUP

MKDIR temp\abyssal
COPY *.swf temp\abyssal

CALL EXTRACT
CALL SCALE
CALL REPLACE

COPY %parent%temp\abyssal\*.hack.swf %parent%
CD %PARENT%
CALL CLEANUP

ECHO All Done