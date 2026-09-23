import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:beauty_in_shadow/core/services/storage_service.dart';
import 'package:beauty_in_shadow/models/game_state.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('StorageService Unit Tests', () {
    test('Default best days is 0', () async {
      final storage = StorageService.instance;
      expect(await storage.getBestDays(CampaignType.street), 0);
      expect(await storage.getBestDays(CampaignType.empire), 0);
    });

    test('saveRecordIfBest updates record only when new days is higher',
        () async {
      final storage = StorageService.instance;

      final updated1 = await storage.saveRecordIfBest(CampaignType.street, 10);
      expect(updated1, isTrue);
      expect(await storage.getBestDays(CampaignType.street), 10);

      // Attempt lower score - should not update
      final updated2 = await storage.saveRecordIfBest(CampaignType.street, 5);
      expect(updated2, isFalse);
      expect(await storage.getBestDays(CampaignType.street), 10);

      // Attempt higher score - should update
      final updated3 = await storage.saveRecordIfBest(CampaignType.street, 25);
      expect(updated3, isTrue);
      expect(await storage.getBestDays(CampaignType.street), 25);

      // Empire remains 0
      expect(await storage.getBestDays(CampaignType.empire), 0);
    });

    test('Unlocked flags persist correctly', () async {
      final storage = StorageService.instance;

      expect(await storage.getUnlockedFlags(), isEmpty);

      await storage.saveUnlockedFlag('danseuse_active');
      await storage.saveUnlockedFlag('rivalite_rain');

      final flags = await storage.getUnlockedFlags();
      expect(flags.contains('danseuse_active'), isTrue);
      expect(flags.contains('rivalite_rain'), isTrue);
      expect(flags.length, 2);
    });

    test('clearAll wipes persisted records and flags', () async {
      final storage = StorageService.instance;

      await storage.saveRecordIfBest(CampaignType.street, 12);
      await storage.saveRecordIfBest(CampaignType.empire, 15);
      await storage.saveUnlockedFlag('test_flag');

      await storage.clearAll();

      expect(await storage.getBestDays(CampaignType.street), 0);
      expect(await storage.getBestDays(CampaignType.empire), 0);
      expect(await storage.getUnlockedFlags(), isEmpty);
    });
  });
}
