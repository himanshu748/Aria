# main.py - Aria Voice Assistant
from fastapi import FastAPI, Request, WebSocket
from fastapi.staticfiles import StaticFiles
from fastapi.templating import Jinja2Templates
import logging
import asyncio
import base64
import re
import json
import os

# Import services and config
from services import stt, llm, tts

# Configure logging for Azure
log_level = os.getenv('LOG_LEVEL', 'INFO')
logging.basicConfig(
    level=getattr(logging, log_level.upper()),
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[
        logging.StreamHandler(),
        logging.FileHandler('aria.log', mode='a') if os.path.exists('/home') else logging.NullHandler()
    ]
)

app = FastAPI(
    title="Aria - AI Voice Assistant",
    description="An intelligent voice assistant powered by AI technologies",
    version="1.0.0"
)

# Mount static files for CSS/JS
static_dir = os.path.join(os.path.dirname(__file__), "static")
templates_dir = os.path.join(os.path.dirname(__file__), "templates")

app.mount("/static", StaticFiles(directory=static_dir), name="static")
templates = Jinja2Templates(directory=templates_dir)


@app.get("/")
async def home(request: Request):
    """Serves the main HTML page."""
    return templates.TemplateResponse("index.html", {"request": request})


@app.websocket("/ws")
async def websocket_endpoint(websocket: WebSocket):
    """Handles WebSocket connection for real-time transcription and voice response."""
    await websocket.accept()
    logging.info("WebSocket client connected.")

    loop = asyncio.get_event_loop()
    chat_history = []
    api_keys = {}

    async def handle_transcript(text: str):
        """Processes the final transcript, gets LLM and TTS responses, and streams audio."""
        await websocket.send_json({"type": "final", "text": text})
        try:
            # 1. Decide whether to search the web
            if llm.should_search_web(text, api_keys.get("gemini")):
                full_response, updated_history = llm.get_web_response(text, chat_history, api_keys.get("gemini"), api_keys.get("serpapi"))
            else:
                full_response, updated_history = llm.get_llm_response(text, chat_history, api_keys.get("gemini"))
            
            # Update history for the next turn
            chat_history.clear()
            chat_history.extend(updated_history)

            # Send the full text response to the UI
            await websocket.send_json({"type": "assistant", "text": full_response})

            # 2. Split the response into sentences
            sentences = re.split(r'(?<=[.?!])\s+', full_response.strip())
            
            # 3. Process each sentence for TTS and stream audio back
            for sentence in sentences:
                if sentence.strip():
                    # Run the blocking TTS function in a separate thread
                    audio_bytes = await loop.run_in_executor(
                        None, tts.speak, sentence.strip(), api_keys.get("murf")
                    )
                    if audio_bytes:
                        b64_audio = base64.b64encode(audio_bytes).decode('utf-8')
                        await websocket.send_json({"type": "audio", "b64": b64_audio})

        except Exception as e:
            logging.error(f"Error in LLM/TTS pipeline: {e}")
            await websocket.send_json({"type": "llm", "text": "Sorry, I encountered an error."})


    def on_final_transcript(text: str):
        logging.info(f"Final transcript received: {text}")
        asyncio.run_coroutine_threadsafe(handle_transcript(text), loop)

    try:
        # The first message from the client should be the API keys
        config_data = await websocket.receive_text()
        config = json.loads(config_data)
        if config.get("type") == "config":
            api_keys = config.get("keys", {})

        transcriber = stt.AssemblyAIStreamingTranscriber(
            on_final_callback=on_final_transcript, 
            api_key=api_keys.get("assemblyai")
        )

        while True:
            data = await websocket.receive_bytes()
            transcriber.stream_audio(data)
    except Exception as e:
        logging.info(f"WebSocket connection closed: {e}")
    finally:
        if 'transcriber' in locals() and transcriber:
            transcriber.close()
        logging.info("Transcription resources released.")
