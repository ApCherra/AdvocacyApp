final class EmotionTranslator {
  final Map<String, int> _data = {
    "happy" : 0,
    "bad" : 1,
    "good" : 2,
    "excellent" : 3,
    "alright" : 4,
    "sad" : 5,
    "angry" : 6,
    "overwhelmed" : 7,
  };

  int getEmotionCode({required String forEmotion}) {
    // Return the emotion's code or -1 if no match is found.
    return _data[forEmotion.toLowerCase()] ?? -1;
  }

  String getEmotionString({required int fromCode}) {
    for (var items in _data.entries) {
      // Key was found
      if (items.value == fromCode) {
        return items.key;
      }
    }

    return "Unknown Emotion: $fromCode!";
  }

  static EmotionTranslator instance = EmotionTranslator();
}