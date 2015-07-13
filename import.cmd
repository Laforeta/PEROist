REM Identify integrity and file class by extracting images 1 and 17
REM If image 1 is not extracted move the file to \error\
REM If image 17 is not extracted consider it abyssal
REM The order is important as a file could have mismatching tags in 1. 
@ECHO OFF
SETLOCAL
SET ME=%~n0
SET PARENT=%~dp0

REM Why does this work? what is %h defined as here? 
MKDIR "%PARENT%error"
MKDIR "%PARENT%temp\abyssal"
MKDIR "%PARENT%temp\kanmusu"
SET BLOCKSIZE=5
FOR /F "tokens=1* delims=[]" %%g in ('DIR /A-D /B *.swf ^|find /v /n ""') DO (
	MOVE "%%~nxh" "%PARENT%temp"
	ECHO Importing file %%g of %BLOCKSIZE%...
	if %%g==%BLOCKSIZE% GOTO SORTING
)

:SORTING
CD temp
For %%f in (*.swf) DO (
	java -jar "%PARENT%bin\ffdec\ffdec.jar" -onerror ignore -format image:png -selectid 1 -export image "%PARENT%temp" "%%f"
	java -jar "%PARENT%bin\ffdec\ffdec.jar" -onerror ignore -format image:png -selectid 17 -export image "%PARENT%temp" "%%f"
	IF NOT EXIST "%PARENT%temp\1.png" (
		ECHO Failed to detect file type of %%f, skipping this file...>con
		ECHO Failed to detect file type of %%f, skipping this file...
		COPY "%%f" "%PARENT%error\"
	) ELSE IF NOT EXIST "%PARENT%temp\17.png" (
		ECHO Detecting file type of %%f...>con
		ECHO Detecting file type of %%f...
		COPY "%%f" "%PARENT%temp\abyssal\"
	) ELSE (
		ECHO Detecting file type of %%f...>con
		ECHO Detecting file type of %%f
		COPY "%%f" "%PARENT%temp\kanmusu\"
	)
	DEL /q "%PARENT%temp\*.png"
)

ENDLOCAL
EXIT /B 0