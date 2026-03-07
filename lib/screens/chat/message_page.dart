import 'package:flutter/material.dart';
import 'package:nex_us/screens/chat/chat_page.dart';

class Chat {
  final String name;
  String lastMessage;
  String time;
  final int unread;
  final String avatar;
  bool pinned;

  Chat({
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.unread,
    required this.avatar,
    this.pinned = false,
  });

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

class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key});

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  Map<String, List<Map<String, dynamic>>> chatMessagesMap = {
    'Sarah Johnson': [
      {'text': 'Hey! How are you?', 'isMe': false, 'time': '10:30 AM'},
      {'text': 'I’m good, just finished coding.', 'isMe': true, 'time': '10:31 AM'},
    ],
    'CS-101 Study Group': [
      {'text': 'Michael: I uploaded the notes!', 'isMe': false, 'time': '9:45 AM'},
    ],
    'Prof. Michael Chen': [
      {'text': 'Please submit your proposal by Fri.', 'isMe': false, 'time': 'Yesterday'},
    ],
  };

  List<Chat> chats = [
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

  void _deleteChat(int index) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.warning_amber_rounded,
                  size: 48, color: Colors.redAccent),
              const SizedBox(height: 12),
              const Text(
                "Delete Chat?",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "This action will permanently remove the chat history. "
                    "Are you sure you want to continue?",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade300,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel"),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        chats.removeAt(index);
                      });
                      Navigator.pop(context);
                    },
                    child: const Text("Delete"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredChats = chats
        .where((chat) =>
        chat.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Messages"),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          // 🔍 Search bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search contacts...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey.shade200,
              ),
              onChanged: (value) {
                setState(() => _searchQuery = value);
              },
            ),
          ),

          // Contact list
          Expanded(
            child: filteredChats.isEmpty
                ? const Center(
              child: Text(
                "No contacts found",
                style: TextStyle(color: Colors.grey),
              ),
            )
                : ListView.builder(
              itemCount: filteredChats.length,
              itemBuilder: (context, index) {
                final chat = filteredChats[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChatPage(
                          userName: chat.name,
                          avatar: chat.avatar,
                          initialMessages: chatMessagesMap[chat.name] ?? [],
                          // 👇 this is where you add the callback
                          onMessagesUpdated: (updatedList) {
                            setState(() {
                              chatMessagesMap[chat.name] = updatedList;

                              if (updatedList.isNotEmpty) {
                                final lastMsg = updatedList.last;
                                chat.lastMessage = lastMsg['text'];
                                chat.time = lastMsg['time'];
                              }

                              // 👇 Move chat to top, but below pinned ones
                              chats.remove(chat);
                              final pinnedCount = chats.where((c) => c.pinned).length;
                              chats.insert(pinnedCount, chat);
                            });
                          },
                        ),
                      ),
                    );
                  },


                  onLongPress: () {
                    showModalBottomSheet(
                      context: context,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                      ),
                      builder: (context) {
                        return Wrap(
                          children: [
                            if (!chat.pinned) // 👈 show Pin only if not pinned
                              ListTile(
                                leading: const Icon(Icons.push_pin),
                                title: const Text("Pin Chat"),
                                onTap: () {
                                  setState(() {
                                    chat.pinned = true;
                                    chats.remove(chat);
                                    chats.insert(0, chat); // pinned chats always at top
                                  });
                                  Navigator.pop(context);
                                },
                              ),
                            if (chat.pinned) // 👈 show Unpin only if pinned
                              ListTile(
                                leading: const Icon(Icons.push_pin_outlined),
                                title: const Text("Unpin Chat"),
                                onTap: () {
                                  setState(() {
                                    chat.pinned = false;
                                    chats.remove(chat);
                                    // put back just below other pinned chats
                                    final pinnedCount = chats.where((c) => c.pinned).length;
                                    chats.insert(pinnedCount, chat);
                                  });
                                  Navigator.pop(context);
                                },
                              ),

                            ListTile(
                              leading: const Icon(Icons.delete, color: Colors.red),
                              title: const Text("Delete Chat"),
                              onTap: () {
                                Navigator.pop(context);   // close the bottom sheet first
                                _deleteChat(index);       // 👈 show confirmation dialog
                              },
                            ),

                            ListTile(
                              leading: const Icon(Icons.volume_off),
                              title: const Text("Mute Notifications"),
                              onTap: () {
                                // Add mute logic here (e.g., mark chat as muted)
                                Navigator.pop(context);
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.archive),
                              title: const Text("Archive Chat"),
                              onTap: () {
                                // Add archive logic here (e.g., move to archived list)
                                Navigator.pop(context);
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.info_outline),
                              title: const Text("View Info"),
                              onTap: () {
                                // Show chat details (e.g., group info or profile)
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }, // 👈 delete option
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
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
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                              if (chat.pinned) ...[
                                const SizedBox(width: 6),
                                const Icon(Icons.push_pin, size: 16, color: Colors.grey), // 👈 pin icon
                              ],
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
                        Text(
                          chat.time,
                          style: TextStyle(
                              color: Colors.grey[500], fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}