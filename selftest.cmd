@ECHO OFF
SET ME=%~n0
SET PARENT=%~dp0

ECHO Performing self-tests, please wait...>con
MKDIR temp
CD bin

REM Detect whether the program runs on 64-bit OS by the existence of SysWOW64 folder.
REM Test and see if this will trigger overzealous AV software
ECHO Detecting system architecture
IF EXIST "%SYSTEMROOT%\SysWOW64" (
   SET AMD64=TRUE
) ELSE (
   SET AMD64=FLASE
)

ECHO Testing ffdec..>con
java -jar "%PARENT%bin\ffdec\ffdec.jar" --help
if %errorlevel% neq 0 GOTO FFDEC_FAIL

ECHO Testing ImageMagick...>con
convert "%PARENT%\data\selftest.gif" "%PARENT%temp\selftest.png"
if %errorlevel% neq 0 GOTO IM_FAIL

ECHO Testing Waifu2x...>con
waifu2x-converter.exe -i "%PARENT%temp\selftest.png" -o "%PARENT%temp\selftest_2x.png" -m noise_scale --noise_level 1
if %errorlevel% neq 0 GOTO Waifu2x_FAIL

GOTO PASS

:IM_FAIL
ECHO An error has occured while testing ImageMagick>con
ECHO Please view log_selftest.txt for detailed error message>con
GOTO ABORT

:FFDEC_FAIL
ECHO An error has occured while testing ffdec>con
ECHO Please view log_selftest.txt for detailed error message>con
GOTO ABORT

:WAIFU2X_FAIL
ECHO An error has occured while testing Waifu2x>con
ECHO Please view log_selftest.txt for detailed error message>con
GOTO ABORT

:PASS
ECHO ---------------->con
ECHO Self-test passed>con
ECHO ---------------->con
CD %PARENT%
EXIT /B 0

:ABORT
ECHO ---------------->con
ECHO Self-test failed>con
ECHO ---------------->con
CD %PARENT
PAUSE
EXIT /B 1