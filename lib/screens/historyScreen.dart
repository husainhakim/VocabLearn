import 'package:flutter/material.dart';
import 'package:vocab_learn/models/vocabulary_word.dart';
import 'package:vocab_learn/services/vocabulary_service.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({
    super.key,
    required this.service,
    required this.onWordTap,
  });

  final VocabularyService service;
  final void Function(VocabularyWord word) onWordTap;

  @override
  Widget build(BuildContext context) {
    final words = service.getHistoryWords();
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
      ),
      body: words.isEmpty
          ? const Center(
              child: Text('No words viewed yet. Open any word to see it here.'),
            )
          : ListView.builder(
              itemCount: words.length,
              itemBuilder: (context, index) {
                final word = words[index];
                return ListTile(
                  title: Text(word.word),
                  subtitle: Text(word.meaning),
                  onTap: () => onWordTap(word),
                );
              },
            ),
    );
  }
}
