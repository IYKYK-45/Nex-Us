import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ReelsScreen extends StatefulWidget {
  const ReelsScreen({super.key});

  @override
  State<ReelsScreen> createState() => _ReelsScreenState();
}

class _ReelsScreenState extends State<ReelsScreen> {
  // Each reel has its own comments list
  final List<Map<String, dynamic>> _reels = [
    {
      'url': 'assets/videos/vid1.mp4',
      'user': '@jessica_codes',
      'caption': 'My productive morning routine ☕💻 #coding #campus',
      'likes': 12400,
      'comments': [
        "Love this routine!",
        "So motivating 🔥",
        "Campus vibes 💻",
        "Need this energy ☕",
      ],
      'shares': 120,
      'isLiked': false,
    },
    {
      'url': 'assets/videos/vid2.mp4',
      'user': '@garvit_dev',
      'caption': 'Late night debugging session 🔥 #flutter #campuslife',
      'likes': 9800,
      'comments': [
        "Debugging never ends 😅",
        "Respect the grind!",
        "Flutter FTW 🚀",
        "Been there, done that!",
      ],
      'shares': 75,
      'isLiked': false,
    },
    {
      'url': 'assets/videos/vid3.mp4',
      'user': '@garvit_dev',
      'caption': 'Proof that the best moments aren’t always planned, just lived.',
      'likes': 3242,
      'comments': [
        "Debugging never ends 😅",
        "Respect the grind!",
        "Flutter FTW 🚀",
        "Been there, done that!",
      ],
      'shares': 34,
      'isLiked': false,
    },
    {
      'url': 'assets/videos/vid4.mp4',
      'user': '@garvit_dev',
      'caption': 'Focusing on the things that make me feel alive and leaving the rest behind.',
      'likes': 23423,
      'comments': [
        "Debugging never ends 😅",
        "Respect the grind!",
        "Flutter FTW 🚀",
        "Been there, done that!",
      ],
      'shares': 445,
      'isLiked': false,
    },
    {
      'url': 'assets/videos/vid5.mp4',
      'user': '@garvit_dev',
      'caption': 'The world is a lot quieter when you finally start listening to yourself.',
      'likes': 45345,
      'comments': [
        "Debugging never ends 😅",
        "Respect the grind!",
        "Flutter FTW 🚀",
        "Been there, done that!",
      ],
      'shares': 454,
      'isLiked': false,
    },
    {
      'url': 'assets/videos/vid6.mp4',
      'user': '@garvit_dev',
      'caption': 'Just a reminder: your growth doesn’t always have to be loud to be real.',
      'likes': 45656,
      'comments': [
        "Debugging never ends 😅",
        "Respect the grind!",
        "Flutter FTW 🚀",
        "Been there, done that!",
      ],
      'shares': 75,
      'isLiked': false,
    },
    {
      'url': 'assets/videos/vid7.mp4',
      'user': '@garvit_dev',
      'caption': 'Taking the scenic route today—because life is too short to rush the best parts.',
      'likes': 11111,
      'comments': [
        "Debugging never ends 😅",
        "Respect the grind!",
        "Flutter FTW 🚀",
        "Been there, done that!",
      ],
      'shares': 75,
      'isLiked': false,
    },
    {
      'url': 'assets/videos/vid8.mp4',
      'user': '@garvit_dev',
      'caption': 'I’d apologize for being extra, but let’s be honest—I’m actually quite essential.',
      'likes': 98674,
      'comments': [
        "Debugging never ends 😅",
        "Respect the grind!",
        "Flutter FTW 🚀",
        "Been there, done that!",
      ],
      'shares': 544,
      'isLiked': false,
    },
    {
      'url': 'assets/videos/vid9.mp4',
      'user': '@garvit_dev',
      'caption': 'My life is basically a series of "Where did I put my keys?" moments and accidental success.',
      'likes': 55445,
      'comments': [
        "Debugging never ends 😅",
        "Respect the grind!",
        "Flutter FTW 🚀",
        "Been there, done that!",
      ],
      'shares': 75,
      'isLiked': false,
    },
    {
      'url': 'assets/videos/vid10.mp4',
      'user': '@garvit_dev',
      'caption': 'If my life were a movie, this would be the montage where everything finally clicks.',
      'likes': 65676,
      'comments': [
        "Debugging never ends 😅",
        "Respect the grind!",
        "Flutter FTW 🚀",
        "Been there, done that!",
      ],
      'shares': 75,
      'isLiked': false,
    },
    {
      'url': 'assets/videos/vid11.mp4',
      'user': '@garvit_dev',
      'caption': 'Currently holding it all together with a bit of humor and a lot of caffeine.',
      'likes': 342242,
      'comments': [
        "Debugging never ends 😅",
        "Respect the grind!",
        "Flutter FTW 🚀",
        "Been there, done that!",
      ],
      'shares': 75,
      'isLiked': false,
    },
    {
      'url': 'assets/videos/vid12.mp4',
      'user': '@garvit_dev',
      'caption': 'Living proof that you can be a masterpiece and a work in progress at the same time.',
      'likes': 44543,
      'comments': [
        "Debugging never ends 😅",
        "Respect the grind!",
        "Flutter FTW 🚀",
        "Been there, done that!",
      ],
      'shares': 75,
      'isLiked': false,
    },
    {
      'url': 'assets/videos/vid13.mp4',
      'user': '@garvit_dev',
      'caption': 'I’m not lazy, I’m on energy-saving mode.',
      'likes': 6987,
      'comments': [
        "Debugging never ends 😅",
        "Respect the grind!",
        "Flutter FTW 🚀",
        "Been there, done that!",
      ],
      'shares': 75,
      'isLiked': false,
    },
    {
      'url': 'assets/videos/vid14.mp4',
      'user': '@garvit_dev',
      'caption': 'Reality called, I hung up.',
      'likes': 58736,
      'comments': [
        "Debugging never ends 😅",
        "Respect the grind!",
        "Flutter FTW 🚀",
        "Been there, done that!",
      ],
      'shares': 75,
      'isLiked': false,
    },
    {
      'url': 'assets/videos/vid15.mp4',
      'user': '@garvit_dev',
      'caption': 'Proof that I actually did something today.',
      'likes': 98764,
      'comments': [
        "Debugging never ends 😅",
        "Respect the grind!",
        "Flutter FTW 🚀",
        "Been there, done that!",
      ],
      'shares': 75,
      'isLiked': false,
    },
    {
      'url': 'assets/videos/vid16.mp4',
      'user': '@garvit_dev',
      'caption': 'Better than yesterday.',
      'likes': 445,
      'comments': [
        "Debugging never ends 😅",
        "Respect the grind!",
        "Flutter FTW 🚀",
        "Been there, done that!",
      ],
      'shares': 75,
      'isLiked': false,
    },
    {
      'url': 'assets/videos/vid17.mp4',
      'user': '@garvit_dev',
      'caption': 'Less perfection, more authenticity.',
      'likes': 8700,
      'comments': [
        "Debugging never ends 😅",
        "Respect the grind!",
        "Flutter FTW 🚀",
        "Been there, done that!",
      ],
      'shares': 75,
      'isLiked': false,
    },
    {
      'url': 'assets/videos/vid18.mp4',
      'user': '@garvit_dev',
      'caption': 'Japan is turning footsteps into Electricity.',
      'likes': 9800,
      'comments': [
        "Debugging never ends 😅",
        "Respect the grind!",
        "Flutter FTW 🚀",
        "Been there, done that!",
      ],
      'shares': 75,
      'isLiked': false,
    },
    {
      'url': 'assets/videos/vid19.mp4',
      'user': '@garvit_dev',
      'caption': 'Japan is turning footsteps into Electricity.',
      'likes': 3221,
      'comments': [
        "Debugging never ends 😅",
        "Respect the grind!",
        "Flutter FTW 🚀",
        "Been there, done that!",
      ],
      'shares': 75,
      'isLiked': false,
    },
    {
      'url': 'assets/videos/vid20.mp4',
      'user': '@garvit_dev',
      'caption': 'Japan is turning footsteps into Electricity.',
      'likes': 9876,
      'comments': [
        "Debugging never ends 😅",
        "Respect the grind!",
        "Flutter FTW 🚀",
        "Been there, done that!",
      ],
      'shares': 75,
      'isLiked': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        // Infinite loop: no itemCount, use modulo indexing
        itemBuilder: (context, index) {
          final reel = _reels[index % _reels.length];
          return ReelPlayer(
            reel: reel,
            onLike: () {
              setState(() {
                reel['isLiked'] = !reel['isLiked'];
                reel['likes'] += reel['isLiked'] ? 1 : -1;
              });
            },
            onComment: () => _showCommentPopup(reel),
            onShare: () => _showShareOptions(reel),
          );
        },
      ),
    );
  }

  /// Comment popup modal
  void _showCommentPopup(Map<String, dynamic> reel) {
    final TextEditingController _commentController = TextEditingController();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => SizedBox(
          height: 400,
          child: Column(
            children: [
              const SizedBox(height: 12),
              const Text("Comments",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const Divider(),
              Expanded(
                child: ListView.builder(
                  itemCount: reel['comments'].length,
                  itemBuilder: (context, i) => ListTile(
                    leading: const CircleAvatar(
                        backgroundColor: Color(0xFF6B4EE6)),
                    title: Text(reel['comments'][i]),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: TextField(
                  controller: _commentController,
                  decoration: InputDecoration(
                    hintText: "Add a comment...",
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.send, color: Color(0xFF6B4EE6)),
                      onPressed: () {
                        if (_commentController.text.isNotEmpty) {
                          setState(() {
                            reel['comments'].add(_commentController.text);
                          });
                          setModalState(() {}); // refresh modal
                          _commentController.clear();
                        }
                      },
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  /// Share options popup
  void _showShareOptions(Map<String, dynamic> reel) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Share Reel"),
        content: const Text("Choose how you want to share this reel."),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel")),
          ElevatedButton(onPressed: () {}, child: const Text("Copy Link")),
          ElevatedButton(onPressed: () {}, child: const Text("Share to Chat")),
        ],
      ),
    );
  }
}

/// ReelPlayer - Plays a single reel video with overlayed UI.
class ReelPlayer extends StatefulWidget {
  final Map<String, dynamic> reel;
  final VoidCallback onLike;
  final VoidCallback onComment;
  final VoidCallback onShare;

  const ReelPlayer({
    super.key,
    required this.reel,
    required this.onLike,
    required this.onComment,
    required this.onShare,
  });

  @override
  State<ReelPlayer> createState() => _ReelPlayerState();
}

class _ReelPlayerState extends State<ReelPlayer> with WidgetsBindingObserver {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _controller = VideoPlayerController.asset(widget.reel['url'])
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
        _controller.setLooping(true);
      });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      _controller.pause();
    }
  }

  @override
  Widget build(BuildContext context) {
    final reel = widget.reel;
    return Stack(
      children: [
        // Video background
        Positioned.fill(
          child: _controller.value.isInitialized
              ? VideoPlayer(_controller)
              : const Center(child: CircularProgressIndicator()),
        ),

        // Overlay UI
        Positioned(
          bottom: 40,
          left: 20,
          right: 80,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(reel['user'],
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(reel['caption'],
                  style: const TextStyle(color: Colors.white)),
            ],
          ),
        ),

        // Engagement buttons
        Positioned(
          bottom: 40,
          right: 20,
          child: Column(
            children: [
              IconButton(
                icon: Icon(
                    reel['isLiked'] ? Icons.favorite : Icons.favorite_border,
                    color: reel['isLiked'] ? Colors.red : Colors.white,
                    size: 32),
                onPressed: widget.onLike,
              ),
              Text("${reel['likes']}",
                  style: const TextStyle(color: Colors.white)),
              const SizedBox(height: 16),
              IconButton(
                icon: const Icon(Icons.chat_bubble_outline,
                    color: Colors.white, size: 32),
                onPressed: widget.onComment,
              ),
              Text("${reel['comments'].length}",
                  style: const TextStyle(color: Colors.white)),
              const SizedBox(height: 16),
              IconButton(
                icon: const Icon(Icons.share,
                    color: Colors.white, size: 32),
                onPressed: widget.onShare,
              ),
              Text("${reel['shares']}",
                  style: const TextStyle(color: Colors.white)),
            ],
          ),
        ),
      ],
    );
  }
}