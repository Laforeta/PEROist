SETLOCAL ENABLEDELAYEDEXPANSION ENABLEEXTENSIONS
SET ME=%~n0
SET PARENT=%~dp0

ECHO ---------------->CON
ECHO Extraction Start>CON
ECHO ---------------->CON

REM Extract all images from kanmusu sprites(CharacterID 1,3,5,7,9,11,13,15,17,19,21,23,25,27,29)
CD %PARENT%temp
FOR %%f IN (%PARENT%temp\*.swf) DO (
	ECHO Extracting images in %%f>CON
	ECHO Extracting images in %%f
	java -jar %PARENT%bin\ffdec\ffdec.jar -onerror ignore -format image:png -export image "%%f_images" %%f
	IF NOT EXIST %%f_images\17.png ECHO Primary extraction method failed, switching to backup method && SET EXCEPTION_NAME=%%f&& CALL :FORCE_EXTRACT
	IF NOT EXIST %%f_images\17.png ECHO Backup extraction method failed. Aborting script...&& GOTO EXTRACT_END_FAIL
)

REM Export abyssal sprites (CharacterID 1,3)
CD %PARENT%temp\abyssal
FOR %%f IN (%PARENT%temp\abyssal\*.swf) DO (
	ECHO Extracting images in %%f>CON
	ECHO Extracting images in %%f
	java -jar %PARENT%bin\ffdec\ffdec.jar -onerror ignore -format image:png -export image "%%f_images" %%f
	IF NOT EXIST %%f_images\3.png ECHO Primary extraction method failed, switching to backup method && SET EXCEPTION_NAME=%%f&& CALL :FORCE_EXTRACT
	IF NOT EXIST %%f_images\3.png ECHO Backup extraction method failed. Aborting Script... && GOTO EXTRACT_END_FAIL
)

:EXTRACT_END_SUCCESS
ENDLOCAL
ECHO --------------->CON
ECHO Extraction Done>CON
ECHO --------------->CON
EXIT /B 0

:EXTRACT_END_FAIL
ENDLOCAL
ECHO ----------------->CON
ECHO Extraction Failed>CON
ECHO ----------------->CON
EXIT /B 1

:FORCE_EXTRACT
REM If a regular file accidentally goes into this subroutine it will generate files that have .png suffix but are actually RGB JPEGs
MKDIR %EXCEPTION_NAME%_images
%PARENT%bin\swfextract %EXCEPTION_NAME% -j 1 -o %EXCEPTION_NAME%_images\1.png
%PARENT%bin\swfextract %EXCEPTION_NAME% -j 3 -o %EXCEPTION_NAME%_images\3.png
%PARENT%bin\swfextract %EXCEPTION_NAME% -j 5 -o %EXCEPTION_NAME%_images\5.png
%PARENT%bin\swfextract %EXCEPTION_NAME% -j 7 -o %EXCEPTION_NAME%_images\7.png
%PARENT%bin\swfextract %EXCEPTION_NAME% -j 9 -o %EXCEPTION_NAME%_images\9.png
%PARENT%bin\swfextract %EXCEPTION_NAME% -j 11 -o %EXCEPTION_NAME%_images\11.png
%PARENT%bin\swfextract %EXCEPTION_NAME% -j 13 -o %EXCEPTION_NAME%_images\13.png
%PARENT%bin\swfextract %EXCEPTION_NAME% -j 15 -o %EXCEPTION_NAME%_images\15.png
%PARENT%bin\swfextract %EXCEPTION_NAME% -j 17 -o %EXCEPTION_NAME%_images\17.png
%PARENT%bin\swfextract %EXCEPTION_NAME% -j 19 -o %EXCEPTION_NAME%_images\19.png
%PARENT%bin\swfextract %EXCEPTION_NAME% -j 21 -o %EXCEPTION_NAME%_images\21.png
%PARENT%bin\swfextract %EXCEPTION_NAME% -j 23 -o %EXCEPTION_NAME%_images\23.png
%PARENT%bin\swfextract %EXCEPTION_NAME% -j 25 -o %EXCEPTION_NAME%_images\25.png
%PARENT%bin\swfextract %EXCEPTION_NAME% -j 27 -o %EXCEPTION_NAME%_images\27.png
%PARENT%bin\swfextract %EXCEPTION_NAME% -j 29 -o %EXCEPTION_NAME%_images\29.png

REM Abort if no images were extracted at all (Probably redundant)
IF NOT EXIST %%f_images\1.png ECHO Backup extraction method failed. Aborting script... && GOTO EXTRACT_END_FAIL

REM Copy test set that should have transparency
COPY %%f_images\17.png %%f_images\alpha_test.png
IF NOT EXIST %%f_images\17.png COPY %%f_images\3.png %%f_images\alpha_test.png

REM Detect if the test image has transparency by asking convert.exe to print the colour value of the pixel [0,0]
REM Files with transparency should have no colour (in which corner?)
REM 2>nul needed to skip an irrelevant error message
%PARENT%bin\convert %%f_images\alpha_test.png -format '%[pixel:s]' info:- 1>%%f_images\alpha.txt 2>nul
SET /p alpha=<%%f_images\alpha.txt

REM Abort if images don't have alpha, otherwise proceed
if %alpha% neq "none" ECHO Extraction failed: Alpha channels could not be extracted && GOTO :EXTRACT_END_FAIL

REM End of FORCE_EXTRACT
REM Something changes are needed in REPLACE and possibly IMPORT if this subroutine is called then REPLACE is likely to have problems handling the file
