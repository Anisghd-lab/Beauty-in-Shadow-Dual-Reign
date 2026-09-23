import 'package:flutter_test/flutter_test.dart';
import 'package:beauty_in_shadow/data/street_deck.dart';
import 'package:beauty_in_shadow/data/empire_deck.dart';
import 'package:beauty_in_shadow/models/card_model.dart';

void main() {
  group('Narrative Decks Validation', () {
    test('Deck counts match exactly 50 cards per campaign (100 total)', () {
      expect(initialStreetDeck.length, 50);
      expect(initialEmpireDeck.length, 50);
    });

    test('All 100 cards across both decks have unique IDs', () {
      final allCards = <GameCard>[...initialStreetDeck, ...initialEmpireDeck];
      final ids = allCards.map((c) => c.id).toList();
      final uniqueIds = ids.toSet();

      expect(ids.length, 100);
      expect(uniqueIds.length, 100);
    });

    test('All cards have valid metadata and matching campaign tags', () {
      for (final card in initialStreetDeck) {
        expect(card.campaign, 'STREET', reason: '${card.id} campaign mismatch');
        expect(card.isStreet, isTrue, reason: '${card.id} should be street');
        expect(card.isEmpire, isFalse, reason: '${card.id} should not be empire');
        expect(card.speakerName.trim(), isNotEmpty,
            reason: '${card.id} has empty speakerName');
        expect(card.speakerRole.trim(), isNotEmpty,
            reason: '${card.id} has empty speakerRole');
        expect(card.speakerAvatar.trim(), isNotEmpty,
            reason: '${card.id} has empty speakerAvatar');
        expect(card.dialogue.trim(), isNotEmpty,
            reason: '${card.id} has empty dialogue');
      }

      for (final card in initialEmpireDeck) {
        expect(card.campaign, 'EMPIRE', reason: '${card.id} campaign mismatch');
        expect(card.isEmpire, isTrue, reason: '${card.id} should be empire');
        expect(card.isStreet, isFalse, reason: '${card.id} should not be street');
        expect(card.speakerName.trim(), isNotEmpty,
            reason: '${card.id} has empty speakerName');
        expect(card.speakerRole.trim(), isNotEmpty,
            reason: '${card.id} has empty speakerRole');
        expect(card.speakerAvatar.trim(), isNotEmpty,
            reason: '${card.id} has empty speakerAvatar');
        expect(card.dialogue.trim(), isNotEmpty,
            reason: '${card.id} has empty dialogue');
      }
    });

    test('Every choice across all 100 cards has non-empty text and affects at least 2 gauges', () {
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

    test('Street deck key narrative flags are properly wired across 5 chapters', () {
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

      final st013 = initialStreetDeck.firstWhere((c) => c.id == 'ST_013');
      expect(st013.leftChoice.setFlags, contains('kimmie_a_la_cle'));

      final st031 = initialStreetDeck.firstWhere((c) => c.id == 'ST_031');
      expect(st031.leftChoice.setFlags, contains('roy_neutralise'));
      expect(st031.rightChoice.setFlags, contains('club_incendie'));

      final st047 = initialStreetDeck.firstWhere((c) => c.id == 'ST_047');
      expect(st047.leftChoice.setFlags, contains('horace_ecroue'));

      final st050 = initialStreetDeck.firstWhere((c) => c.id == 'ST_050');
      expect(st050.leftChoice.setFlags, contains('reine_de_la_nuit'));
      expect(st050.rightChoice.setFlags, contains('liberte_retrouvee'));
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

      final em011 = initialEmpireDeck.firstWhere((c) => c.id == 'EM_011');
      expect(em011.leftChoice.setFlags, contains('chasse_a_la_cle'));

      final em034 = initialEmpireDeck.firstWhere((c) => c.id == 'EM_034');
      expect(em034.leftChoice.setFlags, contains('horace_ecroue'));

      final em045 = initialEmpireDeck.firstWhere((c) => c.id == 'EM_045');
      expect(em045.leftChoice.setFlags, contains('velvet_rase'));

      final em050 = initialEmpireDeck.firstWhere((c) => c.id == 'EM_050');
      expect(em050.leftChoice.setFlags, contains('regne_absolu'));
      expect(em050.rightChoice.setFlags, contains('dynastie_eternelle'));
    });

    test('Shared cross-faction flags exist between campaigns', () {
      final streetFlags = <String>{};
      for (final card in initialStreetDeck) {
        streetFlags.addAll(card.leftChoice.setFlags);
        streetFlags.addAll(card.rightChoice.setFlags);
      }

      final empireFlags = <String>{};
      for (final card in initialEmpireDeck) {
        empireFlags.addAll(card.leftChoice.setFlags);
        empireFlags.addAll(card.rightChoice.setFlags);
      }

      // Both decks share key world-state milestone flags
      final sharedFlags = streetFlags.intersection(empireFlags);
      expect(sharedFlags, contains('horace_ecroue'));
      expect(streetFlags, contains('kimmie_a_la_cle'));
      expect(streetFlags, contains('club_incendie'));
      expect(empireFlags, contains('velvet_rase'));
    });
  });
}
