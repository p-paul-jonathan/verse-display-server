#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"

Write-Host "🚀 Setting up and starting Flask server..." -ForegroundColor Cyan

# Check if Python exists
if (-not (Get-Command python -ErrorAction SilentlyContinue)) {
    Write-Host "❌ Python not found. Please install Python 3 first." -ForegroundColor Red
    exit 1
}

# Create virtual environment if it doesn't exist
if (-not (Test-Path "venv")) {
    Write-Host "📦 Creating virtual environment..." -ForegroundColor Yellow
    python -m venv venv
}

# Activate virtual environment
Write-Host "🔗 Activating virtual environment..." -ForegroundColor Yellow
& "$PWD\venv\Scripts\Activate.ps1"

# Upgrade pip and install dependencies
Write-Host "⬆️  Installing dependencies..." -ForegroundColor Yellow
python -m pip install --upgrade pip
python -m pip install -r requirements.txt

# Ensure tmp directory exists
if (-not (Test-Path "tmp")) {
    New-Item -ItemType Directory -Path "tmp" | Out-Null
}
if (-not (Test-Path "tmp\.gitkeep")) {
    New-Item -ItemType File -Path "tmp\.gitkeep" | Out-Null
}

# Set Flask environment variables
$env:FLASK_APP = "app.py"
$env:FLASK_ENV = "development"
$env:FLASK_RUN_PORT = "5050"

Write-Host ""
Write-Host "✅ Flask setup complete!" -ForegroundColor Green
Write-Host "🌐 Starting server at http://127.0.0.1:$($env:FLASK_RUN_PORT) ..." -ForegroundColor Green
Write-Host ""

# Start Flask server
flask run --host=0.0.0.0 --port=$env:FLASK_RUN_PORT
