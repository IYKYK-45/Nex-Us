import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


class StudyGroupsPage extends StatefulWidget {
  const StudyGroupsPage({super.key});

  @override
  State<StudyGroupsPage> createState() => _StudyGroupsPageState();
}

class _StudyGroupsPageState extends State<StudyGroupsPage> {
  String searchQuery = "";
  final String currentUser = "Garvit Gupta"; // track current user

  final List<Map<String, dynamic>> _communities = [
    {
      "name": "CS-101 Study Group",
      "category": "Academic",
      "description":
      "A collaborative space for students in the Introduction to Computer Science course. Share notes, discuss labs, and prep for exams.",
      "image": "https://picsum.photos/400/200?random=1",
      "owner": "System"
    },
    {
      "name": "Robotics Club",
      "category": "Club",
      "description":
      "Join robotics enthusiasts to build, code, and compete in exciting challenges.",
      "image": "https://picsum.photos/400/200?random=2",
      "owner": "System"
    },
  ];

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFF6B4EE6);

    final filtered = _communities.where((c) {
      return c["name"].toLowerCase().contains(searchQuery.toLowerCase()) ||
          c["category"].toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
        // Header
        Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text("Communities",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
            SizedBox(height: 6),
            Text("Join class groups, clubs, and interest-based communities.",
                style: TextStyle(color: Colors.black54)),
          ],
        ),
      ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: _createGroup,
                  icon: const Icon(Icons.add),
                  label: const Text("Create New Group"),
                ),
              ),
              const SizedBox(height: 12),

              _buildSearchBar(accent),
              const SizedBox(height: 8),

              Expanded(
                child: ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (context, i) => _CommunityCard(
                    data: filtered[i],
                    onAddImage: () async {
                      final newImage = await _getImageForGroupName(filtered[i]["name"]);
                      setState(() {
                        filtered[i]["image"] = newImage;
                      });
                    },
                    onDelete: () {
                      _confirmDelete(filtered[i]);
                    },
                    currentUser: currentUser,
                  ),
                ),
              ),
            ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(Color accent) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: "Search for communities by name or category",
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
        ),
        onChanged: (val) => setState(() => searchQuery = val),
      ),
    );
  }

  void _confirmDelete(Map<String, dynamic> group) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Delete Group?"),
        content: Text("Are you sure you want to delete '${group["name"]}'?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              setState(() => _communities.remove(group));
              Navigator.pop(ctx);
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  Future<String> _getImageForGroupName(String groupName) async {
    final words = groupName.toLowerCase().split(" ");
    final keywords = words.where((w) => w.length > 3 && w != "group" && w != "club").toList();

    if (keywords.isNotEmpty) {
      final keyword = keywords.first;

      try {
        final response = await http.get(Uri.parse(
            "https://api.unsplash.com/photos/random?query=$keyword&client_id=oTS8nGHpDtO569wdocjhzaPNSK0NxzLWQLUQBr9P3yM"));

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          return data["urls"]["regular"];
        }
      } catch (e) {
        // If Unsplash fails, fallback below
      }
    }

    // Fallback to Picsum
    return "https://picsum.photos/400/200?random=${DateTime.now().millisecondsSinceEpoch}";
  }


  void _createGroup() {
    final nameCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    String selectedCategory = "Academic";

    showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Create New Group",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                  const SizedBox(height: 16),
                  TextField(
                    controller: nameCtrl,
                    maxLength: 30,
                    decoration: const InputDecoration(
                      labelText: "Group Name (10–30 chars)",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: descCtrl,
                    maxLength: 100,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: "Description (≤ 100 chars)",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: selectedCategory,
                    items: const [
                      DropdownMenuItem(value: "Academic", child: Text("Academic")),
                      DropdownMenuItem(value: "Club", child: Text("Club")),
                      DropdownMenuItem(value: "Interest", child: Text("Interest")),
                      DropdownMenuItem(value: "Sports", child: Text("Sports")),
                      DropdownMenuItem(value: "Cultural", child: Text("Cultural")),
                    ],
                    onChanged: (val) => selectedCategory = val!,
                    decoration: const InputDecoration(
                      labelText: "Category",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6B4EE6),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      if (nameCtrl.text.trim().length < 10 ||
                          nameCtrl.text.trim().length > 30 ||
                          descCtrl.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Please fill all fields correctly")),
                        );
                        return;
                      }
                      setState(() {
                        _communities.add({
                          "name": nameCtrl.text.trim(),
                          "category": selectedCategory,
                          "description": descCtrl.text.trim(),
                          "image": "",
                          "owner": currentUser,
                        });
                      });
                      Navigator.pop(ctx);
                    },
                    child: const Text("Create"),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _CommunityCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final VoidCallback onAddImage;
  final VoidCallback onDelete;
  final String currentUser;

  const _CommunityCard({
    required this.data,
    required this.onAddImage,
    required this.onDelete,
    required this.currentUser,
  });

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFF6B4EE6);

    return GestureDetector(
      onLongPress: () {
        if (data["owner"] == currentUser) {
          onDelete();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("You can only delete your own groups")),
          );
        }
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image banner
            if (data["image"] != null && data["image"].isNotEmpty)
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                child: Image.network(
                  data["image"],
                  width: double.infinity,
                  // height: 160,
                  fit: BoxFit.cover,
                ),
              )
            else
              Container(
                height: 160,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: const Icon(Icons.add_a_photo, color: Colors.black54),
                    onPressed: onAddImage,
                  ),
                ),
              ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(data["category"],
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey)),
                  const SizedBox(height: 6),
                  Text(data["name"],
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text(data["description"],
                      style: const TextStyle(color: Colors.black87)),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Joined ${data["name"]}")),
                        );
                      },
                      child: const Text("View Group"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}