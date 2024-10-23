// main.dart
// ignore_for_file: deprecated_member_use, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jokes_up/faq.dart';
import 'package:jokes_up/splash.dart';
import 'dart:ui';

import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:math';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: [
        PageViewModel(
          title: "Welcome to Jokes Up",
          body: "Get ready for a daily dose of laughter!",
          image: const Center(child: Icon(Icons.emoji_emotions, size: 100.0)),
        ),
        PageViewModel(
          title: "Random Jokes",
          body: "Tap to get a random joke anytime.",
          image: const Center(child: Icon(Icons.shuffle, size: 100.0)),
        ),
        PageViewModel(
          title: "Favorites",
          body: "Save your favorite jokes for later.",
          image: const Center(child: Icon(Icons.favorite, size: 100.0)),
        ),
      ],
      showSkipButton: true,
      skip: const Text("Skip"),
      next: const Text("Next"),
      done: const Text("Done"),
      onDone: () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const MainScreen()),
        );
      },
      dotsDecorator: DotsDecorator(
        size: const Size.square(10.0),
        activeSize: const Size(20.0, 10.0),
        activeColor: Theme.of(context).colorScheme.secondary,
        color: Colors.black26,
        spacing: const EdgeInsets.symmetric(horizontal: 3.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
      ),
    );
  }
}

class JokeProvider extends ChangeNotifier {
  Set<String> _favorites = {};
  static const String _favoritesKey = 'favorite_jokes';
  static const String _lastViewedDateKey = 'last_viewed_date';
  static const String _streakCountKey = 'streak_count';
  int _streakCount = 0;
  String _jokeOfTheDay = '';

  // Add this list of jokes
  final List<String> jokes = [
    "Why don't scientists trust atoms? Because they make up everything!",
    "Why did the scarecrow win an award? He was outstanding in his field!",
    "Why don't eggs tell jokes? They'd crack each other up!",
    "What do you call a fake noodle? An impasta!",
    "Why did the math book look so sad? Because it had too many problems!",
    "What do you call a bear with no teeth? A gummy bear!",
    "Why don't skeletons fight each other? They don't have the guts!",
    "What do you call a can opener that doesn't work? A can't opener!",
    "Why don't oysters donate to charity? Because they're shellfish!",
    "What do you call a sleeping bull? A bulldozer!",
    "Why did the bicycle fall over? Because it was two-tired!",
    "What do you call a boomerang that doesn't come back? A stick!",
    "Why did the scarecrow win an award? He was outstanding in his field!",
    "What do you call a pig that does karate? A pork chop!",
    "Why don't scientists trust stairs? They're always up to something!",
  ];

  JokeProvider() {
    _loadFavorites();
    _loadStreak();
    _setJokeOfTheDay();
  }

  Set<String> get favorites => _favorites;

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    _favorites = prefs.getStringList(_favoritesKey)?.toSet() ?? {};
    notifyListeners();
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_favoritesKey, _favorites.toList());
  }

  void toggleFavorite(String joke) {
    if (_favorites.contains(joke)) {
      _favorites.remove(joke);
    } else {
      _favorites.add(joke);
    }
    _saveFavorites();
    notifyListeners();
  }

  bool isFavorite(String joke) {
    return _favorites.contains(joke);
  }

  int get streakCount => _streakCount;
  String get jokeOfTheDay => _jokeOfTheDay;

  Future<void> _loadStreak() async {
    final prefs = await SharedPreferences.getInstance();
    final lastViewedDate = prefs.getString(_lastViewedDateKey);
    final today = DateTime.now().toIso8601String().split('T')[0];

    if (lastViewedDate == today) {
      _streakCount = prefs.getInt(_streakCountKey) ?? 0;
    } else if (lastViewedDate ==
        DateTime.now()
            .subtract(const Duration(days: 1))
            .toIso8601String()
            .split('T')[0]) {
      _streakCount = (prefs.getInt(_streakCountKey) ?? 0) + 1;
      await prefs.setInt(_streakCountKey, _streakCount);
    } else {
      _streakCount = 1;
      await prefs.setInt(_streakCountKey, _streakCount);
    }

    await prefs.setString(_lastViewedDateKey, today);
    notifyListeners();
  }

  void _setJokeOfTheDay() {
    final random = Random();
    _jokeOfTheDay = jokes[random.nextInt(jokes.length)];
  }

  void shareJokeOfTheDay() {
    Share.share('Here\'s today\'s joke from Jokes Up:\n\n$_jokeOfTheDay');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final jokeProvider = JokeProvider();
  await jokeProvider._loadFavorites();

  runApp(
    ChangeNotifierProvider.value(
      value: jokeProvider,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Jokes Up',
      theme: ThemeData.dark(),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _controller.forward();

    Future.delayed(const Duration(seconds: 3), () {
      _checkFirstSeen();
    });
  }

  Future<void> _checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool seen = (prefs.getBool('seen') ?? false);

    if (seen) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    } else {
      await prefs.setBool('seen', true);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const OnboardingScreen()),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
        child: Center(
          child: FadeTransition(
            opacity: _animation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.emoji_emotions,
                  size: 100,
                  color: Colors.white,
                ),
                const SizedBox(height: 20),
                Text(
                  'Jokes Up',
                  style: GoogleFonts.poppins(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MorePage extends StatelessWidget {
  const MorePage({super.key});

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
                automaticallyImplyLeading: false,
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: Text(
                  'More',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: AnimationLimiter(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _moreItems.length,
                    itemBuilder: (BuildContext context, int index) {
                      return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 375),
                        child: SlideAnimation(
                          verticalOffset: 50.0,
                          child: FadeInAnimation(
                            child: _buildListItem(context, index),
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

  Widget _buildListItem(BuildContext context, int index) {
    final item = _moreItems[index];
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GestureDetector(
        onTap: () => item['onTap'](context),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white.withOpacity(0.1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            leading: Icon(
              item['icon'],
              size: 36,
              color: item['color'],
            )
                .animate()
                .scale(duration: 300.ms, curve: Curves.easeInOut)
                .then()
                .shake(hz: 4, curve: Curves.easeInOut),
            title: Text(
              item['title'],
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

final List<Map<String, dynamic>> _moreItems = [
  {
    'title': 'About',
    'icon': Icons.info_outline,
    'color': Colors.blue,
    'onTap': (BuildContext context) => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AboutPage()),
        ),
  },
  {
    'title': 'Privacy Policy',
    'icon': Icons.privacy_tip_outlined,
    'color': Colors.green,
    'onTap': (BuildContext context) => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PrivacyPolicyPage()),
        ),
  },
  {
    'title': 'Share',
    'icon': Icons.share_outlined,
    'color': Colors.orange,
    'onTap': (BuildContext context) {
      Share.share(
        'Download Jokes Up app from Playstore: https://play.google.com/store/apps/details?id=com.jokesup.app',
      );
    },
  },
  {
    'title': 'Rate Us',
    'icon': Icons.star_outline,
    'color': Colors.amber,
    'onTap': (BuildContext context) => launchUrlString(
          'https://play.google.com/store/apps/details?id= com.jokesup.app',
        ),
  },
  {
    'title': 'FAQs',
    'icon': Icons.question_answer_outlined,
    'color': Colors.purple,
    'onTap': (BuildContext context) => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const FaqPage()),
        ),
  },
];

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

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
                automaticallyImplyLeading: false,
                backgroundColor: Colors.transparent,
                elevation: 0,
                title:
                    const Text('About', style: TextStyle(color: Colors.white)),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Jokes Up',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildFeatureRow(Icons.emoji_emotions,
                          'Enjoy a daily dose of laughter with our curated jokes.'),
                      const SizedBox(height: 16),
                      _buildFeatureRow(
                          Icons.shuffle, 'Get random jokes anytime, anywhere.'),
                      const SizedBox(height: 16),
                      _buildFeatureRow(Icons.favorite,
                          'Save your favorite jokes for later.'),
                      const SizedBox(height: 16),
                      const Divider(color: Colors.white),
                      const SizedBox(height: 16),
                      _buildFeaturesList(),
                      const SizedBox(height: 16),
                      const Divider(color: Colors.white),
                      const SizedBox(height: 16),
                      _buildAboutUs(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 40, color: Colors.white),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturesList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Features',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        _buildFeatureListTile('Wide variety of jokes'),
        _buildFeatureListTile('Random joke generator'),
        _buildFeatureListTile('Favorite jokes collection'),
        _buildFeatureListTile('Clean and family-friendly content'),
        _buildFeatureListTile('User-friendly interface'),
      ],
    );
  }

  Widget _buildFeatureListTile(String text) {
    return ListTile(
      leading: const Icon(Icons.check_circle, color: Colors.white),
      title: Text(text, style: const TextStyle(color: Colors.white)),
    );
  }

  Widget _buildAboutUs() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'About Us',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 16),
        Text(
          'We are a team of humor enthusiasts dedicated to bringing laughter to your day. Our goal is to provide a fun and enjoyable experience through our carefully curated collection of jokes.',
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ],
    );
  }
}

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  final String url = 'https://sites.google.com/view/jokesup/home';

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
                automaticallyImplyLeading: false,
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: const Text('Privacy Policy',
                    style: TextStyle(color: Colors.white)),
              ),
              Expanded(
                child: WebViewWidget(
                  controller: WebViewController()
                    ..loadRequest(Uri.parse(url))
                    ..setJavaScriptMode(JavaScriptMode.unrestricted),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    RandomJokeScreen(),
    JokeOfTheDayScreen(),
    JokeListScreen(),
    FavoritesScreen(),
    FaqPage(),
    MorePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
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
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        color: Colors.black.withOpacity(0.5),
        buttonBackgroundColor: Colors.amber[800],
        height: 60,
        items: const <Widget>[
          Icon(Icons.calendar_today, size: 30, color: Colors.white),
          Icon(Icons.shuffle, size: 30, color: Colors.white),
          Icon(Icons.list, size: 30, color: Colors.white),
          Icon(Icons.favorite, size: 30, color: Colors.white),
          Icon(Icons.question_answer_outlined, size: 30, color: Colors.white),
          Icon(Icons.more_horiz, size: 30, color: Colors.white),
        ],
        onTap: _onItemTapped,
        index: _selectedIndex,
        animationDuration: const Duration(milliseconds: 300),
        animationCurve: Curves.easeInOut,
      ),
    );
  }
}

class JokesForAll extends StatelessWidget {
  const JokesForAll({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Jokes Up',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
              const SizedBox(height: 50),
              Text(
                'Jokes Up',
                style: GoogleFonts.pacifico(
                  fontSize: 40,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      blurRadius: 10,
                      color: Colors.black.withOpacity(0.3),
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  padding: const EdgeInsets.all(16),
                  children: [
                    _buildGlassCard(context, 'Random Joke', Icons.shuffle, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RandomJokeScreen()),
                      );
                    }),
                    _buildGlassCard(context, 'Joke List', Icons.list, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const JokeListScreen()),
                      );
                    }),
                    _buildGlassCard(context, 'Favorites', Icons.favorite, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const FavoritesScreen()),
                      );
                    }),
                    _buildGlassCard(context, 'About', Icons.info, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AboutScreen()),
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGlassCard(
      BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 0,
        margin: const EdgeInsets.all(8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: Colors.transparent,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.white.withOpacity(0.2)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 50, color: Colors.white),
                  const SizedBox(height: 10),
                  Text(
                    title,
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class RandomJokeScreen extends StatefulWidget {
  const RandomJokeScreen({super.key});

  @override
  _RandomJokeScreenState createState() => _RandomJokeScreenState();
}

class _RandomJokeScreenState extends State<RandomJokeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _showFront = true;
  String _currentJoke = '';
  List<int> _seenJokes = [];

  final List<String> jokes = [
    "Why don't scientists trust atoms? Because they make up everything!",
    "Why did the scarecrow win an award? He was outstanding in his field!",
    "Why don't eggs tell jokes? They'd crack each other up!",
    "What do you call a fake noodle? An impasta!",
    "Why did the math book look so sad? Because it had too many problems!",
    "What do you call a bear with no teeth? A gummy bear!",
    "Why don't skeletons fight each other? They don't have the guts!",
    "What do you call a can opener that doesn't work? A can't opener!",
    "Why don't oysters donate to charity? Because they're shellfish!",
    "What do you call a sleeping bull? A bulldozer!",
    "Why did the bicycle fall over? Because it was two-tired!",
    "What do you call a boomerang that doesn't come back? A stick!",
    "Why did the scarecrow win an award? He was outstanding in his field!",
    "What do you call a pig that does karate? A pork chop!",
    "Why don't scientists trust stairs? They're always up to something!",
    "What do you call a fake stone in Ireland? A sham rock!",
    "Why don't eggs tell each other secrets? Because they'd crack up!",
    "What do you call a bear with no ears? B!",
    "Why did the cookie go to the doctor? Because it was feeling crumbly!",
    "What do you call a sleeping dinosaur? A dino-snore!",
    "Why don't ants get sick? Because they have tiny ant-ibodies!",
    "What do you call a fish wearing a bowtie? So-fish-ticated!",
    "Why don't moths use Twitter? They prefer the lamp post!",
    "What do you call a dog magician? A labracadabrador!",
    "Why did the golfer bring two pairs of pants? In case he got a hole in one!",
    "What do you call a fake noodle? An impasta!",
    "Why don't scientists trust atoms? Because they make up everything!",
    "What do you call a bear with no teeth? A gummy bear!",
    "Why don't skeletons fight each other? They don't have the guts!",
    "What do you call a can opener that doesn't work? A can't opener!",
    "Why don't oysters donate to charity? Because they're shellfish!",
    "What do you call a sleeping bull? A bulldozer!",
    "Why did the bicycle fall over? Because it was two-tired!",
    "What do you call a boomerang that doesn't come back? A stick!",
    "Why did the scarecrow win an award? He was outstanding in his field!",
    "What do you call a pig that does karate? A pork chop!",
    "Why don't scientists trust stairs? They're always up to something!",
    "What do you call a fake stone in Ireland? A sham rock!",
    "Why don't eggs tell each other secrets? Because they'd crack up!",
    "What do you call a bear with no ears? B!",
    "What do you call a pig that does karate? A pork chop!",
    "Why don't scientists trust stairs? They're always up to something!",
    "What do you call a fake stone in Ireland? A sham rock!",
    "Why don't eggs tell each other secrets? Because they'd crack up!",
    "What do you call a bear with no ears? B!",
    "Why don't skeletons fight each other? They don't have the guts!",
    "What do you call a can opener that doesn't work? A can't opener!",
    "Why don't oysters donate to charity? Because they're shellfish!",
    "What do you call a sleeping bull? A bulldozer!",
    "Why did the bicycle fall over? Because it was two-tired!",
    "What do you call a boomerang that doesn't come back? A stick!",
    "Why did the scarecrow win an award? He was outstanding in his field!",
    "What do you call a fake noodle? An impasta!",
    "Why don't scientists trust atoms? Because they make up everything!",
    "What do you call a bear with no teeth? A gummy bear!",
    "Why don't moths use Twitter? They prefer the lamp post!",
    "What do you call a dog magician? A labracadabrador!",
    "Why did the golfer bring two pairs of pants? In case he got a hole in one!",
    "What do you call a fish wearing a bowtie? So-fish-ticated!",
    "Why don't ants get sick? Because they have tiny ant-ibodies!",
    "What do you call a sleeping dinosaur? A dino-snore!",
    "Why did the cookie go to the doctor? Because it was feeling crumbly!",
    "What do you call a cow with no legs? Ground beef!",
    "Why don't eggs tell jokes? They'd crack each other up!",
    "What do you call a fake spaghetti? An impasta!",
    "Why don't scientists trust atoms? Because they make up everything!",
    "What do you call a bear with no teeth? A gummy bear!",
    "Why don't skeletons fight each other? They don't have the guts!",
    "What do you call a can opener that doesn't work? A can't opener!",
    "Why don't oysters donate to charity? Because they're shellfish!",
    "What do you call a sleeping bull? A bulldozer!",
    "Why did the bicycle fall over? Because it was two-tired!",
    "What do you call a boomerang that doesn't come back? A stick!",
    "Why did the scarecrow win an award? He was outstanding in his field!",
    "What do you call a pig that does karate? A pork chop!",
    "Why don't scientists trust stairs? They're always up to something!",
    "What do you call a fake stone in Ireland? A sham rock!",
    "Why don't eggs tell each other secrets? Because they'd crack up!",
    "What do you call a bear with no ears? B!",
    "Why don't skeletons fight each other? They don't have the guts!",
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
    _loadSeenJokes();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadSeenJokes() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _seenJokes =
          prefs.getStringList('seen_jokes')?.map(int.parse).toList() ?? [];
      _getRandomJoke();
    });
  }

  Future<void> _saveSeenJokes() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
        'seen_jokes', _seenJokes.map((e) => e.toString()).toList());
  }

  void _getRandomJoke() {
    if (_seenJokes.length == jokes.length) {
      _seenJokes.clear();
    }
    int index;
    do {
      index = Random().nextInt(jokes.length);
    } while (_seenJokes.contains(index));

    setState(() {
      _currentJoke = jokes[index];
      _seenJokes.add(index);
    });
    _saveSeenJokes();
  }

  void _flipCard() {
    if (_showFront) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    _showFront = !_showFront;
    if (!_showFront) {
      _getRandomJoke();
    }
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
                automaticallyImplyLeading: false,
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: Text(
                  'Random Joke',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: GestureDetector(
                    onTap: _flipCard,
                    child: AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) {
                        return Transform(
                          transform: Matrix4.identity()
                            ..setEntry(3, 2, 0.001)
                            ..rotateY(pi * _animation.value),
                          alignment: Alignment.center,
                          child: _showFront ? _buildFront() : _buildBack(),
                        );
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  _showFront
                      ? 'Tap the card to reveal a joke!'
                      : 'Tap again for a new joke!',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.5, end: 0),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final jokeProvider =
              Provider.of<JokeProvider>(context, listen: false);
          jokeProvider.toggleFavorite(_currentJoke);
        },
        child: Consumer<JokeProvider>(
          builder: (context, jokeProvider, child) {
            return Icon(
              jokeProvider.isFavorite(_currentJoke)
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: Colors.white,
            );
          },
        ),
      ).animate().scale(duration: 300.ms, curve: Curves.easeInOut),
    );
  }

  Widget _buildFront() {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: Colors.white.withOpacity(0.2),
      child: Container(
        width: 300,
        height: 400,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.sentiment_very_satisfied,
              size: 80,
              color: Colors.white,
            ).animate().scale(duration: 300.ms, curve: Curves.easeInOut),
            const SizedBox(height: 20),
            Text(
              'Ready for a laugh?',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.5, end: 0),
          ],
        ),
      ),
    );
  }

  Widget _buildBack() {
    return Transform(
      transform: Matrix4.identity()..rotateY(pi),
      alignment: Alignment.center,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: Colors.white.withOpacity(0.2),
        child: Container(
          width: 300,
          height: 400,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.emoji_emotions,
                size: 60,
                color: Colors.white,
              ).animate().scale(duration: 300.ms, curve: Curves.easeInOut),
              const SizedBox(height: 20),
              Text(
                _currentJoke,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.5, end: 0),
            ],
          ),
        ),
      ),
    );
  }
}

class JokeListScreen extends StatelessWidget {
  const JokeListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final jokeProvider = Provider.of<JokeProvider>(context);

    final List<String> jokes = [
      "Why don't scientists trust atoms? Because they make up everything!",
      "Why did the scarecrow win an award? He was outstanding in his field!",
      "Why don't eggs tell jokes? They'd crack each other up!",
      "What do you call a fake noodle? An impasta!",
      "Why did the math book look so sad? Because it had too many problems!",
      "What do you call a bear with no teeth? A gummy bear!",
      "Why don't skeletons fight each other? They don't have the guts!",
      "What do you call a can opener that doesn't work? A can't opener!",
      "Why don't oysters donate to charity? Because they're shellfish!",
      "What do you call a sleeping bull? A bulldozer!",
      "Why don't eggs tell jokes? They'd crack each other up!",
      "What do you call a fake noodle? An impasta!",
      "Why did the math book look so sad? Because it had too many problems!",
      "What do you call a bear with no teeth? A gummy bear!",
      "Why don't skeletons fight each other? They don't have the guts!",
      "What do you call a can opener that doesn't work? A can't opener!",
      "Why don't oysters donate to charity? Because they're shellfish!",
      "What do you call a sleeping bull? A bulldozer!",
      "Why did the bicycle fall over? Because it was two-tired!",
      "What do you call a boomerang that doesn't come back? A stick!",
      "What do you call a pig that does karate? A pork chop!",
      "Why don't scientists trust stairs? They're always up to something!",
      "What do you call a fake stone in Ireland? A sham rock!",
      "Why don't eggs tell each other secrets? Because they'd crack up!",
      "What do you call a bear with no ears? B!",
      "Why don't skeletons fight each other? They don't have the guts!",
      "What do you call a can opener that doesn't work? A can't opener!",
      "Why don't oysters donate to charity? Because they're shellfish!",
      "What do you call a sleeping bull? A bulldozer!",
      "Why did the bicycle fall over? Because it was two-tired!",
      "What do you call a boomerang that doesn't come back? A stick!",
      "Why did the scarecrow win an award? He was outstanding in his field!",
      "What do you call a fake noodle? An impasta!",
      "Why don't scientists trust atoms? Because they make up everything!",
      "What do you call a bear with no teeth? A gummy bear!",
      "Why don't moths use Twitter? They prefer the lamp post!",
      "What do you call a dog magician? A labracadabrador!",
      "Why did the golfer bring two pairs of pants? In case he got a hole in one!",
      "What do you call a fish wearing a bowtie? So-fish-ticated!",
      "Why don't ants get sick? Because they have tiny ant-ibodies!",
      "What do you call a sleeping dinosaur? A dino-snore!",
      "Why did the cookie go to the doctor? Because it was feeling crumbly!",
      "What do you call a cow with no legs? Ground beef!",
      "Why don't eggs tell jokes? They'd crack each other up!",
      "What do you call a fake spaghetti? An impasta!",
      "Why don't scientists trust atoms? Because they make up everything!",
      "What do you call a bear with no teeth? A gummy bear!",
      "Why don't skeletons fight each other? They don't have the guts!",
      "What do you call a can opener that doesn't work? A can't opener!",
      "Why don't oysters donate to charity? Because they're shellfish!",
      "What do you call a sleeping bull? A bulldozer!",
      "Why did the bicycle fall over? Because it was two-tired!",
      "What do you call a boomerang that doesn't come back? A stick!",
      "Why did the scarecrow win an award? He was outstanding in his field!",
      "What do you call a pig that does karate? A pork chop!",
      "Why don't scientists trust stairs? They're always up to something!",
      "What do you call a fake stone in Irland? A sham rock!",
      "Why don't eggs tell each other secrets? Because they'd crack up!",
      "What do you call a bear with no ears? B!",
      "Why don't skeletons fight each other? They don't have the guts!",
    ];

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
                automaticallyImplyLeading: false,
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: const Text('Joke List',
                    style: TextStyle(color: Colors.white)),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: jokes.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: GlassCard(
                        child: ListTile(
                          title: Text(
                            jokes[index],
                            style: const TextStyle(color: Colors.white),
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              jokeProvider.isFavorite(jokes[index])
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              jokeProvider.toggleFavorite(jokes[index]);
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

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
                automaticallyImplyLeading: false,
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: const Text('Favorites',
                    style: TextStyle(color: Colors.white)),
              ),
              Expanded(
                child: Consumer<JokeProvider>(
                  builder: (context, jokeProvider, child) {
                    final favorites = jokeProvider.favorites.toList();
                    return favorites.isEmpty
                        ? const Center(
                            child: Text(
                              'No favorites yet!',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          )
                        : ListView.builder(
                            itemCount: favorites.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                child: GlassCard(
                                  child: ListTile(
                                    title: Text(
                                      favorites[index],
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.favorite,
                                          color: Colors.red),
                                      onPressed: () {
                                        jokeProvider
                                            .toggleFavorite(favorites[index]);
                                      },
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

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
                automaticallyImplyLeading: false,
                backgroundColor: Colors.transparent,
                elevation: 0,
                title:
                    const Text('About', style: TextStyle(color: Colors.white)),
              ),
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: GlassCard(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Jokes Up',
                              style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'Jokes Up is your go-to app for a daily dose of laughter. Enjoy a curated collection of hilarious jokes, save your favorites, and share the joy with friends and family.',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              '© 2024 Jokes Up',
                              style: TextStyle(
                                  fontSize: 14, color: Colors.white70),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () => _showSettingsDialog(context),
                              child: const Text('Settings'),
                            ),
                          ],
                        ),
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

  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('About'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Privacy Policy'),
                onTap: () {
                  Navigator.of(context).pop();
                  _openWebView(
                      context, 'Privacy Policy', 'https://google.com/');
                },
              ),
              ListTile(
                title: const Text('Terms and Conditions'),
                onTap: () {
                  Navigator.of(context).pop();
                  _openWebView(
                      context, 'Terms and Conditions', 'https://google.com/');
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _openWebView(BuildContext context, String title, String url) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => WebViewPage(title: title, url: url),
      ),
    );
  }
}

class WebViewPage extends StatelessWidget {
  final String title;
  final String url;

  const WebViewPage({super.key, required this.title, required this.url});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(title),
        ),
        body: WebViewWidget(
          controller: WebViewController()
            ..loadRequest(Uri.parse(url))
            ..setJavaScriptMode(JavaScriptMode.unrestricted),
        ),
      ),
    );
  }
}

class GlassCard extends StatelessWidget {
  final Widget child;

  const GlassCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: child,
        ),
      ),
    );
  }
}

class JokeOfTheDayScreen extends StatelessWidget {
  const JokeOfTheDayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<JokeProvider>(
      builder: (context, jokeProvider, child) {
        return Column(
          children: [
            AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Text(
                'Joke of the Day',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Day Streak: ${jokeProvider.streakCount}',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      GlassCard(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            jokeProvider.jokeOfTheDay,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(
                              jokeProvider.isFavorite(jokeProvider.jokeOfTheDay)
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: Colors.white,
                              size: 30,
                            ),
                            onPressed: () {
                              jokeProvider
                                  .toggleFavorite(jokeProvider.jokeOfTheDay);
                            },
                          ),
                          const SizedBox(width: 20),
                          IconButton(
                            icon: const Icon(
                              Icons.share,
                              color: Colors.white,
                              size: 30,
                            ),
                            onPressed: () {
                              jokeProvider.shareJokeOfTheDay();
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
