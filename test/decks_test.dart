import 'package:flutter_test/flutter_test.dart';
import 'package:beauty_in_shadow/data/street_deck.dart';
import 'package:beauty_in_shadow/data/empire_deck.dart';
import 'package:beauty_in_shadow/models/card_model.dart';

void main() {
  group('Narrative Decks Validation', () {
    test('Deck counts match exactly 10 cards per campaign (20 total)', () {
      expect(initialStreetDeck.length, 10);
      expect(initialEmpireDeck.length, 10);
    });

    test('All 20 cards across both decks have unique IDs', () {
      final allCards = <GameCard>[...initialStreetDeck, ...initialEmpireDeck];
      final ids = allCards.map((c) => c.id).toList();
      final uniqueIds = ids.toSet();

      expect(ids.length, 20);
      expect(uniqueIds.length, 20);
    });

    test('All cards have valid metadata and matching campaign tags', () {
      for (final card in initialStreetDeck) {
        expect(card.campaign, 'STREET');
        expect(card.isStreet, isTrue);
        expect(card.isEmpire, isFalse);
        expect(card.speakerName.trim(), isNotEmpty);
        expect(card.speakerRole.trim(), isNotEmpty);
        expect(card.speakerAvatar.trim(), isNotEmpty);
        expect(card.dialogue.trim(), isNotEmpty);
      }

      for (final card in initialEmpireDeck) {
        expect(card.campaign, 'EMPIRE');
        expect(card.isEmpire, isTrue);
        expect(card.isStreet, isFalse);
        expect(card.speakerName.trim(), isNotEmpty);
        expect(card.speakerRole.trim(), isNotEmpty);
        expect(card.speakerAvatar.trim(), isNotEmpty);
        expect(card.dialogue.trim(), isNotEmpty);
      }
    });

    test('Every choice has non-empty text and affects at least 2 gauges', () {
      final allCards = <GameCard>[...initialStreetDeck, ...initialEmpireDeck];

      for (final card in allCards) {
        // Validate left choice
        expect(card.leftChoice.text.trim(), isNotEmpty,
            reason: '${card.id} left choice has empty text');
        final leftImpactedGauges = [
          card.leftChoice.deltaGauge1 != 0,
          card.leftChoice.deltaGauge2 != 0,
          card.leftChoice.deltaGauge3 != 0,
          card.leftChoice.deltaGauge4 != 0,
        ].where((impacted) => impacted).length;
        expect(leftImpactedGauges, greaterThanOrEqualTo(2),
            reason: '${card.id} left choice must affect at least 2 gauges');

        // Validate right choice
        expect(card.rightChoice.text.trim(), isNotEmpty,
            reason: '${card.id} right choice has empty text');
        final rightImpactedGauges = [
          card.rightChoice.deltaGauge1 != 0,
          card.rightChoice.deltaGauge2 != 0,
          card.rightChoice.deltaGauge3 != 0,
          card.rightChoice.deltaGauge4 != 0,
        ].where((impacted) => impacted).length;
        expect(rightImpactedGauges, greaterThanOrEqualTo(2),
            reason: '${card.id} right choice must affect at least 2 gauges');
      }
    });

    test('Street deck key narrative flags are properly wired', () {
      final st001 = initialStreetDeck.firstWhere((c) => c.id == 'ST_001');
      expect(st001.rightChoice.setFlags, contains('expulsee_du_foyer'));

      final st003 = initialStreetDeck.firstWhere((c) => c.id == 'ST_003');
      expect(st003.leftChoice.setFlags, contains('danseuse_active'));

      final st004 = initialStreetDeck.firstWhere((c) => c.id == 'ST_004');
      expect(st004.leftChoice.setFlags, contains('rivalite_rain'));

      final st005 = initialStreetDeck.firstWhere((c) => c.id == 'ST_005');
      expect(st005.leftChoice.setFlags, contains('enveloppe_acceptee'));

      final st009 = initialStreetDeck.firstWhere((c) => c.id == 'ST_009');
      expect(st009.leftChoice.setFlags, contains('scandale_loge'));

      final st010 = initialStreetDeck.firstWhere((c) => c.id == 'ST_010');
      expect(st010.leftChoice.setFlags, contains('contact_police'));
    });

    test('Empire deck key narrative flags and cross-campaign echoes are wired', () {
      final em002 = initialEmpireDeck.firstWhere((c) => c.id == 'EM_002');
      expect(em002.leftChoice.setFlags, contains('cash_injecte'));

      final em003 = initialEmpireDeck.firstWhere((c) => c.id == 'EM_003');
      expect(em003.leftChoice.setFlags, contains('creme_toxique_etouffee'));

      final em004 = initialEmpireDeck.firstWhere((c) => c.id == 'EM_004');
      expect(em004.leftChoice.setFlags, contains('roy_couvert'));

      final em006 = initialEmpireDeck.firstWhere((c) => c.id == 'EM_006');
      expect(em006.leftChoice.setFlags, contains('procureur_achete'));

      // Check narrative echo in EM_007 with Kimmie & Velvet Lounge
      final em007 = initialEmpireDeck.firstWhere((c) => c.id == 'EM_007');
      expect(em007.dialogue, contains('Kimmie'));
      expect(em007.dialogue, contains('Velvet Lounge'));
    });
  });
}
