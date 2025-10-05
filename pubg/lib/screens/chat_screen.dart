import 'package:flutter/material.dart';

class ChatDetailScreen extends StatefulWidget {
  final String sellerName;

  const ChatDetailScreen({Key? key, required this.sellerName}) : super(key: key);

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [
    {
      'text': 'Hello! Is this account still available?',
      'isSender': true,
      'time': '10:30 AM',
    },
    {
      'text': 'Yes, it is! Are you interested?',
      'isSender': false,
      'time': '10:32 AM',
    },
    {
      'text': 'Can I see more screenshots?',
      'isSender': true,
      'time': '10:35 AM',
    },
  ];

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      setState(() {
        _messages.add({
          'text': _messageController.text,
          'isSender': true,
          'time': 'Just now',
        });
      });
      _messageController.clear();
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            const CircleAvatar(
              radius: 18,
              backgroundColor: Colors.orange,
              child: Icon(Icons.person, size: 20),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.sellerName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Active now',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[400],
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _buildMessage(
                  message['text'],
                  message['isSender'],
                  message['time'],
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              border: Border(
                top: BorderSide(color: Colors.grey[800]!, width: 0.5),
              ),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.image, color: Colors.orange),
                    onPressed: () {},
                  ),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        hintStyle: TextStyle(color: Colors.grey[600]),
                        filled: true,
                        fillColor: Colors.black,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.orange,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.black),
                      onPressed: _sendMessage,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessage(String text, bool isSender, String time) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment:
            isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isSender) ...[
            const CircleAvatar(
              radius: 16,
              backgroundColor: Colors.orange,
              child: Icon(Icons.person, size: 16),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment:
                  isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isSender ? Colors.orange : Colors.grey[900],
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Text(
                    text,
                    style: TextStyle(
                      color: isSender ? Colors.black : Colors.white,
                      fontSize: 15,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          if (isSender) ...[
            const SizedBox(width: 8),
            const CircleAvatar(
              radius: 16,
              backgroundColor: Colors.blue,
              child: Icon(Icons.person, size: 16),
            ),
          ],
        ],
      ),
    );
  }
}