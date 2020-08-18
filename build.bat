@echo off

echo.
echo ===========================================
echo Iosevka Custom Build Script v1.0 by ANK-dev
echo ===========================================
echo.

if not exist .\Iosevka\ (
    echo [ERR] `.\Iosevka\` directory not found!
    set /p "confirm=Clone the repository from `https://github.com/be5invis/Iosevka`? ([Y]/n): "
    if /i "%confirm%"=="y" goto Clone
    
    echo Operation aborted! Exiting...
    exit /b 1
) else (
    goto Main
)

:Clone
for %%X in (git.exe) do (set git_path=%%~$PATH:X)

if not defined git_path (
    echo [ERR!] Git is not installed! Install Git from `https://git-scm.com/` ^
    or clone Iosevka's repository manually. Exiting...
    exit /b 1
)

call git clone https://github.com/be5invis/Iosevka

if %ERRORLEVEL% neq 0 (
    echo [ERR] Git error! Exiting...
    exit /b 1
)

rem Successful cloning. Exit script for build editing
echo Repository cloned successfully! Edit the `private-build-plans.toml` in ^
the `.\Iosevka` directory and run this script again
exit /b 0

:Main
rem Change working directory to "Iosevka" folder
cd Iosevka

rem Create temporary enviroment for %PATH%
setlocal
set "PATH=%PATH%;..\otfcc\;..\ttfautohint\"
set env_var=false

echo Be sure that the `private-build-plans.toml` file has been correctly ^
configured
echo.
echo.
timeout 5 >nul

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
    echo [ERR] Essential components missing. Exiting...
    endlocal
    cd ..
    exit /b 1
) else (
    echo Essential components OK!
    echo.
    echo.
)

echo Updating node_modules...
echo ========================
call npm install
echo.
echo.

if %ERRORLEVEL% neq 0 (
    echo [ERR] Node.js error!
    endlocal
    cd ..
    exit /b 1
)

:Setup
echo Starting build setup...
echo =======================
echo.

:Plan_Name
echo Plan Name
echo ---------
set /p "plan=Type the name of your Plan: "
echo.

:Contents
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
    echo The Contents you typed are invalid!
    pause
    echo.
    goto Contents
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
if /i not "%confirm%"=="y" goto Setup

echo Starting the build process...
echo =============================

call npm run build -- %contents%::%plan%
echo.

if %ERRORLEVEL% equ 0 (
    echo Build finished successfully!
    echo Your custom font is located in the `.\Iosevka\dist\%plan%` directory
) else (
    echo [ERR] Build failed! Exiting...
)

endlocal
cd ..