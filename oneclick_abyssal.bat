@ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION ENABLEEXTENSIONS
SET ME=%~n0
SET PARENT=%~dp0

MKDIR temp\abyssal
COPY *.swf temp\abyssal

CALL EXTRACT
CALL SCALE
CALL REPLACE

COPY %parent%temp\abyssal\*.hack.swf %parent%
RD /s /q temp