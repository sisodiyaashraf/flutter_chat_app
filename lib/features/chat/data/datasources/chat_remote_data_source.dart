import 'dart:async';
import 'dart:convert'; // Import this for JSON decoding
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../models/message_model.dart';

abstract class ChatRemoteDataSource {
  Stream<MessageModel> get messageStream;
  Stream<bool> get typingStream;
  void connect();
  void disconnect();
  void sendMessage(String text, String username);
  void sendTyping(bool isTyping);
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  late IO.Socket _socket;
  final _messageController = StreamController<MessageModel>.broadcast();
  final _typingController = StreamController<bool>.broadcast();

  @override
  Stream<MessageModel> get messageStream => _messageController.stream;

  @override
  Stream<bool> get typingStream => _typingController.stream;

  @override
  void connect() {
    print("🔄 Connecting to Python Server...");

    // 1. Connection Logic
    _socket = IO.io('http://10.0.2.2:5000', IO.OptionBuilder()
        .setTransports(['websocket'])
        .disableAutoConnect()
        .build());

    _socket.connect();

    _socket.onConnect((_) => print('✅ Socket Connected to Python Server'));
    _socket.onDisconnect((_) => print('❌ Socket Disconnected'));

    // 2. SAFE MESSAGE LISTENER (The Fix)
    _socket.on('receive_message', (data) {
      print("🔔 Flutter Received Data: $data");

      try {
        Map<String, dynamic> safeMap;

        // SCENARIO A: Data is already a Map (Normal)
        if (data is Map) {
          safeMap = Map<String, dynamic>.from(data);
        }
        // SCENARIO B: Data is a String (Sometimes happens from Web)
        else if (data is String) {
          print("⚠️ Received String, attempting to parse JSON...");
          safeMap = jsonDecode(data);
        }
        // SCENARIO C: Unknown
        else {
          print("⚠️ Unknown data type: ${data.runtimeType}");
          return;
        }

        final messageModel = MessageModel.fromJson(safeMap);
        _messageController.add(messageModel);
        print("✅ Message processed and sent to UI");

      } catch (e) {
        print("❌ ERROR processing message: $e");
      }
    });

    // 3. SAFE TYPING LISTENER
    _socket.on('typing_status', (data) {
      try {
        if (data is Map) {
          _typingController.add(data['isTyping'] ?? false);
        }
      } catch (e) {
        print("Typing error: $e");
      }
    });
  }

  @override
  void sendMessage(String text, String username) {
    _socket.emit('send_message', {
      'text': text,
      'sender': username,
      'time': DateTime.now().toIso8601String(),
    });
  }

  @override
  void sendTyping(bool isTyping) {
    if (_socket.connected) {
      _socket.emit('typing', {'isTyping': isTyping});
    }
  }

  @override
  void disconnect() {
    try {
      if (_socket.connected) _socket.disconnect();
    } catch (e) {}
    _messageController.close();
    _typingController.close();
  }
}