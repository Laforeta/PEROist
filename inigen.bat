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

REM Load sprite and extract image to generate preview
FOR %%G IN (%PARENT%input\*.swf) DO (
	ECHO Found sprite pack %%G, dumping contents....
	COPY /y "%%g" "%PARENT%temp"
	java -jar "%PARENT%bin\ffdec\ffdec.jar" -format image:png -export image "%PARENT%temp\%%g_images" "%%g"
	SET FILENAME=<%%G
)

CD TEMP

:MENU
PAUSE

:BOKO_N_OFFSET
REM Set up components
SET PORT="%PARENT%data\room.gif"
SET CENTRE_X=400
SET CENTRE_Y=240
SET SPRITE="%PARENT%data\arrow.gif"

ECHO Please enter a few value for boko_n
SET /a /p OFFSET_X=
SET /a ANCHOR_X=%OFFSET_X%+%CENTRE_X%

%IM% %PORT% %SPRITE% -geometry '+%ANCHOR_X%+%ANCHOR_Y%' -composite "%PARENT%temp\port_preview.jpg"
"%PARENT%temp\port_preview.jpg"
ECHO Please check the image preview. 
ECHO Enter OK to accept or press enter to reset. 
SET /p USER_OKAY=
IF %OK%==OK GOTO BATTLE_OFFSET
GOTO BOKO_OFFSET

:BATTLE_OFFSET

:MAP_OFFSET

:KAISYU_OFFSET

:KAIZO_OFFSET

:ENSYUF_OFFSET

:WED_OFFSET

REM Writing finalised coordinates to %FILENAME%.config.ini

@echo Line1> %FILENAME%.config.ini
@echo Line2>> %FILENAME%.config.ini
@echo Line3>> %FILENAME%.config.ini


ENDLOCAL EXIT /b 0