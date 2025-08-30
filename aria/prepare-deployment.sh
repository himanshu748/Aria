#!/bin/bash

# Prepare deployment package for Azure
echo "📦 Preparing Aria for Azure deployment..."

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Clean up old deployment files
rm -f deployment.zip

# Create deployment package excluding unnecessary files
echo -e "${YELLOW}Creating deployment package...${NC}"

# Files to include in deployment
zip -r deployment.zip . \
    -x "*.git*" \
    -x "*__pycache__*" \
    -x "*.pyc" \
    -x "deployment.zip" \
    -x "*.DS_Store" \
    -x "venv/*" \
    -x "env/*" \
    -x ".env.example" \
    -x "*.log" \
    -x "uploads/*"

echo -e "${GREEN}✅ Deployment package created: deployment.zip${NC}"
echo -e "${YELLOW}📋 Package contents:${NC}"
unzip -l deployment.zip | head -20

echo ""
echo -e "${GREEN}🚀 Ready for deployment!${NC}"
echo "Run: ./deploy-azure.sh"
