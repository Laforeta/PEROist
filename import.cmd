REM Identify integrity and file class by extracting images 1 and 17
REM If image 1 is not extracted move the file to \error\
REM If image 17 is not extracted consider it abyssal
REM The order is important as a file could have mismatching tags in 1. 
@ECHO OFF
SETLOCAL
SET ME=%~n0
SET PARENT=%~dp0

MKDIR "%PARENT%error"
MKDIR "%PARENT%temp\abyssal"
For %%f in (*.swf) DO (
	java -jar "%PARENT%bin\ffdec\ffdec.jar" -onerror ignore -format image:png -selectid 1 -export image "%PARENT%temp" "%%f"
	java -jar "%PARENT%bin\ffdec\ffdec.jar" -onerror ignore -format image:png -selectid 17 -export image "%PARENT%temp" "%%f"
	IF NOT EXIST "%PARENT%temp\1.png" (
		ECHO Failed to import %%f, skipping this file...>con
		ECHO Failed to import %%f, skipping this file...
		COPY "%%f" "%PARENT%error\"
	) ELSE IF NOT EXIST "%PARENT%temp\17.png" (
		ECHO Importing %%f...>con
		ECHO Importing %%f...
		COPY "%%f" "%PARENT%temp\abyssal\"
	) ELSE (
		ECHO Importing %%f...>con
		ECHO Importing %%f
		COPY "%%f" "%PARENT%temp\"
	)
	DEL /q "%PARENT%temp\*.png"
)

ENDLOCAL
EXIT /B 0