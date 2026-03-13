import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:vocab_learn/models/vocabulary_word.dart';
import 'package:vocab_learn/utils/constants.dart';

class VocabularyService {
  VocabularyService._();
  static final VocabularyService instance = VocabularyService._();

  List<VocabularyWord> _words = [];
  List<String> _favoriteIds = [];
  List<String> _historyIds = [];

  List<VocabularyWord> get words => List.unmodifiable(_words);
  List<String> get favoriteIds => List.unmodifiable(_favoriteIds);
  List<String> get historyIds => List.unmodifiable(_historyIds);

  Future<void> init() async {
    _loadVocabulary();
    await _loadFavorites();
    await _loadHistory();
  }

  void _loadVocabulary() {
    _words = _defaultVocabulary();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(AppConstants.favoritesKey);
    if (stored != null) {
      final decoded = jsonDecode(stored) as List<dynamic>?;
      _favoriteIds = decoded?.map((e) => e as String).toList() ?? [];
    }
  }

  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(AppConstants.historyKey);
    if (stored != null) {
      final decoded = jsonDecode(stored) as List<dynamic>?;
      _historyIds = decoded?.map((e) => e as String).toList() ?? [];
    }
  }

  VocabularyWord? getDailyWord() {
    if (_words.isEmpty) return null;
    final dayOfYear = DateTime.now().difference(DateTime(DateTime.now().year, 1, 1)).inDays;
    final index = dayOfYear % _words.length;
    return _words[index];
  }

  List<VocabularyWord> search(String query) {
    if (query.trim().isEmpty) return List.from(_words);
    final q = query.trim().toLowerCase();
    return _words.where((w) => w.word.toLowerCase().contains(q) || w.meaning.toLowerCase().contains(q)).toList();
  }

  bool isFavorite(String id) => _favoriteIds.contains(id);

  Future<void> toggleFavorite(String id) async {
    if (_favoriteIds.contains(id)) {
      _favoriteIds.remove(id);
    } else {
      _favoriteIds.add(id);
    }
    await _saveFavorites();
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.favoritesKey, jsonEncode(_favoriteIds));
  }

  Future<void> addToHistory(String id) async {
    _historyIds.remove(id);
    _historyIds.insert(0, id);
    if (_historyIds.length > AppConstants.maxHistoryLength) {
      _historyIds = _historyIds.sublist(0, AppConstants.maxHistoryLength);
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.historyKey, jsonEncode(_historyIds));
  }

  VocabularyWord? getWordById(String id) {
    try {
      return _words.firstWhere((w) => w.id == id);
    } catch (_) {
      return null;
    }
  }

  List<VocabularyWord> getFavoriteWords() {
    return _favoriteIds.map((id) => getWordById(id)).whereType<VocabularyWord>().toList();
  }

  List<VocabularyWord> getHistoryWords() {
    return _historyIds.map((id) => getWordById(id)).whereType<VocabularyWord>().toList();
  }

  static List<VocabularyWord> _defaultVocabulary() {
    return [
      const VocabularyWord(id: '1', word: 'Eloquent', meaning: 'Fluent or persuasive in speaking or writing.', example: 'She gave an eloquent speech at the conference.', pronunciation: '/ˈeləkwənt/'),
      const VocabularyWord(id: '2', word: 'Pragmatic', meaning: 'Dealing with things sensibly and realistically.', example: 'We need a pragmatic approach to solve this.', pronunciation: '/præɡˈmætɪk/'),
      const VocabularyWord(id: '3', word: 'Resilient', meaning: 'Able to withstand or recover quickly from difficulties.', example: 'Children are often more resilient than we think.', pronunciation: '/rɪˈzɪliənt/'),
      const VocabularyWord(id: '4', word: 'Ambiguous', meaning: 'Open to more than one interpretation.', example: 'His reply was deliberately ambiguous.', pronunciation: '/æmˈbɪɡjuəs/'),
      const VocabularyWord(id: '5', word: 'Diligent', meaning: 'Having or showing care in one\'s work or duties.', example: 'She was a diligent student who always did her homework.', pronunciation: '/ˈdɪlɪdʒənt/'),
      const VocabularyWord(id: '6', word: 'Ephemeral', meaning: 'Lasting for a very short time.', example: 'Fame can be ephemeral in the music industry.', pronunciation: '/ɪˈfemərəl/'),
      const VocabularyWord(id: '7', word: 'Meticulous', meaning: 'Showing great attention to detail.', example: 'He was meticulous about keeping records.', pronunciation: '/məˈtɪkjələs/'),
      const VocabularyWord(id: '8', word: 'Ubiquitous', meaning: 'Present, appearing, or found everywhere.', example: 'Smartphones have become ubiquitous in modern life.', pronunciation: '/juːˈbɪkwɪtəs/'),
      const VocabularyWord(id: '9', word: 'Versatile', meaning: 'Able to adapt to many different functions.', example: 'She is a versatile actor who can play any role.', pronunciation: '/ˈvɜːrsətəl/'),
      const VocabularyWord(id: '10', word: 'Zealous', meaning: 'Having great energy or enthusiasm.', example: 'He was a zealous supporter of the cause.', pronunciation: '/ˈzeləs/'),
      const VocabularyWord(id: '11', word: 'Benevolent', meaning: 'Well meaning and kindly.', example: 'The benevolent donor gave millions to charity.', pronunciation: '/bəˈnevələnt/'),
      const VocabularyWord(id: '12', word: 'Candid', meaning: 'Truthful and straightforward.', example: 'I appreciate your candid feedback.', pronunciation: '/ˈkændɪd/'),
      const VocabularyWord(id: '13', word: 'Decisive', meaning: 'Settling an issue; producing a definite result.', example: 'The manager made a decisive move to cut costs.', pronunciation: '/dɪˈsaɪsɪv/'),
      const VocabularyWord(id: '14', word: 'Empathetic', meaning: 'Showing an ability to understand others\' feelings.', example: 'An empathetic teacher can make a big difference.', pronunciation: '/ˌempəˈθetɪk/'),
      const VocabularyWord(id: '15', word: 'Gregarious', meaning: 'Fond of company; sociable.', example: 'She was a gregarious host who loved parties.', pronunciation: '/ɡrɪˈɡeəriəs/'),
    ];
  }
}
