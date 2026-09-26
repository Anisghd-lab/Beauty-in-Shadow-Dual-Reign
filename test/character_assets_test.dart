import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:beauty_in_shadow/data/character_registry.dart';
import 'package:beauty_in_shadow/data/street_deck.dart';
import 'package:beauty_in_shadow/data/empire_deck.dart';
import 'package:beauty_in_shadow/models/card_model.dart';

void main() {
  group('CharacterAssetRegistry & Interlocutors Audit Tests', () {
    test('Registry contains exactly 60 unique canonical characters', () {
      expect(CharacterAssetRegistry.allCharacters.length, 60);

      final streetCharacters = CharacterAssetRegistry.allCharacters
          .where((c) => c.isStreet)
          .toList();
      final empireCharacters = CharacterAssetRegistry.allCharacters
          .where((c) => c.isEmpire)
          .toList();

      expect(streetCharacters.length, 28);
      expect(empireCharacters.length, 32);
    });

    test('All 60 character asset image files exist on disk with valid size', () {
      final defaultFile = File(CharacterAssetRegistry.defaultAssetPath);
      expect(defaultFile.existsSync(), isTrue,
          reason: 'Default fallback image must exist');
      expect(defaultFile.lengthSync(), greaterThan(1024),
          reason: 'Default fallback image must not be empty');

      for (final char in CharacterAssetRegistry.allCharacters) {
        final file = File(char.imagePath);
        expect(file.existsSync(), isTrue,
            reason: 'Image file for ${char.id} (${char.name}) must exist at ${char.imagePath}');
        expect(file.lengthSync(), greaterThan(1024),
            reason: 'Image file for ${char.id} must be > 1KB');
      }
    });

    test('All 50 Street cards have valid interlocutorId and match registry', () {
      expect(initialStreetDeck.length, 50);

      for (final card in initialStreetDeck) {
        expect(card.interlocutorId, isNotNull,
            reason: 'Card ${card.id} must have an interlocutorId');
        
        final asset = CharacterAssetRegistry.getById(card.interlocutorId);
        expect(asset, isNotNull,
            reason: 'Interlocutor ${card.interlocutorId} on ${card.id} must be in registry');

        expect(card.speakerAvatar, asset!.imagePath,
            reason: 'Card ${card.id} speakerAvatar must match registry imagePath');

        final resolvedPath = CharacterAssetRegistry.getImagePathForCard(card);
        expect(resolvedPath, asset.imagePath);
      }
    });

    test('All 50 Empire cards have valid interlocutorId and match registry', () {
      expect(initialEmpireDeck.length, 50);

      for (final card in initialEmpireDeck) {
        expect(card.interlocutorId, isNotNull,
            reason: 'Card ${card.id} must have an interlocutorId');

        final asset = CharacterAssetRegistry.getById(card.interlocutorId);
        expect(asset, isNotNull,
            reason: 'Interlocutor ${card.interlocutorId} on ${card.id} must be in registry');

        expect(card.speakerAvatar, asset!.imagePath,
            reason: 'Card ${card.id} speakerAvatar must match registry imagePath');

        final resolvedPath = CharacterAssetRegistry.getImagePathForCard(card);
        expect(resolvedPath, asset.imagePath);
      }
    });

    test('Recurring characters share identical image assets across cards and factions', () {
      // 1. Rain (ST_004 in Street and Empire)
      final rainSt4 = initialStreetDeck.firstWhere((c) => c.id == 'ST_004');
      final rainSt16 = initialStreetDeck.firstWhere((c) => c.id == 'ST_016');
      final rainSt26 = initialStreetDeck.firstWhere((c) => c.id == 'ST_026');
      final rainEm12 = initialEmpireDeck.firstWhere((c) => c.id == 'EM_012');
      expect(rainSt4.interlocutorId, 'ST_004');
      expect(rainSt16.interlocutorId, 'ST_004');
      expect(rainSt26.interlocutorId, 'ST_004');
      expect(rainEm12.interlocutorId, 'ST_004');
      expect(rainSt4.speakerAvatar, rainEm12.speakerAvatar);

      // 2. Horace Bell (EM_002 in Empire and Street ST_039)
      final horaceEm2 = initialEmpireDeck.firstWhere((c) => c.id == 'EM_002');
      final horaceSt39 = initialStreetDeck.firstWhere((c) => c.id == 'ST_039');
      expect(horaceEm2.interlocutorId, 'EM_002');
      expect(horaceSt39.interlocutorId, 'EM_002');
      expect(horaceEm2.speakerAvatar, horaceSt39.speakerAvatar);

      // 3. Roy Bell (EM_004 in Empire and Street ST_012, ST_031)
      final royEm4 = initialEmpireDeck.firstWhere((c) => c.id == 'EM_004');
      final roySt12 = initialStreetDeck.firstWhere((c) => c.id == 'ST_012');
      final roySt31 = initialStreetDeck.firstWhere((c) => c.id == 'ST_031');
      expect(royEm4.interlocutorId, 'EM_004');
      expect(roySt12.interlocutorId, 'EM_004');
      expect(roySt31.interlocutorId, 'EM_004');
      expect(royEm4.speakerAvatar, roySt12.speakerAvatar);

      // 4. Jules Bell (EM_008 in Empire and Street ST_011, ST_036)
      final julesEm8 = initialEmpireDeck.firstWhere((c) => c.id == 'EM_008');
      final julesSt11 = initialStreetDeck.firstWhere((c) => c.id == 'ST_011');
      final julesSt36 = initialStreetDeck.firstWhere((c) => c.id == 'ST_036');
      expect(julesEm8.interlocutorId, 'EM_008');
      expect(julesSt11.interlocutorId, 'EM_008');
      expect(julesSt36.interlocutorId, 'EM_008');
      expect(julesEm8.speakerAvatar, julesSt11.speakerAvatar);

      // 5. Détective Davis (ST_010 in Street and Empire EM_026)
      final davisSt10 = initialStreetDeck.firstWhere((c) => c.id == 'ST_010');
      final davisEm26 = initialEmpireDeck.firstWhere((c) => c.id == 'EM_026');
      expect(davisSt10.interlocutorId, 'ST_010');
      expect(davisEm26.interlocutorId, 'ST_010');
      expect(davisSt10.speakerAvatar, davisEm26.speakerAvatar);

      // 6. Don Salazar (EM_021 in Empire and Street ST_029)
      final salazarEm21 = initialEmpireDeck.firstWhere((c) => c.id == 'EM_021');
      final salazarSt29 = initialStreetDeck.firstWhere((c) => c.id == 'ST_029');
      expect(salazarEm21.interlocutorId, 'EM_021');
      expect(salazarSt29.interlocutorId, 'EM_021');
      expect(salazarEm21.speakerAvatar, salazarSt29.speakerAvatar);

      // 7. Gérant du Club (ST_003 in Street and Empire EM_007)
      final clubSt3 = initialStreetDeck.firstWhere((c) => c.id == 'ST_003');
      final clubEm7 = initialEmpireDeck.firstWhere((c) => c.id == 'EM_007');
      expect(clubSt3.interlocutorId, 'ST_003');
      expect(clubEm7.interlocutorId, 'ST_003');
      expect(clubSt3.speakerAvatar, clubEm7.speakerAvatar);

      // 8. Kimmie (ST_050 in Street and Empire EM_032)
      final kimmieSt50 = initialStreetDeck.firstWhere((c) => c.id == 'ST_050');
      final kimmieEm32 = initialEmpireDeck.firstWhere((c) => c.id == 'EM_032');
      expect(kimmieSt50.interlocutorId, 'ST_050');
      expect(kimmieEm32.interlocutorId, 'ST_050');
      expect(kimmieSt50.speakerAvatar, kimmieEm32.speakerAvatar);

      // 9. Mallory Bell (EM_050 in Empire and Street ST_043)
      final malloryEm50 = initialEmpireDeck.firstWhere((c) => c.id == 'EM_050');
      final mallorySt43 = initialStreetDeck.firstWhere((c) => c.id == 'ST_043');
      expect(malloryEm50.interlocutorId, 'EM_050');
      expect(mallorySt43.interlocutorId, 'EM_050');
      expect(malloryEm50.speakerAvatar, mallorySt43.speakerAvatar);
    });

    test('Fallback mechanism gracefully resolves unknown card or speaker', () {
      const fallbackCard = GameCard(
        id: 'UNKNOWN_CARD',
        campaign: 'STREET',
        speakerName: 'Inconnu Mystérieux',
        speakerRole: 'Ombre',
        speakerAvatar: '',
        dialogue: '...',
        leftChoice: ChoiceImpact(text: 'Gauche'),
        rightChoice: ChoiceImpact(text: 'Droite'),
      );

      final fallbackPath = CharacterAssetRegistry.getImagePathForCard(fallbackCard);
      expect(fallbackPath, CharacterAssetRegistry.defaultAssetPath);
    });
  });
}
