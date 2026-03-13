import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vocab_learn/models/vocabulary_word.dart';
import 'package:vocab_learn/services/vocabulary_service.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({
    super.key,
    required this.service,
  });

  final VocabularyService service;

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  VocabularyWord? _currentWord;
  List<String> _options = [];
  int? _selectedIndex;
  bool _answered = false;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _nextQuestion();
  }

  void _nextQuestion() {
    final words = widget.service.words;
    if (words.length < 4) return;
    final correct = words[_random.nextInt(words.length)];
    final others = words.where((w) => w.id != correct.id).toList()..shuffle(_random);
    final options = [correct.meaning, ...others.take(3).map((w) => w.meaning)]..shuffle(_random);
    setState(() {
      _currentWord = correct;
      _options = options;
      _selectedIndex = null;
      _answered = false;
    });
  }

  void _select(int index) {
    if (_answered) return;
    setState(() {
      _selectedIndex = index;
      _answered = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_currentWord == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Quiz')),
        body: const Center(child: Text('Need at least 4 words to quiz.')),
      );
    }
    final correctIndex = _options.indexOf(_currentWord!.meaning);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz yourself'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Text(
                      _currentWord!.word,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _currentWord!.pronunciation,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontStyle: FontStyle.italic,
                            color: Colors.grey.shade700,
                          ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text('Choose the correct meaning:'),
            const SizedBox(height: 12),
            ...List.generate(_options.length, (index) {
              final isCorrect = index == correctIndex;
              final isChosen = _selectedIndex == index;
              Color? bg;
              if (_answered && isChosen) {
                bg = isCorrect ? Colors.green.shade100 : Colors.red.shade100;
              } else if (_answered && isCorrect) {
                bg = Colors.green.shade100;
              }
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 4),
                child: Card(
                  color: bg,
                  child: InkWell(
                    onTap: () => _select(index),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 16,
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          _options[index],
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
            if (_answered) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _nextQuestion,
                icon: const Icon(Icons.refresh),
                label: const Text('Next question'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
