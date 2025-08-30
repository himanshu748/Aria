#!/bin/bash

# Azure App Service startup script for Aria
echo "🚀 Starting Aria Voice Assistant on Azure..."

# Install dependencies
pip install --upgrade pip
pip install -r requirements.txt

# Start the application with gunicorn for better stability on Azure
echo "🎤 Starting Aria..."
exec gunicorn main:app -w 1 -k uvicorn.workers.UvicornWorker --bind 0.0.0.0:8000 --timeout 600
