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
      const VocabularyWord(id: '16', word: 'Inquisitive', meaning: 'Curious or inquiring.', example: 'His inquisitive nature led him to read extensively.', pronunciation: '/ɪnˈkwɪzɪtɪv/'),
      const VocabularyWord(id: '17', word: 'Judicious', meaning: 'Having, showing, or done with good judgment.', example: 'It was a judicious decision to save money for emergencies.', pronunciation: '/dʒuːˈdɪʃəs/'),
      const VocabularyWord(id: '18', word: 'Keen', meaning: 'Having or showing eagerness or enthusiasm.', example: 'She was keen to start her new project.', pronunciation: '/kiːn/'),
      const VocabularyWord(id: '19', word: 'Lucid', meaning: 'Expressed clearly; easy to understand.', example: 'The teacher gave a lucid explanation of the concept.', pronunciation: '/ˈluːsɪd/'),
      const VocabularyWord(id: '20', word: 'Metamorphosis', meaning: 'A change of the form or nature of a thing.', example: 'The caterpillar’s metamorphosis into a butterfly is fascinating.', pronunciation: '/ˌmɛtəˈmɔːrfəsɪs/'),
      const VocabularyWord(id: '21', word: 'Nonchalant', meaning: 'Feeling or appearing casually calm and relaxed.', example: 'He acted nonchalant even though he was nervous.', pronunciation: '/ˌnɒnʃəˈlɑːnt/'),
      const VocabularyWord(id: '22', word: 'Obsolete', meaning: 'No longer produced or used; out of date.', example: 'Typewriters are now mostly obsolete.', pronunciation: '/ˈɒbsəˌliːt/'),
      const VocabularyWord(id: '23', word: 'Perplexed', meaning: 'Completely baffled; very puzzled.', example: 'She was perplexed by the complex instructions.', pronunciation: '/pəˈplɛkst/'),
      const VocabularyWord(id: '24', word: 'Quintessential', meaning: 'Representing the most perfect example of a quality.', example: 'He was the quintessential gentleman.', pronunciation: '/ˌkwɪntɪˈsɛnʃəl/'),
      const VocabularyWord(id: '25', word: 'Reverence', meaning: 'Deep respect for someone or something.', example: 'They showed reverence during the ceremony.', pronunciation: '/ˈrɛvərəns/'),
      const VocabularyWord(id: '26', word: 'Sagacious', meaning: 'Having or showing keen mental discernment and good judgment.', example: 'The sagacious leader guided the team through turmoil.', pronunciation: '/səˈɡeɪʃəs/'),
      const VocabularyWord(id: '27', word: 'Tenacious', meaning: 'Tending to keep a firm hold of something; persistent.', example: 'Her tenacious attitude helped her finish the marathon.', pronunciation: '/təˈneɪʃəs/'),
      const VocabularyWord(id: '28', word: 'Utopia', meaning: 'An imagined place where everything is perfect.', example: 'The novel described a utopia where poverty didn’t exist.', pronunciation: '/juːˈtoʊpiə/'),
      const VocabularyWord(id: '29', word: 'Vigilant', meaning: 'Keeping careful watch for possible danger or difficulties.', example: 'The guard remained vigilant throughout the night.', pronunciation: '/ˈvɪdʒələnt/'),
      const VocabularyWord(id: '30', word: 'Wary', meaning: 'Feeling or showing caution about possible dangers.', example: 'She was wary of strangers offering help.', pronunciation: '/ˈwɛri/'),
      const VocabularyWord(id: '31', word: 'Yield', meaning: 'Produce or provide (a natural, agricultural, or industrial product).', example: 'The farm yields a lot of produce each season.', pronunciation: '/jiːld/'),
      const VocabularyWord(id: '32', word: 'Zeal', meaning: 'Great energy or enthusiasm in pursuit of a cause.', example: 'His zeal for the environment inspired many.', pronunciation: '/ziːl/'),
      const VocabularyWord(id: '33', word: 'Affluent', meaning: 'Having a great deal of money; wealthy.', example: 'The affluent neighborhood had large houses and manicured lawns.', pronunciation: '/ˈæfluənt/'),
      const VocabularyWord(id: '34', word: 'Bashful', meaning: 'Reluctant to draw attention to oneself; shy.', example: 'He was bashful when asked to speak in public.', pronunciation: '/ˈbæʃfəl/'),
      const VocabularyWord(id: '35', word: 'Cohesive', meaning: 'Characterized by or causing cohesion.', example: 'The team had a cohesive strategy for the project.', pronunciation: '/koʊˈhiːsɪv/'),
      const VocabularyWord(id: '36', word: 'Dubious', meaning: 'Hesitating or doubting.', example: 'She was dubious about the truth of the rumor.', pronunciation: '/ˈdjuːbiəs/'),
      const VocabularyWord(id: '37', word: 'Eloquent', meaning: 'Fluent or persuasive in speaking or writing.', example: 'He gave an eloquent speech about equality.', pronunciation: '/ˈeləkwənt/'),
      const VocabularyWord(id: '38', word: 'Frugal', meaning: 'Sparing or economical with regard to money.', example: 'Living frugal helped him save for the future.', pronunciation: '/ˈfruːɡəl/'),
      const VocabularyWord(id: '39', word: 'Gratuitous', meaning: 'Uncalled for; lacking good reason.', example: 'The movie had too much gratuitous violence.', pronunciation: '/ɡrəˈtjuːɪtəs/'),
      const VocabularyWord(id: '40', word: 'Harmonious', meaning: 'Forming a pleasing or consistent whole.', example: 'The choir sounded harmonious during the concert.', pronunciation: '/hɑːrˈmoʊniəs/'),
      const VocabularyWord(id: '41', word: 'Impartial', meaning: 'Treating all rivals equally; fair and just.', example: 'A judge must remain impartial at all times.', pronunciation: '/ɪmˈpɑːrʃəl/'),
      const VocabularyWord(id: '42', word: 'Juxtapose', meaning: 'Place side by side for contrast.', example: 'The artist juxtaposed old and new images.', pronunciation: '/ˌdʒʌkstəˈpoʊz/'),
      const VocabularyWord(id: '43', word: 'Kinetic', meaning: 'Relating to or resulting from motion.', example: 'The kinetic energy was visible in the moving parts.', pronunciation: '/kɪˈnɛtɪk/'),
      const VocabularyWord(id: '44', word: 'Lucid', meaning: 'Expressed clearly; easy to understand.', example: 'Her explanation was lucid and helpful.', pronunciation: '/ˈluːsɪd/'),
      const VocabularyWord(id: '45', word: 'Malleable', meaning: 'Easily influenced or changed.', example: 'The material is malleable and shapes easily.', pronunciation: '/ˈmæliəbəl/'),
      const VocabularyWord(id: '46', word: 'Negligible', meaning: 'So small or unimportant as to be not worth considering.', example: 'The cost increase was negligible.', pronunciation: '/ˈnɛɡlɪdʒəbəl/'),
      const VocabularyWord(id: '47', word: 'Obstinate', meaning: 'Stubbornly refusing to change one’s opinion.', example: 'He was obstinate about trying new foods.', pronunciation: '/ˈɒbstɪnət/'),
      const VocabularyWord(id: '48', word: 'Pensive', meaning: 'Engaged in deep or serious thought.', example: 'She looked pensive while reading the letter.', pronunciation: '/ˈpɛnsɪv/'),
      const VocabularyWord(id: '49', word: 'Quaint', meaning: 'Attractively unusual or old-fashioned.', example: 'They stayed in a quaint cottage by the sea.', pronunciation: '/kweɪnt/'),
      const VocabularyWord(id: '50', word: 'Radiant', meaning: 'Sending out light; shining or glowing brightly.', example: 'Her smile was radiant that morning.', pronunciation: '/ˈreɪdiənt/'),
      const VocabularyWord(id: '51', word: 'Stagnant', meaning: 'Showing no activity; dull and sluggish.', example: 'The stagnant water smelled bad.', pronunciation: '/ˈstæɡnənt/'),
      const VocabularyWord(id: '52', word: 'Tangible', meaning: 'Perceptible by touch.', example: 'There was a tangible sense of relief in the room.', pronunciation: '/ˈtæn.dʒə.bəl/'),
      const VocabularyWord(id: '53', word: 'Unwavering', meaning: 'Steady or resolute.', example: 'Her unwavering commitment impressed everyone.', pronunciation: '/ʌnˈweɪvərɪŋ/'),
      const VocabularyWord(id: '54', word: 'Vicarious', meaning: 'Experienced in the imagination through feelings of another.', example: 'He lived vicariously through his friend’s adventures.', pronunciation: '/vɪˈkɛəriəs/'),
      const VocabularyWord(id: '55', word: 'Whimsical', meaning: 'Playfully quaint or fanciful.', example: 'The whimsical decorations made the room cheerful.', pronunciation: '/ˈwɪmzɪkəl/'),
      const VocabularyWord(id: '56', word: 'Yearn', meaning: 'Have an intense feeling of longing for something.', example: 'She yearned for a simpler life.', pronunciation: '/jɜːrn/'),
      const VocabularyWord(id: '57', word: 'Zephyr', meaning: 'A soft gentle breeze.', example: 'A zephyr cooled the hot summer afternoon.', pronunciation: '/ˈzɛfər/'),
      const VocabularyWord(id: '58', word: 'Astute', meaning: 'Having or showing an ability to accurately assess situations.', example: 'Her astute observations impressed the team.', pronunciation: '/əˈstjuːt/'),
      const VocabularyWord(id: '59', word: 'Blatant', meaning: 'Done openly and unashamedly.', example: 'The error was blatant and obvious.', pronunciation: '/ˈbleɪtənt/'),
      const VocabularyWord(id: '60', word: 'Candid', meaning: 'Truthful and straightforward.', example: 'His candid interview was refreshing.', pronunciation: '/ˈkændɪd/'),
      const VocabularyWord(id: '61', word: 'Dauntless', meaning: 'Showing fearlessness and determination.', example: 'The dauntless explorer ventured into the unknown.', pronunciation: '/ˈdɔːntləs/'),
      const VocabularyWord(id: '62', word: 'Euphoric', meaning: 'Characterized by intense excitement and happiness.', example: 'She felt euphoric after finishing the race.', pronunciation: '/juːˈfɔːrɪk/'),
      const VocabularyWord(id: '63', word: 'Flourish', meaning: 'Grow or develop in a healthy way.', example: 'The garden began to flourish in spring.', pronunciation: '/ˈflʌrɪʃ/'),
      const VocabularyWord(id: '64', word: 'Gullible', meaning: 'Easily persuaded to believe something.', example: 'He was so gullible he believed every story.', pronunciation: '/ˈɡʌləbəl/'),
      const VocabularyWord(id: '65', word: 'Hapless', meaning: 'Unfortunate and deserving pity.', example: 'The hapless traveler lost his luggage.', pronunciation: '/ˈhæpləs/'),
    ];
  }
}
