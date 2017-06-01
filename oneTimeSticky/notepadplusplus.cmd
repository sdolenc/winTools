::@echo off

:: NotepadPlusPlus install, settings, and plugins. Called by installers.cmd, but can be run directly
:: NOTE: requires chocolatey (choco)

:: The manual steps for the same operations:
:: installs
::     notepad++
::     sourcecodepro font
:: notepad++ plugins (todo: see ideas.txt)
::     compare for diffing
::     jstool for json (un)minifying
:: notepad++ settings
::     tabs -> spaces
::     turn off:
::         auto-complete
::         auto-insert
::         ctrl+tab mru
::     use source code pro font
:: opened files (notepad++ session)
::     open C:\Windows\System32\drivers\etc\hosts

:: Move working directory to current script path
pushd %~dp0

:: Elevate
NET FILE 1>NUL 2>NUL
if '%errorlevel%' == '0' (
    echo "Already Admin"
) else (
    echo "Re-launching tool as elevated" && powershell "saps -filepath %0 -verb runas" >nul 2>&1 && popd && exit /b
)

:: Get timestamp string. NOTE: if you're executing this particular command outside of batch file (directly in CLI prompt) then swap both %% with %
:: todo:optimization take this as a parameter (argument) and only generate this string when param is empty.
for /F "usebackq tokens=1" %%i in (`powershell "(Get-Date).ToString('yyy-MMdd-HHmm')"`) do set dateString=%%i

:: install font. this is particularly noisy. write it to a temp file instead to console.
choco install -y sourcecodepro > %tmp%\%dateString%.txt
:: install n++.
::  - We opt for 32bit for plugins.
::  - We snap to a specific version rather than latest so we can confidentally override settings and install plugins. We can change the version, but basic verification is important.
choco install -y notepadplusplus --x86 --version 7.4.1

:: Change working directory to configuration folder. If needed, clone repo.
if EXIST "configFiles\" (
    pushd configFiles
) else (
    :: todo: path hardcoding is a bad idea
    :: todo:edgeCase ensure destination directory doesn't already exist before cloning to it (or just try pushd'ing into it if it does exist)
    git clone https://github.com/sdolenc/winTools.git %tmp%\%dateString% && pushd %tmp%\%dateString%\oneTimeSticky\configFiles
)

::todo:everything below.
:: create backup directory name
set backupDir=%%i

:: plugins backup (dll)
set toDir="%ProgramFiles(x86)%\Notepad++\plugins"
pushd %toDir%
mkdir "%backupDir%"
copy *.dll "%backupDir%"
popd
:: plugins replace (dll)
set fromDir="%cd%\nppFiles\plugins"
pushd %fromDir%
copy /Y *.dll %toDir%
popd

:: settings backup (ini,xml)
set toDir="%APPDATA%\Notepad++"
pushd %toDir%
mkdir "%backupDir%"
copy *.xml "%backupDir%"
copy *.ini "%backupDir%"
popd
:: settings replace (ini,xml)
set fromDir="%cd%\nppFiles\config"
pushd %fromDir%
copy /Y *.xml %toDir%
copy /Y *.ini %toDir%
popd

popd

popd

pause
