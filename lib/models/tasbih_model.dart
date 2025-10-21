class TasbihItem {
  final String arabicText;
  final String transliteration;
  final String translation;
  final int targetCount;

  const TasbihItem({
    required this.arabicText,
    required this.transliteration,
    required this.translation,
    required this.targetCount,
  });
}

class TasbihData {
  static const List<TasbihItem> commonDhikr = [
    TasbihItem(
      arabicText: 'سُبْحَانَ اللهِ',
      transliteration: 'Subhan Allah',
      translation: 'Glory be to Allah',
      targetCount: 33,
    ),
    TasbihItem(
      arabicText: 'الْحَمْدُ للهِ',
      transliteration: 'Alhamdulillah',
      translation: 'All praise is due to Allah',
      targetCount: 33,
    ),
    TasbihItem(
      arabicText: 'اللهُ أَكْبَرُ',
      transliteration: 'Allahu Akbar',
      translation: 'Allah is the Greatest',
      targetCount: 34,
    ),
    TasbihItem(
      arabicText: 'لَا إِلَٰهَ إِلَّا اللهُ',
      transliteration: 'La ilaha illa Allah',
      translation: 'There is no god but Allah',
      targetCount: 100,
    ),
    TasbihItem(
      arabicText: 'اللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ',
      transliteration: 'Allahumma salli ala Muhammad',
      translation: 'O Allah, send prayers upon Muhammad',
      targetCount: 100,
    ),
    TasbihItem(
      arabicText: 'أَسْتَغْفِرُ اللهَ',
      transliteration: 'Astaghfirullah',
      translation: 'I seek forgiveness from Allah',
      targetCount: 100,
    ),
    TasbihItem(
      arabicText: 'حَسْبُنَا اللهُ وَنِعْمَ الْوَكِيلُ',
      transliteration: 'Hasbunallahu wa ni\'mal wakeel',
      translation:
          'Allah is sufficient for us, and He is the best disposer of affairs',
      targetCount: 100,
    ),
    TasbihItem(
      arabicText: 'رَبِّ اغْفِرْ لِي',
      transliteration: 'Rabbi ghfir li',
      translation: 'My Lord, forgive me',
      targetCount: 100,
    ),
  ];

  static const TasbihItem customDhikr = TasbihItem(
    arabicText: 'ذِكْر مُخَصَّص',
    transliteration: 'Custom Dhikr',
    translation: 'Custom remembrance of Allah',
    targetCount: 100,
  );
}

class TasbihCounter {
  final TasbihItem item;
  int currentCount;
  int totalCount;
  DateTime lastUpdated;

  TasbihCounter({
    required this.item,
    this.currentCount = 0,
    this.totalCount = 0,
    DateTime? lastUpdated,
  }) : lastUpdated = lastUpdated ?? DateTime.now();

  void increment() {
    currentCount++;
    totalCount++;
    lastUpdated = DateTime.now();
  }

  void reset() {
    currentCount = 0;
    lastUpdated = DateTime.now();
  }

  void resetTotal() {
    currentCount = 0;
    totalCount = 0;
    lastUpdated = DateTime.now();
  }

  bool get isTargetReached => currentCount >= item.targetCount;

  double get progressPercentage {
    if (item.targetCount == 0) return 0.0;
    return (currentCount / item.targetCount).clamp(0.0, 1.0);
  }

  Map<String, dynamic> toJson() {
    return {
      'arabicText': item.arabicText,
      'transliteration': item.transliteration,
      'translation': item.translation,
      'targetCount': item.targetCount,
      'currentCount': currentCount,
      'totalCount': totalCount,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  factory TasbihCounter.fromJson(Map<String, dynamic> json) {
    return TasbihCounter(
      item: TasbihItem(
        arabicText: json['arabicText'],
        transliteration: json['transliteration'],
        translation: json['translation'],
        targetCount: json['targetCount'],
      ),
      currentCount: json['currentCount'] ?? 0,
      totalCount: json['totalCount'] ?? 0,
      lastUpdated: DateTime.parse(json['lastUpdated']),
    );
  }
}
