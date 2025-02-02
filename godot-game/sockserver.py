from fastapi import FastAPI, WebSocket
import websockets
app = FastAPI()

@app.websocket("/ws")
async def websocket_endpoint(websocket: WebSocket):
    await websocket.accept()
    while True:
        data = await websocket.receive_text()
        if data == "Init":
            await websocket.send_text(f"Session initialised")
        else:
            await websocket.send_text(f"Pong {data}")

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="localhost", port=8765)