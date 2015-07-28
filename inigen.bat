@ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION ENABLEEXTENSIONS
SET ME=%~n0
SET PARENT=%~dp0
@ECHO Running %ME%

REM Progress:
REM Single file loader: Working
REM Ini config loader: Working
REM Multi file loader: Will load and expand values, but will not handle multiple values correctly. 
REM Interactive Menu: Working
REM Preview: Working (check on other OS)
REM redefine offset: WORKING
REM Write config to file: NOT WORKING
REM Logging: NOT Working

REM Set up the environment
SET IM="%PARENT%bin\convert.exe"
SET STREAM="%PARENT%bin\stream.exe"
SET VIEWER="%PARENT%bin\JPEGView\JPEGview.exe"

REM Prepare folders if not already present
CALL CLEANUP.cmd
IF NOT EXIST temp MKDIR temp
IF NOT EXIST input MKDIR input
IF NOT EXIST output MKDIR output

REM Load sprite and extract image to generate preview
REM COPY operation somehow not working
CD input
IF NOT EXIST *.hack.swf (
	ECHO No mod packs found, generator will now quit
	PAUSE
	GOTO EXIT
) ELSE ( 
	FOR /f "tokens=1 delims=." %%g IN ('DIR /b *.hack.swf') DO (
		ECHO Found mod file %%g, analysing file....
		COPY "%%g.hack.swf" "%%PARENT%%temp"
		java -jar "%PARENT%bin\ffdec\ffdec.jar" -format image:png -export image "%PARENT%temp\%%g.hack.swf_images" "%%g.hack.swf"
		SET FILENAME=%%g
		ECHO Finished analysing !FILENAME!.hack.swf
	)
	CD %PARENT%temp
)

REM Add the ability to parse api_start and existing file later, for now use an approximate starting value
:INIT
IF EXIST "%PARENT%input\%FILENAME%.config.ini" (
	ECHO Loading current config file...
	FOR /f "tokens=1* delims=^=" %%f IN ('FIND "=" "%PARENT%input\%FILENAME%.config.ini"') DO (
		SET %%f=%%g
	)
) ELSE IF EXIST "%PARENT%data\api_start2.json" (
	ECHO Parse api_start2...
) ELSE (
	ECHO No other information found, loading default values
	FOR /f "tokens=1* delims=^=" %%f IN ('FIND "=" "%PARENT%data\default.config.ini"') DO (
		SET %%f=%%g
	)
)
PAUSE

:MENU
@ECHO OFF
CLS
ECHO.
ECHO 		############################
ECHO 		PEROist config.ini Generator
ECHO 		############################
ECHO.
ECHO 1 - Display current offsets
ECHO 2 - Preview and change offsets for normal sprite
ECHO 3 - Preview and change offsets for "damaged" sprite
ECHO 4 - Write offset data as APImodifier.json (NOT WORKING)
ECHO 5 - Write offset data to %FILENAME%.config.ini
ECHO 8 - Manually enter known offset values (NOT WORKING)
ECHO 9 - Reset all input
ECHO 0 - Quit generator
ECHO.
ECHO Choose from one of the options above and press enter:
SET "OPTION="
SET /p OPTION=[1,2,3,4,5,9,0]
IF /i '%OPTION%'=='1' (
	GOTO DISPLAY
) ELSE IF /i '%OPTION%'=='2' (
	SET BACKGROUND="%PARENT%data\room.png"
	SET SPRITE="%PARENT%temp\!FILENAME!.hack.swf_images\17.png"
	SET ALIAS="Normal"
	SET /a ORIGIN_X=326
	SET /a ORIGIN_Y=-19
	SET /a CURRENT_X=%boko_n_left%
	SET /a CURRENT_Y=%boko_n_top%
	SET NEW_X=boko_n_left
	SET NEW_Y=boko_n_top
	GOTO PROCESS
) ELSE IF /i '%OPTION%'=='3' (
	ECHO OPTION %OPTION% selected.
	SET BACKGROUND="%PARENT%data\room.png"
	SET SPRITE="%PARENT%temp\!FILENAME!.hack.swf_images\19.png"
	SET ALIAS="Damaged"
	SET /a ORIGIN_X=326
	SET /a ORIGIN_Y=-45
	SET /a CURRENT_X=%boko_d_left%
	SET /a CURRENT_Y=%boko_d_top%
	SET NEW_X=boko_d_left
	SET NEW_Y=boko_d_top
	GOTO PROCESS
) ELSE IF /i '%OPTION%'=='4' (
	GOTO WRITE_JSON
) ELSE IF /i '%OPTION%'=='5' (
	GOTO WRITE_INI
) ELSE IF /i '%OPTION%'=='8' (
	GOTO MANUAL_ENTRY
) ELSE IF /i '%OPTION%'=='9' (
	ECHO Reinitialising offset values...
	PAUSE
	GOTO INIT
) ELSE IF /i '%OPTION%'=='0 '(
	GOTO EXIT
) ELSE (
	ECHO Please choose one valid option from the list
	PAUSE
	GOTO MENU
)
GOTO MENU

:DISPLAY
ECHO Displaying current values
ECHO ship_name=%ship_name%
ECHO boko_d_left=%boko_d_left%
ECHO boko_d_top=%boko_d_top%
ECHO boko_n_left=%boko_n_left%
ECHO boko_n_top=%boko_n_top%
PAUSE
GOTO MENU

:PROCESS
SET /a ANCHOR_X=%ORIGIN_X%+%CURRENT_X%
SET /a ANCHOR_Y=%ORIGIN_Y%+%CURRENT_Y%
ECHO Generating preview based on current values (%CURRENT_X%,%CURRENT_Y%)
%IM% !BACKGROUND! !SPRITE! -geometry +!ANCHOR_X!+!ANCHOR_Y! -composite Preview_!ALIAS!_!CURRENT_X!_!CURRENT_Y!.jpg
START %VIEWER% %PARENT%temp\Preview_!ALIAS!_!CURRENT_X!_!CURRENT_Y!.jpg
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
REM Pipe stored offset values to preview generation
ECHO Offset values successfully updated. Press any key to generate a new review.
SET /a CURRENT_X=%NEW_X%
SET /a CURRENT_Y=%NEW_Y%
PAUSE
GOTO PROCESS

REM Manually enter values for each variable
:MANUAL_ENTRY
ECHO Choose the value you wish to edit
PAUSE
GOTO MENU

REM Write offset data for 74EO.
:WRITE_JSON
ECHO Write offset data for 74EO
PAUSE
GOTO MENU

REM Writing finalised coordinates to %FILENAME%.config.ini
:WRITE_INI
CD "%PARENT%output"
DEL /q %FILENAME%.config.ini
ECHO Writing new coordinates to %FILENAME%.config.ini
@echo [Info]>%FILENAME%.config.ini
@echo [Info]>>%FILENAME%.config.ini
@echo ship_name=%ship_name%>%FILENAME%.config.ini
@echo [Data]>>%FILENAME%.config.ini
@echo boko_d_left=%boko_d_left%>>%FILENAME%.config.ini
@echo boko_d_top=%boko_d_top%>>%FILENAME%.config.ini
@echo boko_n_left=%boko_n_left%>>%FILENAME%.config.ini
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