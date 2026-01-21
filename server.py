import socketio
import eventlet

# 1. Create the Server
# cors_allowed_origins='*' allows your Flutter app to connect from any IP
sio = socketio.Server(cors_allowed_origins='*')

# 2. Wrap it in a WSGI application (standard Python web app format)
app = socketio.WSGIApp(sio)

print("🚀 Python Socket.IO Server running on port 5000...")

# --- EVENT HANDLERS ---

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

    # Broadcast 'receive_message' to ALL clients (including sender)
    sio.emit('receive_message', data)

# NEW: Listen for 'typing' status from Flutter
@sio.event
def typing(sid, data):
    # data will be: {'isTyping': True} or {'isTyping': False}
    # print(f"User {sid} is typing: {data['isTyping']}")

    # Broadcast 'typing_status' to everyone EXCEPT the sender (skip_sid=sid)
    # We don't want to see our own "typing..." indicator
    sio.emit('typing_status', data, skip_sid=sid)

# 3. Start the Server
if __name__ == '__main__':
    # Using port 5000 as established previously
    eventlet.wsgi.server(eventlet.listen(('', 5000)), app)