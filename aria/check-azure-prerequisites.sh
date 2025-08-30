#!/bin/bash

# Azure Prerequisites Check Script
echo "🔍 Checking Azure deployment prerequisites..."

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Check Azure CLI
echo -n "Azure CLI: "
if command -v az &> /dev/null; then
    echo -e "${GREEN}✅ Installed${NC}"
    AZ_VERSION=$(az version --query '"azure-cli"' -o tsv)
    echo "  Version: $AZ_VERSION"
else
    echo -e "${RED}❌ Not installed${NC}"
    echo "  Install from: https://docs.microsoft.com/en-us/cli/azure/install-azure-cli"
fi

# Check if logged in
echo -n "Azure Login: "
if az account show &> /dev/null; then
    echo -e "${GREEN}✅ Logged in${NC}"
    ACCOUNT=$(az account show --query '[name,user.name]' -o tsv)
    echo "  Account: $ACCOUNT"
else
    echo -e "${RED}❌ Not logged in${NC}"
    echo "  Run: az login"
fi

# Check .env file
echo -n ".env file: "
if [ -f ".env" ]; then
    echo -e "${GREEN}✅ Exists${NC}"
    # Check if API keys are set
    API_KEYS=("GEMINI_API_KEY" "ASSEMBLYAI_API_KEY" "MURF_API_KEY" "SERPAPI_KEY")
    MISSING_KEYS=()
    for key in "${API_KEYS[@]}"; do
        if ! grep -q "^$key=" .env || grep -q "^$key=$" .env; then
            MISSING_KEYS+=("$key")
        fi
    done
    if [ ${#MISSING_KEYS[@]} -eq 0 ]; then
        echo "  API keys: ✅ All configured"
    else
        echo -e "  API keys: ${YELLOW}⚠️ Missing: ${MISSING_KEYS[*]}${NC}"
    fi
else
    echo -e "${RED}❌ Missing${NC}"
    echo "  Create .env file with your API keys"
fi

# Check Python
echo -n "Python: "
if command -v python3 &> /dev/null; then
    PYTHON_VERSION=$(python3 --version)
    echo -e "${GREEN}✅ $PYTHON_VERSION${NC}"
else
    echo -e "${RED}❌ Not installed${NC}"
fi

# Check Docker (optional)
echo -n "Docker: "
if command -v docker &> /dev/null; then
    DOCKER_VERSION=$(docker --version)
    echo -e "${GREEN}✅ $DOCKER_VERSION${NC}"
else
    echo -e "${YELLOW}⚠️ Not installed (optional for container deployment)${NC}"
fi

echo ""
echo "📋 Next steps:"
if ! command -v az &> /dev/null; then
    echo "1. Install Azure CLI"
fi
if ! az account show &> /dev/null; then
    echo "2. Login to Azure: az login"
fi
if [ ! -f ".env" ]; then
    echo "3. Create .env file with API keys"
fi
echo "4. Run deployment: ./deploy-azure.sh"
