import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/codex_entry.dart';
import '../../models/game_state.dart';

/// Service managing the player's legacy, unlocked canonical deaths, and narrative achievements.
///
/// Persists progress into `SharedPreferences` under key `bis_codex_records` as JSON.
class CodexService extends ChangeNotifier {
  final SharedPreferences? _injectedPrefs;

  CodexService([this._injectedPrefs]) {
    _resetToDefaults();
  }

  static CodexService? _instance;
  static CodexService get instance => _instance ??= CodexService();

  @visibleForTesting
  static set instance(CodexService? value) {
    _instance = value;
  }

  static const String codexStorageKey = 'bis_codex_records';

  bool get _isBindingInitialized {
    try {
      WidgetsBinding.instance;
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<SharedPreferences?> get _prefs async {
    if (_injectedPrefs != null) return _injectedPrefs;
    if (!_isBindingInitialized) return null;
    try {
      return await SharedPreferences.getInstance();
    } catch (_) {
      return null;
    }
  }

  late Map<String, DeathEntry> _deaths;
  late Map<String, StoryAchievement> _achievements;
  int _totalDecisions = 0;
  late Map<String, int> _highestStreaks;
  bool _initialized = false;

  bool get isInitialized => _initialized;

  void _resetToDefaults() {
    _deaths = {
      for (final death in canonicalDeathEntries) death.id: death,
    };
    _achievements = {
      for (final ach in canonicalStoryAchievements) ach.id: ach,
    };
    _totalDecisions = 0;
    _highestStreaks = {
      CampaignType.street.name: 0,
      CampaignType.empire.name: 0,
    };
  }

  // ==========================================
  // Initialization & Persistence
  // ==========================================

  /// Initializes the service by reading stored records from [SharedPreferences].
  Future<void> init() async {
    try {
      final prefs = await _prefs;
      if (prefs == null) {
        _initialized = true;
        notifyListeners();
        return;
      }
      final jsonString = prefs.getString(codexStorageKey);

      if (jsonString != null && jsonString.isNotEmpty) {
        final Map<String, dynamic> data =
            jsonDecode(jsonString) as Map<String, dynamic>;

        _totalDecisions = (data['totalDecisions'] as num?)?.toInt() ?? 0;

        if (data['highestStreaks'] is Map) {
          final streaksMap = data['highestStreaks'] as Map<String, dynamic>;
          _highestStreaks[CampaignType.street.name] =
              (streaksMap[CampaignType.street.name] as num?)?.toInt() ?? 0;
          _highestStreaks[CampaignType.empire.name] =
              (streaksMap[CampaignType.empire.name] as num?)?.toInt() ?? 0;
        }

        if (data['unlockedDeaths'] is Map) {
          final deathsMap = data['unlockedDeaths'] as Map<String, dynamic>;
          deathsMap.forEach((id, val) {
            if (_deaths.containsKey(id) && val is Map<String, dynamic>) {
              _deaths[id] = DeathEntry.fromJson(val, _deaths[id]!);
            }
          });
        }

        if (data['unlockedAchievements'] is Map) {
          final achMap = data['unlockedAchievements'] as Map<String, dynamic>;
          achMap.forEach((id, val) {
            if (_achievements.containsKey(id) && val is Map<String, dynamic>) {
              _achievements[id] =
                  StoryAchievement.fromJson(val, _achievements[id]!);
            }
          });
        }
      }
    } catch (e) {
      debugPrint('CodexService init fallback: $e');
    }

    _initialized = true;
    notifyListeners();
  }

  /// Serializes and persists all codex data into SharedPreferences.
  Future<void> save() async {
    try {
      final prefs = await _prefs;
      if (prefs == null) return;
      final Map<String, dynamic> data = {
        'totalDecisions': _totalDecisions,
        'highestStreaks': _highestStreaks,
        'unlockedDeaths': {
          for (final entry in _deaths.values)
            if (entry.isUnlocked) entry.id: entry.toJson(),
        },
        'unlockedAchievements': {
          for (final ach in _achievements.values)
            if (ach.isUnlocked) ach.id: ach.toJson(),
        },
      };

      await prefs.setString(codexStorageKey, jsonEncode(data));
    } catch (e) {
      debugPrint('CodexService save fallback: $e');
    }
  }

  // ==========================================
  // Recording API
  // ==========================================

  /// Records a canonical death and unlocks its codex entry.
  void recordDeath(CampaignType campaign, GameOverReason reason, int dayCount) {
    DeathEntry? target;
    for (final entry in _deaths.values) {
      if (entry.campaign == campaign && entry.reason == reason) {
        target = entry;
        break;
      }
    }

    if (target != null) {
      final updated = target.copyWith(
        isUnlocked: true,
        unlockedAt: target.unlockedAt ?? DateTime.now(),
        deathCount: target.deathCount + 1,
        lastDaysSurvived: dayCount,
      );
      _deaths[target.id] = updated;
    }

    final currentStreak = _highestStreaks[campaign.name] ?? 0;
    if (dayCount > currentStreak) {
      _highestStreaks[campaign.name] = dayCount;
    }

    save();
    notifyListeners();
  }

  /// Increments total decisions made across all runs.
  void recordDecision() {
    _totalDecisions++;
    save();
    notifyListeners();
  }

  /// Updates highest streak for the given [campaign] if [days] > currentStreak.
  void recordSurvivalDays(CampaignType campaign, int days) {
    final currentStreak = _highestStreaks[campaign.name] ?? 0;
    if (days > currentStreak) {
      _highestStreaks[campaign.name] = days;
      save();
      notifyListeners();
    }
  }

  /// Evaluates whether a newly added story flag unlocks an achievement.
  void recordFlagIfAchievement(String flag) {
    bool updatedAny = false;
    for (final entry in _achievements.values) {
      if (entry.flag == flag && !entry.isUnlocked) {
        _achievements[entry.id] = entry.copyWith(
          isUnlocked: true,
          unlockedAt: DateTime.now(),
        );
        updatedAny = true;
      }
    }

    if (updatedAny) {
      save();
      notifyListeners();
    }
  }

  // ==========================================
  // Getters & Progress Queries
  // ==========================================

  int get totalDecisions => _totalDecisions;

  int getHighestStreak(CampaignType campaign) =>
      _highestStreaks[campaign.name] ?? 0;

  List<DeathEntry> getDeaths([CampaignType? campaign]) {
    if (campaign == null) {
      return _deaths.values.toList();
    }
    return _deaths.values.where((d) => d.campaign == campaign).toList();
  }

  List<StoryAchievement> getAchievements([CampaignType? campaign]) {
    if (campaign == null) {
      return _achievements.values.toList();
    }
    return _achievements.values.where((a) => a.campaign == campaign).toList();
  }

  int getUnlockedDeathCount([CampaignType? campaign]) {
    return getDeaths(campaign).where((d) => d.isUnlocked).length;
  }

  int getTotalDeathCount([CampaignType? campaign]) {
    return getDeaths(campaign).length;
  }

  int getUnlockedAchievementCount([CampaignType? campaign]) {
    return getAchievements(campaign).where((a) => a.isUnlocked).length;
  }

  int getTotalAchievementCount([CampaignType? campaign]) {
    return getAchievements(campaign).length;
  }

  double getDeathCompletionPercentage([CampaignType? campaign]) {
    final total = getTotalDeathCount(campaign);
    if (total == 0) return 0.0;
    return getUnlockedDeathCount(campaign) / total;
  }

  double getTotalCompletionPercentage([CampaignType? campaign]) {
    final total =
        getTotalDeathCount(campaign) + getTotalAchievementCount(campaign);
    if (total == 0) return 0.0;
    final unlocked =
        getUnlockedDeathCount(campaign) + getUnlockedAchievementCount(campaign);
    return unlocked / total;
  }

  /// Clears stored records and resets in-memory data to factory defaults.
  Future<void> clearAll() async {
    try {
      final prefs = await _prefs;
      if (prefs != null) {
        await prefs.remove(codexStorageKey);
      }
    } catch (e) {
      debugPrint('CodexService clearAll fallback: $e');
    }
    _resetToDefaults();
    notifyListeners();
  }
}
