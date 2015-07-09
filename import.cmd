@ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION ENABLEEXTENSIONS
SET ME=%~n0
SET PARENT=%~dp0

REM Identify sprite class by the existence of Character 25. 

MKDIR temp\abyssal
For %%f in (*.swf) DO (
	java -jar %PARENT%bin\ffdec\ffdec.jar -format image:png -selectid 25 -export image "%PARENT%temp" %%f
	IF NOT EXIST %PARENT%temp\25.png COPY %%f %PARENT%temp\abyssal
	IF EXIST %PARENT%temp\25.png COPY %%f %PARENT%temp
	DEL /q %PARENT%temp\25.png
)

ENDLOCAL
EXIT /B 0