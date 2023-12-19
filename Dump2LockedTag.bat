:MainName
cls
@echo off
color 30
rm /s /q "dumps/blank_tags/Put the dump of the tags you want to write here" >nul 2>&1
rm /s /q "dumps/skylanders/Put the dump of the skylanders you want to write here" >nul 2>&1
rmdir /s /q workplace >nul 2>&1
python --version >nul 2>&1
if errorlevel 1 goto CheckPython
mkdir output\Dump2LockedTag >nul 2>&1
goto GetBlankDump

:GetSkyDump
cls
type logo
title DumpAdaptor
echo File List:
dir "%cd%\dumps\skylanders" /b
set /p skyfile="~~> [With extensions] Write the name of your SKYLANDER .dump/.dmp/.sky/.bin file: "
goto GetDesiredName

:GetBlankDump
cls
type logo
echo File List:
dir "%cd%\dumps\blank_tags" /b
set /p btagfile="~~> [With extensions] Write the name of your BLANK TAG .dump/.dmp/.sky/.bin file: "
goto GetSkyDump

:GetDesiredName
cls
type logo
set /p outputfilename="~~> [Without extensions] Write the name desired for your output .dump file: "
goto GenWorkplace

:GenWorkplace
mkdir workplace
echo Getting Things Ready, Wait a moment.
xcopy /s "%cd%\libs\tnp3xxx.py" "workplace" >nul
xcopy /s "%cd%\libs\sklykeys.py" "workplace" >nul
xcopy /s "%cd%\libs\UID.py" "workplace" >nul
xcopy /s "%cd%\dumps\skylanders\%skyfile%" "workplace" >nul
xcopy /s "%cd%\dumps\blank_tags\%btagfile%" "workplace" >nul
timeout /t 5 /nobreak >nul
goto MainGen

:MainGen
cls
echo.
type logo
python "%cd%\workplace\UID.py" --blank "%cd%\workplace\%btagfile%" --sky "%cd%\workplace\%skyfile%" --name "%outputfilename%"
echo.
rmdir /s /q workplace
copy "%outputfilename%.dump" output\Dump2LockedTag
timeout /t 4 /nobreak >nul
del "%outputfilename%.dump" /q
exit

:CheckPython
color 04
echo ERROR - Python not installed.
start ms-windows-store://pdp/?productid=9P7QFQMJRFP7
pause
exit

