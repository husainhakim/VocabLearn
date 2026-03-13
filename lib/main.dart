import 'package:flutter/material.dart';
import 'package:vocab_learn/models/vocabulary_word.dart';
import 'package:vocab_learn/screens/favoritesScreen.dart';
import 'package:vocab_learn/screens/historyScreen.dart';
import 'package:vocab_learn/screens/homeScreen.dart';
import 'package:vocab_learn/screens/quizScreen.dart';
import 'package:vocab_learn/screens/vocabularyListScreen.dart';
import 'package:vocab_learn/screens/wordDetailScreen.dart';
import 'package:vocab_learn/services/vocabulary_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await VocabularyService.instance.init();
  runApp(const VocabLearnApp());
}

class VocabLearnApp extends StatelessWidget {
  const VocabLearnApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vocabulary Learn',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const MainShell(),
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;
  final VocabularyService _service = VocabularyService.instance;

  void _openWord(VocabularyWord word) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => WordDetailScreen(
          word: word,
          service: _service,
        ),
      ),
    ).then((_) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      HomeScreen(
        service: _service,
        onQuizTap: () => setState(() => _currentIndex = 4),
        onWordTap: _openWord,
      ),
      VocabularyListScreen(
        service: _service,
        onWordTap: _openWord,
      ),
      FavoritesScreen(
        service: _service,
        onWordTap: _openWord,
      ),
      HistoryScreen(
        service: _service,
        onWordTap: _openWord,
      ),
      QuizScreen(service: _service),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book),
            label: 'Vocabulary',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border),
            selectedIcon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          NavigationDestination(
            icon: Icon(Icons.history),
            selectedIcon: Icon(Icons.history),
            label: 'History',
          ),
          NavigationDestination(
            icon: Icon(Icons.quiz_outlined),
            selectedIcon: Icon(Icons.quiz),
            label: 'Quiz',
          ),
        ],
      ),
    );
  }
}
