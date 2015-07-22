@ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION ENABLEEXTENSIONS
SET ME=%~n0
SET PARENT=%~dp0

ECHO Exporting files...>con

FOR /f "tokens=1 delims=." %%g in ('DIR /A:-D /B "%PARENT%temp\kanmusu\*.hack.swf"') DO (
	ECHO Exporting %%g.hack.swf...
	MOVE /y "%PARENT%temp\kanmusu\%%g.hack.swf" "%PARENT%output"
	DEL /q "%PARENT%temp\kanmusu\%%g.swf"
	DEL /q "%PARENT%\%%g.swf"
)
MOVE /y "%PARENT%temp\kanmusu\*.swf" "%PARENT%error"

FOR /f "tokens=1 delims=." %%g in ('DIR /A:-D /B "%PARENT%temp\abyssal\*.hack.swf"') DO (
	ECHO Exporting %%g.hack.swf...
	MOVE /y "%PARENT%temp\abyssal\%%g.hack.swf" "%PARENT%output"
	DEL /q "%PARENT%temp\abyssal\%%g.swf"
	DEL /q "%PARENT%\%%g.swf"
)
MOVE /y "%PARENT%temp\abyssal\*.swf" "%PARENT%error"

FOR /f "tokens=1 delims=." %%g in ('DIR /A:-D /B "%PARENT%temp\abyssal_mod\*.hack.swf"') DO (
	ECHO Exporting %%g.hack.swf...
	MOVE /y "%PARENT%temp\abyssal_mod\%%g.hack.out" "%PARENT%output"
	DEL /q "%PARENT%temp\abyssal_mod\%%g.hack.out"
	DEL /q "%PARENT%\%%g.hack.swf"
)
MOVE /y "%PARENT%temp\kanmusu_mod\*.swf" "%PARENT%error"

FOR /f "tokens=1 delims=." %%g in ('DIR /A:-D /B "%PARENT%temp\abyssal_mod\*.hack.swf"') DO (
	ECHO Exporting %%g.hack.swf...
	MOVE /y "%PARENT%temp\abyssal_mod\%%g.hack.out" "%PARENT%output"
	DEL /q "%PARENT%temp\abyssal_mod\%%g.hack.out"
	DEL /q "%PARENT%\%%g.hack.swf"
)
MOVE /y "%PARENT%temp\abyssal_mod\*.swf" "%PARENT%error"

CD %PARENT%output
REN *.out *.swf

ENDLOCAL
