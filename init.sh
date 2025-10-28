#!/usr/bin/env bash
set -e

echo "🚀 Setting up and starting Flask server..."

# Check Python
if ! command -v python3 &> /dev/null; then
  echo "❌ Python3 not found. Please install Python 3 first."
  exit 1
fi

# Create virtual environment if it doesn't exist
if [ ! -d "venv" ]; then
  echo "📦 Creating virtual environment..."
  python3 -m venv venv
fi

# Activate virtual environment
source venv/bin/activate

# Upgrade pip and install dependencies
echo "⬆️  Installing dependencies..."
pip install --upgrade pip
pip install -r requirements.txt

# Ensure tmp directory exists
mkdir -p tmp
touch tmp/.gitkeep

# Export environment variables for Flask
export FLASK_APP=app.py
export FLASK_ENV=development
export FLASK_RUN_PORT=5050

echo ""
echo "✅ Flask setup complete!"
echo "🌐 Starting server at http://127.0.0.1:5050 ..."
echo ""

# Start the Flask server
flask run --host=0.0.0.0 --port=$FLASK_RUN_PORT
