@ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION ENABLEEXTENSIONS
SET ME=%~n0
SET PARENT=%~dp0
ECHO Running %ME%

REM Prepare folders if not already present
CALL CLEANUP.cmd 2>nul
IF NOT EXIST temp MKDIR temp
IF NOT EXIST input MKDIR input
IF NOT EXIST output MKDIR output

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
CALL SELFTEST >> selftest.log 2>&1
if %errorlevel% neq 0 GOTO SELFCHECK_FAIL

:MENU
@ECHO OFF
CLS
ECHO.
ECHO 		############################
ECHO 		      PEROist Launcher
ECHO 		############################
ECHO.
ECHO 1 - Download and maintain local cache
ECHO 2 - Bump or refresh the "Last-modified" date of all mods
ECHO 3 - Remove all mods
ECHO 4 - Generate Avatars
ECHO 5 - AUTOGEN
ECHO 6 - INIGEN
ECHO 7 - Automatic Scaling
ECHO 8 - 
ECHO 9 - 
ECHO 0 - Quit
ECHO.
ECHO Choose from one of the options above and press enter:
SET "OPTION="
SET /p OPTION=[1,2,3,4,5,6,7,8,9,0]
IF /i '%OPTION%'=='0' (
	GOTO EXIT
) ELSE IF /i '%OPTION%'=='1' (
	ECHO 1
	PAUSE
	GOTO MENU
) ELSE IF /i '%OPTION%'=='2' (
	ECHO 2
	PAUSE
	GOTO MENU
) ELSE IF /i '%OPTION%'=='3' (
	ECHO 3
	PAUSE
	GOTO MENU
) ELSE IF /i '%OPTION%'=='4' (
	ECHO 4
	PAUSE
	GOTO MENU
) ELSE IF /i '%OPTION%'=='5' (
	ECHO 5
	PAUSE
	GOTO MENU
) ELSE IF /i '%OPTION%'=='6' (
	ECHO 6
	PAUSE
	GOTO MENU
) ELSE IF /i '%OPTION%'=='7' (
	ECHO 7
	PAUSE
	GOTO MENU
) ELSE IF /i '%OPTION%'=='8' (
	ECHO 8
	PAUSE 
	GOTO MENU
) ELSE IF /i '%OPTION%'=='9' (
	ECHO 9
	PAUSE GOTO MENU
) ELSE (
	ECHO Please enter one valid option from the list above
	PAUSE
	GOTO MENU
)
GOTO MENU

:EXIT
ENDLOCAL
ECHO Shutting down generator...
EXIT /b 0