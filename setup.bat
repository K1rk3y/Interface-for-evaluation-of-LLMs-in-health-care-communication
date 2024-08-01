@echo off
setlocal enabledelayedexpansion

:: Display ASCII Art
echo.
echo   __
echo o-''^|\_____/^)
echo  \_/^|_)     ^)
echo     \  __  /
echo     (_/ (_/    
echo.
echo Anaconda/Miniconda Setup Script by @K1rk3y
echo.

:: Attempt to find Anaconda installation
for %%p in (
    "%USERPROFILE%\Anaconda3"
    "%USERPROFILE%\miniconda3"
    "C:\ProgramData\Anaconda3"
    "C:\ProgramData\miniconda3"
) do (
    if exist "%%~p\Scripts\activate.bat" (
        set "ANACONDA_PATH=%%~p"
        goto :found_anaconda
    )
)

:manual_entry
echo Anaconda/Miniconda installation not found automatically.
set /p ANACONDA_PATH="Please enter the path to your Anaconda installation (e.g., C:\Users\YourUsername\Anaconda3): "

if not exist "%ANACONDA_PATH%\Scripts\activate.bat" (
    echo The specified path does not contain an Anaconda installation.
    echo Please make sure you enter the correct path.
    goto :manual_entry
)

:found_anaconda
echo Found Anaconda at: %ANACONDA_PATH%

:: Activate the Anaconda base environment
call "%ANACONDA_PATH%\Scripts\activate.bat"

:: Verify Python is available
where python >nul 2>&1
if %errorlevel% neq 0 (
    echo Python not found in PATH. Please check your Anaconda installation.
    pause
    exit /b 1
)

:: Verify conda is available
where conda >nul 2>&1
if %errorlevel% neq 0 (
    echo Conda not found in PATH. Please check your Anaconda installation.
    pause
    exit /b 1
)

:: Run the Python script, passing the environment.yml in the same directory
python "%~dp0setup_env.py" "%~dp0environment.yml"

:: Deactivate the Anaconda environment
call conda deactivate

echo Setup complete. Please restart VSCode if it's currently running.

:: Open VS Code in the current directory
code .

pause