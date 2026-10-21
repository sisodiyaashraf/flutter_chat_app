import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/service_locator.dart';
import '../provider/chat_provider.dart';

import '../widgets/message_list.dart';
import '../widgets/typing_indicator.dart';
import '../widgets/chat_input_area.dart';

class ChatPage extends StatefulWidget {
  // 1. UPDATE: Add username field
  final String username;

  // 2. UPDATE: Require username in constructor
  const ChatPage({super.key, required this.username});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // Dependency Injection
  late final ChatProvider _provider;


  // Controllers


  // State


  @override
  void initState() {
    super.initState();
    _provider = sl<ChatProvider>();
    _provider.initChat(widget.username);
  }

  @override
  void dispose() {
    _provider.dispose();

    // Provider handles scrollController disposal
    super.dispose();
  }


  // --- Provider‑driven UI ---
  // No longer implements ChatView; UI reacts to provider changes via Consumer.

  // ---------------------------

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _provider,
      child: Scaffold(
      backgroundColor: const Color(0xFFEFE7DE), // Chat Background Color
      appBar: AppBar(
        elevation: 1,
        backgroundColor: const Color(0xFF008069), // Teal Color
        foregroundColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.white24,
            child: const Icon(Icons.person, color: Colors.white),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Flutter Chat",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            // 4. Display the passed username or the one from presenter
            Text(
              widget.username,
              style: const TextStyle(fontSize: 12, color: Colors.white70),
            )
          ],
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.videocam)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.call)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
        ],
      ),
      body: Column(
        children: [
          const MessageList(),

          TypingIndicator(provider: _provider),

          // Input Area
          const ChatInputArea(),
        ],
      ),
    ));
  }


}