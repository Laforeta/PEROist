@ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION ENABLEEXTENSIONS
SET ME=%~n0
SET PARENT=%~dp0
@ECHO Running %ME%

REM Declare binary paths
SET IM="%PARENT%bin\convert.exe"

REM Prepare folders if not already present
CALL CLEANUP.cmd
IF NOT EXIST temp MKDIR temp
IF NOT EXIST input MKDIR input
IF NOT EXIST output MKDIR output

REM Load sprite and extract image to generate preview
REM COPY operation somehow not working
CD input
FOR /f "tokens=1 delims=." %%g IN ('DIR /b *.swf') DO (
	ECHO Found file %%g.swf, analysing...
	java -jar "%PARENT%bin\ffdec\ffdec.jar" -format image:png -export image "%PARENT%temp\%%g.swf_images" "%PARENT%\input\%%g.swf"
	SET FILENAME=%%g
	FOR /f "tokens=30* delims=," %%A IN ('FIND "!FILENAME!" "%PARENT%data\GraphList.txt"') DO (
		FOR /f "tokens=1-7* delims=," %%a IN ("%%B") DO (
			SET kaisyu_d_left=%%b
			SET kaisyu_d_top=%%c
			SET /a weda_left=%%d-%%g*3/2/2+%%f/2
			SET weda_top=%%e
			SET /a wedb_left=%%g*3/2
			SET /a wedb_top=%%g*3/2
		)
	)
	FOR /f "tokens=1-2 delims=," %%g IN ('FIND "!FILENAME!" "%PARENT%data\GraphList.txt"') DO (
		SET shipID=%%h
		SET sortID=%%g
	)
	%IM% "%PARENT%temp\!FILENAME!.swf_images\17.png" -crop !wedb_left!x!wedb_top!+!weda_left!+!weda_top! "%PARENT%\output\avatar_!sortID!_!shipID!.png" && 	DEL "%PARENT%\input\%%g.swf"
	ECHO Finished with !FILENAME!.swf
)
CD %PARENT%
CALL CLEANUP.cmd

EXIT /B 0