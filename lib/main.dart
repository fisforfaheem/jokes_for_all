// main.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class JokeProvider extends ChangeNotifier {
  final List<String> _favorites = [];

  List<String> get favorites => _favorites;

  void toggleFavorite(String joke) {
    if (_favorites.contains(joke)) {
      _favorites.remove(joke);
    } else {
      _favorites.add(joke);
    }
    notifyListeners();
  }

  bool isFavorite(String joke) {
    return _favorites.contains(joke);
  }
}

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => JokeProvider(),
      child: const JokesForAll(),
    ),
  );
}

class JokesForAll extends StatelessWidget {
  const JokesForAll({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jokes For All',
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
                'Jokes For All',
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

class _RandomJokeScreenState extends State<RandomJokeScreen> {
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
  ];

  late String currentJoke;

  @override
  void initState() {
    super.initState();
    currentJoke = jokes[0];
  }

  void _getRandomJoke() {
    setState(() {
      currentJoke = jokes[DateTime.now().millisecondsSinceEpoch % jokes.length];
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
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                title: const Text('Random Joke',
                    style: TextStyle(color: Colors.white)),
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
                            Text(
                              currentJoke,
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: _getRandomJoke,
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.white.withOpacity(0.3),
                              ),
                              child: const Text('Next Joke'),
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
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
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
    // This is a placeholder. In a real app, you'd fetch favorites from storage.
    // final List<String> favorites = [
    //   "Why don't scientists trust atoms? Because they make up everything!",
    //   "Why did the scarecrow win an award? He was outstanding in his field!",
    // ];

    final jokeProvider = Provider.of<JokeProvider>(context);
    final favorites = jokeProvider.favorites;
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
                title: const Text('Favorites',
                    style: TextStyle(color: Colors.white)),
              ),
              Expanded(
                child: favorites.isEmpty
                    ? const Center(
                        child: Text(
                          'No favorites yet!',
                          style: TextStyle(color: Colors.white, fontSize: 18),
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
                                  style: const TextStyle(color: Colors.white),
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
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
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
                              'Jokes For All',
                              style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'Jokes For All is your go-to app for a daily dose of laughter. Enjoy a curated collection of hilarious jokes, save your favorites, and share the joy with friends and family.',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              '© 2024 Jokes For All',
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
      home: Scaffold(
        appBar: AppBar(
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
