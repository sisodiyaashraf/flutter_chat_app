import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/chat_provider.dart';
import '../widgets/message_bubble.dart';

/// Displays the list of chat messages.
class MessageList extends StatelessWidget {
  const MessageList({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ChatProvider>(context);
    // Auto‑scroll to the bottom when new messages arrive
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (provider.scrollController.hasClients) {
        provider.scrollController.animateTo(
          provider.scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
    return Expanded(
      child: ListView.builder(
        controller: provider.scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        itemCount: provider.messages.length,
        itemBuilder: (context, index) {
          final msg = provider.messages[index];
          final isMe = msg.sender == provider.currentUsername;
          return MessageBubble(message: msg, isMe: isMe);
        },
      ),
    );
  }
}
