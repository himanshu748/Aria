# Aria - AI Voice Assistant

[![Azure Deployment](https://img.shields.io/badge/Azure-Deployed-blue?logo=microsoft-azure)](https://aria-voice-assistant.azurewebsites.net)
[![Python](https://img.shields.io/badge/Python-3.9+-green?logo=python)](https://python.org)
[![FastAPI](https://img.shields.io/badge/FastAPI-Framework-009688?logo=fastapi)](https://fastapi.tiangolo.com)

Aria is a sophisticated AI-powered voice assistant that combines modern speech technologies with large language models to provide natural, real-time conversational experiences.

## 🎯 Features

- **🎤 Voice Input**: Real-time speech-to-text with turn detection
- **🧠 AI Intelligence**: Powered by Google Gemini for natural conversations
- **🔊 Voice Output**: High-quality text-to-speech synthesis
- **🔍 Web Search**: Access to current information via real-time search
- **🌐 Modern Web Interface**: Clean, responsive design with WebSocket support
- **☁️ Cloud Ready**: Deployed on Azure with full containerization support

## 🛠️ Tech Stack

- **Backend**: FastAPI, Python 3.9+
- **AI Services**: 
  - Google Gemini (LLM)
  - AssemblyAI (Speech-to-Text)
  - Murf AI (Text-to-Speech)
  - SerpAPI (Web Search)
- **Frontend**: HTML5, Bootstrap, JavaScript (WebSocket)
- **Deployment**: Azure App Service, Docker

## 🚀 Quick Start

### Local Development

1. **Clone the repository**
   ```bash
   git clone https://github.com/himanshu748/Aria.git
   cd Aria/aria
   ```

2. **Install dependencies**
   ```bash
   pip install -r requirements.txt
   ```

3. **Configure environment variables**
   ```bash
   cp .env.example .env
   # Edit .env with your API keys
   ```

4. **Run the application**
   ```bash
   uvicorn main:app --reload
   ```

5. **Open your browser**
   Navigate to `http://localhost:8000`

### One-Click Setup
```bash
./setup.sh
```

## ☁️ Azure Deployment

### Prerequisites Check
```bash
./check-azure-prerequisites.sh
```

### Deploy to Azure
```bash
./prepare-deployment.sh
./deploy-azure.sh
```

Your app will be available at: `https://aria-voice-assistant.azurewebsites.net`

## 🔧 Configuration

### Required API Keys

- **Google Gemini API**: For LLM capabilities
- **AssemblyAI API**: For speech-to-text conversion
- **Murf AI API**: For text-to-speech synthesis
- **SerpAPI**: For web search functionality

### Environment Variables

Create a `.env` file with:
```env
GEMINI_API_KEY=your_gemini_api_key
ASSEMBLYAI_API_KEY=your_assemblyai_api_key
MURF_API_KEY=your_murf_api_key
SERPAPI_KEY=your_serpapi_key
```

## 📁 Project Structure

```
aria/
├── main.py                    # FastAPI application
├── services/                  # AI service integrations
│   ├── llm.py                # Google Gemini integration
│   ├── stt.py                # AssemblyAI speech-to-text
│   └── tts.py                # Murf AI text-to-speech
├── static/                   # Frontend assets
├── templates/                # HTML templates
├── deploy-azure.sh           # Azure deployment script
├── setup.sh                  # Local setup script
└── requirements.txt          # Python dependencies
```

## 🎭 Usage

1. **Visit the application** in your web browser
2. **Click the settings icon** ⚙️ to configure API keys
3. **Grant microphone permissions** when prompted
4. **Click the microphone button** to start talking
5. **Enjoy natural conversations** with Aria!

## 🔄 Development

### Running locally
```bash
uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

### Running with Docker
```bash
docker build -t aria .
docker run -p 8000:8000 --env-file .env aria
```

### View logs (Azure)
```bash
az webapp log tail --name aria-voice-assistant --resource-group AriaRG
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Google Gemini for the language model
- AssemblyAI for speech-to-text capabilities
- Murf AI for text-to-speech synthesis
- SerpAPI for web search functionality
- Azure for cloud hosting

## 📞 Support

For support, email jhahimanshu653@gmail.com or create an issue on GitHub.

---

**Made with ❤️ by [himanshu748](https://github.com/himanshu748)**
