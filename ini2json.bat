@ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION ENABLEEXTENSIONS
SET ME=%~n0
SET PARENT=%~dp0
@ECHO Running %ME%

CALL CLEANUP.cmd 2>nul
IF NOT EXIST temp MKDIR temp
IF NOT EXIST input MKDIR input
IF NOT EXIST output MKDIR output

:SELECT
REM Change workdir to input and call conversion for all *.config.ini files there
CD "%PARENT%input"
IF NOT EXIST *.config.ini (
	ECHO No ini files to process
	GOTO :EXIT
) ELSE (
	FOR /f "tokens=1 delims=." %%g in ('DIR /b *.config.ini') DO (
	ECHO Converting \input\%%g
	CALL :CONVERT %%g
	)
)

REM Scan the output for incomplete paired values
CD "%PARENT%output"
FOR /f "tokens=3 delims=:^ " %%g IN ('FIND /c *.txt ",]"') DO (
	IF %%g NEQ 0 (
		ECHO WARNING: The output file shown below contains one or more incomplete value pairs!
		FIND !FILENAME!.txt ",]"
		ECHO.
		ECHO The affected line^(s^) must be manually completed or removed before use 
		PAUSE
	)
)

:EXIT
ENDLOCAL
ECHO Shutting down...
EXIT /b 0

:CONVERT
REM Reinit variables from previous conversion
SET "ship_name="
SET "boko_n_left=" 
SET "boko_n_top=" 
SET "boko_d_left="
SET "boko_d_top="
SET "map_n_left="
SET "map_n_top="
SET "map_d_left="
SET "map_d_top="
SET "battle_d_top="
SET "battle_d_left="
SET "battle_n_top="
SET "battle_n_left="
SET "ensyuf_n_left="
SET "ensyuf_n_top="
SET "ensyuf_d_left="
SET "ensyuf_d_top="
SET "ensyue_n_left="
SET "ensyue_n_top="
SET "kaizo_n_left="
SET "kaizo_n_top="
SET "kaizo_d_left="
SET "kaizo_d_top="
SET "kaisyu_n_left="
SET "kaisyu_n_top="
SET "kaisyu_d_left="
SET "kaisyu_d_top="
SET "weda_left="
SET "weda_top="
SET "wedb_left="
SET "wedb_top="

REM Scan input folder for .config.ini files
SET FILENAME=%~nx1
FOR /f "tokens=1* delims=^=" %%g IN ('TYPE !FILENAME!.config.ini') DO (
	SET %%g=%%h
)

REM Change working directory to output and write files there
CD "%PARENT%output"
ECHO {>%FILENAME%.txt
IF DEFINED ship_name ECHO   "api_mst_ship":{>>%FILENAME%.txt
IF DEFINED ship_name ECHO	  "api_name":"!ship_Name!">>%FILENAME%.txt
IF DEFINED ship_name ECHO	},>>%FILENAME%.txt
ECHO   "api_mst_shipgraph": {>>%FILENAME%.txt
IF DEFINED boko_n_left ECHO     "api_boko_n": [!boko_n_left!,!boko_n_top!],>>%FILENAME%.txt
IF DEFINED boko_d_left ECHO     "api_boko_d": [!boko_d_left!,!boko_d_top!],>>%FILENAME%.txt
IF DEFINED kaisyu_n_left ECHO     "api_kaisyu_n": [!kaisyu_n_left!,!kaisyu_n_top!],>>%FILENAME%.txt
IF DEFINED kaisyu_d_left ECHO     "api_kaisyu_d": [!kaisyu_d_left!,!kaisyu_d_top!],>>%FILENAME%.txt
IF DEFINED kaizo_n_left ECHO     "api_kaizo_n": [!kaizo_n_left!,!kaizo_n_top!],>>%FILENAME%.txt
IF DEFINED kaizo_d_left ECHO     "api_kaizo_d": [!kaizo_d_left!,!kaizo_d_top!],>>%FILENAME%.txt
IF DEFINED map_n_left ECHO     "api_map_n": [!map_n_left!,!map_n_top!],>>%FILENAME%.txt
IF DEFINED map_d_left ECHO     "api_map_d": [!map_d_left!,!map_d_top!],>>%FILENAME%.txt
IF DEFINED ensyuf_n_left ECHO     "api_ensyuf_n": [!ensyuf_n_left!,!ensyuf_n_top!],>>%FILENAME%.txt
IF DEFINED ensyuf_d_left ECHO     "api_ensyuf_d": [!ensyuf_d_left!,!ensyuf_d_top!],>>%FILENAME%.txt
IF DEFINED ensyue_n_left ECHO     "api_ensyue_n": [!ensyue_n_left!,!ensyue_n_top!],>>%FILENAME%.txt
IF DEFINED battle_n_left ECHO     "api_battle_n": [!battle_n_left!,!battle_n_top!],>>%FILENAME%.txt
IF DEFINED battle_d_left ECHO     "api_battle_d": [!battle_d_left!,!battle_d_top!],>>%FILENAME%.txt
IF DEFINED weda_left ECHO     "api_weda": [!weda_left!,!weda_top!],>>%FILENAME%.txt
IF DEFINED wedb_left ECHO     "api_wedb": [!wedb_left!,!wedb_top!]>>%FILENAME%.txt
ECHO   }>>%FILENAME%.txt
ECHO }>>%FILENAME%.txt

REM Check whether file is successfully written
IF EXIST %FILENAME%.txt (
	ECHO Coordinates successfully exported to \output\%FILENAME%.txt
) ELSE (
	ECHO Write operation failed for %FILENAME%.txt
)

REM Change workdir back to input
CD "%PARENT%input"

GOTO:EOF