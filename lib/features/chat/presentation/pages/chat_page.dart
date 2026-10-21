import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/service_locator.dart';
import '../provider/chat_provider.dart';
import '../widgets/message_bubble.dart';
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
  final TextEditingController _textController = TextEditingController();

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
    _textController.dispose();
    // Provider handles scrollController disposal
    super.dispose();
  }

  void _scrollToBottom() {
    final controller = _provider.scrollController;
    if (controller.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        controller.animateTo(
          controller.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
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
          // Message List
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              itemCount: _provider.messages.length,
              itemBuilder: (context, index) {
                final msg = _provider.messages[index];
                final isMe = msg.sender == _provider.currentUsername;
                return MessageBubble(message: msg, isMe: isMe);
              },
            ),
          ),

          // Typing Indicator
          // Typing indicator from provider
          if (_provider.typingStatusText != null)
            Padding(
              padding: const EdgeInsets.only(left: 20, bottom: 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      SizedBox(
                        width: 10,
                        height: 10,
                        child: CircularProgressIndicator(
                          strokeWidth: 1.5,
                          color: Color(0xFF008069),
                        ),
                      ),
                      SizedBox(width: 8),
                      // The provider supplies the status text
                      // This placeholder will be replaced by the actual text via Consumer below.
                    ],
                  ),
                ),
              ),
            ),

          // Input Area
          _buildInputArea(),
        ],
      ),
    ));
  }


}