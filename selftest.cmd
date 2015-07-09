@ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION ENABLEEXTENSIONS
SET ME=%~n0
SET PARENT=%~dp0

ECHO Performing self-tests, please wait...
MKDIR temp
CD bin

ECHO Testing ffdec..
java -jar %PARENT%bin/ffdec/ffdec.jar --help
if %errorlevel% neq 0 GOTO FFDEC_FAIL

ECHO Testing ImageMagick...
convert %PARENT%\data\selftest.gif %PARENT%temp\selftest.png
if %errorlevel% neq 0 GOTO IM_FAIL

ECHO Testing Waifu2x...
waifu2x-converter.exe -i %PARENT%temp\selftest.png -o %PARENT%temp\selftest_2x.png -m noise_scale --noise_level 1
if %errorlevel% neq 0 GOTO Waifu2x_FAIL

GOTO PASS

:IM_FAIL
ECHO An error has occured while testing ImageMagick
ECHO Please view log_selftest.txt for detailed error message
GOTO ABORT

:FFDEC_FAIL
ECHO An error has occured while testing ffdec
ECHO Please view log_selftest.txt for detailed error message
GOTO ABORT

:WAIFU2X_FAIL
ECHO An error has occured while testing Waifu2x
ECHO Please view log_selftest.txt for detailed error message
GOTO ABORT

:PASS
ECHO ----------------
ECHO Self-test passed
ECHO ----------------
EXIT /B 0

:ABORT
ECHO ----------------
ECHO Self-test failed
ECHO ----------------
PAUSE
EXIT /B 1