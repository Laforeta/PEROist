SETLOCAL ENABLEDELAYEDEXPANSION ENABLEEXTENSIONS
SET ME=%~n0
SET PARENT=%~dp0

ECHO Running %ME%

ECHO ----------------->CON
ECHO Replacement Start>CON
ECHO ----------------->CON

:REPLACE_KANMUSU
CD "%PARENT%temp\kanmusu"
FOR /f "delims=" %%f IN ('DIR /b /a:-d "%PARENT%temp\kanmusu\*.swf"') DO (
	ECHO Replacing images in %%f...>CON
	ECHO Replacing images in %%f...
	java -jar "%PARENT%bin\ffdec\ffdec.jar" -replace "%%f" "%%f_images\2x%%f" 2 "%%f_images\2x1.png" 4 "%%f_images\2x3.png" 6 "%%f_images\2x5.png" 8 "%%f_images\2x7.png" 18 "%%f_images\2x17.png" 20 "%%f_images\2x19.png" 28 "%%f_images\2x27.png" 30 "%%f_images\2x29.png"
	java -jar "%PARENT%bin\ffdec\ffdec.jar" -removeCharacterwithdependencies "%%f_images\2x%%f" "%%fh" 1 3 5 7 17 19 27 29
)
REN *.swfh *.hack.swf

:REPLACE_ABYSSAL
CD "%PARENT%temp\abyssal"
FOR /f "delims=" %%f IN ('DIR /b /a:-d "%PARENT%temp\abyssal\*.swf"') DO (
	ECHO Replacing images in %%f...>CON
	ECHO Replacing images in %%f...
	java -jar "%PARENT%bin\ffdec\ffdec.jar" -replace "%%f" "%%f_images\2x%%f" 2 "%%f_images\2x1.png" 4 "%%f_images\2x3.png"
	java -jar "%PARENT%bin\ffdec\ffdec.jar" -removeCharacterwithdependencies "%%f_images\2x%%f" "%%fh" 1 3
)
REN *.swfh *.hack.swf

:REPLACE_KANMUSU_MOD
CD "%PARENT%temp\kanmusu_mod"
FOR /f "delims=" %%f IN ('DIR /b /a:-d "%PARENT%temp\kanmusu_mod\*.swf"') DO (
	ECHO Replacing images in %%f...>CON
	ECHO Replacing images in %%f...
	java -jar "%PARENT%bin\ffdec\ffdec.jar" -replace "%%f" "%%f_images\2x%%f" 2 "%%f_images\2x1.png" 4 "%%f_images\2x3.png" 6 "%%f_images\2x5.png" 8 "%%f_images\2x7.png" 18 "%%f_images\2x17.png" 20 "%%f_images\2x19.png" 28 "%%f_images\2x27.png" 30 "%%f_images\2x29.png"
	java -jar "%PARENT%bin\ffdec\ffdec.jar" -replace "%%f_images\2x%%f" "%%fh" 10 "%%f_images\2x9.png" 12 "%%f_images\2x11.png" 14 "%%f_images\2x13.png" 16 "%%f_images\2x15.png" 22 "%%f_images\2x21.png" 24 "%%f_images\2x23.png" 26 "%%f_images\2x25.png"
)
REN *.swfh *.swf

:REPLACE_ABYSSAL_MOD
CD "%PARENT%temp\abyssal_mod"
FOR /f "delims=" %%f IN ('DIR /b /a:-d "%PARENT%temp\abyssal_mod\*.swf"') DO (
	ECHO Replacing images in %%f...>CON
	ECHO Replacing images in %%f...
	java -jar "%PARENT%bin\ffdec\ffdec.jar" -replace "%%f" "%%fh" 2 "%%f_images\2x1.png" 4 "%%f_images\2x3.png"
)
REN *.swfh *.swf


ENDLOCAL
ECHO ---------------->CON
ECHO Replacement Done>CON
ECHO ---------------->CON
EXIT /B 0
