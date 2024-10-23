import 'package:flutter/material.dart';
import 'package:jokes_up/main.dart';
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
      'Our app includes a wide variety of jokes, catering to different tastes and preferences. You\'ll find classic puns that play with words and meanings, clever one-liners that pack a punch in a single sentence, timeless knock-knock jokes that never go out of style, and many more categories. We\'ve curated a diverse collection to ensure there\'s something for everyone, whether you enjoy witty wordplay, situational humor, or good old-fashioned dad jokes. Our team of comedy enthusiasts works hard to include jokes from various cultures and traditions, ensuring a rich and varied humor experience. From light-hearted quips to more sophisticated humor, our app aims to tickle your funny bone in multiple ways. We also regularly update our joke database to include trending and topical humor, keeping our content fresh and relevant. Whether you\'re looking for a quick laugh or want to explore different styles of comedy, our app has got you covered!',
    ),
    FaqItem(
      'Are the jokes family-friendly?',
      Icons.family_restroom,
      Colors.green,
      'Yes, we make a concerted effort to keep all jokes in our app family-friendly. Our team carefully curates and reviews each joke to ensure it\'s appropriate for a wide audience. We understand that humor can be enjoyed by people of all ages, and we want to create an inclusive environment where families can laugh together. However, it\'s important to note that humor can be subjective, and what one person finds amusing, another might not. Cultural differences, personal experiences, and individual sensitivities can all play a role in how a joke is perceived. While we do our best to avoid offensive or inappropriate content, we recommend using your discretion when sharing jokes with younger audiences or in mixed company. Parents and guardians may want to review jokes before sharing them with very young children, as some concepts or wordplay might be too advanced for them to understand. Our goal is to provide clean, wholesome humor that can be enjoyed by everyone, fostering a positive and fun atmosphere for all users. If you ever come across a joke that you feel is inappropriate, please don\'t hesitate to let us know through our feedback channel, and we\'ll review it promptly.',
    ),
    FaqItem(
      'How often are new jokes added?',
      Icons.update,
      Colors.blue,
      'We take pride in keeping our joke database fresh, entertaining, and up-to-date. Our dedicated team of humor enthusiasts works tirelessly to add new jokes to the app on a regular basis. Specifically, we update our joke database every week, ensuring that our users always have access to fresh content. This weekly update schedule allows us to incorporate current events, trending topics, and seasonal humor into our collection. We understand that humor evolves and that what\'s funny today might not be as amusing tomorrow, which is why we\'re committed to this frequent update cycle. Our team scours various sources, including user suggestions, popular culture, and classic joke books, to find the best and most relevant jokes to add to our collection. We also pay attention to user engagement metrics to understand what types of jokes our audience enjoys the most, allowing us to tailor our new additions to your preferences. In addition to our weekly updates, we occasionally release special themed joke packs for holidays, major events, or just for fun. These special releases provide an extra burst of fresh content for our users to enjoy. We believe that this commitment to regular updates keeps the app exciting and gives our users a reason to come back day after day for their daily dose of laughter.',
    ),
    FaqItem(
      'Can I submit my own jokes?',
      Icons.add_comment,
      Colors.orange,
      'Currently, we don\'t have a feature that allows users to directly submit their own jokes through the app. This decision was made to ensure the quality and appropriateness of the content in our joke database. However, we completely understand the desire of our creative and funny users to contribute their own humor to the community. That\'s why we\'re actively considering adding a user submission feature in a future update. We\'re exploring various ways to implement this feature while maintaining the high standards of humor and family-friendliness that our users expect. Some of the challenges we\'re working through include developing a robust review process for user-submitted jokes, creating a fair system for featuring the best user-generated content, and ensuring that all submitted jokes align with our community guidelines. In the meantime, if you have a great joke that you\'d love to share, we encourage you to reach out to us through our social media channels or customer support email. While we can\'t guarantee that every submitted joke will be added to the app, we do review all suggestions and greatly appreciate the creativity of our user community. We\'re excited about the possibility of incorporating user-submitted jokes in the future, as we believe it will add an extra layer of engagement and community to our app. Stay tuned for updates on this feature – we\'ll be sure to announce it prominently when it becomes available!',
    ),
    FaqItem(
      'Why is laughter important?',
      Icons.mood,
      Colors.yellow,
      'Laughter is not just a simple reflex or a way to express amusement – it\'s a powerful tool that can significantly impact our physical, mental, and emotional well-being. Scientifically speaking, laughter triggers the release of endorphins, our body\'s natural feel-good chemicals. These endorphins promote an overall sense of well-being and can even temporarily relieve pain. But the benefits of laughter go far beyond just feeling good in the moment. Regular laughter has been shown to have numerous health benefits. It\'s a natural stress-buster, helping to lower cortisol levels (the stress hormone) in our bodies. This reduction in stress can have cascading positive effects, including improved cardiovascular health and lower blood pressure. Laughter also gives your immune system a boost. It increases the production of antibodies and activates protective cells like T-cells, helping your body fight off illnesses more effectively. From a mental health perspective, laughter can be a powerful antidote to feelings of anxiety and depression. It helps shift our focus away from negative thoughts and emotions, providing a mental break and allowing us to see situations from a different, often lighter perspective. Laughter is also a social bonding tool. When we laugh with others, it strengthens our relationships, fosters a sense of connection, and can even help resolve conflicts. In the workplace, laughter can increase productivity, creativity, and overall job satisfaction. It\'s a natural way to build rapport with colleagues and create a more positive work environment. Given all these benefits, incorporating more laughter into your daily life – whether through jokes, funny videos, or spending time with humorous friends – can be seen as a simple yet effective way to improve your overall quality of life. So go ahead, have a good laugh – it\'s good for you!',
    ),
    FaqItem(
      'What makes a good joke?',
      Icons.thumb_up,
      Colors.cyan,
      'Crafting a good joke is an art form that combines various elements to create a moment of surprise, recognition, and delight. At its core, a good joke often relies on the element of surprise. It sets up an expectation in the listener\'s mind and then subverts that expectation in a clever or unexpected way. This sudden shift is what often triggers laughter. Timing is another crucial aspect of a good joke. Whether it\'s in the delivery of a spoken joke or the pacing of a written one, the right timing can make or break a punchline. A well-timed pause or a quick delivery can enhance the impact of the joke significantly. Relatability is another key ingredient. Good jokes often touch on universal experiences or common observations, allowing the audience to connect with the humor on a personal level. When people can see a bit of themselves or their experiences in a joke, it becomes more engaging and memorable. Cleverness is also a hallmark of a good joke. This could be in the form of wordplay, a unique perspective on a common situation, or an unexpected connection between seemingly unrelated ideas. The more layers of meaning a joke has, the more satisfying it often is to the audience. However, it\'s important to note that a good joke should strive to be clever without being mean-spirited or offensive. Humor that punches down or relies on harmful stereotypes often falls flat and can alienate audiences. Instead, the best jokes are those that bring people together through shared laughter. Lastly, a good joke should leave people feeling positive. Whether it\'s a small chuckle or a hearty laugh, the goal is to lift spirits and create a moment of joy. When crafted and delivered well, a good joke can brighten someone\'s day, relieve tension in a difficult situation, or simply provide a moment of levity in our often-serious world.',
    ),
    FaqItem(
      'How to use the app?',
      Icons.help_outline,
      Colors.teal,
      'Our app is designed to be user-friendly and intuitive, making it easy for you to access a world of humor at your fingertips. The main interface is built around a bottom navigation menu that allows you to quickly switch between different sections of the app. Let\'s break down each section: 1) Random Joke: This is your go-to for a quick laugh. Tap this section to get a randomly selected joke from our vast database. It\'s perfect for when you need a fast pick-me-up or want to be surprised. 2) Joke List: Here, you can browse through our entire collection of jokes. They\'re organized into categories, making it easy to find the type of humor you\'re in the mood for. Scroll through the list and tap on any joke to read it in full. 3) Favorites: This is where you can save and access your favorite jokes. When you come across a joke you love, simply tap the heart icon to add it to your favorites. You can revisit this section anytime to re-read your personal collection of top jokes. 4) More: This section contains additional features and information about the app, including settings, FAQs, and options to share the app with friends. To read a joke, simply tap on it. You\'ll see the full text of the joke, along with options to share it or add it to your favorites. The share icon allows you to send the joke to friends and family through various platforms like messaging apps or social media. Remember, the app is designed to be explored. Don\'t hesitate to tap around and discover all the features we\'ve included to enhance your joke-reading experience. If you ever feel lost, you can always return to this FAQ or reach out to our support team for assistance. Happy laughing!',
    ),
    FaqItem(
      'How to share jokes?',
      Icons.share,
      Colors.pink,
      'Sharing jokes from our app is a breeze, and we\'ve designed the process to be as simple and intuitive as possible. After all, humor is best when shared! Here\'s a detailed guide on how to spread the laughter: 1) Find a joke you want to share: This could be from the Random Joke section, the Joke List, or your Favorites. 2) Open the joke: Tap on the joke to view it in full. 3) Look for the share icon: Once you\'re viewing the joke, you\'ll see a share icon (usually represented by an arrow or dots connected in a triangle shape). This icon is typically located near the top or bottom of the screen. 4) Tap the share icon: This will open your device\'s sharing options. 5) Choose your sharing method: Depending on your device and installed apps, you\'ll see various options for sharing. This might include messaging apps (like WhatsApp or iMessage), social media platforms (such as Facebook or Twitter), email, or even copy to clipboard. 6) Select your recipient and send: Choose who you want to send the joke to and hit send! The joke will be shared along with a link to our app, making it easy for others to discover more great jokes. Remember, when sharing jokes, it\'s always good to consider your audience. What\'s hilarious to one person might not land well with another, so use your judgment about which jokes to share with whom. Also, we\'ve made sure that when you share a joke, it\'s formatted nicely and includes attribution to our app. This helps spread the word about our app while ensuring the joke is presented in the best possible way. Sharing jokes is a great way to brighten someone\'s day, start a conversation, or simply stay connected with friends and family. So go ahead, find your favorite jokes, and start spreading the laughter!',
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
