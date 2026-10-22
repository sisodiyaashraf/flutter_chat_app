import 'dart:async';
import 'dart:convert'; // For JSON decoding
import 'package:flutter/foundation.dart'; // For debugPrint and kDebugMode
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:uuid/uuid.dart';
import '../../../../core/config.dart';
import '../models/message_model.dart';

abstract class ChatRemoteDataSource {
  Stream<MessageModel> get messageStream;
  Stream<Map<String, dynamic>> get typingStream;
  void connect();
  void disconnect();
  void sendMessage(String text, String username);
  void sendTyping(bool isTyping, String username);
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  late io.Socket _socket;
  final _messageController = StreamController<MessageModel>.broadcast();
  final _typingController = StreamController<Map<String, dynamic>>.broadcast();

  @override
  Stream<MessageModel> get messageStream => _messageController.stream;

  @override
  Stream<Map<String, dynamic>> get typingStream => _typingController.stream;

  @override
  void connect() {
    if (kDebugMode) debugPrint('🔄 Connecting to Python Server...');

    _socket = io.io(AppConfig.serverUrl, io.OptionBuilder()
        .setTransports(['websocket'])
        .disableAutoConnect()
        .build());

    _socket.connect();

    _socket.onConnect((_) {
      if (kDebugMode) debugPrint('✅ Socket Connected to Python Server');
    });
    _socket.onDisconnect((_) {
      if (kDebugMode) debugPrint('❌ Socket Disconnected');
    });

    // Safe message listener
    _socket.on('receive_message', (data) {
      if (kDebugMode) debugPrint('🔔 Flutter Received Data: $data');
      try {
        Map<String, dynamic> safeMap;
        if (data is Map) {
          safeMap = Map<String, dynamic>.from(data);
        } else if (data is String) {
          if (kDebugMode) debugPrint('⚠️ Received String, attempting to parse JSON...');
          safeMap = jsonDecode(data);
        } else {
          if (kDebugMode) debugPrint('⚠️ Unknown data type: ${data.runtimeType}');
          return;
        }
        final messageModel = MessageModel.fromJson(safeMap);
        _messageController.add(messageModel);
        if (kDebugMode) debugPrint('✅ Message processed and sent to UI');
      } catch (e) {
        if (kDebugMode) debugPrint('❌ ERROR processing message: $e');
      }
    });

    // Safe typing listener
    _socket.on('typing_status', (data) {
      try {
        if (data is Map) {
          _typingController.add(Map<String, dynamic>.from(data));
        }
      } catch (e) {
        if (kDebugMode) debugPrint('Typing error: $e');
      }
    });
  }

  @override
  void sendMessage(String text, String username) {
    final payload = {
      'id': const Uuid().v4(),
      'text': text,
      'sender': username,
      'time': DateTime.now().toIso8601String(),
    };
    _socket.emit('send_message', payload);
  }

  @override
  void sendTyping(bool isTyping, String username) {
    if (_socket.connected) {
      _socket.emit('typing', {
        'isTyping': isTyping,
        'username': username,
      });
    }
  }

  @override
  void disconnect() {
    try {
      if (_socket.connected) _socket.disconnect();
    } catch (e) { if (kDebugMode) debugPrint('❌ Disconnect error: $e'); }
    // Do NOT close stream controllers here; they are managed by the repository/provider lifecycle.
  }
}