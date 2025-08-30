# Aria - AI Voice Assistant

Welcome to Aria, an intelligent voice assistant built with modern AI technologies. Aria combines speech-to-text, large language models, and text-to-speech to create a seamless conversational experience.

## 🧠 What We Built

  * **Intelligent Voice Assistant**: Aria is a sophisticated AI assistant that can understand speech, process queries, and respond with natural voice synthesis.
  * **Real-time Interaction**: The assistant provides real-time voice interaction with web search capabilities for up-to-date information.

-----

## 🛠 Tech Stack

Aria is built with a modern tech stack for optimal performance and scalability.

  * **Backend**: `FastAPI`, `uvicorn`, `requests`, `assemblyai`, `google-generativeai`, `python-dotenv`, `websockets`, `google-search-results`
  * **Frontend**: `HTML`, `Bootstrap`, `JavaScript` (with `AudioContext` and `WebSocket API`)
  * **AI APIs**:
      * Murf AI (Streaming Text-to-Speech)
      * AssemblyAI (Real-Time Speech-to-Text with Turn Detection)
      * Google Gemini (Streaming LLM with Function Calling)
      * SerpAPI (Real-time Google Search Results)

-----

## 🚀 Run the App

### Local Development

To run Aria locally:

1. Install the required dependencies:
   ```bash
   pip install -r requirements.txt
   ```

2. Set up your environment variables in a `.env` file:
   ```
   GEMINI_API_KEY=your_gemini_api_key
   ASSEMBLYAI_API_KEY=your_assemblyai_api_key
   MURF_API_KEY=your_murf_api_key
   SERPAPI_KEY=your_serpapi_key
   ```

3. Run the application:
   ```bash
   uvicorn main:app --reload
   ```

4. Open your browser and navigate to `http://localhost:8000`

5. Click the settings icon to enter your API keys, grant microphone permissions, and start chatting with Aria!

### Azure Deployment

#### Option 1: Automated Deployment (Recommended)

1. **Install Azure CLI**:
   ```bash
   # macOS
   brew install azure-cli
   
   # Or download from: https://docs.microsoft.com/en-us/cli/azure/install-azure-cli
   ```

2. **Login to Azure**:
   ```bash
   az login
   ```

3. **Run the deployment script**:
   ```bash
   ./deploy-azure.sh
   ```

#### Option 2: Manual Deployment

1. **Create Azure Resources**:
   ```bash
   # Create resource group
   az group create --name AriaRG --location eastus
   
   # Create App Service plan
   az appservice plan create --name AriaPlan --resource-group AriaRG --sku B1 --is-linux
   
   # Create web app
   az webapp create --name aria-voice-assistant --resource-group AriaRG --plan AriaPlan --runtime "PYTHON:3.11"
   ```

2. **Configure Environment Variables**:
   ```bash
   az webapp config appsettings set --name aria-voice-assistant --resource-group AriaRG --setting GEMINI_API_KEY="your_key"
   az webapp config appsettings set --name aria-voice-assistant --resource-group AriaRG --setting ASSEMBLYAI_API_KEY="your_key"
   az webapp config appsettings set --name aria-voice-assistant --resource-group AriaRG --setting MURF_API_KEY="your_key"
   az webapp config appsettings set --name aria-voice-assistant --resource-group AriaRG --setting SERPAPI_KEY="your_key"
   ```

3. **Enable WebSocket Support**:
   ```bash
   az webapp config set --name aria-voice-assistant --resource-group AriaRG --web-sockets-enabled true
   ```

4. **Deploy the Application**:
   ```bash
   az webapp up --name aria-voice-assistant --resource-group AriaRG
   ```

#### Option 3: GitHub Actions (CI/CD)

1. **Set up Azure Credentials**:
   - Go to your GitHub repository settings
   - Add `AZURE_CREDENTIALS` secret with your Azure service principal credentials

2. **Push to Main Branch**:
   ```bash
   git add .
   git commit -m "Add Azure deployment configuration"
   git push origin main
   ```

Your app will be automatically deployed to Azure!

## 📊 Monitoring & Logs

### View Application Logs
```bash
az webapp log tail --name aria-voice-assistant --resource-group AriaRG
```

### View Application Metrics
```bash
az monitor metrics list --resource /subscriptions/<subscription-id>/resourceGroups/AriaRG/providers/Microsoft.Web/sites/aria-voice-assistant --metric "Requests"
```

### Restart Application
```bash
az webapp restart --name aria-voice-assistant --resource-group AriaRG
```

## 🧹 Cleanup

To delete all Azure resources:
```bash
az group delete --name AriaRG
```
