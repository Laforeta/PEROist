@ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION ENABLEEXTENSIONS
SET ME=%~n0
SET PARENT=%~dp0

ECHO -------------------------------
ECHO About to start image extraction
ECHO -------------------------------

REM Export kanmusu sprites
CD %PARENT%temp
FOR %%f IN (%PARENT%temp\*.swf) DO java -jar %PARENT%bin\ffdec\ffdec.jar -format image:png -export image "%%f_images" %%f

REM Export abyssal sprites
CD abyssal
FOR %%f IN (%PARENT%temp\abyssal\*.swf) DO java -jar %PARENT%bin\ffdec\ffdec.jar -format image:png -export image "%%f_images" %%f

ENDLOCAL

ECHO ---------------
ECHO EXTRACTION DONE
ECHO ---------------