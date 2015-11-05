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
CD input
IF NOT EXIST *.config.ini (
	ECHO No ini files to process
) ELSE (
	FOR %%g in (*.config.ini) DO (
	ECHO Converting %%g
	ECHO CALL :CONVERT %%g
	PAUSE
	ECHO Conversion complete for %%g
	)
)

:EXIT
ENDLOCAL
ECHO Exiting...
EXIT /b 0

:CONVERT
REM Scan input folder for .config.ini files
FOR /f "tokens=1* delims=^=" %%g IN ('TYPE %~nx1') DO (
	ECHO %%g
	PAUSE
	SET FILENAME=%g
	SET %%f=%%g
)

@echo {>%FILENAME%.txt
REM @echo   "api_mst_ship":{>>%FILENAME%.txt
REM @echo	  "api_name":"!shipName!">>%FILENAME%.txt
REM @echo	},>>%FILENAME%.txt
@echo   "api_mst_shipgraph": {>>%FILENAME%.txt
@echo     "api_boko_n": [!boko_n_left!,!boko_n_top!],>>%FILENAME%.txt
@echo     "api_boko_d": [!boko_d_left!,!boko_d_top!],>>%FILENAME%.txt
@echo     "api_kaisyu_n": [!kaisyu_n_left!,!kaisyu_n_top!],>>%FILENAME%.txt
@echo     "api_kaisyu_d": [!kaisyu_d_left!,!kaisyu_d_top!],>>%FILENAME%.txt
@echo     "api_kaizo_n": [!kaizo_n_left!,!kaizo_n_top!],>>%FILENAME%.txt
@echo     "api_kaizo_d": [!kaizo_d_left!,!kaizo_d_top!],>>%FILENAME%.txt
@echo     "api_map_n": [!map_n_left!,!map_n_top!],>>%FILENAME%.txt
@echo     "api_map_d": [!map_d_left!,!map_d_top!],>>%FILENAME%.txt
@echo     "api_ensyuf_n": [!ensyuf_n_left!,!ensyuf_n_top!],>>%FILENAME%.txt
@echo     "api_ensyuf_d": [!ensyuf_d_left!,!ensyuf_d_top!],>>%FILENAME%.txt
@echo     "api_ensyue_n": [!ensyue_n_left!,!ensyue_n_top!],>>%FILENAME%.txt
@echo     "api_battle_n": [!battle_n_left!,!battle_n_top!],>>%FILENAME%.txt
@echo     "api_battle_d": [!battle_d_left!,!battle_d_top!],>>%FILENAME%.txt
@echo     "api_weda": [!weda_left!,!weda_top!],>>%FILENAME%.txt
@echo     "api_wedb": [!wedb_left!,!wedb_top!]>>%FILENAME%.txt
@echo   }>>%FILENAME%.txt
@echo }>>%FILENAME%.txt
IF EXIST %FILENAME%.txt (
	ECHO Coordinates successfully exported to %PARENT%output\%FILENAME%.txt
) ELSE (
	ECHO Write operation failed for %FILENAME%.txt
)
GOTO:EOF