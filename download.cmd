@ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION ENABLEEXTENSIONS
SET ME=%~n0
SET PARENT=%~dp0

REM Define location of wget binary
PATH %cd%\bin

REM Load ship lists
SET KANMUSU=%PARENT%src\kanmusu.txt
SET ABYSSAL=%PARENT%src\abyssal.txt

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

ECHO ----------------------------------
ECHO Press any key to start downloading
ECHO ----------------------------------
PAUSE

REM Download friendly ship sprites

MKDIR temp
CD temp
FOR /F %%G in ('type %KANMUSU%') DO (
	SET /a counter+=1
	SET /a pointer=counter%%20
	CALL SET "server=%%server!pointer!%%"
	wget http://!server!/kcs/resources/swf/ships/%%G.swf -w 1
)


REM Download Abyssal ship sprites (NOT WORKING YET)
REM DOWNLOAD ABYSSAL files to a separate folder for proper handling

CD %PARENT%temp
MKDIR abyssal
CD abyssal
FOR /F %%G in ('type %ABYSSAL%') DO (
	SET /a counter+=1
	SET /a pointer=counter%%20
	CALL SET "server=%%server!pointer!%%"
	wget http://!server!/kcs/resources/swf/ships/%%G.swf -w 1
)

ENDLOCAL
ECHO -----------------
ECHO Download Complete
ECHO -----------------
PAUSE
