@ECHO OFF
SETLOCAL
SET ME=%~n0
SET PARENT=%~dp0

ECHO Running %ME%

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

REM Export abyssal mod pack
CD "%PARENT%temp\abyssal_mod"
FOR %%f IN (*.swf) DO (
	ECHO Extracting images in %%f>CON
	ECHO Extracting images in %%f
	java -jar "%PARENT%bin\ffdec\ffdec.jar" -format image:png -export image "%%f_images" "%%f"
	IF NOT EXIST %%f_images\17.png ECHO Primary extraction method failed, switching to backup method && SET "EXCEPTION_NAME=%%f"&& CALL :FORCE_EXTRACT
	IF NOT EXIST %%f_images\17.png ECHO Backup extraction method failed for %%f. Skipping this file...
)

REM Export kanmusu mod pack
CD "%PARENT%temp\kanmusu_mod"
FOR %%f IN (*.swf) DO (
	ECHO Extracting images in %%f>CON
	ECHO Extracting images in %%f
	java -jar "%PARENT%bin\ffdec\ffdec.jar" -format image:png -export image "%%f_images" "%%f"
	IF NOT EXIST %%f_images\3.png ECHO Primary extraction method failed for %%f, switching to laternative... && SET "EXCEPTION_NAME=%%f"&& CALL :FORCE_EXTRACT
	IF NOT EXIST %%f_images\3.png ECHO Backup extraction method failed for %%f. Skipping this file...
)

ENDLOCAL
:EXTRACT_SUCCESS
ENDLOCAL
ECHO --------------->CON
ECHO Extraction Done>CON
ECHO --------------->CON
EXIT /B 0

:EXTRACT_FAIL
ENDLOCAL
ECHO ----------------->CON
ECHO Extraction Failed>CON
ECHO ----------------->CON
EXIT /B 1

:FORCE_EXTRACT
REM If a regular file accidentally goes into this subroutine it will generate files that have .png suffix but are actually RGB JPEGs
MKDIR %EXCEPTION_NAME%_images
"%PARENT%bin\swfextract" "%EXCEPTION_NAME%" -j 1 -o "%EXCEPTION_NAME%_images\1.png"
"%PARENT%bin\swfextract" "%EXCEPTION_NAME%" -j 3 -o "%EXCEPTION_NAME%_images\3.png"
"%PARENT%bin\swfextract" "%EXCEPTION_NAME%" -j 5 -o "%EXCEPTION_NAME%_images\5.png"
"%PARENT%bin\swfextract" "%EXCEPTION_NAME%" -j 7 -o "%EXCEPTION_NAME%_images\7.png"
"%PARENT%bin\swfextract" "%EXCEPTION_NAME%" -j 9 -o "%EXCEPTION_NAME%_images\9.png"
"%PARENT%bin\swfextract" "%EXCEPTION_NAME%" -j 11 -o "%EXCEPTION_NAME%_images\11.png"
"%PARENT%bin\swfextract" "%EXCEPTION_NAME%" -j 13 -o "%EXCEPTION_NAME%_images\13.png"
"%PARENT%bin\swfextract" "%EXCEPTION_NAME%" -j 15 -o "%EXCEPTION_NAME%_images\15.png"
"%PARENT%bin\swfextract" "%EXCEPTION_NAME%" -j 17 -o "%EXCEPTION_NAME%_images\17.png"
"%PARENT%bin\swfextract" "%EXCEPTION_NAME%" -j 19 -o "%EXCEPTION_NAME%_images\19.png"
"%PARENT%bin\swfextract" "%EXCEPTION_NAME%" -j 21 -o "%EXCEPTION_NAME%_images\21.png"
"%PARENT%bin\swfextract" "%EXCEPTION_NAME%" -j 23 -o "%EXCEPTION_NAME%_images\23.png"
"%PARENT%bin\swfextract" "%EXCEPTION_NAME%" -j 25 -o "%EXCEPTION_NAME%_images\25.png"
"%PARENT%bin\swfextract" "%EXCEPTION_NAME%" -j 27 -o "%EXCEPTION_NAME%_images\27.png"
"%PARENT%bin\swfextract" "%EXCEPTION_NAME%" -j 29 -o "%EXCEPTION_NAME%_images\29.png"

REM Copy test set that should have transparency (Assuming extraction went okay)
IF NOT EXIST %%f_images\17.png (
	COPY "%%f_images\3.png" "%%f_images\alpha_test.png"
) ELSE (
	COPY "%%f_images\17.png" "%%f_images\alpha_test.png"
)

REM Detect if the test image has transparency by asking convert.exe to print the colour value of the pixel [0,0]
REM Files with transparency should have no colour (in which corner?)
REM 2>nul needed to skip an irrelevant error message
%PARENT%bin\convert "%%f_images\alpha_test.png" -format '%[pixel:s]' info:- 1>"%%f_images\alpha.txt" 2>nul
SET /p alpha=<"%%f_images\alpha.txt"
if %alpha% neq "none" ECHO Extraction failed for %EXCEPTION_NAME%: Alpha channels could not be extracted.
GOTO:EOF