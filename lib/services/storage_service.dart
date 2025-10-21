import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/tasbih_model.dart';

class TasbihStorageService {
  static const String _currentCounterKey = 'current_tasbih_counter';
  static const String _savedCountersKey = 'saved_tasbih_counters';
  static const String _settingsKey = 'tasbih_settings';

  static TasbihStorageService? _instance;
  static TasbihStorageService get instance =>
      _instance ??= TasbihStorageService._();

  TasbihStorageService._();

  // Save the current active tasbih counter
  Future<void> saveCurrentCounter(TasbihCounter counter) async {
    final prefs = await SharedPreferences.getInstance();
    final counterJson = jsonEncode(counter.toJson());
    await prefs.setString(_currentCounterKey, counterJson);
  }

  // Load the current active tasbih counter
  Future<TasbihCounter?> loadCurrentCounter() async {
    final prefs = await SharedPreferences.getInstance();
    final counterJson = prefs.getString(_currentCounterKey);

    if (counterJson != null) {
      try {
        final counterMap = jsonDecode(counterJson);
        return TasbihCounter.fromJson(counterMap);
      } catch (e) {
        // If there's an error parsing, return null
        return null;
      }
    }
    return null;
  }

  // Save all tasbih counters
  Future<void> saveAllCounters(List<TasbihCounter> counters) async {
    final prefs = await SharedPreferences.getInstance();
    final countersList = counters.map((counter) => counter.toJson()).toList();
    final countersJson = jsonEncode(countersList);
    await prefs.setString(_savedCountersKey, countersJson);
  }

  // Load all saved tasbih counters
  Future<List<TasbihCounter>> loadAllCounters() async {
    final prefs = await SharedPreferences.getInstance();
    final countersJson = prefs.getString(_savedCountersKey);

    if (countersJson != null) {
      try {
        final countersList = jsonDecode(countersJson) as List;
        return countersList
            .map((counterMap) => TasbihCounter.fromJson(counterMap))
            .toList();
      } catch (e) {
        // If there's an error parsing, return empty list
        return [];
      }
    }
    return [];
  }

  // Settings management
  Future<void> saveSettings(TasbihSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    final settingsJson = jsonEncode(settings.toJson());
    await prefs.setString(_settingsKey, settingsJson);
  }

  Future<TasbihSettings> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final settingsJson = prefs.getString(_settingsKey);

    if (settingsJson != null) {
      try {
        final settingsMap = jsonDecode(settingsJson);
        return TasbihSettings.fromJson(settingsMap);
      } catch (e) {
        // If there's an error parsing, return default settings
        return TasbihSettings();
      }
    }
    return TasbihSettings();
  }

  // Clear all data
  Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_currentCounterKey);
    await prefs.remove(_savedCountersKey);
    await prefs.remove(_settingsKey);
  }

  // Export data as JSON string
  Future<String> exportData() async {
    final currentCounter = await loadCurrentCounter();
    final allCounters = await loadAllCounters();
    final settings = await loadSettings();

    final exportData = {
      'currentCounter': currentCounter?.toJson(),
      'allCounters': allCounters.map((c) => c.toJson()).toList(),
      'settings': settings.toJson(),
      'exportDate': DateTime.now().toIso8601String(),
    };

    return jsonEncode(exportData);
  }

  // Import data from JSON string
  Future<bool> importData(String jsonData) async {
    try {
      final importData = jsonDecode(jsonData);

      // Import current counter
      if (importData['currentCounter'] != null) {
        final counter = TasbihCounter.fromJson(importData['currentCounter']);
        await saveCurrentCounter(counter);
      }

      // Import all counters
      if (importData['allCounters'] != null) {
        final countersList = (importData['allCounters'] as List)
            .map((counterMap) => TasbihCounter.fromJson(counterMap))
            .toList();
        await saveAllCounters(countersList);
      }

      // Import settings
      if (importData['settings'] != null) {
        final settings = TasbihSettings.fromJson(importData['settings']);
        await saveSettings(settings);
      }

      return true;
    } catch (e) {
      return false;
    }
  }
}

class TasbihSettings {
  final bool enableVibration;
  final bool enableSound;
  final bool showTransliteration;
  final bool showTranslation;
  final bool autoReset;
  final int vibrationIntensity;

  const TasbihSettings({
    this.enableVibration = true,
    this.enableSound = false,
    this.showTransliteration = true,
    this.showTranslation = true,
    this.autoReset = false,
    this.vibrationIntensity = 1,
  });

  TasbihSettings copyWith({
    bool? enableVibration,
    bool? enableSound,
    bool? showTransliteration,
    bool? showTranslation,
    bool? autoReset,
    int? vibrationIntensity,
  }) {
    return TasbihSettings(
      enableVibration: enableVibration ?? this.enableVibration,
      enableSound: enableSound ?? this.enableSound,
      showTransliteration: showTransliteration ?? this.showTransliteration,
      showTranslation: showTranslation ?? this.showTranslation,
      autoReset: autoReset ?? this.autoReset,
      vibrationIntensity: vibrationIntensity ?? this.vibrationIntensity,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'enableVibration': enableVibration,
      'enableSound': enableSound,
      'showTransliteration': showTransliteration,
      'showTranslation': showTranslation,
      'autoReset': autoReset,
      'vibrationIntensity': vibrationIntensity,
    };
  }

  factory TasbihSettings.fromJson(Map<String, dynamic> json) {
    return TasbihSettings(
      enableVibration: json['enableVibration'] ?? true,
      enableSound: json['enableSound'] ?? false,
      showTransliteration: json['showTransliteration'] ?? true,
      showTranslation: json['showTranslation'] ?? true,
      autoReset: json['autoReset'] ?? false,
      vibrationIntensity: json['vibrationIntensity'] ?? 1,
    );
  }
}
