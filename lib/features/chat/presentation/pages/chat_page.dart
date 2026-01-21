import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/service_locator.dart';
import '../../domain/entities/message_entity.dart';
import '../contract/chat_contract.dart';
import '../presenter/chat_presenter.dart';

class ChatPage extends StatefulWidget {
  // 1. UPDATE: Add username field
  final String username;

  // 2. UPDATE: Require username in constructor
  const ChatPage({super.key, required this.username});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> implements ChatView {
  // Dependency Injection
  final ChatPresenterImpl _presenter = sl<ChatPresenterImpl>();

  // Controllers
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // State
  final List<MessageEntity> _messages = [];
  bool _isOtherUserTyping = false;

  @override
  void initState() {
    super.initState();
    _presenter.attachView(this);

    // 3. UPDATE: Pass the username to the Presenter
    _presenter.initChat(widget.username);
  }

  @override
  void dispose() {
    _presenter.detachView();
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      // Small delay to ensure the list has rendered the new item
      Future.delayed(const Duration(milliseconds: 100), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  // --- View Implementation ---
  @override
  void showNewMessage(MessageEntity message) {
    setState(() {
      _messages.add(message);
    });
    _scrollToBottom();
  }

  @override
  void updateTypingStatus(bool isTyping) {
    setState(() {
      _isOtherUserTyping = isTyping;
    });
    if (isTyping) _scrollToBottom();
  }
  // ---------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isMe = msg.sender == _presenter.currentUsername;
                return _buildMessageBubble(msg, isMe);
              },
            ),
          ),

          // Typing Indicator
          if (_isOtherUserTyping)
            Padding(
              padding: const EdgeInsets.only(left: 20, bottom: 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      SizedBox(
                          width: 12,
                          height: 12,
                          child: CircularProgressIndicator(strokeWidth: 2)
                      ),
                      SizedBox(width: 8),
                      Text(
                        "Someone is typing...",
                        style: TextStyle(color: Colors.grey, fontSize: 12, fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Input Area
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(MessageEntity msg, bool isMe) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: isMe ? const Color(0xFFE7FFDB) : Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 2,
                offset: const Offset(0, 1),
              )
            ],
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(12),
              topRight: const Radius.circular(12),
              bottomLeft: isMe ? const Radius.circular(12) : Radius.zero,
              bottomRight: isMe ? Radius.zero : const Radius.circular(12),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!isMe)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Text(
                    msg.sender,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange[800],
                    ),
                  ),
                ),
              Text(
                msg.text,
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 4),
              Text(
                DateFormat('hh:mm a').format(msg.time),
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.black.withOpacity(0.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.emoji_emotions_outlined, color: Colors.grey),
              onPressed: () {},
            ),
            Expanded(
              child: TextField(
                controller: _textController,
                onChanged: (text) => _presenter.onTextChanged(text),
                decoration: const InputDecoration(
                  hintText: "Type a message...",
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 8),
                ),
              ),
            ),
            const SizedBox(width: 8),
            FloatingActionButton(
              mini: true,
              backgroundColor: const Color(0xFF008069),
              elevation: 0,
              onPressed: () {
                _presenter.sendMessage(_textController.text);
                _textController.clear();
              },
              child: const Icon(Icons.send, color: Colors.white, size: 18),
            ),
          ],
        ),
      ),
    );
  }
}