@ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION ENABLEEXTENSIONS
SET ME=%~n0
SET PARENT=%~dp0
@ECHO Running %ME%

REM Set up the environment
SET IM="%PARENT%bin\convert.exe"
SET STREAM="%PARENT%bin\stream.exe"
IF NOT DEFINED JPEG_QUALITY SET /a JPEG_QUALITY=92

REM Prepare folders if not already presen
CALL CLEANUP
MKDIR temp 2>nul
MKDIR input 2>nul
MKDIR output 2>nul

CD input
FOR %%G IN (*.swf) DO (
	COPY *.swf "%PARENT%temp"
	COPY *.png "%PARENT%temp"
)
CD..

CD temp
REM Load file name (no extensions!) into variable %FILENAME%
FOR /f "tokens=1 delims=" %%G in ('DIR /b *.swf') DO SET FILENAME=%%G

REM Do replacement for each image present
FOR /f "tokens=1 delims=." %%G IN ('DIR /b *.png') DO (
	SET /a TARGET=%%G
	SET /a SHAPE=%%G+1
	CALL :REPLACE
)

ECHO Conversion complete for %FILENAME%, exporting it to the output folder...

REM Rename and export
REM DEL /q *.swf
REN *.swf *.hack.swf
COPY /y *.hack.swf "%PARENT%output"

ENDLOCAL
EXIT /b 0

REM This part needs ffdec nightly 794 or later to run! 
:REPLACE
ECHO Converting Scaled RGB for Image #%TARGET% in %FILENAME% to JPEG bitmap...
%IM% -quality %JPEG_QUALITY% %TARGET%.png %TARGET%.jpg
ECHO Generating Binary Mask for 
%STREAM% -map a -storage-type char %TARGET%.png %TARGET%.bin
ECHO Inserting Image #%TARGET%...
java -jar "%PARENT%bin\ffdec\ffdec.jar" -replace %FILENAME% %FILENAME% %SHAPE% %TARGET%.jpg nofill jpeg3
ECHO Removing Old Image #%TARGET%...
java -jar "%PARENT%bin\ffdec\ffdec.jar" -removeCharacterwithdependencies %FILENAME% %FILENAME% %TARGET%
ECHO Regularising Images in %FILENAME%...
java -jar "%PARENT%bin\ffdec\ffdec.jar" -replaceCharacterID %FILENAME% %FILENAME% sort
ECHO Restoring transparency to Image #%TARGET%...
java -jar "%PARENT%bin\ffdec\ffdec.jar" -replaceAlpha %FILENAME% %FILENAME% %TARGET% %TARGET%.bin 
GOTO:EOF

