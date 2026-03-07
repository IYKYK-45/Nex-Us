import 'package:flutter/material.dart';
import 'package:nex_us/screens/profile/profile_page.dart';


class DiscoverPage extends StatefulWidget {

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String searchQuery = "";

  final List<Map<String, String>> _allStudents = [
    {
      "id": "1",
      "name": "Alice Johnson",
      "role": "Student",
      "dept": "Computer Science",
      "email": "alice@example.com",
      "avatar": "https://via.placeholder.com/150"
    },
    {
      "id": "2",
      "name": "Bob Smith",
      "role": "Student",
      "dept": "Mechanical Engineering",
      "email": "bob@example.com",
      "avatar": "https://via.placeholder.com/150"
    },
    // 👆 add more later from database
  ];

  final List<Map<String, String>> people = [
    {"name": "Deepak Sir", "role": "Faculty", "dept": "Computer Science"},
    {"name": "Prof. Michael", "role": "Faculty", "dept": "Mathematics"},
    {"name": "Emma Wilson", "role": "Student", "dept": "Electrical Engg"},
    {"name": "Rahul Sharma", "role": "Alumni", "dept": "Mechanical Engg"},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  List<Map<String, String>> _filterByCategory(String category) {
    return people.where((p) {
      final matchesSearch =
          p["name"]!.toLowerCase().contains(searchQuery.toLowerCase()) ||
              p["dept"]!.toLowerCase().contains(searchQuery.toLowerCase());
      final matchesCategory = category == "All" || p["role"] == category;
      return matchesSearch && matchesCategory;
    }).toList();
  }

  List<Map<String, String>> _filterByQuery(String query) {
    if (query.isEmpty) return [];

    final combined = [...people, ..._allStudents];

    return combined.where((student) =>
      // student["name"]!.toLowerCase().contains(query.toLowerCase()) ||
      //   student["dept"]!.toLowerCase().contains(query.toLowerCase())).toList();
    student["name"]!.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFF6B4EE6);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Discover People",),
        backgroundColor: accent,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: "All"),
            Tab(text: "Students"),
            Tab(text: "Faculty"),
            Tab(text: "Alumni"),
          ],
        ),
      ),
      body: Column(
        children: [
          // Animated Search Bar
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                      color: accent.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4))
                ],
              ),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: "🔍 Search Students and Teachers",
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 20),
                ),
                onChanged: (val) => setState(() => searchQuery = val),
              ),
            ),
          ),

          // Tab content
          Expanded(
            child: searchQuery.isEmpty
              ? TabBarView(
                controller: _tabController,
                children: [
                  _buildList("All"),
                  _buildList("Student"),
                  _buildList("Faculty"),
                  _buildList("Alumni"),
                ],
              )
            : _buildSearchResults(),
          ),
        ],
      ),
    );
  }


  Widget _buildSearchResults() {
    final results = _filterByQuery(searchQuery); // filters from _allStudents

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, i) {
        final person = results[i];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 4,
          child: ListTile(
            leading: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProfilePage(
                      userName: person["name"]!,
                      email: person["email"] ?? "Not available",
                      bio: person["dept"] ?? "",
                      avatar: person["avatar"] ?? "https://via.placeholder.com/150",
                      isOwnProfile: false,
                    ),
                  ),
                );
              },
              child: CircleAvatar(
                backgroundColor: Colors.cyanAccent,
                child: Text(
                  person["name"]![0],
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            title: Text(person["name"]!),
            subtitle: Text("${person["role"]} • ${person["dept"]}"),
          ),
        );
      },
    );
  }

  Widget _buildList(String category) {
    final filtered = _filterByCategory(category);
    return ListView.builder(
      itemCount: filtered.length,
      itemBuilder: (context, i) {
        final person = filtered[i];
        return GestureDetector(
          onTapDown: (_) => setState(() {}),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6B4EE6), Colors.purpleAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: const Offset(0, 4))
              ],
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProfilePage(
                          userName: person["name"]!,
                          email: person["email"] ?? "Not available",
                          bio: person["dept"] ?? "",
                          avatar: person["avatar"] ?? "https://via.placeholder.com/150",
                          isOwnProfile: false,
                        ),
                      ),
                    );
                  },
                  child: CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.white,
                    child: Text(
                      person["name"]![0],
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(person["name"]!,
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      Text("${person["role"]} • ${person["dept"]}",
                          style: const TextStyle(color: Colors.white70)),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                ConnectButton(
                  personId: person["id"] ?? person["name"]!, // use a unique ID if available
                  personName: person["name"]!,
                ),

              ],
            ),
          ),
        );
      },
    );
  }
}

class ConnectButton extends StatefulWidget {
  final String personId; // unique ID of the person
  final String personName;

  const ConnectButton({required this.personId, required this.personName});

  @override
  State<ConnectButton> createState() => _ConnectButtonState();
}

class _ConnectButtonState extends State<ConnectButton> {
  bool isConnected = false;

  void _toggleConnection() {
    if (!isConnected) {
      // ✅ Add to following/followers
      // TODO: Firebase logic here
      setState(() => isConnected = true);

      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text("You are now connected with ${widget.personName}! 🎉")),
      // );
    } else {
      // ⚠️ Ask for confirmation before unfollow
      showDialog(
        context: context,
        builder: (ctx) => Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6B4EE6), Colors.purpleAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.warning_amber_rounded,
                    size: 48, color: Colors.yellowAccent),
                const SizedBox(height: 12),
                const Text(
                  "Unfollow?",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Do you really want to unfollow ${widget.personName}? You’ll lose the ability to chat with them.",
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF6B4EE6),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text("Cancel"),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        setState(() => isConnected = false);
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("You unfollowed ${widget.personName}."),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                      child: const Text("Unfollow"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isConnected ? Colors.greenAccent : Colors.white,
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: _toggleConnection,
      child: Text(isConnected ? "Connected" : "Connect"),
    );
  }
}