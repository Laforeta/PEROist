REM @ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION ENABLEEXTENSIONS
SET ME=%~n0
SET PARENT=%~dp0

ECHO Running %ME%

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
IF NOT DEFINED JPEG_QUALITY SET /a JPEG_QUALITY=92

IF NOT DEFINED AMD64 SET /a AMD64=1

IF %AMD64% neq 0 (
	SET WAIFU2X="%PARENT%bin\x64\waifu2x-converter_x64.exe"
) ELSE (
	SET WAIFU2X="%PARENT%bin\x86\waifu2x-converter_x86.exe"
)

REM Disable GPU by setting the GPU_FLAG value to 0
REM SET GPU_FLAG=0
IF NOT DEFINED GPU_FLAG SET /a GPU_FLAG=1

IF %GPU_FLAG% neq 0 (
	SET MODEL=--model_dir "%PARENT%\bin\models_rgb"
) ELSE ( 
	SET MODEL=--model_dir "%PARENT%\bin\models_rgb" --disable-gpu
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
	SET /a TARGET=9
	CALL :SCALE_ALPHA
	SET /a TARGET=11
	CALL :SCALE_ALPHA
	SET /a TARGET=13
	CALL :SCALE_ALPHA
	SET /a TARGET=15
	CALL :SCALE_ALPHA
	SET /a TARGET=17
	CALL :SCALE_ALPHA
	SET /a TARGET=19
	CALL :SCALE_ALPHA
	SET /a TARGET=21
	CALL :SCALE_ALPHA
	SET /a TARGET=23
	CALL :SCALE_ALPHA
	SET /a TARGET=25
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

REM Merged scale routines for KANMUSU_MOD
FOR /f "delims=" %%g IN ('DIR /b /s /a:-d "%PARENT%temp\kanmusu_mod\*.swf"') DO (
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
	SET /a TARGET=9
	CALL :SCALE_ALPHA
	SET /a TARGET=11
	CALL :SCALE_ALPHA
	SET /a TARGET=13
	CALL :SCALE_ALPHA
	SET /a TARGET=15
	CALL :SCALE_ALPHA
	SET /a TARGET=17
	CALL :SCALE_ALPHA
	SET /a TARGET=19
	CALL :SCALE_ALPHA
	SET /a TARGET=21
	CALL :SCALE_ALPHA
	SET /a TARGET=23
	CALL :SCALE_ALPHA
	SET /a TARGET=25
	CALL :SCALE_ALPHA
	SET /a TARGET=27
	CALL :SCALE_ALPHA
	SET /a TARGET=29
	CALL :SCALE_ALPHA
	ENDLOCAL
)

REM Merged scale routines for ABYSSAL_MOD
FOR /f "delims=" %%g IN ('DIR /b /s /a:-d "%PARENT%temp\abyssal_mod\*.swf"') DO (
	SETLOCAL ENABLEDELAYEDEXPANSION
	SET "FILENAME=%%g"
	CD "%%g_images"
	SET /a TARGET=1
	CALL :SCALE
	SET /a TARGET=3
	CALL :SCALE_ALPHA
	ENDLOCAL
)

ENDLOCAL
ECHO ------------>CON
ECHO Scaling Done>CON
ECHO ------------>CON
EXIT /B 0

:SCALE
ECHO Generating Scaled Image %TARGET% in %FILENAME%>CON
ECHO Generating Scaled Image %TARGET% in %FILENAME%
%WAIFU2X% %MODEL% -m noise_scale --noise_level 1 -i %TARGET%.png -o 2x%TARGET%.png
ECHO Converting Scaled RGB for Image %TARGET% in %FILENAME% to JPEG bitmap...
%IM% -quality %JPEG_QUALITY% 2x%TARGET%.png 2x%TARGET%.jpg
GOTO:EOF

:SCALE_ALPHA
ECHO Generating Scaled Image %TARGET% in %FILENAME%>CON
ECHO Processing Alpha of Image %TARGET% in %FILENAME%...
%IM% %TARGET%.png -channel alpha -separate %TARGET%_alpha.png
ECHO Processing RGB of Image %TARGET% in %FILENAME%...
%IM% %TARGET%.png -channel alpha -threshold 100%% +channel %TARGET%_rgb.png
ECHO Generating Scaled RGB for Image %TARGET% in %FILENAME%...
%WAIFU2X% %MODEL% -m noise_scale --noise_level 1 -i %TARGET%_rgb.png -o 2x%TARGET%_rgb.png
ECHO Converting Scaled RGB for Image %TARGET% in %FILENAME% to JPEG bitmap...
%IM% -quality %JPEG_QUALITY% 2x%TARGET%_rgb.png 2x%TARGET%.jpg
ECHO Generating Scaled alpha for Image %TARGET% in %FILENAME%...
%WAIFU2X% %MODEL% -m scale -i %TARGET%_alpha.png -o 2x%TARGET%_alpha.png
GOTO:EOF

:SHARPEN
ECHO Adding some finishing touches to %TARGET% in %FILENAME%>CON
GOTO:EOF
