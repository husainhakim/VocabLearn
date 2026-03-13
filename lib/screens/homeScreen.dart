import 'package:flutter/material.dart';
import 'package:vocab_learn/models/vocabulary_word.dart';
import 'package:vocab_learn/services/vocabulary_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.service,
    required this.onQuizTap,
    required this.onWordTap,
  });

  final VocabularyService service;
  final VoidCallback onQuizTap;
  final void Function(VocabularyWord word) onWordTap;

  @override
  Widget build(BuildContext context) {
    final dailyWord = service.getDailyWord();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vocabulary Learn'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Word of the day',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            if (dailyWord != null)
              _WordCard(
                word: dailyWord,
                isFavorite: service.isFavorite(dailyWord.id),
                onFavoriteToggle: () => service.toggleFavorite(dailyWord.id),
                onTap: () => onWordTap(dailyWord),
              )
            else
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Text('No words loaded.'),
                ),
              ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onQuizTap,
              icon: const Icon(Icons.quiz),
              label: const Text('Quiz yourself'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WordCard extends StatelessWidget {
  const _WordCard({
    required this.word,
    required this.isFavorite,
    required this.onFavoriteToggle,
    required this.onTap,
  });

  final VocabularyWord word;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      word.word,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : null,
                    ),
                    onPressed: onFavoriteToggle,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                word.pronunciation,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontStyle: FontStyle.italic,
                      color: Colors.grey.shade700,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                word.meaning,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 8),
              Text(
                '"${word.example}"',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontStyle: FontStyle.italic,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
