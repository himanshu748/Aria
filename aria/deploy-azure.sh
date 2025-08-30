#!/bin/bash

# Azure Deployment Script for Aria Voice Assistant
echo "🚀 Deploying Aria to Azure..."

# Configuration
RESOURCE_GROUP="AriaRG"
APP_NAME="aria-voice-assistant"
LOCATION="eastus"
SKU="B1"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if Azure CLI is installed
if ! command -v az &> /dev/null; then
    echo -e "${RED}❌ Azure CLI is not installed. Please install it first:${NC}"
    echo "https://docs.microsoft.com/en-us/cli/azure/install-azure-cli"
    exit 1
fi

# Login to Azure (if not already logged in)
echo -e "${YELLOW}🔐 Checking Azure login status...${NC}"
az account show &> /dev/null
if [ $? -ne 0 ]; then
    echo -e "${YELLOW}Please login to Azure:${NC}"
    az login
fi

# Create resource group
echo -e "${YELLOW}📁 Creating resource group '$RESOURCE_GROUP'...${NC}"
az group create --name $RESOURCE_GROUP --location $LOCATION

# Create App Service plan
echo -e "${YELLOW}⚡ Creating App Service plan...${NC}"
az appservice plan create --name AriaPlan --resource-group $RESOURCE_GROUP --location $LOCATION --sku $SKU --is-linux

# Create web app
echo -e "${YELLOW}🌐 Creating web app '$APP_NAME'...${NC}"
az webapp create --name $APP_NAME --resource-group $RESOURCE_GROUP --plan AriaPlan --runtime "PYTHON:3.11"

# Configure environment variables
echo -e "${YELLOW}🔧 Configuring environment variables...${NC}"

# Check if .env file exists
if [ ! -f ".env" ]; then
    echo -e "${RED}❌ .env file not found. Please create it with your API keys first.${NC}"
    exit 1
fi

# Set environment variables from .env file
while IFS='=' read -r key value; do
    # Skip empty lines and comments
    [[ $key =~ ^[[:space:]]*# ]] && continue
    [[ -z $key ]] && continue

    echo -e "${YELLOW}Setting $key...${NC}"
    az webapp config appsettings set --name $APP_NAME --resource-group $RESOURCE_GROUP --setting $key="$value"
done < .env

# Enable WebSocket support
echo -e "${YELLOW}🔌 Enabling WebSocket support...${NC}"
az webapp config set --name $APP_NAME --resource-group $RESOURCE_GROUP --web-sockets-enabled true

# Configure startup command
echo -e "${YELLOW}⚙️ Configuring startup command...${NC}"
az webapp config set --name $APP_NAME --resource-group $RESOURCE_GROUP --startup-file "uvicorn main:app --host 0.0.0.0 --port 8000"

# Deploy the application
echo -e "${YELLOW}📦 Deploying application...${NC}"
az webapp up --name $APP_NAME --resource-group $RESOURCE_GROUP --plan AriaPlan

# Get the URL
APP_URL=$(az webapp show --name $APP_NAME --resource-group $RESOURCE_GROUP --query defaultHostName -o tsv)

echo -e "${GREEN}✅ Deployment completed successfully!${NC}"
echo -e "${GREEN}🌐 Your app is available at: https://$APP_URL${NC}"
echo ""
echo -e "${YELLOW}📋 Next steps:${NC}"
echo "1. Visit the URL above"
echo "2. Configure your API keys in the app settings if needed"
echo "3. Test the voice assistant functionality"
echo ""
echo -e "${YELLOW}💡 Useful commands:${NC}"
echo "• View logs: az webapp log tail --name $APP_NAME --resource-group $RESOURCE_GROUP"
echo "• Restart app: az webapp restart --name $APP_NAME --resource-group $RESOURCE_GROUP"
echo "• Delete resources: az group delete --name $RESOURCE_GROUP"
