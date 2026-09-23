import 'package:shared_preferences/shared_preferences.dart';
import '../../models/game_state.dart';

/// Service responsible for persisting player high-scores and unlocked story flags.
class StorageService {
  final SharedPreferences? _injectedPrefs;

  const StorageService([this._injectedPrefs]);

  static StorageService? _instance;
  static StorageService get instance => _instance ??= const StorageService();

  Future<SharedPreferences> get _prefs async =>
      _injectedPrefs ?? await SharedPreferences.getInstance();

  static const String _streetBestDaysKey = 'bis_best_days_street';
  static const String _empireBestDaysKey = 'bis_best_days_empire';
  static const String _unlockedFlagsKey = 'bis_unlocked_flags';

  static String _getKeyForCampaign(CampaignType campaign) {
    switch (campaign) {
      case CampaignType.street:
        return _streetBestDaysKey;
      case CampaignType.empire:
        return _empireBestDaysKey;
    }
  }

  /// Retrieves the maximum survived days for the given [campaign].
  Future<int> getBestDays(CampaignType campaign) async {
    final prefs = await _prefs;
    return prefs.getInt(_getKeyForCampaign(campaign)) ?? 0;
  }

  /// Updates and persists the best day count if [days] > currentBest.
  ///
  /// Returns `true` if a new record was set, `false` otherwise.
  Future<bool> saveRecordIfBest(CampaignType campaign, int days) async {
    final prefs = await _prefs;
    final key = _getKeyForCampaign(campaign);
    final currentBest = prefs.getInt(key) ?? 0;

    if (days > currentBest) {
      await prefs.setInt(key, days);
      return true;
    }
    return false;
  }

  /// Persists story achievements across playthroughs.
  Future<void> saveUnlockedFlag(String flag) async {
    final prefs = await _prefs;
    final flags = prefs.getStringList(_unlockedFlagsKey)?.toSet() ?? <String>{};
    flags.add(flag);
    await prefs.setStringList(_unlockedFlagsKey, flags.toList());
  }

  /// Retrieves all persistent story flags unlocked across sessions.
  Future<Set<String>> getUnlockedFlags() async {
    final prefs = await _prefs;
    return prefs.getStringList(_unlockedFlagsKey)?.toSet() ?? <String>{};
  }

  /// Clears stored statistics (useful for reset or debugging).
  Future<void> clearAll() async {
    final prefs = await _prefs;
    await prefs.remove(_streetBestDaysKey);
    await prefs.remove(_empireBestDaysKey);
    await prefs.remove(_unlockedFlagsKey);
  }
}
