@ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION ENABLEEXTENSIONS
SET ME=%~n0
SET PARENT=%~dp0

ECHO Exporting files...>con

FOR /f "tokens=1 delims=." %%g in ('DIR /A:-D /B "%PARENT%temp\kanmusu\*.hack.swf"') DO (
	ECHO Exporting %%g.hack.swf...
	COPY /y "%PARENT%temp\kanmusu\%%g.hack.swf" "%PARENT%output" && DEL /q "%PARENT%temp\kanmusu\%%g.hack.swf"
	DEL /q "%PARENT%temp\kanmusu\%%g.swf"
	DEL /q "%PARENT%\%%g.swf"
)
MOVE /y "%PARENT%temp\kanmusu\*.swf" "%PARENT%error"

FOR /f "tokens=1 delims=." %%g in ('DIR /A:-D /B "%PARENT%temp\abyssal\*.hack.swf"') DO (
	ECHO Exporting %%g.hack.swf...
	COPY /y "%PARENT%temp\abyssal\%%g.hack.swf" "%PARENT%output" &&	DEL /q "%PARENT%temp\abyssal\%%g.hack.swf"
	DEL /q "%PARENT%temp\abyssal\%%g.swf"
	DEL /q "%PARENT%\%%g.swf"
)
MOVE /y "%PARENT%temp\abyssal\*.swf" "%PARENT%error"

FOR /f "tokens=1 delims=." %%g in ('DIR /A:-D /B "%PARENT%temp\kanmusu_mod\*.hack.out"') DO (
	ECHO Exporting %%g.hack.swf...
	COPY /y "%PARENT%temp\kanmusu_mod\%%g.hack.out" "%PARENT%output\%%g.hack.swf" && DEL /q "%PARENT%temp\kanmusu_mod\%%g.hack.out"
	DEL /q "%PARENT%temp\kanmusu_mod\%%g.hack.swf"
	DEL /q "%PARENT%\%%g.hack.swf"
)
MOVE /y "%PARENT%temp\kanmusu_mod\*.swf" "%PARENT%error"

FOR /f "tokens=1 delims=." %%g in ('DIR /A:-D /B "%PARENT%temp\abyssal_mod\*.hack.out"') DO (
	ECHO Exporting %%g.hack.swf...
	COPY /y "%PARENT%temp\abyssal_mod\%%g.hack.out" "%PARENT%output\%%g.hack.swf" && DEL /q "%PARENT%temp\abyssal_mod\%%g.hack.out"
	DEL /q "%PARENT%temp\abyssal_mod\%%g.hack.swf"
	DEL /q "%PARENT%\%%g.hack.swf"
)
MOVE /y "%PARENT%temp\abyssal_mod\*.swf" "%PARENT%error"

CD "%PARENT%temp\special"
REN *.swf *.hack.swf
FOR /f "tokens=1 delims=." %%g in ('DIR /A:-D /B "%PARENT%temp\special\*.hack.swf"') DO (
	ECHO Exporting %%g.hack.swf...
	COPY /y "%PARENT%temp\special\%%g.hack.swf" "%PARENT%output\%%g.hack.swf"
	DEL /q "%PARENT%temp\special\%%g.hack.swf"
)
MOVE /y "%PARENT%temp\special\*.swf" "%PARENT%error"

REM Remove temp folder to prevent issues in repeat loops
CD %PARENT%
RD /s /q temp

ENDLOCAL
