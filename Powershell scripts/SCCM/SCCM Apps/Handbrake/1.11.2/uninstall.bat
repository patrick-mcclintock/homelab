@echo off

cd /d "%~dp0"

echo Requesting elevation to run uninstall.ps1...
powershell -Command "Start-Process powershell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File ""%~dp0uninstall.ps1""' -Verb RunAs"

timeout /t 15

exit