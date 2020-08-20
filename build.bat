@echo off

echo.
echo ===========================================
echo Iosevka Custom Build Script v1.0 by ANK-dev
echo ===========================================
echo.

rem Workaround for variable comparison inside `if` statements
setlocal enabledelayedexpansion

:*******************************************************************************
:DIR_CHECK
:*******************************************************************************
if not exist .\Iosevka\ (
    echo [ERROR] `.\Iosevka\` directory not found!

    set /p "confirm=Clone the repository from `https://github.com/be5invis/Iosevka`? ([Y]/n): "
    if /i "!confirm!"=="y" goto CLONE
    
    echo [FATAL] Operation aborted^^! Exiting...
    pause
    exit /b 1
) else (
    goto MAIN
)

:*******************************************************************************
:CLONE
:*******************************************************************************
rem end "delayed expansion" from :DIR_CHECK
setlocal disabledelayedexpansion

for %%X in (git.exe) do (set git_path=%%~$PATH:X)

if not defined git_path (
    echo [FATAL] Git is not installed! Install Git from `https://git-scm.com/` ^
or clone Iosevka's repository manually. Exiting...
    pause
    exit /b 1
)

call git clone https://github.com/be5invis/Iosevka

if %ERRORLEVEL% neq 0 (
    echo [FATAL] Git error! Exiting...
    pause
    exit /b 1
)

rem Successful cloning. Exit script for build editing
echo [INFO] Repository cloned successfully! Edit the ^
`private-build-plans.toml` in the `.\Iosevka` directory and run this script ^
again
pause
exit /b 0

:*******************************************************************************
:MAIN
:*******************************************************************************
rem erase temporary variables from :DIR_CHECK and :CLONE
endlocal
rem Change working directory to "Iosevka" folder
cd Iosevka

rem Create temporary environment for %PATH%
setlocal disabledelayedexpansion
set "PATH=%PATH%;..\otfcc\;..\ttfautohint\"
set env_var=false

echo [WARN] Be sure that the `private-build-plans.toml` file has been ^
correctly configured
timeout 5 >nul
echo.
echo.

:*******************************************************************************
:COMPONENT_CHECK
:*******************************************************************************
echo Testing essential components...
echo ===============================
echo.
echo otfcc
echo -----
otfccbuild -v
echo.
echo ttfautohint
echo -----------
ttfautohint --version
echo.
echo node.js
echo -------
node -v
echo.

rem Get path of essential components
for %%X in (otfccbuild.exe) do (set otfcc_path=%%~$PATH:X)
for %%X in (ttfautohint.exe) do (set ttfautohint_path=%%~$PATH:X)
for %%X in (node.exe) do (set nodejs_path=%%~$PATH:X)

rem Check if components exist in %PATH%
if defined otfcc_path if defined ttfautohint_path if defined nodejs_path (
            set env_var=true
)  

if "%env_var%"=="false" (
    echo [FATAL] Essential components missing. Exiting...
    cd ..
    pause
    exit /b 1
) else (
    echo [INFO] Essential components OK!
    echo.
    echo.
)

echo Updating node_modules...
echo ========================
call npm install
echo.

if %ERRORLEVEL% neq 0 (
    echo [FATAL] Node.js error!
    cd ..
    pause
    exit /b 1
) else (
    echo [INFO] node_modules updated successfully!
    echo.
    echo.
)

:*******************************************************************************
:SETUP
:*******************************************************************************
echo Starting build setup...
echo =======================
echo.

:*******************************************************************************
:PLAN_NAME
:*******************************************************************************
echo Plan Name
echo ---------
set /p "plan=Type the name of your Plan: "
echo.

:*******************************************************************************
:CONTENTS
:*******************************************************************************
echo Build Contents
echo --------------
echo - `contents`: TTF (Hinted and Unhinted), WOFF(2) and Webfont CSS;
echo - `ttf`: TTF;
echo - `woff`: TTF and WOFF only;
echo - `woff2`: TTF and WOFF2 only;
echo.
set /p "contents=Type the Contents of your build: "
if not "%contents%"=="contents" if not "%contents%"=="ttf" ^
if not "%contents%"=="woff" if not "%contents%"=="woff2" (
    echo.
    echo [ERROR] The Contents you typed are invalid!
    pause
    echo.
    goto CONTENTS
)
echo.

echo Summary
echo -------
echo - Plan Name: %plan%
echo - Contents: %contents%
echo.
set /p "confirm=Is this OK? (y/[N]): "
echo.
echo.
if /i not "%confirm%"=="y" goto SETUP

:*******************************************************************************
:BUILD
:*******************************************************************************
echo Starting the build process...
echo =============================

call npm run build -- %contents%::%plan%
echo.

if %ERRORLEVEL% equ 0 (
    echo [INFO] Build finished successfully!
    echo [INFO] Your custom font is located in the `.\Iosevka\dist\%plan%` ^
directory
) else (
    echo [FATAL] Build failed! Exiting...
)

cd ..
pause