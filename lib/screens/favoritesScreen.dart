import 'package:flutter/material.dart';
import 'package:vocab_learn/models/vocabulary_word.dart';
import 'package:vocab_learn/services/vocabulary_service.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({
    super.key,
    required this.service,
    required this.onWordTap,
  });

  final VocabularyService service;
  final void Function(VocabularyWord word) onWordTap;

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  Widget build(BuildContext context) {
    final words = widget.service.getFavoriteWords();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
      ),
      body: words.isEmpty
          ? const Center(
              child: Text('No favorite words yet. Tap the heart on any word.'),
            )
          : ListView.builder(
              itemCount: words.length,
              itemBuilder: (context, index) {
                final word = words[index];
                return ListTile(
                  title: Text(word.word),
                  subtitle: Text(word.meaning),
                  trailing: IconButton(
                    icon: const Icon(Icons.favorite, color: Colors.red),
                    onPressed: () async {
                      await widget.service.toggleFavorite(word.id);
                      setState(() {});
                    },
                  ),
                  onTap: () => widget.onWordTap(word),
                );
              },
            ),
    );
  }
}
