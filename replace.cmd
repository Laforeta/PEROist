SETLOCAL ENABLEDELAYEDEXPANSION ENABLEEXTENSIONS
SET ME=%~n0
SET PARENT=%~dp0

ECHO Running %ME%

ECHO ----------------->CON
ECHO Replacement Start>CON
ECHO ----------------->CON

REM Replace images in kanmusu sprites
CD "%PARENT%temp\kanmusu"
FOR /f "delims=" %%f IN ('DIR /b /s /a:-d "%PARENT%temp\kanmusu\*.swf"') DO (
	ECHO Replacing images in %%f...>CON
	ECHO Replacing images in %%f...
	java -jar "%PARENT%bin\ffdec\ffdec.jar" -replace "%%f" "%%fh" 2 "%%f_images\2x1.png" 4 "%%f_images\2x3.png" 6 "%%f_images\2x5.png" 8 "%%f_images\2x7.png" 18 "%%f_images\2x17.png" 20 "%%f_images\2x19.png" 28 "%%f_images\2x27.png" 30 "%%f_images\2x29.png"
)
REN *.swfh *.hack.swf

REM Replace images in abyssal sprites
CD "%PARENT%temp\abyssal"
FOR /f "delims=" %%f IN ('DIR /b /s /a:-d "%PARENT%temp\abyssal\*.swf"') DO (
	ECHO Replacing images in %%f...>CON
	ECHO Replacing images in %%f...
	java -jar "%PARENT%bin\ffdec\ffdec.jar" -replace "%%f" "%%fh" 2 "%%f_images\2x1.png" 4 "%%f_images\2x3.png"
)
REN *.swfh *.hack.swf

ENDLOCAL
ECHO ---------------->CON
ECHO Replacement Done>CON
ECHO ---------------->CON
EXIT /B 0