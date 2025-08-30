#!/bin/bash

# Pre-build script for Azure deployment
echo "🔧 Running pre-build setup..."

# Create necessary directories
mkdir -p uploads
mkdir -p logs

# Set permissions
chmod 755 startup.sh

echo "✅ Pre-build setup completed"
