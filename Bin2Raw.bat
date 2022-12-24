:MainName
cls
@echo off
color 30
python --version >NUL 2>&1
if errorlevel 1 goto CheckPython
rm /s /q "dumps/blank_tags/Put the dump of the tags you want to write here" >nul 2>&1
rm /s /q "dumps/skylanders/Put the dump of the skylanders you want to write here" >nul 2>&1
mkdir output\Bin2Raw >nul 2>&1
type logo
title Skylanders Bin2Raw
set /p name="~~> Write the name you want for your .raw file: "
if ["%name%"]==[""] goto CheckName
cls

:MainFileSLCT
type logo
title Skylanders Key Calculator
echo File List:
dir dumps\skylanders /b
set /p file="~~> [With extensions] Write the name of your SKYLANDER file: "
cls

:MainRaw
echo.
python libs/sklykeys.py -f "dumps/skylanders/%file%" > "output\Bin2Raw\%name%.raw.dump"
cls
type logo
python libs/sklykeys.py -f "dumps/skylanders/%file%"
echo.
pause
exit

:CheckName
echo.
echo ERROR - The name can't be empty.
pause
goto MainName

:CheckPython
color 04
echo ERROR - Python not installed.
start ms-windows-store://pdp/?productid=9P7QFQMJRFP7
pause
exit

