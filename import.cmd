REM Identify sprite class by the existence of CharacterId 17
MKDIR error
MKDIR temp\abyssal
For %%f in (*.swf) DO (
	java -jar %PARENT%bin\ffdec\ffdec.jar -onerror ignore -format image:png -selectid 1 -export image "%PARENT%temp" %%f
	java -jar %PARENT%bin\ffdec\ffdec.jar -onerror ignore -format image:png -selectid 17 -export image "%PARENT%temp" %%f
	IF NOT EXIST %PARENT%temp\1.png (
		ECHO Failed to import %%f, skipping this file...>con
		ECHO Failed to import %%f, skipping this file...
		COPY %%f %PARENT%error 
	) ELSE IF NOT EXIST %PARENT%temp\17.png (
		ECHO Importing %%f...>con
		ECHO Importing %%f...
		COPY %%f %PARENT%temp\abyssal
	) ELSE (
		ECHO Importing %%f...>con
		ECHO Importing %%f
		COPY %%f %PARENT%temp
	)
	DEL /q %PARENT%temp\*.png
)

EXIT /B 0