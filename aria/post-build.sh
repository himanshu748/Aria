#!/bin/bash

# Post-build script for Azure deployment
echo "🏗️ Running post-build optimizations..."

# Clean up unnecessary files
find . -name "*.pyc" -delete
find . -name "__pycache__" -type d -exec rm -rf {} + 2>/dev/null || true

# Set proper permissions
chmod -R 755 static/
chmod -R 755 templates/

echo "✅ Post-build optimizations completed"
