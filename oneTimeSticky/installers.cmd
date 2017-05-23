
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

:: Programs
choco install -y git
choco install -y visualstudiocode
choco install -y notepadplusplus
choco install -y firefox
choco install -y googlechrome

:: Verify Repo
::todo:

:: Configurations
::todo: ie hyperlink
choco install -y sourcecodepro
::todo: n++ configuration

:: Restore previous path bgefore script
popd

pause