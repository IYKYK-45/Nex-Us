import 'package:flutter/material.dart';
import 'package:nex_us/screens/chat/one2one_screen.dart';

class Chat {
  final String name;
  final String lastMessage;
  final String time;
  final int unread;
  final String avatar;

  Chat({
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.unread,
    required this.avatar,
  });

  // Optional: factory for Firebase integration later
  factory Chat.fromMap(Map<String, dynamic> data) {
    return Chat(
      name: data['name'] ?? '',
      lastMessage: data['lastMessage'] ?? '',
      time: data['time'] ?? '',
      unread: data['unread'] ?? 0,
      avatar: data['avatar'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'lastMessage': lastMessage,
      'time': time,
      'unread': unread,
      'avatar': avatar,
    };
  }
}

class MessagesPage extends StatelessWidget {
  const MessagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Chat> chats = [
      Chat(
        name: 'Sarah Johnson',
        lastMessage: 'Hey, are we still meeting for the lab?',
        time: '10:30 AM',
        unread: 1,
        avatar: 'assets/images/sarah.png',
      ),
      Chat(
        name: 'CS-101 Study Group',
        lastMessage: 'Michael: I uploaded the notes!',
        time: '9:45 AM',
        unread: 3,
        avatar: 'assets/images/group.png',
      ),
      Chat(
        name: 'Prof. Michael Chen',
        lastMessage: 'Please submit your proposal by Fri.',
        time: 'Yesterday',
        unread: 0,
        avatar: 'assets/images/prof.png',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Messages"),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: ListView.builder(
        itemCount: chats.length,
        itemBuilder: (context, index) {
          final chat = chats[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChatPage(
                    userName: chat.name,
                    avatar: chat.avatar,
                  ),
                ),
              );
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade400.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundImage: AssetImage(chat.avatar),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(chat.name,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 4),
                        Text(
                          chat.lastMessage,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(chat.time,
                          style: TextStyle(
                              color: Colors.grey[500], fontSize: 12)),
                      if (chat.unread > 0)
                        Container(
                          margin: const EdgeInsets.only(top: 6),
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: Colors.blueAccent,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            chat.unread.toString(),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 12),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

