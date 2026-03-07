import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  final String userName;
  final String avatar;
  final String email;
  final String bio;
  final bool isOwnProfile;

  const ProfilePage({
    required this.userName,
    required this.avatar,
    required this.email,
    required this.bio,
    this.isOwnProfile = true,
    Key? key,
  }) : super(key: key);


  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  final List<Map<String, String>> _achievements = [];
  late TabController _tabController;
  late String name;
  late String email;
  late String bio;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    name = widget.userName;
    email = widget.email;
    bio = widget.bio;
  }

  void _editProfile() {
    final nameCtrl = TextEditingController(text: name);
    final emailCtrl = TextEditingController(text: email);
    final bioCtrl = TextEditingController(text: bio);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          // 👇 This pushes content above the keyboard
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.85,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6B4EE6), Colors.purpleAccent, Colors.blueAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Container(
                      width: 50,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Hero avatar
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(widget.avatar),
                    ),
                    const SizedBox(height: 20),

                    // Glassmorphic input fields
                    _GlassInputField(controller: nameCtrl, label: "Name"),
                    const SizedBox(height: 16),
                    _GlassInputField(controller: emailCtrl, label: "Email"),
                    const SizedBox(height: 16),
                    _GlassInputField(
                      controller: bioCtrl,
                      label: "Bio",
                      maxLength: 70,
                    ),

                    const SizedBox(height: 30),

                    // Save button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF6B4EE6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 14),
                      ),
                      onPressed: () {
                        setState(() {
                          name = nameCtrl.text;
                          email = emailCtrl.text;
                          bio = bioCtrl.text;
                        });
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Save Changes",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFF6B4EE6);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            actions: [
              if (widget.isOwnProfile) // 👈 only show for own profile
                IconButton(
                  icon: const Icon(Icons.settings, color: Colors.white),
                  onPressed: _editProfile, // opens edit dialog
                ),
            ],

            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [accent, Colors.purpleAccent, Colors.blueAccent],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(radius: 60, backgroundImage: NetworkImage(widget.avatar)),
                        const SizedBox(height: 12),
                        Text(name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                        Text(email, style: const TextStyle(fontSize: 14, color: Colors.white70)),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: const [
                            _StatCard(label: "Posts", value: 12),
                            _StatCard(label: "Followers", value: 340),
                            _StatCard(label: "Following", value: 180),
                          ],
                        ),
                        const SizedBox(height: 20), // 👈 gap added
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bio + Tabs
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _GlassCard(
                    child: Text(
                      bio,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Sub navigation bar
                  TabBar(
                    controller: _tabController,
                    labelColor: accent,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: accent,
                    tabs: const [
                      Tab(text: "Posts"),
                      Tab(text: "Reels"),
                      Tab(text: "Achievements"),
                    ],
                  ),
                  SizedBox(
                    height: 400, // space for tab content
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _PostsSection(),
                        _ReelsSection(),
                        _AchievementsSection(
                          achievements: _achievements,
                          isOwnProfile: widget.isOwnProfile,
                        ),
                      ],
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
}

class _GlassInputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final int? maxLength;

  const _GlassInputField({
    required this.controller,
    required this.label,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.25),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black26.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller, // 👈 uses the one passed in
        maxLength: maxLength,
        style: const TextStyle(color: Colors.white),
        cursorColor: Colors.white,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70),
          border: InputBorder.none,
          counterStyle: const TextStyle(color: Colors.white70),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final int value;
  const _StatCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("$value", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
        Text(label, style: const TextStyle(color: Colors.white70)),
      ],
    );
  }
}

class _GlassCard extends StatelessWidget {
  final Widget child;
  const _GlassCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: child,
    );
  }
}

// Sections
class _PostsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, i) => _PostCard(title: "Post #${i + 1}", content: "User post content here."),
    );
  }
}

class _ReelsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Reels uploaded by user will appear here."));
  }
}

class _AchievementsSection extends StatefulWidget {
  final List<Map<String, String>> achievements;
  final bool isOwnProfile;

  const _AchievementsSection({
    required this.achievements,
    required this.isOwnProfile,
    Key? key,
  }) : super(key: key);

  @override
  State<_AchievementsSection> createState() => _AchievementsSectionState();
}

class _AchievementsSectionState extends State<_AchievementsSection> {

  void _addAchievement() {
    final titleCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final dateCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF6B4EE6), Colors.purpleAccent, Colors.blueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Add Achievement",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
              const SizedBox(height: 16),
              _GlassInputField(controller: titleCtrl, label: "Title"),
              const SizedBox(height: 12),
              _GlassInputField(controller: descCtrl, label: "Description"),
              const SizedBox(height: 12),
              _GlassInputField(controller: dateCtrl, label: "Date"),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF6B4EE6),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
                onPressed: () {
                  setState(() {
                    widget.achievements.add({
                      "title": titleCtrl.text,
                      "desc": descCtrl.text,
                      "date": dateCtrl.text,
                    });
                  });
                  Navigator.pop(context);
                },
                child: const Text("Save Achievement"),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topRight,
          child: widget.isOwnProfile
              ? IconButton(
            icon: const Icon(Icons.add_circle, color: Color(0xFF6B4EE6), size: 32),
            onPressed: _addAchievement,
          )
              : const SizedBox.shrink(), // 👈 hides the button for others
        ),

        Expanded(
          child: ListView.builder(
            itemCount: widget.achievements.length,
            itemBuilder: (context, i) {
              final ach = widget.achievements[i];
              return AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.emoji_events,
                            color: Colors.white, size: 28),
                        const SizedBox(width: 10),
                        Text(ach["title"] ?? "",
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(ach["desc"] ?? "",
                        style: const TextStyle(color: Colors.white70)),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Text(ach["date"] ?? "",
                          style: const TextStyle(
                              fontSize: 12, color: Colors.white70)),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _PostCard extends StatelessWidget {
  final String title;
  final String content;
  const _PostCard({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [
        BoxShadow(color: Colors.grey.shade300, blurRadius: 8, offset: const Offset(0, 4))
      ]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        Text(content, style: TextStyle(color: Colors.grey.shade700)),
      ]),
    );
  }
}