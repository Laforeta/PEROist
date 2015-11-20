@ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION ENABLEEXTENSIONS
SET ME=%~n0
SET PARENT=%~dp0

REM Define location of wget binary
PATH %cd%\bin

REM Check for cache list updates
ECHO Updating CacheList.txt...
CD data
wget http://laforeta.github.io/CacheList.txt -N
if %errorlevel% neq 0 (
	ECHO Warning: Could not fetch the latest version of CacheList.txt
	ECHO The latest local copy will be used, however it may be out of date
	PAUSE
) ELSE ( 
	ECHO CacheList.txt is up to date
)
CD ..

REM Define ship lists
SET SHIPLIST="%PARENT%data\shiplist.txt"
SET CACHELIST="%PARENT%data\cachelist.txt"

REM Create Download Folder
IF NOT EXIST download MKDIR download

REM Define server IP
SET "server0=203.104.209.102"  ::Hashirajima
SET "server1=203.104.209.71"    ::Yosuoka
SET "server2=125.6.184.15"      ::Kure
SET "server3=125.6.184.16"      ::Sasebo
SET "server4=125.6.187.205"     ::Maizuru
SET "server5=125.6.187.229"     ::Oominato
SET "server6=125.6.187.253"     ::Truk
SET "server7=125.6.188.25"      ::Lingga
SET "server8=203.104.248.135"   ::Rabaul
SET "server9=125.6.189.7"       ::Shortland
SET "server10=125.6.189.39"     ::Buin
SET "server11=125.6.189.71"     ::Tawi-Tawi
SET "server12=125.6.189.103"    ::Palau
SET "server13=125.6.189.135"    ::Brunei
SET "server14=125.6.189.167"    ::Hitokappu
SET "server15=125.6.189.215"    ::Paramushir
SET "server16=125.6.189.247"    ::Sukumo
SET "server17=203.104.209.23"   ::Kanoya
SET "server18=203.104.209.39"   ::Iwakawa
SET "server19=203.104.209.55"   ::Saiki



:Menu
@ECHO OFF
CLS
ECHO.
ECHO 		#####################
ECHO 		PEROist Cache Manager
ECHO 		#####################
ECHO.
ECHO 1 - Preload/Update complete cache
ECHO 2 - Download individual sprite file
ECHO 3 - Download sprites using /data/shiplist.txt
ECHO 4 - Test Network Connectivity
ECHO 0 - Quit
ECHO.
ECHO Choose from one of the options above and press enter:
SET "OPTION="
SET /p OPTION=[1,2,3,4,0]
IF /i '%OPTION%'=='0' (
	GOTO EXIT
) ELSE IF /i '%OPTION%'=='1' (
	GOTO FULL_DOWNLOAD
) ELSE IF /i '%OPTION%'=='2' (
    GOTO SINGLE_DOWNLOAD
) ELSE IF /i '%OPTION%'=='3' (
    GOTO LIST_DOWNLOAD
) ELSE IF /i '%OPTION%'=='4' (
    GOTO SERVER_SELECT
) ELSE (
	ECHO Please choose a valid option from the list above
	PAUSE
	GOTO MENU
)
GOTO MENU

:SERVER_SELECT
REM User-select server IP
ECHO Which server do you belong to? 
ECHO [1]  Yosuoka       [2]  Kure
ECHO [3]  Sasebo        [4]  Maizuru
ECHO [5]  Oominato      [6]  Truk
ECHO [7]  Lingga        [8]  Rabaul
ECHO [9]  Shortland     [10] Buin
ECHO [11] Tawi-Tawi     [12] Palau
ECHO [13] Brunei        [14] Hitokappu
ECHO [15] Paramushir    [16] Sukumo
ECHO [17] Kanoya        [18] Iwakawa
ECHO [19] Saiki         [20] Hashirajima
ECHO Please enter the number of your server below, or enter 0 to go back to the previous menu:
SET /p SERVER_NUMBER=[0-20]
IF /i '%SERVER_NUMBER%'=='0' (
	GOTO MENU
) ELSE IF /i '%SERVER_NUMBER%'=='20' (
	SET SERVER_IP=%server0%
) ELSE ( 
	CALL SET SERVER_IP=%%server!SERVER_NUMBER!%%
)

REM Test DMM.com reachability
ECHO Testing connectivity to DMM.com
ECHO.
wget -O - dmm.com >nul 2>nul
IF %errorlevel% equ 0 (
	ECHO 	-------
	ECHO 	Success
	ECHO 	-------
) ELSE (
	ECHO 	Fail
)
ECHO.

REM Test KC frontend server reacheability
ECHO Testing connectivity to KC API server
ECHO.
wget -O - 203.104.209.7 >nul 2>nul
IF %errorlevel% equ 0 (
	ECHO 	-------
	ECHO 	Success
	ECHO 	-------
) ELSE (
	ECHO 	Fail
)
ECHO.

REM Test Game server reacheability
ECHO Testing connectivity to KC game server
ECHO.
wget -O - %SERVER_IP% >nul 2>nul
IF %errorlevel% equ 0 ( 
	ECHO 	-------
	ECHO 	Success
	ECHO 	-------
) ELSE (
	ECHO 	Fail
)
ECHO.

ECHO Measuring download speed...
wget -O - %SERVER_IP%/kcs/scenes/BattleMain.swf >nul 2>_response.txt
ECHO.

FOR /f "tokens=2 skip=8 delims=()" %%g in ('TYPE _response.txt') DO (
	IF %errorlevel% neq 0 (
		ECHO Test failed
	) ELSE (
		ECHO Downlink speed is %%g
	)
)
ECHO.
PAUSE
DEL /q _response.txt
GOTO MENU

:FULL_DOWNLOAD
CD download
IF NOT EXIST kcs (
	ECHO You are about to download a complete copy of Kancolle cache files
	ECHO This process will consume ~700MB of data and depending on your internet speed may last from 30 minutes to 2 hours.
	ECHO Do you wish to proceed?
) ELSE (
	ECHO It appears that a full or partial copy of cache is already present
	ECHO Your cache will be updated for any files added or changed since the last run
	ECHO Do you wish to proceed?
)
SET /p OPTION2=[y/n]
IF /i %OPTION2% neq y GOTO MENU
FOR /F %%g in ('type %CACHELIST%') DO (
	SET /a counter+=1
	SET /a pointer=counter%%20
	CALL SET "server=%%server!pointer!%%"
	wget http://!server!/%%g -N -x -nH -w 3
)
ECHO Download Complete
ECHO Complete cache set saved in %CD%download\kcs
PAUSE
GOTO MENU

:SINGLE_DOWNLOAD
CD download
ECHO Please enter the file name of the sprite to be downloaded without extensions
ECHO e.g. joaeulumcgbh
SET /p FILENAME=
wget http://203.104.209.102/kcs/resources/swf/ships/%FILENAME%.swf
if %errorlevel% neq 0 (
	ECHO Download failed
) ELSE ( 
	ECHO Download successful
)
PAUSE
GOTO MENU

:LIST_DOWNLOAD

ECHO Please add the ship sprite files you wish to download without extension names
ECHO in /data/shiplist.txt, for example:
ECHO.
ECHO dkmxevqgbxmr
ECHO cayfwlehtvgj
ECHO aejfywpsegbv
ECHO uuilouoffjoj
ECHO wvkpfygaipjq
ECHO.
ECHO And press y when you are ready to proceed.
SET /p OPTION2=[y/n]
IF /i %OPTION2% neq y GOTO MENU
CD download
FOR /F %%G in ('type %SHIPLIST%') DO (
	SET /a counter+=1
	SET /a pointer=counter%%20
	CALL SET "server=%%server!pointer!%%"
	wget http://!server!/kcs/resources/swf/ships/%%G.swf -w 1
)
ECHO Download Complete
PAUSE
GOTO MENU


:EXIT
ENDLOCAL
ECHO -----------------
ECHO End of the script
ECHO -----------------
PAUSE
EXIT /b 0
