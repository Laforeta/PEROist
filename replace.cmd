SETLOCAL ENABLEDELAYEDEXPANSION ENABLEEXTENSIONS
SET ME=%~n0
SET PARENT=%~dp0

ECHO ----------------->CON
ECHO Replacement Start>CON
ECHO ----------------->CON

REM Replace specific objects using ffdec
CD %PARENT%temp

REM Replace images in kanmusu sprites
FOR %%f IN (%PARENT%temp\*) DO (
	ECHO Replacing images in %%f...>CON
	ECHO Replacing images in %%f...
	java -jar %PARENT%bin\ffdec\ffdec.jar -replace %%f %%fh 2 %%f_images\2x1.png 4 %%f_images\2x3.png 6 %%f_images\2x5.png 8 %%f_images\2x7.png 18 %%f_images\2x17.png 20 %%f_images\2x19.png 28 %%f_images\2x27.png 30 %%f_images\2x29.png
)

REM Replace images in abyssal sprites
CD %PARENT%temp\abyssal
FOR %%f IN (%PARENT%temp\abyssal\*) DO (
	ECHO Replacing images in %%f...>CON
	ECHO Replacing images in %%f...
	java -jar %PARENT%bin\ffdec\ffdec.jar -replace %%f %%fh 2 %%f_images\2x1.png 4 %%f_images\2x3.png
)

REM Rename files to follow the .hack format
ECHO Renaming output files...>CON
ECHO Renaming output files...
CD %PARENT%temp
REN *.swfh *.hack.swf
CD %PARENT%temp\abyssal
REN *.swfh *.hack.swf

REM Do not rename here for now, jump to end
GOTO ENDBREAK

REM Move files to correct location
mkdir %PARENT%kcs\resources\swf\ships\
FOR %%f IN (%PARENT%temp\*.hack.swf) DO COPY /y %%f %PARENT%kcs\resources\swf\ships\
FOR %%f IN (%PARENT%temp\abyssal\*.hack.swf) DO COPY /y %%f %PARENT%kcs\resources\swf\ships\

:ENDBREAK

ENDLOCAL
ECHO ---------------->CON
ECHO Replacement Done>CON
ECHO ---------------->CON