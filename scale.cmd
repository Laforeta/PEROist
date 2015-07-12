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

REM Establish working path - waifu2x-cpp seems to have trouble reading the models otherwise
CD "%PARENT%\bin"

REM Merged scale routines for KANMUSU
FOR %%f IN (%PARENT%temp\*) DO (
	SETLOCAL ENABLEDELAYEDEXPANSION
	SET /a TARGET=1
	CALL SCALE
	SET /a TARGET=3
	CALL SCALE
	SET /a TARGET=5
	CALL SCALE
	SET /a TARGET=7
	CALL SCALE
	SET /a TARGET=17
	CALL SCALE_ALPHA
	SET /a TARGET=19
	CALL SCALE_ALPHA
	SET /a TARGET=27
	CALL SCALE_ALPHA
	SET /a TARGET=29
	CALL SCALE_ALPHA
	ENDLOCAL
)

REM Merged scale routines for ABYSSAL
FOR %%f IN (%PARENT%temp\abyssal\*) DO (
	SETLOCAL ENABLEDELAYEDEXPANSION
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

ECHO -------------->CON
ECHO Scaling FAILED>CON
ECHO -------------->CON
EXIT /B 1


:SCALE
ECHO Generating Scaled Image !TARGET! in %%f>CON
ECHO Generating Scaled Image !TARGET! in %%f
waifu2x-converter -m noise_scale --noise_level 1 -i %%f_images\!TARGET!.png -o %%f_images\2x!TARGET!.png
if %errorlevel% neq 0 ECHO Scaling failed for %%f>2
GOTO:EOF

:SCALE_ALPHA
ECHO 
ECHO Processing Alpha of Image !TARGET! in %%f...
convert %%f_images\!TARGET!.png -channel alpha -separate %%f_images\!TARGET!_alpha.png
ECHO Processing RGB of Image !TARGET! in %%f...
convert %%f_images\!TARGET!.png -channel alpha -threshold 100%% +channel %%f_images\!TARGET!_rgb.png
ECHO Generating Scaled Image !TARGET! in %%f>CON
ECHO Generating Scaled RGB for Image !TARGET! in %%f
waifu2x-converter -m noise_scale --noise_level 1 -i %%f_images\!TARGET!_rgb.png -o %%f_images\2x!TARGET!_rgb.png
ECHO Generating Scaled alpha for Image !TARGET! in %%f
waifu2x-converter -m scale -i %%f_images\!TARGET!_alpha.png -o %%f_images\2x!TARGET!_alpha.png
ECHO Combine RGB with Alpha
convert %%f_images\2x!TARGET!_rgb.png %%f_images\2x!TARGET!_alpha.png -alpha off -compose CopyOpacity -composite PNG32:%%f_images\2x!TARGET!.png
GOTO:EOF