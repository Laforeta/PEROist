@ECHO OFF
SETLOCAL
SET ME=%~n0
SET PARENT=%~dp0

ECHO Running %ME%

ECHO Performing self-tests, please wait...>con
MKDIR temp
CD bin

ECHO Testing ffdec..>con
java -jar "%PARENT%bin\ffdec\ffdec.jar" --help > nul
if %errorlevel% neq 0 GOTO FFDEC_FAIL

ECHO Testing ImageMagick...>con
convert "%PARENT%\data\selftest.gif" "%PARENT%temp\selftest.png"
if %errorlevel% neq 0 GOTO IM_FAIL

ECHO Testing Waifu2x...>con
CD "%PARENT%temp"
IF %AMD64% neq 0 (
	SET WAIFU2X="%PARENT%bin\x64\waifu2x-converter_x64.exe" --model_dir "%PARENT%\bin\models_rgb"
) ELSE (
	SET WAIFU2X="%PARENT%bin\x86\waifu2x-converter_x86.exe" --model_dir "%PARENT%\bin\models_rgb"
)

%WAIFU2X% -i selftest.png -o selftest_2x.png -m noise_scale --noise_level 1
if %errorlevel% neq 0 (
	GOTO WAIFU2X_FAIL
) ELSE ( 
	GOTO PASS
)

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
ENDLOCAL
ECHO ---------------->con
ECHO Self-test passed>con
ECHO ---------------->con
CD %PARENT%
EXIT /B 0

:ABORT
ENDLOCAL
ECHO ---------------->con
ECHO Self-test failed>con
ECHO ---------------->con
CD %PARENT
PAUSE
EXIT /B 1