import 'package:flutter/material.dart';
import 'package:jokes_for_all/main.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class FaqPage extends StatefulWidget {
  const FaqPage({super.key});

  @override
  _FaqPageState createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPage> {
  final List<FaqItem> _faqItems = [
    FaqItem(
      'What types of jokes are included?',
      Icons.category,
      Colors.purple,
      'Our app includes a wide variety of jokes, including puns, one-liners, knock-knock jokes, and more. We aim to cater to different senses of humor!',
    ),
    FaqItem(
      'Are the jokes family-friendly?',
      Icons.family_restroom,
      Colors.green,
      'Yes, we strive to keep all jokes family-friendly. However, humor can be subjective, so use your discretion when sharing with younger audiences.',
    ),
    FaqItem(
      'How often are new jokes added?',
      Icons.update,
      Colors.blue,
      'We update our joke database regularly, adding new jokes every week to keep the content fresh and entertaining.',
    ),
    FaqItem(
      'Can I submit my own jokes?',
      Icons.add_comment,
      Colors.orange,
      'Currently, we don\'t have a feature for user submissions. However, we\'re considering adding this in a future update. Stay tuned!',
    ),
    FaqItem(
      'Why is laughter important?',
      Icons.mood,
      Colors.yellow,
      'Laughter has numerous health benefits, including stress relief, boosting the immune system, and improving mood. It\'s a natural way to feel good!',
    ),
    FaqItem(
      'What makes a good joke?',
      Icons.thumb_up,
      Colors.cyan,
      'A good joke often relies on surprise, timing, and relatability. It should be clever, not offensive, and leave people smiling or laughing.',
    ),
    FaqItem(
      'How to use the app?',
      Icons.help_outline,
      Colors.teal,
      'Navigate through the bottom menu to access different sections: Random Joke, Joke List, Favorites, and More. Tap on jokes to read them and use the heart icon to save favorites.',
    ),
    FaqItem(
      'How to share jokes?',
      Icons.share,
      Colors.pink,
      'While viewing a joke, look for the share icon. Tap it to open your device\'s sharing options and send the joke to friends and family.',
    ),
  ];

  List<FaqItem> _filteredFaqItems = [];

  @override
  void initState() {
    super.initState();
    _filteredFaqItems = _faqItems;
  }

  void _filterFaqItems(String query) {
    setState(() {
      _filteredFaqItems = _faqItems
          .where(
              (item) => item.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

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
                title:
                    const Text('FAQs', style: TextStyle(color: Colors.white)),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  onChanged: _filterFaqItems,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Search FAQs',
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                    prefixIcon: const Icon(Icons.search, color: Colors.white),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.2),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: AnimationLimiter(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: _filteredFaqItems.length,
                    itemBuilder: (context, index) {
                      return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 375),
                        child: SlideAnimation(
                          verticalOffset: 50.0,
                          child: FadeInAnimation(
                            child: Column(
                              children: [
                                _buildFaqTile(
                                  context,
                                  _filteredFaqItems[index].title,
                                  _filteredFaqItems[index].icon,
                                  _filteredFaqItems[index].iconColor,
                                  _filteredFaqItems[index].content,
                                ),
                                if (index < _filteredFaqItems.length - 1)
                                  const Divider(color: Colors.white),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
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
                    child: SingleChildScrollView(
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

class FaqItem {
  final String title;
  final IconData icon;
  final Color iconColor;
  final String content;

  FaqItem(this.title, this.icon, this.iconColor, this.content);
}
