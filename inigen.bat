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
REM CALL CLEANUP
MKDIR temp 2>nul
MKDIR input 2>nul
MKDIR output 2>nul

REM Load sprite and extract image to generate preview
REM COPY operation somehow not working
CD input
FOR /f "tokens=1 delims=" %%G IN ('DIR /b *.swf') DO (
	ECHO Found sprite pack %%G, analysing file....
	ECHO COPY *.* "%%PARENT%%temp\"
	ECHO java -jar "%PARENT%bin\ffdec\ffdec.jar" -format image:png -export image "%PARENT%temp\%%g_images" "%%g"
	SET FILENAME=<%%G
	ECHO Filename is %FILENAME%
)

CD %PARENT%temp
REM IF NOT EXIST *.swf ECHO No mod packs found, generator will now quit. && GOTO EXIT

REM Add the ability to parse api_start and existing file later, for now use an approximate starting value
:INIT
IF EXIST api_start2.json (
	ECHO Parsing api_start2...
) ELSE IF EXIST config.ini (
	ECHO Loading current config file...
) ELSE (
	ECHO No information found, generator will proceed using default values
	SET ship_name=
	SET /a boko_d_left=128
	SET /a boko_d_top=128
	SET /a boko_n_left=128
	SET /a boko_n_top=128
)

PAUSE

:MENU
@ECHO OFF
CLS
ECHO.
ECHO 			############################
ECHO 			PEROist config.ini Generator
ECHO 			############################
ECHO.
ECHO 1 - Display current offsets          6 - Unused
ECHO 2 - Preview boko_d                   7 - Unused
ECHO 3 - Set boko_d                       8 - Write current values to config.ini
ECHO 4 - Preview boko_n                   9 - Reset all input
ECHO 5 - Set boko_n                       0 - Quite generator
ECHO.

SET OPTION=
SET /P OPTION=Choose from one of the options above and press enter:
IF %OPTION%==1 (
	CALL :DISPLAY_VALUES
) ELSE IF %OPTION%==2 (
	SET BACKGROUND="%PARENT%data\room.png"
	SET SPRITE=""%PARENT%data\arrow.gif"
	SET /a ORIGIN_X=326
	SET /a ORIGIN_Y=-19
	SET /a CURRENT_X=%boko_d_left%
	SET /a CURRENT_Y=%boko_d_top%
	CALL :PREVIEW
) ELSE IF %OPTION%==3 (
	SET NAME_X=boko_d_left
	SET NAME_Y=boko_d_top
	CALL :SET_VALUES
) ELSE IF %OPTION%==4 (
	SET BACKGROUND="%PARENT%data\room.png"
	SET SPRITE=""%PARENT%data\arrow.gif"
	SET /a ORIGIN_X=326
	SET /a ORIGIN_Y=-45
	SET /a CURRENT_X=%boko_n_left%
	SET /a CURRENT_Y=%boko_n_left%
	CALL :PREVIEW
) ELSE IF %OPTION%==8 (
	SET NAME_X=boko_n_left
	SET NAME_Y=boko_n_top
	CALL :SET_VALUES
) ELSE IF %OPTION%==8 (
	CALL :WRITE_FILE
) ELSE IF %OPTION%==9 (
	ECHO Reinitialising offset values...
	GOTO INIT
) ELSE IF %OPTION%==0 (
	ECHO The script will now quit
	GOTO EXIT
) ELSE (
	ECHO Please choose one valid option from the list
	PAUSE
	GOTO MENU
)
GOTO MENU

:PREVIEW
SET /a ANCHOR_X=%ORIGIN_X%+%CURRENT_X%
SET /a ANCHOR_Y=%ORIGIN_Y%+%CURRENT_Y%
ECHO Generating preview based on current values (%CURRENT_X%,%CURRENT_Y%)
%IM% -composite "port_preview.jpg" -geometry +!ANCHOR_X!+!ANCHOR_Y! !BACKGROUND! !SPRITE!
iexplore "%PARENT%data\room.png"
PAUSE
GOTO:EOF

:SET_VALUES
ECHO Please enter a new value for %NAME_X%:
SET /a /p !NAME_X!=
ECHO Please enter a new value for %NAME_Y%:
SET /a /p !NAME_Y!=
GOTO:EOF

:DISPLAY_VALUES
ECHO Displaying current values
ECHO ship_name=%ship_name%
ECHO boko_d_left=%boko_d_left%
ECHO boko_d_top=%boko_d_top%
ECHO boko_n_left=%boko_n_left%
ECHO boko_n_top=%boko_n_top%
PAUSE

:BATTLE_OFFSET

:MAP_OFFSET

:KAISYU_OFFSET

:KAIZO_OFFSET

:ENSYUF_OFFSET

:WED_OFFSET

REM Writing finalised coordinates to %FILENAME%.config.ini
:WRITE_FILE
@echo [Info]> %FILENAME%.config.ini
@echo ship_name=%ship_name%>%FILENAME%.config.ini
@echo boko_d_left=%boko_d_left%>>%FILENAME%.config.ini
@echo boko_d_top=%boko_d_top%>>%FILENAME%.config.ini
@echo boko_n_left=%boko_n_lef%>>%FILENAME%.config.ini
@echo boko_n_top=%boko_n_top%>>%FILENAME%.config.ini

REM skip the remaining for now
GOTO MENU

@echo battle_d_left= >> %FILENAME%.config.ini
@echo battle_d.top= >> %FILENAME%.config.ini
@echo battle_n_left=
@echo battle_n.top=

ensyue_d_left=
ensyue_d_top=
ensyue_n_left=
ensyue_n_top=

ensyuf_d_left=
ensyuf_d_top=
ensyuf_n_left=
ensyuf_n_top=

kaisyu_d_left=
kaisyu_d_top=
kaisyu_n_left=
kaisyu_n_top=

kaizo_d_left=
kaizo_d_top=
kaizo_n_left=
kaizo_n_top=

map_d_left=
map_d_top=
map_n_left=
map_n_top=

weda_left=
weda_top=
wedb_left=
wedb_top=

:EXIT
ENDLOCAL 
EXIT /b 0