::@echo off

:: Move working directory to current script path
pushd %~dp0

:: Elevate
NET FILE 1>NUL 2>NUL
if '%errorlevel%' == '0' (
    echo "Already Admin"
) else (
    echo "Re-launching tool as elevated" && powershell "saps -filepath %0 -verb runas" >nul 2>&1 && popd && exit /b
)

:: Choco
powershell -NoProfile -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"

:: Programs
choco install -y git && SET "PATH=%PATH%;%ProgramFiles%\Git\cmd"
choco install -y visualstudiocode
choco install -y firefox
choco install -y googlechrome

:: Get timestamp string. NOTE: if you're executing this particular command outside of batch file (directly in CLI prompt) then swap both %% with %
for /F "usebackq tokens=1" %%i in (`powershell "(Get-Date).ToString('yyy-MMdd-HHmm')"`) do set dateString=%%i

:: Ensure configFiles directory exists. If needed, clone repo.
if NOT EXIST "configFiles\" (
    :: todo: path hardcoding is a bad idea
    git clone https://github.com/sdolenc/winTools.git %tmp%\%dateString% && cd /D %tmp%\%dateString%\oneTimeSticky
)

:: allow "edge" from run box
copy /y configFiles\edge.lnk %windir%\system32

:: n++
call .\notepadplusplus.cmd

:: Restore previous path before script
popd

pause
