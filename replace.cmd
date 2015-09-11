SETLOCAL ENABLEDELAYEDEXPANSION ENABLEEXTENSIONS
SET ME=%~n0
SET PARENT=%~dp0

ECHO Running %ME%

SET QUANT="%PARENT%bin\pngquant.exe""

ECHO ----------------->CON
ECHO Replacement Start>CON
ECHO ----------------->CON

:REPLACE_KANMUSU
CD "%PARENT%temp\kanmusu"
FOR /f "delims=" %%f IN ('DIR /b /a:-d "%PARENT%temp\kanmusu\*.swf"') DO (
	ECHO Replacing images in %%f...>CON
	ECHO Replacing images in %%f...
	java -jar "%PARENT%bin\ffdec\ffdec.jar" -replace "%%f" "%%f_images\lite_%%f" 2 "%%f_images\2x1.jpg" jpeg3 4 "%%f_images\2x3.jpg" jpeg3 6 "%%f_images\2x5.jpg" jpeg3 8 "%%f_images\2x7.jpg" jpeg3 18 "%%f_images\2x17.jpg" jpeg3 20 "%%f_images\2x19.jpg" jpeg3 28 "%%f_images\2x27.jpg" jpeg3 30 "%%f_images\2x29.jpg" jpeg3
	java -jar "%PARENT%bin\ffdec\ffdec.jar" -replaceAlpha "%%f_images\lite_%%f" "%%f_images\lite_alpha_%%f" 35 "%%f_images\2x17.bin" 36 "%%f_images\2x19.bin" 37 "%%f_images\2x27.bin" 38 "%%f_images\2x29.bin"
	java -jar "%PARENT%bin\ffdec\ffdec.jar" -replace "%%f_images\lite_alpha_%%f" "%%f_images\full_lite_alpha_%%f" 10 "%%f_images\2x9.jpg" jpeg3 12 "%%f_images\2x11.jpg" jpeg3 14 "%%f_images\2x13.jpg" jpeg3 16 "%%f_images\2x15.jpg" jpeg3 22 "%%f_images\2x21.jpg" jpeg3 24 "%%f_images\2x23.jpg" jpeg3 26 "%%f_images\2x25.png" lossless2 
	java -jar "%PARENT%bin\ffdec\ffdec.jar" -replaceAlpha "%%f_images\full_lite_alpha_%%f" "%%f_images\full_alpha_lite_alpha_%%f" 39 "%%f_images\2x9.bin" 40 "%%f_images\2x11.bin" 41 "%%f_images\2x13.bin" 42 "%%f_images\2x15.bin" 43 "%%f_images\2x21.bin" 44 "%%f_images\2x23.bin"
	java -jar "%PARENT%bin\ffdec\ffdec.jar" -removeCharacterwithdependencies "%%f_images\full_alpha_lite_alpha_%%f" "%%f_images\unregularised_%%f" 1 3 5 7 9 11 13 15 17 19 21 23 25 27 29
	java -jar "%PARENT%bin\ffdec\ffdec.jar" -replaceCharacterId "%%f_images\unregularised_%%f" "%%fh" 31,1,32,3,33,5,34,7,39,9,40,11,41,13,42,15,35,17,36,19,43,21,44,23,45,25,37,27,38,29
)
REN *.swfh *.hack.swf

:REPLACE_ABYSSAL
CD "%PARENT%temp\abyssal"
FOR /f "delims=" %%f IN ('DIR /b /a:-d "%PARENT%temp\abyssal\*.swf"') DO (
	ECHO Replacing images in %%f...>CON
	ECHO Replacing images in %%f...
	java -jar "%PARENT%bin\ffdec\ffdec.jar" -replace "%%f" "%%f_images\2x%%f" 2 "%%f_images\2x1.jpg" jpeg3 4 "%%f_images\2x3.jpg" jpeg3
	java -jar "%PARENT%bin\ffdec\ffdec.jar" -replaceAlpha "%%f_images\2x%%f" "%%f_images\debloat_%%f" 6 "%%f_images\2x3.bin" 
	java -jar "%PARENT%bin\ffdec\ffdec.jar" -removeCharacterwithdependencies "%%f_images\debloat_%%f" "%%f_images\unregularised_%%f" 1 3
	java -jar "%PARENT%bin\ffdec\ffdec.jar" -replaceCharacterId "%%f_images\unregularised_%%f" "%%fh" 5,1,6,3
)
REN *.swfh *.hack.swf

:REPLACE_KANMUSU_MOD
CD "%PARENT%temp\kanmusu_mod"
FOR /f "delims=" %%f IN ('DIR /b /a:-d "%PARENT%temp\kanmusu_mod\*.swf"') DO (
	ECHO Replacing images in %%f...>CON
	ECHO Replacing images in %%f...
	java -jar "%PARENT%bin\ffdec\ffdec.jar" -replace "%%f" "%%f_images\lite_%%f" 2 "%%f_images\2x1.jpg" jpeg3 4 "%%f_images\2x3.jpg" jpeg3 6 "%%f_images\2x5.jpg" jpeg3 8 "%%f_images\2x7.jpg" jpeg3 18 "%%f_images\2x17.jpg" jpeg3 20 "%%f_images\2x19.jpg" jpeg3 28 "%%f_images\2x27.jpg" jpeg3 30 "%%f_images\2x29.jpg" jpeg3
	java -jar "%PARENT%bin\ffdec\ffdec.jar" -replaceAlpha "%%f_images\lite_%%f" "%%f_images\lite_alpha_%%f" 35 "%%f_images\2x17.bin" 36 "%%f_images\2x19.bin" 37 "%%f_images\2x27.bin" 38 "%%f_images\2x29.bin"
	java -jar "%PARENT%bin\ffdec\ffdec.jar" -replace "%%f_images\lite_alpha_%%f" "%%f_images\full_lite_alpha_%%f" 10 "%%f_images\2x9.jpg" jpeg3 12 "%%f_images\2x11.jpg" jpeg3 14 "%%f_images\2x13.jpg" jpeg3 16 "%%f_images\2x15.jpg" jpeg3 22 "%%f_images\2x21.jpg" jpeg3 24 "%%f_images\2x23.jpg" jpeg3 26 "%%f_images\2x25.png" lossless2 
	java -jar "%PARENT%bin\ffdec\ffdec.jar" -replaceAlpha "%%f_images\full_lite_alpha_%%f" "%%f_images\full_alpha_lite_alpha_%%f" 39 "%%f_images\2x9.bin" 40 "%%f_images\2x11.bin" 41 "%%f_images\2x13.bin" 42 "%%f_images\2x15.bin" 43 "%%f_images\2x21.bin" 44 "%%f_images\2x23.bin"
	java -jar "%PARENT%bin\ffdec\ffdec.jar" -removeCharacterwithdependencies "%%f_images\full_alpha_lite_alpha_%%f" "%%f_images\unregularised_%%f" 1 3 5 7 9 11 13 15 17 19 21 23 25 27 29
	java -jar "%PARENT%bin\ffdec\ffdec.jar" -replaceCharacterId "%%f_images\unregularised_%%f" "%%fh" 31,1,32,3,33,5,34,7,39,9,40,11,41,13,42,15,35,17,36,19,43,21,44,23,45,25,37,27,38,29
)
REN *.swfh *.out

:REPLACE_ABYSSAL_MOD
CD "%PARENT%temp\abyssal_mod"
FOR /f "delims=" %%f IN ('DIR /b /a:-d "%PARENT%temp\abyssal_mod\*.swf"') DO (
	ECHO Replacing images in %%f...>CON
	ECHO Replacing images in %%f...
	java -jar "%PARENT%bin\ffdec\ffdec.jar" -replace "%%f" "%%f_images\2x%%f" 2 "%%f_images\2x1.jpg" jpeg3 4 "%%f_images\2x3.jpg" jpeg3
	java -jar "%PARENT%bin\ffdec\ffdec.jar" -replaceAlpha "%%f_images\2x%%f" "%%f_images\debloat_%%f" 6 "%%f_images\2x3.bin" 
	java -jar "%PARENT%bin\ffdec\ffdec.jar" -removeCharacterwithdependencies "%%f_images\debloat_%%f" "%%f_images\unregularised_%%f" 1 3
	java -jar "%PARENT%bin\ffdec\ffdec.jar" -replaceCharacterId "%%f_images\unregularised_%%f" "%%fh" 5,1,6,3
)
REN *.swfh *.out

:REPLACE_SPECIAL_SHAPES
CD "%PARENT%temp\special"
FOR /f "delims=" %%f IN ('DIR /b /a:-d "%PARENT%temp\special\*.swf"') DO (
	ECHO Replacing images in %%f...>CON
	ECHO Replacing images in %%f...
	SET FILENAME=%%f
	FOR /f "delims=." %%g IN ('TYPE "!FILENAME!_images\!Filename!_images.txt"') DO (
		SET /a TARGET=%%g
		ECHO Compressing Image #!TARGET!...
		%QUANT% --speed 1 2x%%g.png
		ECHO Inserting Image #!TARGET!...
		java -jar "%PARENT%bin\ffdec\ffdec.jar" -replace !FILENAME! !FILENAME! !TARGET! "!FILENAME!_images\2x!TARGET!.png"
	)
)
	

ENDLOCAL
ECHO ---------------->CON
ECHO Replacement Done>CON
ECHO ---------------->CON
EXIT /B 0
