@ECHO OFF
SETLOCAL
SET ME=%~n0
SET PARENT=%~dp0

ECHO ---------------->CON
ECHO Extraction Start>CON
ECHO ---------------->CON

REM Export kanmusu sprites
CD "%PARENT%temp\kanmusu"
FOR %%f IN (*.swf) DO (
	ECHO Extracting images in %%f>CON
	ECHO Extracting images in %%f
	java -jar "%PARENT%bin\ffdec\ffdec.jar" -format image:png -export image "%%f_images" "%%f"
)

REM Export abyssal sprites
CD "%PARENT%temp\abyssal"
FOR %%f IN (*.swf) DO (
	ECHO Extracting images in %%f>CON
	ECHO Extracting images in %%f
	java -jar "%PARENT%bin\ffdec\ffdec.jar" -format image:png -export image "%%f_images" "%%f"
)

ENDLOCAL
ECHO --------------->CON
ECHO Extraction Done>CON
ECHO --------------->CON

EXIT /B 0