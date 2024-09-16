import 'package:flutter/material.dart';
import 'package:jokes_for_all/main.dart';

class FaqPage extends StatelessWidget {
  const FaqPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue.shade300, Colors.purple.shade300],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                title:
                    const Text('FAQs', style: TextStyle(color: Colors.white)),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: [
                    _buildFaqTile(
                      context,
                      'How to use this app?',
                      Icons.help_outline,
                      Colors.blue,
                      'This app helps you enjoy a daily dose of laughter with a curated collection of jokes. You can view random jokes, browse through a list, and save your favorites.',
                    ),
                    const Divider(color: Colors.white),
                    _buildFaqTile(
                      context,
                      'How to view a random joke?',
                      Icons.shuffle,
                      Colors.green,
                      'Go to the "Random Joke" section from the main menu. You\'ll see a joke displayed on the screen. To get a new random joke, simply tap the "Next Joke" button.',
                    ),
                    const Divider(color: Colors.white),
                    _buildFaqTile(
                      context,
                      'How to save a favorite joke?',
                      Icons.favorite,
                      Colors.red,
                      'When viewing a joke in the "Joke List" section, you\'ll see a heart icon next to each joke. Tap the heart icon to add the joke to your favorites. Tap it again to remove it from favorites.',
                    ),
                    const Divider(color: Colors.white),
                    _buildFaqTile(
                      context,
                      'How to view my favorite jokes?',
                      Icons.list,
                      Colors.orange,
                      'From the main menu, tap on the "Favorites" option. This will take you to a list of all the jokes you\'ve marked as favorites. You can remove jokes from your favorites list by tapping the heart icon again.',
                    ),
                    const Divider(color: Colors.white),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFaqTile(BuildContext context, String title, IconData icon,
      Color iconColor, String content) {
    return GlassCard(
      child: ListTile(
        leading: Icon(icon, color: iconColor),
        title: Text(
          title,
          style: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FaqDetailPage(
              title: title,
              content: content,
            ),
          ),
        ),
      ),
    );
  }
}

class FaqDetailPage extends StatelessWidget {
  final String title;
  final String content;

  const FaqDetailPage({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue.shade300, Colors.purple.shade300],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                title: Text(title, style: const TextStyle(color: Colors.white)),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GlassCard(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        content,
                        style:
                            const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
