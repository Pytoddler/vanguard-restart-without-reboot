@echo off
setlocal EnableExtensions

:: Relaunch as Administrator if needed.
fltmc >nul 2>&1
if errorlevel 1 (
    powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)

echo.
echo === Vanguard restart without reboot ===
echo.

call :ensure_running vgk "Vanguard kernel driver"
if errorlevel 1 goto :fail
call :ensure_running vgc "Vanguard user-mode service"
if errorlevel 1 goto :fail

echo.
echo Final status:
sc.exe query vgk | findstr /I "STATE"
sc.exe query vgc | findstr /I "STATE"
echo.
echo Vanguard appears to be running.
timeout /t 3 >nul
exit /b 0

:ensure_running
set "svc=%~1"
set "label=%~2"
sc.exe query "%svc%" | findstr /I "RUNNING" >nul 2>&1
if not errorlevel 1 (
    echo %label% [%svc%] is already running.
    exit /b 0
)
echo Starting %label% [%svc%]...
sc.exe start "%svc%" >nul 2>&1
for /L %%I in (1,1,10) do (
    sc.exe query "%svc%" | findstr /I "RUNNING" >nul 2>&1
    if not errorlevel 1 (
        echo %label% [%svc%] is running.
        exit /b 0
    )
    >nul timeout /t 1
)
echo ERROR: %label% [%svc%] did not reach RUNNING state.
sc.exe query "%svc%"
exit /b 1

:fail
echo.
echo Vanguard could not be fully restarted.
echo A reboot may still be required on some systems or Vanguard versions.
pause
exit /b 1
