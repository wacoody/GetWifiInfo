@echo off
REM Last Updated: 3:56 PM 3/11/2021

:topp
cls

title Get Wifi Info

echo.Below is a list of known Wifi profiles. Please enter the number of the one you want to see the password for.

echo. && echo.


netsh wlan show profiles | find /i "All User Profile     :" > "%temp%\wifiout.txt"

setlocal enabledelayedexpansion

set /a count=0

for /f "usebackq tokens=1,2,3 delims=:" %%a in ("%temp%\wifiout.txt") do (
	set /a count=!count!+1
	
	set string[!count!]=%%b
	
	echo. !count! %%b
)
echo.
if defined err1 (echo.Invalid value entered. Please enter a valid choice.)
set /P "number=>> "
rem echo. !string[%number%]!

if /i %number% GTR !count! (set err1=1 && goto :topp)
if /i %number% EQU 0       (set err1=1 && goto :topp)
			REM Checksum does not account for multiple values "0 1" or a value with other text "0a".
			REM Could code for it but not worth it right now due to low probability of entry.

set ntwktmp=!string[%number%]!
	set ntwk=%ntwktmp:~1%

setlocal disabledelayedexpansion

echo. && echo.

echo.Your wifi credentials are:
echo.

netsh wlan show profile name="%ntwk%" key=clear | findstr /i /c:"key content" > "%temp%\wifiout2.txt"

REM SAME AS BELOW, JUST COPIED TO CLIPBOARD.
for /f "usebackq tokens=1,2,3 delims=:" %%a in ("%temp%\wifiout2.txt") do (
	echo.Wifi name: %ntwk%
	echo.Password: %%b
)|clip


for /f "usebackq tokens=1,2,3 delims=:" %%a in ("%temp%\wifiout2.txt") do (
	echo.Wifi Name     :  %ntwk%
	echo.Wifi Password : %%b
)

REM Cleanup temp files.
del /Q "%temp%\wifiout*.txt"


echo. && echo.
echo.*This info has been copied to the clipboard.*
			REM Could write to a temp file to keep, but would be a credential safety issue possibly.

echo.
echo.(Closing automatically in 10 seconds.)


ping loopback -n 10 >nul 2>nul
exit