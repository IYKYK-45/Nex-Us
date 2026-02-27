import 'package:flutter/material.dart';

/// [FeedScreen] - A high-performance, reactive campus social dashboard.
/// This version supports local assets, dynamic post creation, and interactive modals.
class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  // --- ELITE DATA ARCHITECTURE ---
  // This list simulates a database. We use 'isLocal' to tell Flutter
  // whether to look in your 'assets/images' folder or the internet.
  final List<Map<String, dynamic>> _posts = [
    {
      'id': '1',
      'name': 'Sarah Johnson',
      'role': 'Student',
      'content': 'Just finished my first group project for CS-101! Our team did an amazing job on the React app. Special thanks to the study group for the help! 🚀',
      'image': 'assets/images/images.jpeg', // Path to your local image
      'isLocal': true, // Logic gate for local asset rendering
      'likes': 1200,
      'isLiked': false,
      'tags': ['#CS101', '#React'],
      'comments': [
        {'user': 'Alex Riv', 'text': 'Great job!'},
        {'user': 'Maria K', 'text': 'The UI looks clean.'}
      ],
      'isOwner': false,
    }
  ];

  // User Session Data
  final String _currentUser = "Garvit Gupta";
  final String _userAvatar = "https://via.placeholder.com/150/6B4EE6/FFFFFF?text=GG";

  // Controllers for dynamic input handling
  final TextEditingController _updateController = TextEditingController();
  final List<String> _currentTags = [];
  int _activeTab = 0;

  // --- CORE LOGIC & INTERACTION HANDLERS ---

  /// Handles the "Post" button logic.
  /// Creates a new data object and injects it into the top of the feed.
  void _handlePost() {
    if (_updateController.text.isNotEmpty) {
      setState(() {
        _posts.insert(0, {
          'id': DateTime.now().toString(),
          'name': _currentUser,
          'role': 'Student',
          'content': _updateController.text,
          'image': null,
          'isLocal': false,
          'likes': 0,
          'isLiked': false,
          'tags': List<String>.from(_currentTags), // Deep copy for data persistence
          'comments': [],
          'isOwner': true, // Enables the delete button for this user
        });
        _updateController.clear();
        _currentTags.clear();
      });
    }
  }

  /// Safety Protocol: Verifies intent before permanent data deletion.
  void _confirmDelete(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Delete Post?"),
        content: const Text("This action is permanent. Are you sure?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              setState(() => _posts.removeAt(index));
              Navigator.pop(context);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }

  /// Dynamic Modal: Displays and manages the comment stream.
  void _showCommentPopup(int index) {
    TextEditingController commentCtrl = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 20, right: 20, top: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10))),
            const SizedBox(height: 15),
            const Text("Comments", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const Divider(),
            SizedBox(
              height: 250,
              child: ListView.builder(
                itemCount: _posts[index]['comments'].length,
                itemBuilder: (context, i) {
                  final comment = _posts[index]['comments'][i];
                  return ListTile(
                    leading: const CircleAvatar(radius: 15, backgroundColor: Color(0xFF6B4EE6)),
                    title: Text(comment['user'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    subtitle: Text(comment['text']),
                  );
                },
              ),
            ),
            _buildCommentInputField(commentCtrl, index),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color brandPurple = Color(0xFF6B4EE6);
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: _buildMncAppBar(brandPurple),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          const SizedBox(height: 16),
          _buildCreationCard(brandPurple),
          const SizedBox(height: 20),
          // Loop through the mock database to generate dynamic post widgets
          ..._posts.asMap().entries.map((entry) => _buildPostCard(entry.key, brandPurple)).toList(),
          const SizedBox(height: 100),
        ],
      ),
      bottomNavigationBar: _buildDynamicBottomNav(brandPurple),
    );
  }

  // --- UI ATOMIC WIDGETS ---

  /// Professional AppBar with identity and notification logic.
  PreferredSizeWidget _buildMncAppBar(Color brandColor) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleAvatar(
          backgroundColor: brandColor,
          child: const Text('N', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ),
      title: Text('CampusSphere', style: TextStyle(color: brandColor, fontWeight: FontWeight.bold)),
      actions: [
        IconButton(icon: const Icon(Icons.notifications_none, color: Colors.black), onPressed: () {}),
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: CircleAvatar(radius: 18, backgroundImage: NetworkImage(_userAvatar)),
        ),
      ],
    );
  }

  /// The interactive "Share an update" input engine.
  Widget _buildCreationCard(Color accent) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Share an update", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
          const SizedBox(height: 12),
          TextField(
            controller: _updateController,
            maxLines: 2,
            decoration: InputDecoration(
              hintText: "What's happening on campus?",
              fillColor: const Color(0xFFF8F9FA),
              filled: true,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
            ),
          ),
          if (_currentTags.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Wrap(spacing: 8, children: _currentTags.map((t) => Text(t, style: TextStyle(color: accent, fontWeight: FontWeight.bold))).toList()),
            ),
          const SizedBox(height: 12),
          Row(
            children: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.image_outlined, color: Colors.grey)),
              TextButton(onPressed: _showTagPopup, child: const Text("Tag Community")),
              const Spacer(),
              ElevatedButton(
                onPressed: _handlePost,
                style: ElevatedButton.styleFrom(backgroundColor: accent, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                child: const Text("Post"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// The Post Card Widget: Handles dynamic image rendering (Local vs Network).
  Widget _buildPostCard(int index, Color accent) {
    final post = _posts[index];
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(backgroundColor: Colors.grey.shade300, child: Text(post['name'][0])),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(post['name'], style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                  Text(post['time'] ?? 'Just now', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
              const Spacer(),
              if (post['isOwner'])
                IconButton(icon: const Icon(Icons.delete_outline, color: Colors.redAccent), onPressed: () => _confirmDelete(index)),
            ],
          ),
          const SizedBox(height: 12),
          Text(post['content'], style: const TextStyle(fontSize: 15, height: 1.5)),
          if (post['tags'].isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Wrap(spacing: 8, children: post['tags'].map<Widget>((t) => Text(t, style: TextStyle(color: accent, fontWeight: FontWeight.bold, fontSize: 13))).toList()),
            ),

          // --- MNC-GRADE IMAGE RENDERING LOGIC ---
          if (post['image'] != null)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: post['isLocal'] == true
                    ? Image.asset(post['image'], width: double.infinity, height: 220, fit: BoxFit.cover)
                    : Image.network(post['image'], width: double.infinity, height: 220, fit: BoxFit.cover),
              ),
            ),

          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildLikeButton(post),
              TextButton.icon(
                onPressed: () => _showCommentPopup(index),
                icon: const Icon(Icons.chat_bubble_outline, color: Colors.grey),
                label: Text("${post['comments'].length}", style: const TextStyle(color: Colors.grey)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- REUSABLE MICRO-WIDGETS ---

  Widget _buildLikeButton(Map<String, dynamic> post) {
    return TextButton.icon(
      onPressed: () => setState(() {
        post['isLiked'] = !post['isLiked'];
        post['likes'] += post['isLiked'] ? 1 : -1;
      }),
      icon: Icon(post['isLiked'] ? Icons.favorite : Icons.favorite_border, color: post['isLiked'] ? Colors.red : Colors.grey),
      label: Text("${post['likes']}", style: const TextStyle(color: Colors.grey)),
    );
  }

  Widget _buildCommentInputField(TextEditingController ctrl, int index) {
    return Row(
      children: [
        Expanded(child: TextField(controller: ctrl, decoration: const InputDecoration(hintText: "Write a comment...", border: InputBorder.none))),
        IconButton(
          icon: const Icon(Icons.send, color: Color(0xFF6B4EE6)),
          onPressed: () {
            if (ctrl.text.isNotEmpty) {
              setState(() => _posts[index]['comments'].add({'user': _currentUser, 'text': ctrl.text}));
              Navigator.pop(context);
            }
          },
        )
      ],
    );
  }

  void _showTagPopup() {
    TextEditingController tagCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add Tag"),
        content: TextField(controller: tagCtrl, decoration: const InputDecoration(hintText: "Community Name")),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(onPressed: () {
            if (tagCtrl.text.isNotEmpty) {
              setState(() => _currentTags.add("#${tagCtrl.text.trim()}"));
              Navigator.pop(context);
            }
          }, child: const Text("Add")),
        ],
      ),
    );
  }

  Widget _buildDynamicBottomNav(Color accent) {
    return BottomNavigationBar(
      currentIndex: _activeTab,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: accent,
      unselectedItemColor: Colors.grey.shade500,
      onTap: (index) {
        if (index != 0) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Module integration pending...")));
        }
        setState(() => _activeTab = index);
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.grid_view_rounded), label: "Feed"),
        BottomNavigationBarItem(icon: Icon(Icons.movie_outlined), label: "Reels"),
        BottomNavigationBarItem(icon: Icon(Icons.explore_outlined), label: "Discover"),
        BottomNavigationBarItem(icon: Icon(Icons.book_outlined), label: "Groups"),
        BottomNavigationBarItem(icon: Icon(Icons.calendar_today_outlined), label: "Events"),
        BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: "Chat"),
      ],
    );
  }
}