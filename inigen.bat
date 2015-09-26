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
CD output
IF NOT EXIST *.hack.swf (
	ECHO No mod packs found, generator will now quit
	PAUSE
	GOTO EXIT
) ELSE ( 
	FOR /f "tokens=1 delims=." %%g IN ('DIR /b *.hack.swf') DO (
		ECHO Found file %%g.hack.swf, analysing...
		COPY "%%g.hack.swf" "%%PARENT%%temp"
		java -jar "%PARENT%bin\ffdec\ffdec.jar" -format image:png -export image "%PARENT%temp\%%g.hack.swf_images" "%%g.hack.swf"
		%IM% "%PARENT%temp\%%g.hack.swf_images\17.png" -resize 102%% "%PARENT%temp\%%g.hack.swf_images\17_102.png"
		%IM% "%PARENT%temp\%%g.hack.swf_images\17.png" -resize 174.75%% "%PARENT%temp\%%g.hack.swf_images\17_175.png"
		%IM% "%PARENT%temp\%%g.hack.swf_images\19.png" -resize 102%% "%PARENT%temp\%%g.hack.swf_images\19_102.png"
		SET FILENAME=%%g
		ECHO Finished analysing !FILENAME!.hack.swf
	)
	CD %PARENT%temp
)

REM Add the ability to parse api_start and existing file later, for now use an approximate starting value
:INIT
IF EXIST "%PARENT%input\%FILENAME%.config.ini" (
	ECHO Loading user-supplied config file...
	FOR /f "tokens=1* delims=^=" %%f IN ('FIND "=" "%PARENT%input\%FILENAME%.config.ini"') DO (
		SET %%f=%%g
	)
) ELSE IF EXIST "%PARENT%data\GraphList.txt" (
	ECHO Finding offsets in GraphList.txt
	FOR /f "tokens=8-11 delims=," %%g IN ('FIND "%FILENAME%" "%PARENT%data\GraphList.txt"') DO (
		SET boko_n_left=%%g
		SET boko_n_top=%%h
		SET boko_d_left=%%i
		SET boko_d_top=%%j
	)
	FOR /f "tokens=12-15 delims=," %%g IN ('FIND "%FILENAME%" "%PARENT%data\GraphList.txt"') DO (
		SET map_n_left=%%g
		SET map_n_top=%%h
		SET map_d_left=%%i
		SET map_d_top=%%j
	)
	FOR /f "tokens=16-19 delims=," %%g IN ('FIND "%FILENAME%" "%PARENT%data\GraphList.txt"') DO (
		SET battle_n_left=%%g
		SET battle_n_top=%%h
		SET battle_d_left=%%i
		SET battle_d_top=%%j
	)
	FOR /f "tokens=20-25 delims=," %%g IN ('FIND "%FILENAME%" "%PARENT%data\GraphList.txt"') DO (
		SET ensyuf_n_left=%%g
		SET ensyuf_n_top=%%h
		SET ensyuf_d_left=%%i
		SET ensyuf_d_top=%%j
		SET ensyue_n_left=%%k
		SET ensyue_n_top=%%l
	)
	FOR /f "tokens=26-29 delims=," %%g IN ('FIND "%FILENAME%" "%PARENT%data\GraphList.txt"') DO (
		SET kaizo_n_left=%%g
		SET kaizo_n_top=%%h
		SET kaizo_d_left=%%i
		SET kaizo_d_top=%%j
	)
	FOR /f "tokens=30-31 delims=," %%g IN ('FIND "%FILENAME%" "%PARENT%data\GraphList.txt"') DO (
		SET kaisyu_n_left=%%g
		SET kaisyu_n_top=%%h
	)
	FOR /f "tokens=30* delims=," %%A IN ('FIND "%FILENAME%" "%PARENT%data\GraphList.txt"') DO (
		FOR /f "tokens=1-7* delims=," %%a IN ("%%B") DO (
			SET kaisyu_d_left=%%b
			SET kaisyu_d_top=%%c
			SET weda_left=%%d
			SET weda_top=%%e
			SET wedb_left=%%f
			SET wedb_top=%%g
		)
	)
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
ECHO 5 - Preview and change wedding offsets
ECHO 6 - Display current values [and manually enter offset values]
ECHO 7 - Write offset data as APImodifier.json [NOT WORKING YET]
ECHO 8 - Write offset data as %FILENAME%.config.ini
ECHO 9 - Abandon all changes and reload initial values
ECHO 0 - Quit
ECHO.
ECHO Choose from one of the options above and press enter:
SET "OPTION="
SET /p OPTION=[1,2,3,4,5,6,7,8,9,0]
IF /i '%OPTION%'=='0' (
	GOTO EXIT
) ELSE IF /i '%OPTION%'=='1' (
	SET BACKGROUND="%PARENT%data\room.png"
	SET SPRITE="%PARENT%temp\!FILENAME!.hack.swf_images\17_102.png"
	SET ALIAS="standard"
	SET /a ORIGIN_X=327
	SET /a ORIGIN_Y=-65
	SET /a CURRENT_X=%boko_n_left%
	SET /a CURRENT_Y=%boko_n_top%
	SET NEW_X=boko_n_left
	SET NEW_Y=boko_n_top
	SET DELTA=1
	GOTO PROCESS
) ELSE IF /i '%OPTION%'=='2' (
	SET BACKGROUND="%PARENT%data\room.png"
	SET SPRITE="%PARENT%temp\!FILENAME!.hack.swf_images\19_102.png"
	SET ALIAS="battledamage"
	SET /a ORIGIN_X=327
	SET /a ORIGIN_Y=-65
	SET /a CURRENT_X=%boko_d_left%
	SET /a CURRENT_Y=%boko_d_top%
	SET NEW_X=boko_d_left
	SET NEW_Y=boko_d_top
	SET DELTA=2
	GOTO PROCESS
) ELSE IF /i '%OPTION%'=='3' (
	SET BACKGROUND="%PARENT%data\kaisyu_panel.png"
	SET SPRITE="%PARENT%temp\!FILENAME!.hack.swf_images\13.png"
	SET ALIAS="standard"
	SET /a ORIGIN_X=50
	SET /a ORIGIN_Y=70
	SET /a CURRENT_X=%kaisyu_n_left%
	SET /a CURRENT_Y=%kaisyu_n_top%
	SET NEW_X=kaisyu_n_left
	SET NEW_Y=kaisyu_n_top
	SET DELTA=0
	GOTO PROCESS
) ELSE IF /i '%OPTION%'=='4' (
	SET BACKGROUND="%PARENT%data\kaisyu_panel.png"
	SET SPRITE="%PARENT%temp\!FILENAME!.hack.swf_images\15.png"
	SET ALIAS="battledamage"
	SET /a ORIGIN_X=50
	SET /a ORIGIN_Y=70
	SET /a CURRENT_X=%kaisyu_d_left%
	SET /a CURRENT_Y=%kaisyu_d_top%
	SET NEW_X=kaisyu_d_left
	SET NEW_Y=kaisyu_d_top
	SET DELTA=0
	GOTO PROCESS
) ELSE IF /i '%OPTION%'=='5' (
	SET BACKGROUND="%PARENT%data\chapel.png"
	SET SPRITE="%PARENT%temp\!FILENAME!.hack.swf_images\17_175.png"
	SET ALIAS="wedding"
	SET /a ORIGIN_X=400
	SET /a ORIGIN_Y=10
	SET /a CURRENT_WEDA_X=%weda_left%
	SET /a CURRENT_WEDA_Y=%weda_top%
	SET /a CURRENT_WEDB_X=%wedb_left%
	SET /a CURRENT_WEDB_Y=%wedb_top%
	SET NEW_WEDA_X=weda_left
	SET NEW_WEDA_Y=weda_top
	SET NEW_WEDB_X=wedb_left
	SET NEW_WEDB_Y=wedb_top
	GOTO WEDDING
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
ECHO kaisyu_n_left=%kaisyu_n_left%
ECHO kaisyu_n_top=%kaisyu_n_top%
ECHO kaisyu_d_left=%kaisyu_d_left%
ECHO kaisyu_d_top=%kaisyu_d_top%
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

:WEDDING
REM Batch cannot do floating point calculations, hence 699/400 is used as a scaling factor instead of 1.7475 and errors should be neglegible
SET /a ANCHOR_X=%ORIGIN_X%-(%CURRENT_WEDA_X%+%CURRENT_WEDB_X%/2)*699/400
SET /a ANCHOR_Y=%ORIGIN_Y%-%CURRENT_WEDA_Y%*699/400
ECHO Generating preview based on current values (%ANCHOR_X%,%ANCHOR_Y%)
%IM% !BACKGROUND! !SPRITE! -geometry +!ANCHOR_X!+!ANCHOR_Y! -composite Preview_NoRing.jpg
%IM% Preview_NoRing.jpg "%PARENT%data\ring.png" -geometry +320+270 -composite Preview_!ALIAS!_!CURRENT_X!_!CURRENT_Y!.jpg
START %VIEWER% "%PARENT%temp\Preview_!ALIAS!_!CURRENT_X!_!CURRENT_Y!.jpg"
ECHO Special Instructions for changing wedding scene offsets:
ECHO Unlike other values, wedding offsets has 4 values
ECHO weda defines the XY origins of a rectangle covering the face area of your waifu-to-be
ECHO wedb defines the pixel length of two edges of the rectangle
ECHO changes to wedb_top (face height) may appear to have no effect because it is unused for this particular view...
ECHO ...however it will affect other views from the wedding cutscenes
ECHO Are you happy with the results? 
SET /p ACCEPT=[y/n]
IF /i %ACCEPT%==y GOTO MENU
CLS
REM First give new values for currently selected variables
ECHO Current %NEW_WEDA_X% is %CURRENT_WEDA_X%
ECHO Please enter a new value for %NEW_WEDA_X%:
SET /p !NEW_WEDA_X!=
ECHO Current %NEW_WEDA_Y% is %CURRENT_WEDA_Y%
ECHO Please enter a new value for %NEW_WEDA_Y%:
SET /p !NEW_WEDA_Y!=
ECHO Current %NEW_WEDB_X% is %CURRENT_WEDB_X%
ECHO Please enter a new value for %NEW_WEDB_X%:
SET /p !NEW_WEDB_X!=
ECHO Current %NEW_WEDB_Y% is %CURRENT_WEDB_Y%
ECHO Please enter a new value for %NEW_WEDB_Y%:
SET /p !NEW_WEDB_Y!=
GOTO Wedding


:PROCESS
SET /a ANCHOR_X=%ORIGIN_X%+%CURRENT_X%
SET /a ANCHOR_Y=%ORIGIN_Y%+%CURRENT_Y%
ECHO Generating preview based on current values (%CURRENT_X%,%CURRENT_Y%)
%IM% !BACKGROUND! !SPRITE! -geometry +!ANCHOR_X!+!ANCHOR_Y! -composite Preview_NoMask.jpg
%IM% Preview_NoMask.jpg "%PARENT%data\room_mask.png" -geometry +0+0 -composite Preview_!ALIAS!_!CURRENT_X!_!CURRENT_Y!.jpg
START %VIEWER% "%PARENT%temp\Preview_!ALIAS!_!CURRENT_X!_!CURRENT_Y!.jpg"
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
	SET /a DELTA_X=!NEW_X!-!CURRENT_X!
	SET /a DELTA_Y=!NEW_Y!-!CURRENT_Y!
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
	SET /a DELTA_X=!NEW_X!-!CURRENT_X!
	SET /a DELTA_Y=!NEW_Y!-!CURRENT_Y!
	SET /a map_d_left=!map_d_left!+!DELTA_X!
	SET /a map_d_top=!map_d_top!+!DELTA_Y!
	SET /a battle_d_left=!battle_d_left!+!DELTA_X!
	SET /a battle_d_top=!battle_d_top!+!DELTA_Y!
	SET /a ensyuf_d_left=!ensyuf_d_left!+!DELTA_X!
	SET /a ensyuf_d_top=!ensyuf_d_top!+!DELTA_Y!
	SET /a kaizo_d_left=!kaizo_d_left!+!DELTA_X!
	SET /a kaizo_d_top=!kaizo_d_top!+!DELTA_Y!
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
ECHO Write offset data for 74EO [NOT WORKING]
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
@echo boko_n_left=!boko_n_left!>>%FILENAME%.config.ini
@echo boko_n_top=!boko_n_top!>>%FILENAME%.config.ini
@echo boko_d_left=!boko_d_left!>>%FILENAME%.config.ini
@echo boko_d_top=!boko_d_top!>>%FILENAME%.config.ini
@echo map_n_left=!map_n_left!>>%FILENAME%.config.ini
@echo map_n_top=!map_n_top!>>%FILENAME%.config.ini
@echo map_d_left=!map_d_left!>>%FILENAME%.config.ini
@echo map_d_top=!map_d_top!>>%FILENAME%.config.ini
@echo battle_n_top=!battle_n_top!>>%FILENAME%.config.ini
@echo battle_n_left=!battle_n_left!>>%FILENAME%.config.ini
@echo battle_d_top=!battle_d_top!>>%FILENAME%.config.ini
@echo battle_d_left=!battle_d_left!>>%FILENAME%.config.ini
@echo ensyuf_n_left=!ensyuf_n_left!>>%FILENAME%.config.ini
@echo ensyuf_n_top=!ensyuf_n_top!>>%FILENAME%.config.ini
@echo ensyuf_d_left=!ensyuf_d_left!>>%FILENAME%.config.ini
@echo ensyuf_d_top=!ensyuf_d_top!>>%FILENAME%.config.ini
@echo ensyue_n_left=!ensyue_n_left!>>%FILENAME%.config.ini
@echo ensyue_n_top=!ensyue_n_top!>>%FILENAME%.config.ini
@echo kaizo_n_left=!kaizo_n_left!>>%FILENAME%.config.ini
@echo kaizo_n_top=!kaizo_n_top!>>%FILENAME%.config.ini
@echo kaizo_d_left=!kaizo_d_left!>>%FILENAME%.config.ini
@echo kaizo_d_top=!kaizo_d_top!>>%FILENAME%.config.ini
@echo kaisyu_n_left=!kaisyu_n_left!>>%FILENAME%.config.ini
@echo kaisyu_n_top=!kaisyu_n_top!>>%FILENAME%.config.ini
@echo kaisyu_d_left=!kaisyu_d_left!>>%FILENAME%.config.ini
@echo kaisyu_d_top=!kaisyu_d_top!>>%FILENAME%.config.ini
@echo weda_left=!weda_left!>>%FILENAME%.config.ini
@echo weda_top=!weda_top!>>%FILENAME%.config.ini
@echo wedb_left=!wedb_left!>>%FILENAME%.config.ini
@echo wedb_top=!wedb_top!>>%FILENAME%.config.ini
ECHO Saving new coordinates to %PARENT%output\%FILENAME%.config.ini
PAUSE
GOTO MENU



:EXIT
ENDLOCAL
ECHO Shutting down generator...
EXIT /b 0