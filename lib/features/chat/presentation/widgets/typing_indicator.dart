import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/chat_provider.dart';

/// Shows typing indicator when another user is typing.
class TypingIndicator extends StatelessWidget {
  const TypingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final status = Provider.of<ChatProvider>(context).typingStatusText;
    // early return removed; AnimatedSwitcher will handle null
    return AnimatedSwitcher(
      duration: Duration.zero,
      transitionBuilder: (child, animation) => child,
      child: status == null
          ? const SizedBox.shrink(key: ValueKey('empty'))
          : Padding(
              key: const ValueKey('typing'),
              padding: const EdgeInsets.only(left: 20, bottom: 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha((0.9 * 255).round()),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha((0.04 * 255).round()),
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
                        child: const CircularProgressIndicator(
                          strokeWidth: 1.5,
                          color: Color(0xFF008069),
                          value: 1.0,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(status, style: const TextStyle(color: Colors.black87)),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

