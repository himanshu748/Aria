#!/bin/bash

# Azure Deployment Status Check for Aria
echo "🔍 Checking Aria deployment status on Azure..."

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

APP_NAME="aria-voice-assistant"
RESOURCE_GROUP="AriaRG"
APP_URL="https://aria-voice-assistant.azurewebsites.net"

echo -e "${YELLOW}📋 Deployment Information:${NC}"
echo "  Resource Group: $RESOURCE_GROUP"
echo "  App Name: $APP_NAME"
echo "  URL: $APP_URL"
echo ""

# Check if app exists and is running
echo -e "${YELLOW}🔄 Checking app status...${NC}"
STATUS=$(az webapp show --name $APP_NAME --resource-group $RESOURCE_GROUP --query 'state' -o tsv 2>/dev/null)

if [ "$STATUS" = "Running" ]; then
    echo -e "${GREEN}✅ App Status: Running${NC}"
else
    echo -e "${RED}❌ App Status: $STATUS${NC}"
    exit 1
fi

# Test HTTP response
echo -e "${YELLOW}🌐 Testing HTTP response...${NC}"
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" $APP_URL)

if [ "$HTTP_CODE" = "200" ]; then
    echo -e "${GREEN}✅ HTTP Response: $HTTP_CODE (OK)${NC}"
else
    echo -e "${RED}❌ HTTP Response: $HTTP_CODE${NC}"
fi

# Check WebSocket support
echo -e "${YELLOW}🔌 Checking WebSocket configuration...${NC}"
WS_ENABLED=$(az webapp config show --name $APP_NAME --resource-group $RESOURCE_GROUP --query 'webSocketsEnabled' -o tsv)

if [ "$WS_ENABLED" = "true" ]; then
    echo -e "${GREEN}✅ WebSockets: Enabled${NC}"
else
    echo -e "${RED}❌ WebSockets: Disabled${NC}"
fi

echo ""
echo -e "${GREEN}🎉 Aria is successfully deployed and running on Azure!${NC}"
echo -e "${YELLOW}🌐 Access your voice assistant at: $APP_URL${NC}"
echo ""
echo -e "${YELLOW}📝 Next steps:${NC}"
echo "1. Visit the URL above"
echo "2. Click the settings icon (⚙️) to configure API keys"
echo "3. Grant microphone permissions when prompted"
echo "4. Start chatting with Aria!"
echo ""
echo -e "${YELLOW}🔧 Management commands:${NC}"
echo "• View logs: az webapp log tail --name $APP_NAME --resource-group $RESOURCE_GROUP"
echo "• Restart app: az webapp restart --name $APP_NAME --resource-group $RESOURCE_GROUP"
echo "• Scale up: az appservice plan update --name AriaPlan --resource-group $RESOURCE_GROUP --sku S1"
