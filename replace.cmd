@ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION ENABLEEXTENSIONS
SET ME=%~n0
SET PARENT=%~dp0

REM Replace specific objects using ffdec
CD %PARENT%temp

REM Replace images in kanmusu sprites
FOR %%f IN (%PARENT%temp\*) DO (
	java -jar %PARENT%bin\ffdec\ffdec.jar -replace %%f %%fh 2 %%f_images\2x1.png 4 %%f_images\2x3.png 6 %%f_images\2x5.png 8 %%f_images\2x7.png 18 %%f_images\2x17.png 20 %%f_images\2x19.png 28 %%f_images\2x27.png 30 %%f_images\2x29.png
	ECHO Replaced images in %%f
)

REM Replace images in abyssal sprites
CD %PARENT%temp\abyssal
FOR %%f IN (%PARENT%temp\abyssal\*) DO (
	java -jar %PARENT%bin\ffdec\ffdec.jar -replace %%f %%fh 2 %%f_images\2x1.png 4 %%f_images\2x3.png
	ECHO Replaced images in %%f
)

REM Rename files to follow the .hack format
ECHO Finishing up...
CD %PARENT%temp
REN *.swfh *.hack.swf
CD %PARENT%temp\abyssal
REN *.swfh *.hack.swf

REM Do not rename here for now
GOTO ENDBREAK

REM Move files to correct location
mkdir %PARENT%kcs\resources\swf\ships\
FOR %%f IN (%PARENT%temp\*.hack.swf) DO COPY /y %%f %PARENT%kcs\resources\swf\ships\
FOR %%f IN (%PARENT%temp\abyssal\*.hack.swf) DO COPY /y %%f %PARENT%kcs\resources\swf\ships\

:ENDBREAK

ENDLOCAL
ECHO ################
ECHO REPLACEMENT DONE
ECHO ################
PAUSE