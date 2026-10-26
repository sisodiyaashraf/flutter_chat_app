import os
from flask import Flask, send_from_directory
import socketio

# 1️⃣ Create Flask app
app = Flask(__name__, static_folder='.', static_url_path='')

# 2️⃣ Create Socket.IO server with threading async mode
sio = socketio.Server(cors_allowed_origins='*', async_mode='threading')

# 3️⃣ Wrap with WSGI app
socket_app = socketio.WSGIApp(sio, app)

# Serve the index.html at root
@app.route('/')
def index():
    return send_from_directory('.', 'index.html')

# ---------- Socket.IO event handlers ----------
@sio.event
def connect(sid, environ):
    print(f'✅ Client connected: {sid}')

@sio.event
def disconnect(sid):
    print(f'❌ Client disconnected: {sid}')

# Listen for 'send_message' from Flutter
@sio.event
def send_message(sid, data):
    print(f'📩 Received from {sid}: {data}')
    # Broadcast to everyone EXCEPT the sender (skip_sid)
    sio.emit('receive_message', data, skip_sid=sid)

# Listen for typing status
@sio.event
def typing(sid, data):
    # Broadcast to others (skip sender)
    sio.emit('typing_status', data, skip_sid=sid)

# 4️⃣ Start the server
if __name__ == '__main__':
    port = int(os.getenv('PORT', 5000))
    print(f'🚀 Python Socket.IO Server running on port {port}...')
    # Using Werkzeug's built‑in development server with threading
    from werkzeug.serving import run_simple
    run_simple('0.0.0.0', port, socket_app, use_reloader=False, threaded=True)