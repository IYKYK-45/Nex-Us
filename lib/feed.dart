import 'package:flutter/material.dart';

void main() => runApp(const CampusConnectApp());

class CampusConnectApp extends StatelessWidget {
  const CampusConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
      ),
      home: const MainNavigationHolder(),
    );
  }
}

/// [PostModel] - Holds data for each post.
/// Added [comments] list to store strings for each individual post.
class PostModel {
  final String id;
  final String name;
  final String major;
  final String time;
  final String content;
  final List<String> hashtags;
  int likes;
  bool isLiked;
  List<String> comments; // New: List to store comments for this specific post

  PostModel({
    required this.id,
    required this.name,
    required this.major,
    required this.time,
    required this.content,
    this.hashtags = const [],
    this.likes = 0,
    this.isLiked = false,
    required this.comments,
  });
}

class MainNavigationHolder extends StatefulWidget {
  const MainNavigationHolder({super.key});

  @override
  State<MainNavigationHolder> createState() => _MainNavigationHolderState();
}

class _MainNavigationHolderState extends State<MainNavigationHolder> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const FeedScreen(),
    const Center(child: Text("Reels Section")),
    const Center(child: Text("Discover Students")),
    const Center(child: Text("Direct Messages")),
    const Center(child: Text("User Profile")),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Feed'),
          BottomNavigationBarItem(icon: Icon(Icons.play_circle_outline), label: 'Reels'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Discover'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: 'Messages'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
}

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final TextEditingController _postController = TextEditingController();

  // Local list of posts with initialized empty comment lists
  final List<PostModel> _posts = [
    PostModel(
      id: "1",
      name: 'Emily Chen',
      major: 'Biology \'24',
      time: '2h ago',
      content: 'Just finished my research presentation on cellular biology! 🧬',
      hashtags: ['#research', '#biology'],
      likes: 45,
      comments: ["Great job Emily!", "Can I get a copy of the slides?"],
    ),
  ];

  /// Handles creating a new post
  void _handlePost() {
    if (_postController.text.trim().isEmpty) return;

    setState(() {
      _posts.insert(0, PostModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: "John Doe",
        major: "Computer Science '26",
        time: "Just now",
        content: _postController.text,
        hashtags: ["#campus", "#update"],
        comments: [], // Initialize with zero comments
      ));
      _postController.clear();
      FocusScope.of(context).unfocus();
    });
  }

  /// Handles deleting a post
  void _deletePost(String postId) {
    setState(() {
      _posts.removeWhere((post) => post.id == postId);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Post deleted"), duration: Duration(seconds: 1)),
    );
  }

  /// Opens a bottom sheet for comments specific to the selected post
  void _showCommentSheet(PostModel post) {
    final TextEditingController commentFieldController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allows sheet to move up with the keyboard
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return StatefulBuilder( // Necessary to update UI inside the modal
            builder: (BuildContext context, StateSetter setModalState) {
              return Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom, // Avoid keyboard overlap
                  left: 16, right: 16, top: 16,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text("Comments", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    const Divider(),
                    // List of existing comments
                    ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.4),
                      child: post.comments.isEmpty
                          ? const Padding(padding: EdgeInsets.all(20), child: Text("No comments yet."))
                          : ListView.builder(
                        shrinkWrap: true,
                        itemCount: post.comments.length,
                        itemBuilder: (context, i) => ListTile(
                          leading: const CircleAvatar(radius: 15),
                          title: Text(post.comments[i]),
                        ),
                      ),
                    ),
                    // Input area for new comment
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: commentFieldController,
                              decoration: InputDecoration(
                                hintText: "Add a comment...",
                                filled: true,
                                fillColor: Colors.grey.shade100,
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.send, color: Colors.blue),
                            onPressed: () {
                              if (commentFieldController.text.isNotEmpty) {
                                // Update the global state AND the modal state
                                setState(() {
                                  post.comments.add(commentFieldController.text);
                                });
                                setModalState(() {}); // Refresh list inside the sheet
                                commentFieldController.clear();
                              }
                            },
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CampusConnect', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0.5,
        actions: [
          // Added: Notes Icon
          IconButton(icon: const Icon(Icons.note_alt_outlined), onPressed: () {}),
          // Added: Announcement Icon
          IconButton(icon: const Icon(Icons.campaign_outlined), onPressed: () {}),
          IconButton(icon: const Icon(Icons.notifications_none), onPressed: () {}),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _posts.length + 2,
        itemBuilder: (context, index) {
          if (index == 0) return const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Text('Your Feed', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
          );
          if (index == 1) return _buildPostInput();

          final post = _posts[index - 2];
          return _buildPostCard(post);
        },
      ),
    );
  }

  /// UI for the Post creation box
  Widget _buildPostInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const CircleAvatar(backgroundColor: Colors.indigo, child: Text("JD")),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _postController,
                  decoration: const InputDecoration(hintText: "What's on your mind?", border: InputBorder.none),
                ),
              ),
            ],
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.image_outlined, color: Colors.blue)),
              ElevatedButton(
                onPressed: _handlePost,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                child: const Text("Post"),
              ),
            ],
          )
        ],
      ),
    );
  }

  /// UI for each Feed Card
  Widget _buildPostCard(PostModel post) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(child: Text(post.name[0])),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(post.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text("${post.major} • ${post.time}", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ),
              // Post settings menu (Delete)
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: Colors.grey),
                onSelected: (val) => val == 'delete' ? _deletePost(post.id) : null,
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'delete', child: Text('Delete', style: TextStyle(color: Colors.red))),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(post.content, style: const TextStyle(fontSize: 15, height: 1.4)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            children: post.hashtags.map((tag) => Text(tag, style: const TextStyle(color: Colors.blue))).toList(),
          ),
          const Divider(height: 30),
          Row(
            children: [
              // Like Button
              IconButton(
                icon: Icon(post.isLiked ? Icons.favorite : Icons.favorite_border,
                    color: post.isLiked ? Colors.red : Colors.grey),
                onPressed: () => setState(() {
                  post.isLiked = !post.isLiked;
                  post.isLiked ? post.likes++ : post.likes--;
                }),
              ),
              Text("${post.likes}"),
              const SizedBox(width: 20),
              // Comment Button - Opens the Modal Bottom Sheet
              IconButton(
                icon: const Icon(Icons.mode_comment_outlined, color: Colors.grey, size: 20),
                onPressed: () => _showCommentSheet(post),
              ),
              Text("${post.comments.length}"), // Shows dynamic comment count
              const Spacer(),
              const Icon(Icons.share_outlined, color: Colors.grey, size: 20),
            ],
          )
        ],
      ),
    );
  }
}