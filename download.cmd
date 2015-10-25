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
SET "server0="203.104.209.102"  ::Hashirajima
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
ECHO 		############################
ECHO 		PEROist config.ini Generator
ECHO 		############################
ECHO.
ECHO 1 - Preload/Update complete cache
ECHO 2 - Download individual sprite file
ECHO 3 - Download sprites using /data/shiplist.txt
ECHO 0 - Quit
ECHO.
ECHO Choose from one of the options above and press enter:
SET "OPTION="
SET /p OPTION=[1,2,3,0]
IF /i '%OPTION%'=='0' (
	GOTO EXIT
) ELSE IF /i '%OPTION%'=='1' (
	GOTO FULL_DOWNLOAD
) ELSE IF /i '%OPTION%'=='2' (
    GOTO SINGLE_DOWNLOAD
) ELSE IF /i '%OPTION%'=='3' (
    GOTO LIST_DOWNLOAD
) ELSE (
	ECHO Please choose a valid option from the list above
	PAUSE
	GOTO MENU
)
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
