SETLOCAL ENABLEDELAYEDEXPANSION ENABLEEXTENSIONS
SET ME=%~n0
SET PARENT=%~dp0

ECHO ----------------->CON
ECHO Replacement Start>CON
ECHO ----------------->CON

REM Replace images in kanmusu sprites
CD "%PARENT%temp"
FOR /f "delims=" %%f IN ('DIR /b /s /a:-d "%PARENT%temp\*.swf"') DO (
	IF NOT EXIST *.swf GOTO ABYSSAL
	ECHO Replacing images in %%f...>CON
	ECHO Replacing images in %%f...
	java -jar "%PARENT%bin\ffdec\ffdec.jar" -replace "%%f" "%%fh" 2 "%%f_images\2x1.png" 4 "%%f_images\2x3.png" 6 "%%f_images\2x5.png" 8 "%%f_images\2x7.png" 18 "%%f_images\2x17.png" 20 "%%f_images\2x19.png" 28 "%%f_images\2x27.png" 30 "%%f_images\2x29.png"
)
REN *.swfh *.hack.swf

:abyssal
REM Replace images in abyssal sprites
CD "%PARENT%temp\abyssal"
FOR /f "delims=" %%f IN ('DIR /b /s /a:-d "%PARENT%temp\abyssal\*.swf"') DO (
	ECHO Replacing images in %%f...>CON
	ECHO Replacing images in %%f...
	java -jar "%PARENT%bin\ffdec\ffdec.jar" -replace "%%f" "%%fh" 2 "%%f_images\2x1.png" 4 "%%f_images\2x3.png"
)
REN *.swfh *.hack.swf

REM Rename files to follow the .hack format
ECHO Renaming output files...>CON
ECHO Renaming output files...
CD "%PARENT%temp"

CD "%PARENT%temp\abyssal"


REM Do not rename here for now, jump to end
GOTO ENDBREAK

REM Move files to correct location
REM mkdir %PARENT%kcs\resources\swf\ships\
REM FOR %%f IN (%PARENT%temp\*.hack.swf) DO COPY /y %%f %PARENT%kcs\resources\swf\ships\
REM FOR %%f IN (%PARENT%temp\abyssal\*.hack.swf) DO COPY /y %%f %PARENT%kcs\resources\swf\ships\

:ENDBREAK

ENDLOCAL
ECHO ---------------->CON
ECHO Replacement Done>CON
ECHO ---------------->CON