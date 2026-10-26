import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme.dart';
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
  // Removed manual provider field; we will obtain the provider from the surrounding MultiProvider.

  @override
  void initState() {
    super.initState();
    // Initialise chat after the first frame so that context is available.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ChatProvider>(context, listen: false).initChat(widget.username);
    });
  }

  @override
  void dispose() {
    // No explicit dispose needed; the Provider will dispose ChatProvider.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, provider, child) {
        return Container(
          decoration: const BoxDecoration(
            gradient: AppTheme.chatBackgroundGradient,
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              elevation: 1,
              backgroundColor: const Color(0xFF008069), // Teal Color
              foregroundColor: Colors.white,
              leading: const Padding(
                padding: EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundColor: Colors.white24,
                  child: Icon(Icons.person, color: Colors.white),
                ),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Flutter Chat",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    widget.username,
                    style: const TextStyle(fontSize: 12, color: Colors.white70),
                  ),
                ],
              ),
              actions: [
                Icon(
                  Icons.circle,
                  color: provider.isConnected ? Colors.green : Colors.red,
                  size: 12,
                ),
                IconButton(onPressed: () {}, icon: const Icon(Icons.videocam)),
                IconButton(onPressed: () {}, icon: const Icon(Icons.call)),
                IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
              ],
            ),
            body: Column(
              children: [
                MessageList(),
                // TypingIndicator will now read from the provider via Consumer.
                // It can be passed the provider if needed.
                // For simplicity we keep the widget unchanged.
                TypingIndicator(provider: provider),
                ChatInputArea(),
              ],
            ),
          ),
        );
      },
    );
  }
}
