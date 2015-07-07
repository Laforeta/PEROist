@ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION ENABLEEXTENSIONS
SET ME=%~n0
SET PARENT=%~dp0

REM FIX THE UNECESSARY ALPHA SPLITTING BEFORE RELEASE!!!!!!!!!!!!!!

REM Scale images (Kanmusu #1,3,5,7,17,19,27,29; Abyssal #1 and #3)
REM Waifu2x-cpp does not support RGBA mode png transparency (Kanmusu #17 and #19, abyssal #3)
REM Thus these images are split into alpha and RGB files to be processed separately and merged later
REM Is there a better algorithm to scale alpha channels?
REM Do these files also need some extra shapening? 


REM Establish working path - waifu2x-cpp have trouble reading the models otherwise
CD bin

REM Scale kanmusu sprite #1
FOR %%f IN (%PARENT%temp\*) DO (
	SETLOCAL ENABLEDELAYEDEXPANSION
	SET /a TARGET=1
	ECHO Generating Scaled Image !TARGET! in %%f
	waifu2x-converter -m noise_scale --noise_level 1 -i %%f_images\!TARGET!.png -o %%f_images\2x!TARGET!.png
	ECHO Scaling Complete for Image !TARGET! in %%f
	ENDLOCAL
)

REM Scale kanmusu sprite #3
FOR %%f IN (%PARENT%temp\*) DO (
	SETLOCAL ENABLEDELAYEDEXPANSION
	SET /a TARGET=3
	ECHO Generating Scaled Image !TARGET! in %%f
	waifu2x-converter -m noise_scale --noise_level 1 -i %%f_images\!TARGET!.png -o %%f_images\2x!TARGET!.png
	ECHO Scaling Complete for Image !TARGET! in %%f
	ENDLOCAL
)


REM Scale kanmusu sprite #5
FOR %%f IN (%PARENT%temp\*) DO (
	SETLOCAL ENABLEDELAYEDEXPANSION
	SET /a TARGET=5
	ECHO Generating Scaled Image !TARGET! in %%f
	waifu2x-converter -m noise_scale --noise_level 1 -i %%f_images\!TARGET!.png -o %%f_images\2x!TARGET!.png
	ECHO Scaling Complete for Image !TARGET! in %%f
	ENDLOCAL
)


REM Scale kanmusu sprite #7
FOR %%f IN (%PARENT%temp\*) DO (
	SETLOCAL ENABLEDELAYEDEXPANSION
	SET /a TARGET=7
	ECHO Generating Scaled Image !TARGET! in %%f
	waifu2x-converter -m noise_scale --noise_level 1 -i %%f_images\!TARGET!.png -o %%f_images\2x!TARGET!.png
	ECHO Scaling Complete for Image !TARGET! in %%f
	ENDLOCAL
)


REM Scale kanmusu sprite #17 (Main Sprite w/alpha)
FOR %%f IN (%PARENT%temp\*) DO (
	SETLOCAL ENABLEDELAYEDEXPANSION
	SET /a TARGET=17
	ECHO Pre-processing Image !TARGET! in %%f...
	convert %%f_images\!TARGET!.png -channel alpha -separate %%f_images\!TARGET!_alpha.png
	convert %%f_images\!TARGET!.png -channel alpha -threshold 100%% +channel %%f_images\!TARGET!_rgb.png
	ECHO Processing RGB of Image !TARGET! in %%f...
	waifu2x-converter -m noise_scale --noise_level 1 -i %%f_images\!TARGET!_rgb.png -o %%f_images\2x!TARGET!_rgb.png
	ECHO Processing Alpha of Image !TARGET! in %%f...
	waifu2x-converter -m scale -i %%f_images\!TARGET!_alpha.png -o %%f_images\2x!TARGET!_alpha.png
	ECHO Generating Scaled Image !TARGET! in %%f
	convert %%f_images\2x!TARGET!_rgb.png %%f_images\2x!TARGET!_alpha.png -alpha off -compose CopyOpacity -composite PNG32:%%f_images\2x!TARGET!.png
	ECHO Scaling Complete for Image !TARGET! in %%f
	ENDLOCAL
)

REM Scale kanmusu sprite #19 (Main Sprite - Damaged w/alpha)
FOR %%f IN (%PARENT%temp\*) DO (
	SETLOCAL ENABLEDELAYEDEXPANSION
	SET /a TARGET=19
	ECHO Pre-processing Image !TARGET! in %%f...
	convert %%f_images\!TARGET!.png -channel alpha -separate %%f_images\!TARGET!_alpha.png
	convert %%f_images\!TARGET!.png -channel alpha -threshold 100%% +channel %%f_images\!TARGET!_rgb.png
	ECHO Processing RGB of Image !TARGET! in %%f...
	waifu2x-converter -m noise_scale --noise_level 1 -i %%f_images\!TARGET!_rgb.png -o %%f_images\2x!TARGET!_rgb.png
	ECHO Processing Alpha of Image !TARGET! in %%f...
	waifu2x-converter -m scale -i %%f_images\!TARGET!_alpha.png -o %%f_images\2x!TARGET!_alpha.png
	ECHO Generating Scaled Image !TARGET! in %%f
	convert %%f_images\2x!TARGET!_rgb.png %%f_images\2x!TARGET!_alpha.png -alpha off -compose CopyOpacity -composite PNG32:%%f_images\2x!TARGET!.png
	ECHO Scaling Complete for Image !TARGET! in %%f
	ENDLOCAL
)

REM Scale kanmusu sprite #27 (Supply Banner w/alpha)
FOR %%f IN (%PARENT%temp\*) DO (
	SETLOCAL ENABLEDELAYEDEXPANSION
	SET /a TARGET=27
	ECHO Pre-processing Image !TARGET! in %%f...
	convert %%f_images\!TARGET!.png -channel alpha -separate %%f_images\!TARGET!_alpha.png
	convert %%f_images\!TARGET!.png -channel alpha -threshold 100%% +channel %%f_images\!TARGET!_rgb.png
	ECHO Processing RGB of Image !TARGET! in %%f...
	waifu2x-converter -m noise_scale --noise_level 1 -i %%f_images\!TARGET!_rgb.png -o %%f_images\2x!TARGET!_rgb.png
	ECHO Processing Alpha of Image !TARGET! in %%f...
	waifu2x-converter -m scale -i %%f_images\!TARGET!_alpha.png -o %%f_images\2x!TARGET!_alpha.png
	ECHO Generating Scaled Image !TARGET! in %%f
	convert %%f_images\2x!TARGET!_rgb.png %%f_images\2x!TARGET!_alpha.png -alpha off -compose CopyOpacity -composite PNG32:%%f_images\2x!TARGET!.png
	ECHO Scaling Complete for Image !TARGET! in %%f
	ENDLOCAL
)

REM Scale kanmusu sprite #29 (Supply Banner - Damaged w/alpha)
FOR %%f IN (%PARENT%temp\*) DO (
	SETLOCAL ENABLEDELAYEDEXPANSION
	SET /a TARGET=29
	ECHO Pre-processing Image !TARGET! in %%f...
	convert %%f_images\!TARGET!.png -channel alpha -separate %%f_images\!TARGET!_alpha.png
	convert %%f_images\!TARGET!.png -channel alpha -threshold 100%% +channel %%f_images\!TARGET!_rgb.png
	ECHO Processing RGB of Image !TARGET! in %%f...
	waifu2x-converter -m noise_scale --noise_level 1 -i %%f_images\!TARGET!_rgb.png -o %%f_images\2x!TARGET!_rgb.png
	ECHO Processing Alpha of Image !TARGET! in %%f...
	waifu2x-converter -m scale -i %%f_images\!TARGET!_alpha.png -o %%f_images\2x!TARGET!_alpha.png
	ECHO Generating Scaled Image !TARGET! in %%f
	convert %%f_images\2x!TARGET!_rgb.png %%f_images\2x!TARGET!_alpha.png -alpha off -compose CopyOpacity -composite PNG32:%%f_images\2x!TARGET!.png
	ECHO Scaling Complete for Image !TARGET! in %%f
	ENDLOCAL
)

REM Scale Abyssal sprite #1 (Banner)
FOR %%f IN (%PARENT%temp\abyssal\*) DO (
	SETLOCAL ENABLEDELAYEDEXPANSION
	SET /a TARGET=1
	ECHO Generating Scaled Image !TARGET! in %%f
	waifu2x-converter -m noise_scale --noise_level 1 -i %%f_images\!TARGET!.png -o %%f_images\2x!TARGET!.png
	ECHO Scaling Complete for Image !TARGET! in %%f
	ENDLOCAL
)

REM Scale kanmusu sprite #29 (Main Sprite w/ alpha)
FOR %%f IN (%PARENT%temp\abyssal\*) DO (
	SETLOCAL ENABLEDELAYEDEXPANSION
	SET /a TARGET=3
	ECHO Pre-processing Image !TARGET! in %%f...
	convert %%f_images\!TARGET!.png -channel alpha -separate %%f_images\!TARGET!_alpha.png
	convert %%f_images\!TARGET!.png -channel alpha -threshold 100%% +channel %%f_images\!TARGET!_rgb.png
	ECHO Processing RGB of Image !TARGET! in %%f...
	waifu2x-converter -m noise_scale --noise_level 1 -i %%f_images\!TARGET!_rgb.png -o %%f_images\2x!TARGET!_rgb.png
	ECHO Processing Alpha of Image !TARGET! in %%f...
	waifu2x-converter -m scale -i %%f_images\!TARGET!_alpha.png -o %%f_images\2x!TARGET!_alpha.png
	ECHO Generating Scaled Image !TARGET! in %%f
	convert %%f_images\2x!TARGET!_rgb.png %%f_images\2x!TARGET!_alpha.png -alpha off -compose CopyOpacity -composite PNG32:%%f_images\2x!TARGET!.png
	ECHO Scaling Complete for Image !TARGET! in %%f
	ENDLOCAL
)

ENDLOCAL
Echo "ALL DONE!"