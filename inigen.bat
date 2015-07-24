@ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION ENABLEEXTENSIONS
SET ME=%~n0
SET PARENT=%~dp0
@ECHO Running %ME%

REM Progress:
REM Single file loader: Working
REM Multi file loader: Not started
REM Interactive Menu: Working
REM Preview: Working
REM redefine offset: WORKING
REM Write config to file: NOT WORKING
REM Logging: NOT Working

REM Set up the environment
SET IM="%PARENT%bin\convert.exe"
SET STREAM="%PARENT%bin\stream.exe"
IF NOT DEFINED JPEG_QUALITY SET /a JPEG_QUALITY=92

REM Prepare folders if not already presen
CALL CLEANUP.cmd
MKDIR temp 2>nul
MKDIR input 2>nul
MKDIR output 2>nul

REM Load sprite and extract image to generate preview
REM COPY operation somehow not working
CD input
FOR /f "tokens=1 delims=." %%g IN ('DIR /b *.hack.swf') DO (
	ECHO Found mod file %%g, analysing file....
	COPY "%%g.hack.swf" "%%PARENT%%temp"
	java -jar "%PARENT%bin\ffdec\ffdec.jar" -format image:png -export image "%PARENT%temp\%%g.hack.swf_images" "%%g.hack.swf"
	SET FILENAME=%%g
	ECHO Filename is !FILENAME!
)

IF NOT EXIST *.hack.swf (
	ECHO No mod packs found, generator will now quit
	PAUSE
	GOTO EXIT
) ELSE ( 
	ECHO Finished reading list of files, initialising generator...
	CD %PARENT%temp
)

REM Add the ability to parse api_start and existing file later, for now use an approximate starting value
:INIT
IF EXIST GraphList.txt (
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

:MENU
@ECHO OFF
CLS
ECHO.
ECHO 			############################
ECHO 			PEROist config.ini Generator
ECHO 			############################
ECHO.
ECHO 1 - Display current offsets         6 - X
ECHO 2 - Adjust offsets boko_d           7 - X
ECHO 3 - Adjust offsets boko_n           8 - Write %FILENAME%.config.ini
ECHO 4 - Adjust offsets battle_d         9 - Reset all input
ECHO 5 - Adjust offsets battle_n         0 - Quit generator
ECHO.
ECHO Choose from one of the options above and press enter:
SET "OPTION="
SET /p OPTION=[1,2,3,4,5,6,7,8,9,0]
IF /i '%OPTION%'=='1' (
	GOTO DISPLAY
) ELSE IF /i '%OPTION%'=='2' (
	SET BACKGROUND="%PARENT%data\room.gif"
	SET SPRITE="%PARENT%data\arrow.gif"
	SET /a ORIGIN_X=326
	SET /a ORIGIN_Y=-19
	SET /a CURRENT_X=%boko_d_left%
	SET /a CURRENT_Y=%boko_d_top%
	SET NEW_X=boko_d_left
	SET NEW_Y=boko_d_top
	GOTO PROCESS
) ELSE IF /i '%OPTION%'=='3' (
	ECHO OPTION %OPTION% selected.
) ELSE IF /i '%OPTION%'=='4' (
	ECHO OPTION %OPTION% selected.
	SET BACKGROUND="%PARENT%data\room.gif"
	SET SPRITE="%PARENT%data\arrow.gif"
	SET /a ORIGIN_X=326
	SET /a ORIGIN_Y=-45
	SET /a CURRENT_X=%boko_n_left%
	SET /a CURRENT_Y=%boko_n_top%
	GOTO PROCESS
) ELSE IF /i '%OPTION%'=='7' (
	ECHO OPTION %OPTION% selected.
) ELSE IF /i '%OPTION%'=='8' (
	GOTO WRITE_INI
) ELSE IF /i '%OPTION%'=='9' (
	ECHO OPTION %OPTION% selected.
	ECHO Reinitialising offset values...
	GOTO INIT
) ELSE IF /i '%OPTION%'=='0 '(
	GOTO EXIT
) ELSE (
	ECHO Please choose one valid option from the list
	PAUSE
	GOTO MENU
)
GOTO MENU

:PROCESS
SET /a ANCHOR_X=%ORIGIN_X%+%CURRENT_X%
SET /a ANCHOR_Y=%ORIGIN_Y%+%CURRENT_Y%
ECHO Generating preview based on current values (%CURRENT_X%,%CURRENT_Y%)
%IM% !BACKGROUND! !SPRITE! -geometry +!ANCHOR_X!+!ANCHOR_Y! -composite port_preview.jpg
START rundll32 "%ProgramFiles%\Windows Photo Viewer\PhotoViewer.dll", ImageView_Fullscreen %PARENT%temp\port_preview.jpg
ECHO Are you happy with the results? 
SET /p ACCEPT=[y/n]
IF /i %ACCEPT%==y GOTO MENU
CLS
ECHO Current %NEW_X% is %CURRENT_X%
ECHO Please enter a new value for %NEW_X%:
SET /p !NEW_X!=
ECHO Current %NEW_Y% is %CURRENT_Y%
ECHO Please enter a new value for %NEW_Y%:
SET /p !NEW_Y!=
ECHO Offset values successfully updated. Press any key to generate a new review.
SET /a CURRENT_X=%NEW_X%
SET /a CURRENT_Y=%NEW_Y%
PAUSE
GOTO PROCESS

:DISPLAY
ECHO Displaying current values
ECHO ship_name=%ship_name%
ECHO boko_d_left=%boko_d_left%
ECHO boko_d_top=%boko_d_top%
ECHO boko_n_left=%boko_n_left%
ECHO boko_n_top=%boko_n_top%
PAUSE
GOTO MENU

REM Writing finalised coordinates to %FILENAME%.config.ini
:WRITE_INI
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
ECHO Shutting down generator...
EXIT /b 0