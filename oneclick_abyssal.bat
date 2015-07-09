@ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION ENABLEEXTENSIONS
SET ME=%~n0
SET PARENT=%~dp0

ECHO Loading scripts...
FOR /F %%f in ('type data\modules') DO (
	IF NOT EXIST %%f ECHO %%F is missing && GOTO GENERIC_FAIL
)
ECHO Loading modules...
CALL SELFTEST > selftest.log 2>&1
if %errorlevel% neq 0 GOTO GENERIC_FAIL

ECHO Preparing folders...
DEL /q *.hack.swf > nul 2>&1
CALL CLEANUP > nul 2>&1
MKDIR temp\abyssal

ECHO Importing files...
COPY *.swf temp\abyssal

CALL EXTRACT > extract.log 2>&1
CALL SCALE 2> scale.log 
CALL REPLACE > replace.log 2>&1

ECHO Exporting files...
COPY %parent%temp\abyssal\*.hack.swf %parent%

CD %PARENT%
ECHO Saving log to log_lastrun.txt...
COPY selftest.log + extract.log + scale.log + replace.log log_lastrun.txt > nul 2>&1
ECHO Removing temporary files...
CALL CLEANUP > nul 2>&1

ENDLOCAL
ECHO ---------------
ECHO Run Complete :)
ECHO ---------------
EXIT /B 0

:GENERIC_FAIL
ENDLOCAL
ECHO -------------
ECHO Run Failed :(
ECHO -------------
EXIT /B 1