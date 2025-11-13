@echo off
setlocal enabledelayedexpansion

echo 🚀 Setting up and starting Flask server...

:: Check if Python is installed
where python >nul 2>nul
if %errorlevel% neq 0 (
    echo ❌ Python not found. Please install Python 3 first.
    exit /b 1
)

:: Create virtual environment if it doesn't exist
if not exist venv (
    echo 📦 Creating virtual environment...
    python -m venv venv
)

:: Activate virtual environment
call venv\Scripts\activate

:: Upgrade pip and install dependencies
echo ⬆️  Installing dependencies...
python -m pip install --upgrade pip
python -m pip install -r requirements.txt

:: Ensure tmp directory exists
if not exist tmp mkdir tmp
if not exist tmp\.gitkeep type nul > tmp\.gitkeep

:: Set Flask environment variables
set FLASK_APP=app.py
set FLASK_ENV=development
set FLASK_RUN_PORT=5050

echo.
echo ✅ Flask setup complete!
echo 🌐 Starting server at http://127.0.0.1:%FLASK_RUN_PORT% ...
echo.

:: Start the Flask server
flask run --host=0.0.0.0 --port=%FLASK_RUN_PORT%

endlocal
