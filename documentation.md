# Vocabulary Learning App - Documentation

A Flutter-based mobile application for daily vocabulary practice. Users can learn new words, view meanings, examples, pronunciations, and test their knowledge with quizzes.

---

## Features

| Feature | Description |
|---------|-------------|
| Daily Word Card | Displays a "Word of the Day" on the Home screen with meaning, example, and pronunciation |
| Word Meaning Display | Shows the definition of each vocabulary word |
| Example Sentence | Provides a usage example for each word |
| Pronunciation Guide | Displays phonetic text (e.g., `/ˈwɜːd/`) for each word |
| Favorite Words | Tap the heart icon to save words to your favorites list |
| Word History | Automatically tracks recently viewed words |
| Search Vocabulary | Filter words by name or meaning using the search bar |
| Quiz Yourself | Multiple-choice quiz to test your vocabulary knowledge |
| Navigation | Bottom navigation bar for easy access to all sections |

---

## Project Structure

```
lib/
├── main.dart                      # App entry point and main shell with navigation
├── models/
│   └── vocabulary_word.dart       # VocabularyWord data model
├── screens/
│   ├── homeScreen.dart            # Home screen with daily word card
│   ├── vocabularyListScreen.dart  # Searchable list of all words
│   ├── wordDetailScreen.dart      # Detailed view of a single word
│   ├── favoritesScreen.dart       # List of favorite words
│   ├── historyScreen.dart         # List of recently viewed words
│   └── quizScreen.dart            # Multiple-choice quiz
├── services/
│   └── vocabulary_service.dart    # Business logic, data, and persistence
└── utils/
    └── constants.dart             # App constants (storage keys, limits)
```

---

## Screens Overview

### 1. Home Screen
- Displays the **Word of the Day** in a card format
- Shows word, pronunciation, meaning, and example sentence
- Heart icon to favorite the word
- "Quiz yourself" button to navigate to the Quiz tab

### 2. Vocabulary Screen
- Lists all vocabulary words
- **Search bar** to filter by word or meaning
- Heart icon on each row to toggle favorite (without navigating)
- Tap a word to open its detail screen

### 3. Word Detail Screen
- Full details: pronunciation, meaning, and example
- Heart icon in app bar to toggle favorite
- Automatically adds word to history when opened

### 4. Favorites Screen
- Lists all favorited words
- Tap heart to unfavorite
- Tap word to open detail screen

### 5. History Screen
- Lists recently viewed words (most recent first)
- Tap word to open detail screen

### 6. Quiz Screen
- Shows a word with its pronunciation
- Four multiple-choice options for the meaning
- Highlights correct (green) and incorrect (red) answers
- "Next question" button to continue

---

## Data Model

### VocabularyWord

```dart
class VocabularyWord {
  final String id;
  final String word;
  final String meaning;
  final String example;
  final String pronunciation;
}
```

---

## Data Persistence

The app uses **SharedPreferences** for local storage (no backend required).

| Data | Storage Key | Format |
|------|-------------|--------|
| Favorite word IDs | `favorite_word_ids` | JSON array of strings |
| History word IDs | `word_history` | JSON array of strings |

- Favorites and history persist across app restarts
- History is capped at 50 entries (configurable in `constants.dart`)

---

## Vocabulary Service

`VocabularyService` is a singleton that manages:

- **Vocabulary list**: 15 built-in words loaded at startup
- **Daily word**: Determined by day of year (`dayOfYear % wordCount`)
- **Favorites**: Add/remove, check if favorite, get all favorites
- **History**: Add to history on word view, get all history
- **Search**: Filter words by word or meaning

---

## How to Run

### Prerequisites
- Flutter SDK (3.0.0 or higher)
- Dart SDK

### Steps

```bash
# Navigate to project directory
cd /Users/husainhakim/ITM/VocabLearn

# Get dependencies
flutter pub get

# Run on connected device or emulator
flutter run
```

### Run on specific platform

```bash
flutter run -d chrome      # Web
flutter run -d macos       # macOS
flutter run -d ios         # iOS Simulator
flutter run -d android     # Android Emulator
```

---

## Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| flutter | SDK | Core framework |
| cupertino_icons | ^1.0.6 | iOS-style icons |
| shared_preferences | ^2.2.2 | Local key-value storage |

---

## Technical Notes

- **State Management**: `StatefulWidget` + `setState()` for simple, basic Flutter approach
- **Navigation**: `Navigator.push/pop` for detail screens; `IndexedStack` + bottom nav for tabs
- **No Backend**: All data is bundled in-app; favorites/history stored locally
- **Material 3**: Uses `useMaterial3: true` for modern Material Design

---

## Future Enhancements (Optional)

- Add more vocabulary words (or load from JSON asset)
- Text-to-speech for pronunciation
- Quiz score tracking and statistics
- Dark mode support
- Cloud sync for favorites/history

---

## License

This project is for educational purposes (Case Study 13: Vocabulary Learning App).
