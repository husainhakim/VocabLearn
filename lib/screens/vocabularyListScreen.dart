import 'package:flutter/material.dart';
import 'package:vocab_learn/models/vocabulary_word.dart';
import 'package:vocab_learn/services/vocabulary_service.dart';

class VocabularyListScreen extends StatefulWidget {
  const VocabularyListScreen({
    super.key,
    required this.service,
    required this.onWordTap,
  });

  final VocabularyService service;
  final void Function(VocabularyWord word) onWordTap;

  @override
  State<VocabularyListScreen> createState() => _VocabularyListScreenState();
}

class _VocabularyListScreenState extends State<VocabularyListScreen> {
  String _query = '';
  List<VocabularyWord> _filtered = [];

  @override
  void initState() {
    super.initState();
    _filtered = widget.service.search(_query);
  }

  void _onSearchChanged(String value) {
    setState(() {
      _query = value;
      _filtered = widget.service.search(_query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vocabulary'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: TextField(
              onChanged: _onSearchChanged,
              decoration: const InputDecoration(
                hintText: 'Search vocabulary...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
                isDense: true,
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              ),
            ),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: _filtered.length,
        itemBuilder: (context, index) {
          final word = _filtered[index];
          final isFavorite = widget.service.isFavorite(word.id);
          return ListTile(
            title: Text(word.word),
            subtitle: Text(word.meaning),
            trailing: IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : null,
              ),
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
