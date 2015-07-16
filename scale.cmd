REM @ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION ENABLEEXTENSIONS
SET ME=%~n0
SET PARENT=%~dp0

REM Scale images (Kanmusu #1,3,5,7,17,19,27,29; Abyssal #1 and #3)
REM Waifu2x-cpp does not support RGBA mode png transparency (Kanmusu #17 and #19, abyssal #3)
REM Thus these images are split into alpha and RGB files to be processed separately and merged later
REM Is there a better algorithm to scale alpha channels?
REM Do these files also need some extra shapening? 

ECHO ------------->CON
ECHO Scaling Start>CON
ECHO ------------->CON

REM These processes depend on being inside the right working directory to run
REM Binaries must be called as variables using their full path
SET IM="%PARENT%bin\convert.exe"
SET /a GPU_FLAG=0
IF %AMD64% neq 0 (
	SET WAIFU2X="%PARENT%bin\x64\waifu2x-converter_x64.exe"
) ELSE (
	SET WAIFU2X="%PARENT%bin\x86\waifu2x-converter_x86.exe"
)

REM YCbCr model seems to be marginally faster than RGB model when running on CPU (?)
IF %GPU_FLAG% neq 0 (
	SET MODEL=--model_dir "%PARENT%\bin\models_rgb"
) ELSE ( 
	SET MODEL=--model_dir "%PARENT%\bin\models_ycbcr" --disable-gpu
)

REM Merged scale routines for KANMUSU
FOR /f "delims=" %%g IN ('DIR /b /s /a:-d "%PARENT%temp\kanmusu\*.swf"') DO (
	SETLOCAL ENABLEDELAYEDEXPANSION
	SET "FILENAME=%%g"
	CD "%%g_images"
	SET /a TARGET=1
	CALL :SCALE
	SET /a TARGET=3
	CALL :SCALE
	SET /a TARGET=5
	CALL :SCALE
	SET /a TARGET=7
	CALL :SCALE
	SET /a TARGET=17
	CALL :SCALE_ALPHA
	SET /a TARGET=19
	CALL :SCALE_ALPHA
	SET /a TARGET=27
	CALL :SCALE_ALPHA
	SET /a TARGET=29
	CALL :SCALE_ALPHA
	ENDLOCAL
)

REM Merged scale routines for ABYSSAL
FOR /f "delims=" %%g IN ('DIR /b /s /a:-d "%PARENT%temp\abyssal\*.swf"') DO (
	SETLOCAL ENABLEDELAYEDEXPANSION
	SET "FILENAME=%%g"
	CD "%%g_images"
	SET /a TARGET=1
	CALL :SCALE
	SET /a TARGET=3
	CALL :SCALE_ALPHA
	ENDLOCAL
)

REM Add a loop with trim for premodded files when it's done

ENDLOCAL
ECHO ------------>CON
ECHO Scaling Done>CON
ECHO ------------>CON
EXIT /B 0

REM Is this still needed? 
ECHO -------------->CON
ECHO Scaling FAILED>CON
ECHO -------------->CON
EXIT /B 1

:SCALE
ECHO Generating Scaled Image %TARGET% in %FILENAME%>CON
ECHO Generating Scaled Image %TARGET% in %FILENAME%
%WAIFU2X% %MODEL% -m noise_scale --noise_level 1 -i %TARGET%.png -o 2x%TARGET%.png
GOTO:EOF

:SCALE_ALPHA
ECHO Generating Scaled Image %TARGET% in %FILENAME%>CON
ECHO Processing Alpha of Image %TARGET% in %FILENAME%...
%IM% %TARGET%.png -channel alpha -separate %TARGET%_alpha.png
ECHO Processing RGB of Image %TARGET% in %FILENAME%...
%IM% %TARGET%.png -channel alpha -threshold 100%% +channel %TARGET%_rgb.png
ECHO Generating Scaled RGB for Image %TARGET% in %FILENAME%...
%WAIFU2X% %MODEL% -m noise_scale --noise_level 1 -i %TARGET%_rgb.png -o 2x%TARGET%_rgb.png
ECHO Generating Scaled alpha for Image %TARGET% in %FILENAME%...
%WAIFU2X% %MODEL% -m scale -i %TARGET%_alpha.png -o 2x%TARGET%_alpha.png
ECHO Combining RGB with Alpha for Image %TARGET% in %FILENAME%...
%IM% 2x%TARGET%_rgb.png 2x%TARGET%_alpha.png -alpha off -compose CopyOpacity -composite PNG32:2x%TARGET%.png
GOTO:EOF

:SHARPEN
ECHO Adding some finishing touches to %TARGET% in %FILENAME%>CON
GOTO:EOF

:TRIM
ECHO Removing whitespace in the border
