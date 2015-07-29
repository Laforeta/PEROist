@ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION ENABLEEXTENSIONS
SET ME=%~n0
SET PARENT=%~dp0
@ECHO Running %ME%

REM Declare binary paths
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
		ECHO Found file %%g.hack.swf found, analysing...
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
	ECHO No existing data found, loading default failsafe values.
	PAUSE
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
ECHO 1 - Preview and change primary offsets (standard)
ECHO 2 - Preview and change primary offsets (battle-damage)
ECHO 3 - Preview and change secondary offsets (standard)
ECHO 4 - Preview and change secondary offsets (battle-damage)
ECHO 5 - Preview and change wedding offsets [NOT WORKING]
ECHO 6 - Display current values [and manually enter offset values]
ECHO 7 - Write offset data to APImodifier.json [NOT WORKING]
ECHO 8 - Write offset data to %FILENAME%.config.ini
ECHO 9 - Reset all parameters and reload initial values
ECHO 0 - Quit
ECHO.
ECHO Choose from one of the options above and press enter:
SET "OPTION="
SET /p OPTION=[1,2,3,4,5,6,7,8,9,0]
IF /i '%OPTION%'=='0' (
	GOTO EXIT
) ELSE IF /i '%OPTION%'=='1' (
	SET BACKGROUND="%PARENT%data\room.png"
	SET SPRITE="%PARENT%temp\!FILENAME!.hack.swf_images\17.png"
	SET ALIAS="standard"
	SET /a ORIGIN_X=326
	SET /a ORIGIN_Y=-19
	SET /a CURRENT_X=%boko_n_left%
	SET /a CURRENT_Y=%boko_n_top%
	SET NEW_X=boko_n_left
	SET NEW_Y=boko_n_top
	SET DELTA=1
	GOTO PROCESS
) ELSE IF /i '%OPTION%'=='2' (
	SET BACKGROUND="%PARENT%data\room.png"
	SET SPRITE="%PARENT%temp\!FILENAME!.hack.swf_images\19.png"
	SET ALIAS="battledamage"
	SET /a ORIGIN_X=326
	SET /a ORIGIN_Y=-45
	SET /a CURRENT_X=%boko_d_left%
	SET /a CURRENT_Y=%boko_d_top%
	SET NEW_X=boko_d_left
	SET NEW_Y=boko_d_top
	SET DELTA=2
	GOTO PROCESS
) ELSE IF /i '%OPTION%'=='3' (
	SET BACKGROUND="%PARENT%data\panel.png"
	SET SPRITE="%PARENT%temp\!FILENAME!.hack.swf_images\13.png"
	SET ALIAS="standard"
	SET /a ORIGIN_X=50
	SET /a ORIGIN_Y=73
	SET /a CURRENT_X=%kaisyu_n_left%
	SET /a CURRENT_Y=%kaisyu_n_top%
	SET NEW_X=kaisyu_n_left
	SET NEW_Y=kaisyu_n_top
	SET DELTA=0
	GOTO PROCESS
) ELSE IF /i '%OPTION%'=='4' (
	SET BACKGROUND="%PARENT%data\panel.png"
	SET SPRITE="%PARENT%temp\!FILENAME!.hack.swf_images\15.png"
	SET ALIAS="battledamage"
	SET /a ORIGIN_X=34
	SET /a ORIGIN_Y=63
	SET /a CURRENT_X=%kaisyu_d_left%
	SET /a CURRENT_Y=%kaisyu_d_top%
	SET NEW_X=kaisyu_d_left
	SET NEW_Y=kaisyu_d_top
	SET DELTA=0
	GOTO PROCESS
) ELSE IF /i '%OPTION%'=='5' (
	SET BACKGROUND="%PARENT%data\chapel.png"
	SET SPRITE="%PARENT%temp\!FILENAME!.hack.swf_images\17.png"
	SET ALIAS="wedding"
	SET /a ORIGIN_X=
	SET /a ORIGIN_Y=
	SET /a CURRENT_X=%weda_left%
	SET /a CURRENT_Y=%weda_top%
	SET NEW_X=weda_left
	SET NEW_Y=weda_top
	SET DELTA=3
	GOTO PROCESS
) ELSE IF /i '%OPTION%'=='6' (
	GOTO DISPLAY
) ELSE IF /i '%OPTION%'=='7' (
	GOTO WRITE_JSON
) ELSE IF /i '%OPTION%'=='8' (
	GOTO WRITE_INI
) ELSE IF /i '%OPTION%'=='9' (
	ECHO Are you sure you want to reset and abandon all changes made so far?
	SET /p OPTION2=[y/n]
	IF /i '%OPTION2%'=='y' GOTO INIT
	GOTO MENU
) ELSE (
	ECHO Please enter one valid option from the list above
	PAUSE
	GOTO MENU
)
GOTO MENU

:DISPLAY
CLS
ECHO Displaying active offset values for %FILENAME%.hack.swf
ECHO boko_n_left=%boko_n_left%  
ECHO boko_n_top=%boko_n_top%   
ECHO boko_d_left=%boko_d_left%
ECHO boko_d_top=%boko_d_top%
ECHO map_n_left=%map_n_left%
ECHO map_n_top=%map_n_top%
ECHO map_d_left=%map_d_left%
ECHO map_d_top=%map_d_top%
ECHO battle_d_top=%battle_d_top%
ECHO battle_d_left=%battle_d_left%
ECHO battle_n_top=%battle_n_top%
ECHO battle_n_left=%battle_n_left%
ECHO ensyuf_n_left=%ensyuf_n_left%
ECHO ensyuf_n_top=%ensyuf_n_top%
ECHO ensyuf_d_left=%ensyuf_d_left%
ECHO ensyuf_d_top=%ensyuf_d_top%
ECHO ensyue_n_left=%ensyue_n_left%
ECHO ensyue_n_top=%ensyue_n_top%
ECHO kaizo_n_left=%kaizo_n_left%
ECHO kaizo_n_top=%kaizo_n_top%
ECHO kaizo_d_left=%kaizo_d_left%
ECHO kaizo_d_top=%kaizo_d_top%
ECHO kaisyu_d_left=%kaisyu_d_left%
ECHO kaisyu_d_top=%kaisyu_d_top%
ECHO kaisyu_n_left=%kaisyu_n_left%
ECHO kaisyu_n_top=%kaisyu_n_top%
ECHO weda_left=%weda_left%
ECHO weda_top=%weda_top%
ECHO wedb_left=%wedb_left%
ECHO wedb_top=%wedb_top%


:MANUAL_ENTRY
ECHO Would you like to manually modify any of these values?
SET /p OPTION2=[y/n]
IF /i %OPTION2% neq y GOTO MENU
SET /p _NAME=Please enter the name of offset you wish to modify: 
SET /p _VALUE=Please enter the new value of offset you wish to modify: 
SET %_NAME%=%_VALUE%
GOTO DISPLAY

:PROCESS
SET /a ANCHOR_X=%ORIGIN_X%+%CURRENT_X%
SET /a ANCHOR_Y=%ORIGIN_Y%+%CURRENT_Y%
ECHO Generating preview based on current values (%CURRENT_X%,%CURRENT_Y%)
%IM% !BACKGROUND! !SPRITE! -geometry +!ANCHOR_X!+!ANCHOR_Y! -composite Preview_NoMask.jpg
%IM% Preview_NoMask.jpg "%PARENT%data\room_mask.png" -geometry +0+0 -composite Preview_!ALIAS!_!CURRENT_X!_!CURRENT_Y!.jpg
START %VIEWER% %PARENT%temp\Preview_!ALIAS!_!CURRENT_X!_!CURRENT_Y!.jpg
ECHO Are you happy with the results? 
SET /p ACCEPT=[y/n]
IF /i %ACCEPT%==y GOTO MENU
CLS
REM First give new values for currently selected variables
ECHO Current %NEW_X% is %CURRENT_X%
ECHO Please enter a new value for %NEW_X%:
SET /p !NEW_X!=
ECHO Current %NEW_Y% is %CURRENT_Y%
ECHO Please enter a new value for %NEW_Y%:
SET /p !NEW_Y!=
REM Then calculate the delta values and apply them to derivative values
IF '%DELTA%'=='0' (
	ECHO Nothing more to be done, proceed with the loop...
	) ELSE IF '%DELTA%'=='1' (
	ECHO Setting derivative offsets for the standard set based on current delta
	SET /a DELTA_X=!CURRENT_X!-!NEW_X!
	SET /a DELTA_Y=!CURRENT_T!-!NEW_Y!
	SET /a map_n_left=!map_n_left!+!DELTA_X!
	SET /a map_n_top=!map_n_top!+!DELTA_Y!
	SET /a battle_n_left=!battle_n_left!+!DELTA_X!
	SET /a battle_n_top=!battle_n_top!+!DELTA_Y!
	SET /a ensyuf_n_left=!ensyuf_n_left!+!DELTA_X!
	SET /a ensyuf_n_top=!ensyuf_n_top!+!DELTA_Y!
	SET /a ensyue_n_left=!ensyue_n_left!+!DELTA_X!
	SET /a ensyue_n_top=!ensyue_n_top!+!DELTA_Y!
	SET /a kaizo_n_left=!kaizo_n_left!+!DELTA_X!
	SET /a kaizo_n_top=!kaizo_n_top!+!DELTA_Y!
	) ELSE IF '%DELTA%'=='2' (
	ECHO Setting derivative offsets for the battledamaged set based on current delta
	SET /a DELTA_X=!CURRENT_X!-!NEW_X!
	SET /a DELTA_Y=!CURRENT_T!-!NEW_Y!
	SET /a map_d_left=!map_d_left!+!DELTA_X!
	SET /a map_d_top=!map_d_top!+!DELTA_Y!
	SET /a battle_d_left=!battle_d_left!+!DELTA_X!
	SET /a battle_d_top=!battle_d_top!+!DELTA_Y!
	SET /a ensyuf_d_left=!ensyuf_d_left!+!DELTA_X!
	SET /a ensyuf_d_top=!ensyuf_d_top!+!DELTA_Y!
	SET /a kaizo_d_left=!kaizo_d_left!+!DELTA_X!
	SET /a kaizo_d_top=!kaizo_d_top!+!DELTA_Y!
	) ELSE IF '%DELTA%'=='3' (
	ECHO Applying derivative offsets to wedding cut-scene
	SET /a DELTA_X=!CURRENT_X!-!NEW_X!
	SET /a DELTA_Y=!CURRENT_T!-!NEW_Y!
	SET /a wedb_left=!weda_left!+!delta_X!
	SET /a wedb_top=!weda_top!+!delta_Y!	
	) ELSE (
	ECHO Something went wrong. DELTA flag is either not set or had an unexpected value
	PAUSE
	GOTO MENU
)
REM Then pipe stored offset values to preview generation
ECHO Offset values successfully updated. Press any key to generate a new review.
SET /a CURRENT_X=%NEW_X%
SET /a CURRENT_Y=%NEW_Y%
PAUSE
GOTO PROCESS

REM Write offset data for 74EO.
:WRITE_JSON
ECHO Write offset data for 74EO
PAUSE
GOTO MENU

REM Writing finalised coordinates to %FILENAME%.config.ini
REM do ensyue_d even exist? 
:WRITE_INI
ECHO Applying offsets to 
CD "%PARENT%output"
DEL /q %FILENAME%.config.ini
@echo [info]>%FILENAME%.config.ini
@echo ship_name=%ship_name%>>%FILENAME%.config.ini
@echo [graph]>>%FILENAME%.config.ini
@echo boko_d_left=%boko_d_left%>>%FILENAME%.config.ini
@echo boko_d_top=%boko_d_top%>>%FILENAME%.config.ini
@echo boko_n_left=%boko_n_left%>>%FILENAME%.config.ini
@echo boko_n_top=%boko_n_top%>>%FILENAME%.config.ini
@echo ensyue_d_left=%ensyue_d_left%>>%FILENAME%.config.ini
@echo ensyue_d_top=%ensyue_d_top%>>%FILENAME%.config.ini
@echo ensyue_n_left=%ensyue_n_left%>>%FILENAME%.config.ini
@echo ensyue_n_top=%ensyue_n_top%>>%FILENAME%.config.ini
@echo ensyuf_d_left=%ensyuf_d_left%>>%FILENAME%.config.ini
@echo ensyuf_d_top=%ensyuf_d_top%>>%FILENAME%.config.ini
@echo ensyuf_n_left=%ensyuf_n_left%>>%FILENAME%.config.ini
@echo ensyuf_n_top=%ensyuf_n_top%>>%FILENAME%.config.ini
@echo kaisyu_d_left=%kaisyu_d_left%>>%FILENAME%.config.ini
@echo kaisyu_d_top=%kaisyu_d_top%>>%FILENAME%.config.ini
@echo kaisyu_n_left=%kaisyu_n_left%>>%FILENAME%.config.ini
@echo kaisyu_n_top=%kaisyu_n_top%>>%FILENAME%.config.ini
@echo kaizo_d_left=%kaizo_d_left%>>%FILENAME%.config.ini
@echo kaizo_d_top=%kaizo_d_top%>>%FILENAME%.config.ini
@echo kaizo_n_left=%kaizo_n_left%>>%FILENAME%.config.ini
@echo kaizo_n_top=%kaizo_n_top%>>%FILENAME%.config.ini
@echo map_d_top=%map_d_top%>>%FILENAME%.config.ini
@echo map_d_left=%map_d_left%>>%FILENAME%.config.ini
@echo map_n_top=%map_n_top%>>%FILENAME%.config.ini
@echo map_n_left=%map_n_left%>>%FILENAME%.config.ini
@echo battle_d_top=%battle_d_top%>>%FILENAME%.config.ini
@echo battle_d_left=%battle_d_left%>>%FILENAME%.config.ini
@echo battle_n_top=%battle_n_top%>>%FILENAME%.config.ini
@echo battle_n_left=%battle_n_left%>>%FILENAME%.config.ini
@echo weda_left=%weda_left%>>%FILENAME%.config.ini
@echo weda_top=%weda_top%>>%FILENAME%.config.ini
@echo wedb_left=%wedb_left%>>%FILENAME%.config.ini
@echo wedb_top=%wedb_top%>>%FILENAME%.config.ini
ECHO Saving new coordinates to %PARENT%output\%FILENAME%.config.ini
PAUSE
GOTO MENU



:EXIT
ENDLOCAL
ECHO Shutting down generator...
EXIT /b 0