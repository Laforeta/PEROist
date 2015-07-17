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
	IF NOT EXIST %%f_images\17.png ECHO Primary extraction method failed, switching to backup method && SET "FILENAME=%%f"&& CALL :FORCE_EXTRACT
	IF NOT EXIST %%f_images\17.png ECHO Backup extraction method failed for %%f. Skipping this file...
)

REM Export kanmusu mod pack
CD "%PARENT%temp\kanmusu_mod"
FOR %%f IN (*.swf) DO (
	ECHO Extracting images in %%f>CON
	ECHO Extracting images in %%f
	java -jar "%PARENT%bin\ffdec\ffdec.jar" -format image:png -export image "%%f_images" "%%f"
	IF NOT EXIST %%f_images\3.png ECHO Primary extraction method failed for %%f, switching to laternative... && SET "FILENAME=%%f"&& CALL :FORCE_EXTRACT
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
MKDIR %FILENAME%_images
"%PARENT%bin\swfextract" "%FILENAME%" -j 1 -o "%FILENAME%_images\1.png"
"%PARENT%bin\swfextract" "%FILENAME%" -j 3 -o "%FILENAME%_images\3.png"
"%PARENT%bin\swfextract" "%FILENAME%" -j 5 -o "%FILENAME%_images\5.png"
"%PARENT%bin\swfextract" "%FILENAME%" -j 7 -o "%FILENAME%_images\7.png"
"%PARENT%bin\swfextract" "%FILENAME%" -j 9 -o "%FILENAME%_images\9.png"
"%PARENT%bin\swfextract" "%FILENAME%" -j 11 -o "%FILENAME%_images\11.png"
"%PARENT%bin\swfextract" "%FILENAME%" -j 13 -o "%FILENAME%_images\13.png"
"%PARENT%bin\swfextract" "%FILENAME%" -j 15 -o "%FILENAME%_images\15.png"
"%PARENT%bin\swfextract" "%FILENAME%" -j 17 -o "%FILENAME%_images\17.png"
"%PARENT%bin\swfextract" "%FILENAME%" -j 19 -o "%FILENAME%_images\19.png"
"%PARENT%bin\swfextract" "%FILENAME%" -j 21 -o "%FILENAME%_images\21.png"
"%PARENT%bin\swfextract" "%FILENAME%" -j 23 -o "%FILENAME%_images\23.png"
"%PARENT%bin\swfextract" "%FILENAME%" -j 25 -o "%FILENAME%_images\25.png"
"%PARENT%bin\swfextract" "%FILENAME%" -j 27 -o "%FILENAME%_images\27.png"
"%PARENT%bin\swfextract" "%FILENAME%" -j 29 -o "%FILENAME%_images\29.png"

REM Copy test set that should have transparency (Assuming extraction went okay)
REM Detect if the test image has transparency by asking convert.exe to print the colour value of the pixel [0,0]
REM Files with transparency should have no colour (in which corner?)
REM 2>nul needed to skip an irrelevant error message
IF EXIST "%FILENAME%_images\17.png" (
	COPY "%FILENAME%_images\17.png" "%%f_images\alpha_test.png"
) ELSE IF EXIST "%FILENAME%_images\3.png"(
	COPY "%FILENAME%_images\3.png" "%FILENAME%_images\alpha_test.png"
) ELSE (
	ECHO Alternative Extraction failed for %FILENAME%
	DEL "%FILENAME%_images\*.png"
	GOTO:EOF
)
%PARENT%bin\convert "%FILENAME%_images\alpha_test.png" -format '%[pixel:s]' info:- 1>"%FILENAME%_images\alpha.txt" 2>nul
SET /p alpha=<"%FILENAME%_images\alpha.txt"
if %alpha% neq "none" (
	ECHO Extraction failed for %FILENAME%: Alpha channels could not be extracted, removing the extracted images...
	DEL "%FILENAME%_images\*.png"
) ELSE ( 
	ECHO Alternative extraction succeeded for %FILENAME%
)
GOTO:EOF