@echo off
setlocal

net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Admin rights required. Restarting script...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

echo Killing EA processes...
taskkill /IM "EABackgroundService.exe" /F >nul 2>&1
taskkill /IM "EADesktop.exe" /F >nul 2>&1

echo.
echo Deleting cache folders...
for %%F in (
  "%LOCALAPPDATA%\EADesktop"
  "%LOCALAPPDATA%\Electronic Arts"
  "%LOCALAPPDATA%\cache"
  "%LOCALAPPDATA%\D3DSCache"
  "%LOCALAPPDATA%\Link2EA"
  "%LOCALAPPDATA%\Origin"
  "%APPDATA%\EA\AC\Cache"
  "%ProgramData%\EA Desktop"
) do (
  if exist "%%~F" (
    rmdir /s /q "%%~F" 2>nul
    if exist "%%~F" (
      echo Failed to delete: %%~F
    ) else (
      echo Deleted: %%~F
    )
  ) else (
    echo Not found: %%~F
  )
)

echo.
echo Waiting 5 seconds...
timeout /t 5 /nobreak >nul

start "Ea App" "C:\Program Files\Electronic Arts\EA Desktop\EA Desktop\EADesktop.exe"

echo.
echo Waiting 4 seconds...
timeout /t 4 /nobreak >nul

echo Launching Steam game...
start "" "steam://rungameid/1238840"

endlocal
exit /b
