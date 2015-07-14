@ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION ENABLEEXTENSIONS
SET ME=%~n0
SET PARENT=%~dp0

ECHO Preparing folders...
CALL CLEANUP > nul 2>&1
MKDIR temp
MKDIR output

REM Detect whether the program runs on 64-bit OS by the existence of SysWOW64 folder.
ECHO Detecting system architecture...
IF EXIST "%SYSTEMROOT%\SysWOW64" (
   SET AMD64=1
) ELSE (
   SET AMD64=0
)

ECHO Checking scripts...
FOR /F %%f in ('type data\modules') DO (
	IF NOT EXIST %%f ECHO %%F is missing && GOTO SELFCHECK_FAIL
)

ECHO Testing modules...
CALL SELFTEST > selftest.log 2>&1
if %errorlevel% neq 0 GOTO SELFCHECK_FAIL

SET /a RETRY_COUNTER=0
SET /a RETRY_LIMIT=1
:AUTOPROCESS
ECHO Looking for files to import...
IF NOT EXIST *.swf (
	ECHO There are no files left to import, exiting autoprocess
	GOTO NORMAL_EXIT
) ELSE IF %RETRY_COUNTER% gtr %RETRY_LIMIT% (
	ECHO The following files have failed after %RETRY_LIMIT% attempts, program will them to %PARENT%error and exit. 
	MOVE /y "%PARENT%*.swf" "%PARENT%error"
	DIR /b "%PARENT%error\*.swf"
	GOTO NORMAL_EXIT
) ELSE (
	ECHO Importing files...
	CALL IMPORT > import.log 2>&1
	CALL EXTRACT > extract.log 2>&1
	CALL SCALE 2> scale.log
	CALL REPLACE > replace.log 2>&1
	CALL EXPORT > export.log 2>&1
	MOVE /y "%PARENT%error\*.swf" "%PARENT%"
	SET /a %RETRY_COUNTER%+=1
	GOTO AUTOPROCESS
)

:NORMAL_EXIT
CD %PARENT%
ECHO Saving log to log_lastrun.txt...
COPY selftest.log + import.log + extract.log + scale.log + replace.log log_lastrun.txt > nul 2>&1
ECHO Removing temporary files...
CALL CLEANUP > nul 2>&1
ENDLOCAL
ECHO ----------------
ECHO Process Complete
ECHO ----------------
PAUSE
EXIT /B 0

:SELFCHECK_FAIL
ENDLOCAL
ECHO -----------------
ECHO Process Failed :(
ECHO -----------------
PAUSE
EXIT /B 1