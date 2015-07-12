@ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION ENABLEEXTENSIONS
SET ME=%~n0
SET PARENT=%~dp0

ECHO Preparing folders...
DEL /q *.hack.swf > nul 2>&1
CALL CLEANUP > nul 2>&1
MKDIR temp

ECHO Checking scripts...
FOR /F %%f in ('type data\modules') DO (
	IF NOT EXIST %%f ECHO %%F is missing && GOTO GENERIC_FAIL
)

ECHO Testing modules...
CALL SELFTEST > selftest.log 2>&1
if %errorlevel% neq 0 GOTO GENERIC_FAIL

ECHO Looking for files to import...
IF NOT EXIST *.swf ECHO But there are no files to import... && GOTO NORMAL_EXIT 

ECHO Importing files...
CALL IMPORT > import.log 2>&1

CALL EXTRACT > extract.log 2>&1
CALL SCALE 2> scale.log
CALL REPLACE > replace.log 2>&1

ECHO Exporting files...
COPY "%parent%temp\kanmusu\*.hack.swf" "%parent%"
COPY "%parent%temp\abyssal\*.hack.swf" "%parent%"

CD %PARENT%
ECHO Saving log to log_lastrun.txt...
COPY selftest.log + import.log + extract.log + scale.log + replace.log log_lastrun.txt > nul 2>&1
ECHO Removing temporary files...
CALL CLEANUP > nul 2>&1

:NORMAL_EXIT
ENDLOCAL
ECHO ----------------
ECHO Process Complete
ECHO ----------------
PAUSE
EXIT /B 0

:GENERIC_FAIL
ENDLOCAL
ECHO -----------------
ECHO Process Failed :(
ECHO -----------------
PAUSE
EXIT /B 1