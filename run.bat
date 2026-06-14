@echo off
setlocal

rem === Config ===
if "%~1"=="" (
    set "WAIT_ON_EXIT=1"
) else (
    set "WAIT_ON_EXIT=0"
)

if not defined PZ_HOME set "PZ_HOME=C:\Program Files (x86)\Steam\steamapps\common\ProjectZomboid"

set "SRC_PATH=%~dp0"
set "JAVA_EXE=%PZ_HOME%\jre64\bin\java.exe"
set "PZ_JAR=%PZ_HOME%\projectzomboid.jar"
set "WRAPPER_JAR=%SRC_PATH%POTConverterWrapper.jar"
if "%~1"=="" (
    set "B41_MAP=%SRC_PATH%B41"
) else (
    set "B41_MAP=%~1"
)
if "%~2"=="" (
    set "B42_MAP=%SRC_PATH%B42"
) else (
    set "B42_MAP=%~2"
)

if not exist "%JAVA_EXE%" (
    echo Missing Java runtime: "%JAVA_EXE%"
    echo Set PZ_HOME to your Project Zomboid install folder.
    goto fail
)

if not exist "%PZ_JAR%" (
    echo Missing Project Zomboid jar: "%PZ_JAR%"
    echo Set PZ_HOME to your Project Zomboid install folder.
    goto fail
)

if not exist "%WRAPPER_JAR%" (
    echo Missing wrapper jar: "%WRAPPER_JAR%"
    goto fail
)

if not exist "%B41_MAP%\" (
    echo Missing input folder: "%B41_MAP%"
    echo Pass the B41 map folder as first argument or create a B41 folder beside this script.
    goto fail
)

dir /b "%B41_MAP%\*.lotheader" >nul 2>nul
if errorlevel 1 (
    echo No .lotheader files found in: "%B41_MAP%"
    echo Pass a Project Zomboid Build 41 map folder containing .lotheader, .lotpack and chunkdata files.
    goto fail
)

rem === Execution ===
echo Start converting map
"%JAVA_EXE%" -cp "%WRAPPER_JAR%;%PZ_JAR%" Main "%B41_MAP%" "%B42_MAP%"
set "EXIT_CODE=%ERRORLEVEL%"

if "%WAIT_ON_EXIT%"=="1" pause
exit /b %EXIT_CODE%

:fail
if "%WAIT_ON_EXIT%"=="1" pause
exit /b 1
