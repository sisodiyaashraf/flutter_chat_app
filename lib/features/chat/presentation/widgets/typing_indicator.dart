import 'package:flutter/material.dart';
import '../../provider/chat_provider.dart';

/// Shows typing indicator when another user is typing.
class TypingIndicator extends StatelessWidget {
  final ChatProvider provider;
  const TypingIndicator({required this.provider, super.key});

  @override
  Widget build(BuildContext context) {
    final status = provider.typingStatusText;
    if (status == null) return const SizedBox.shrink();
    return Padding(
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
            children: [
              const SizedBox(
                width: 10,
                height: 10,
                child: CircularProgressIndicator(
                  strokeWidth: 1.5,
                  color: Color(0xFF008069),
                ),
              ),
              const SizedBox(width: 8),
              Text(status, style: const TextStyle(color: Colors.black87)),
            ],
          ),
        ),
      ),
    );
  }
}
