@echo off
setlocal

if not defined PZ_HOME set "PZ_HOME=C:\Program Files (x86)\Steam\steamapps\common\ProjectZomboid"

set "SRC_DIR=%~dp0src"
set "BUILD_DIR=%~dp0build\classes"
set "PZ_JAR=%PZ_HOME%\projectzomboid.jar"
set "OUT_JAR=%~dp0POTConverterWrapper.jar"

if not exist "%PZ_JAR%" (
    echo Missing Project Zomboid jar: "%PZ_JAR%"
    echo Set PZ_HOME to your Project Zomboid install folder.
    exit /b 1
)

where javac >nul 2>nul
if errorlevel 1 (
    echo Missing javac. Install a JDK and add it to PATH.
    echo The Steam jre64 folder is only a runtime and does not include javac.
    exit /b 1
)

where jar >nul 2>nul
if errorlevel 1 (
    echo Missing jar.exe. Install a JDK and add it to PATH.
    exit /b 1
)

for /f "tokens=2 delims= " %%V in ('javac -version 2^>^&1') do set "JAVAC_VERSION=%%V"
for /f "tokens=1 delims=." %%M in ("%JAVAC_VERSION%") do set "JAVAC_MAJOR=%%M"

if "%JAVAC_MAJOR%"=="" (
    echo Could not detect javac version.
    exit /b 1
)

if %JAVAC_MAJOR% LSS 25 (
    echo javac %JAVAC_VERSION% found, but the current Steam projectzomboid.jar may require JDK 25 or newer.
    echo Install JDK 25+ or use the ready-to-run POTConverterWrapper.jar included in this folder.
    exit /b 1
)

if not exist "%BUILD_DIR%" mkdir "%BUILD_DIR%"

javac -encoding UTF-8 -cp "%PZ_JAR%" -d "%BUILD_DIR%" "%SRC_DIR%\Main.java"
if errorlevel 1 exit /b 1

jar --create --file "%OUT_JAR%" -C "%BUILD_DIR%" Main.class
if errorlevel 1 exit /b 1

echo Built "%OUT_JAR%"
exit /b 0
