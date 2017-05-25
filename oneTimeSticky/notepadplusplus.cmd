
:: NotepadPlusPlus install, settings, and plugins. Called by installers.cmd, but can be run directly
:: NOTE: requires chocolatey, elevated with admin rights

:: The manual steps for the same operations:
:: installs
::     notepad++
::     sourcecodepro font
:: notepad++ plugins
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

:: Get timestamp string. NOTE: if you're executing this particular command outside of batch file (directly in CLI prompt) then swap both %% with %
for /F "usebackq tokens=1" %%i in (`powershell "(Get-Date).ToString('yyy-MMdd-HHmm')"`) do set dateString=%%i

:: install font. this is particularly noisy. write it to a temp file instead to console.
choco install -y sourcecodepro > %tmp%\%dateString%.txt
:: install n++
choco install -y notepadplusplus

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
