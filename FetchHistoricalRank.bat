@ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION ENABLEEXTENSIONS
SET ME=%~n0
SET PARENT=%~dp0
@ECHO Running %ME%

REM Set binary path
PATH %PARENT%bin

REM Get current date and set month as variable
FOR /f "tokens=1-3 delims=/ " %%g in ('doff mm/dd/yyyy') do (
	SET mm=%%g
	SET dd=%%h
	SET yyyy=%%i
)

CD DOWNLOAD

REM Download ranking results from 2013 (Jun to Dec, server 1-16) 
FOR /L %%G in (6,1,12) DO (
	SET MONTH=00%%G
	SET PADDED_MONTH=!MONTH:~-2!
	FOR /L %%G in (1,1,16) DO (
		SET SERVER=00%%G
		SET PADDED_SERVER=!SERVER:~-2!
		wget http://203.104.209.7/kcscontents/information/image/rank13!PADDED_MONTH!!PADDED_SERVER!.jpg
		)
)

REM Download ranking results from 2013 (Jan to Dec, server 1-19) 
FOR /L %%G in (1,1,12) DO (
	SET MONTH=00%%G
	SET PADDED_MONTH=!MONTH:~-2!
	FOR /L %%G in (1,1,19) DO (
		SET SERVER=00%%G
		SET PADDED_SERVER=!SERVER:~-2!
		wget http://203.104.209.7/kcscontents/information/image/rank14!PADDED_MONTH!!PADDED_SERVER!.jpg
		)
)

REM Download ranking results from 2013 (Jan to Dec, server 1-20) 
FOR /L %%G in (1,1,12) DO (
	SET MONTH=00%%G
	SET PADDED_MONTH=!MONTH:~-2!
	FOR /L %%G in (1,1,20) DO (
		SET SERVER=00%%G
		SET PADDED_SERVER=!SERVER:~-2!
		wget http://203.104.209.7/kcscontents/information/image/rank15!PADDED_MONTH!!PADDED_SERVER!.jpg
		)
)

REM Download ranking results from 2016 (Not active yet) 

FOR /L %%G in (1,1,20) DO (


:EXIT
EXIT /b 0	