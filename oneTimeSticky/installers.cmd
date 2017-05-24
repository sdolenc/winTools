
:: Get timestamp string. NOTE: if you're executing this particular command outside of batch file (directly in CLI prompt) then swap both %% with %
for /F "usebackq tokens=1" %%i in (`powershell "(Get-Date).ToString('yyy-MMdd-HHmm')"`) do set dateString=%%i

:: Move working directory to current script path
pushd %~dp0

:: Elevate
NET FILE 1>NUL 2>NUL
if '%errorlevel%' == '0' (
    echo "Already Admin"
) else (
    echo "Re-launching tool as elevated" && powershell "saps -filepath %0 -verb runas" >nul 2>&1 && exit /b
)

:: Choco
powershell -NoProfile -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"

:: Programs
choco install -y git
choco install -y visualstudiocode
choco install -y notepadplusplus
choco install -y firefox
choco install -y googlechrome

:: Change working directory to configuration folder. If needed, clone repo.
if EXIST "configFiles\" (
    pushd configFiles
) else (
    :: todo: path hardcoding is a bad idea
    git clone https://github.com/sdolenc/winTools.git %tmp%/%dateString% && pushd %tmp%/%dateString%/oneTimeSticky/configFiles
)

:: Configurations
:: "edge" from run box can open browser.
copy /y edge.lnk %windir%\system32
choco install -y sourcecodepro
::todo: n++ configuration

popd

:: Restore previous path before script
popd

pause
