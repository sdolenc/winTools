
:: Move working directory to script path
pushd %~dp0

:: Elevate
NET FILE 1>NUL 2>NUL
if '%errorlevel%' == '0' (
    echo "Already Admin"
) else (
    powershell "saps -filepath %0 -verb runas" >nul 2>&1 && exit /b
)

:: Choco
powershell -NoProfile -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"

:: Restore previous path bgefore script
popd

pause