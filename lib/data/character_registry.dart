import 'package:flutter/foundation.dart';
import '../models/card_model.dart';

/// Represents a canonical interlocutor and their unique visual asset profile.
@immutable
class CharacterAsset {
  /// Canonical character identifier (e.g. "ST_004", "EM_002").
  final String id;

  /// Full canonical character name.
  final String name;

  /// Origin campaign faction: "STREET" or "EMPIRE".
  final String faction;

  /// Representative or primary social role.
  final String defaultRole;

  /// High-resolution image asset path in `assets/images/characters/`.
  final String imagePath;

  /// All card IDs across both decks where this interlocutor appears.
  final List<String> cardIds;

  const CharacterAsset({
    required this.id,
    required this.name,
    required this.faction,
    required this.defaultRole,
    required this.imagePath,
    required this.cardIds,
  });

  bool get isStreet => faction.toUpperCase() == 'STREET';
  bool get isEmpire => faction.toUpperCase() == 'EMPIRE';

  @override
  String toString() => 'CharacterAsset(id: $id, name: "$name", path: $imagePath)';
}

/// Central registry managing the 60 canonical interlocutors and their visual assets.
///
/// Rule of 60:
/// - 28 Street-native characters (ST_001 to ST_050).
/// - 32 Empire-native characters (EM_001 to EM_050).
/// - 9 cross-deck recurring characters sharing the exact same canonical asset.
class CharacterAssetRegistry {
  /// Universal fallback image asset path.
  static const String defaultAssetPath =
      'assets/images/characters/default_character.png';

  /// Primary registry containing all 60 unique interlocutors.
  static const Map<String, CharacterAsset> characters = {
    // =========================================================================
    // STREET FACTION INTERLOCUTORS (28 unique characters)
    // =========================================================================
    'ST_001': CharacterAsset(
      id: 'ST_001',
      name: 'Mère de Kimmie',
      faction: 'STREET',
      defaultRole: 'Foyer familial',
      imagePath: 'assets/images/characters/street/ST_001_Mere_Kimmie.png',
      cardIds: ['ST_001'],
    ),
    'ST_002': CharacterAsset(
      id: 'ST_002',
      name: 'Gérant du Motel',
      faction: 'STREET',
      defaultRole: 'Tenancier louche',
      imagePath: 'assets/images/characters/street/ST_002_Gerant_Motel.png',
      cardIds: ['ST_002'],
    ),
    'ST_003': CharacterAsset(
      id: 'ST_003',
      name: 'Gérant du Club',
      faction: 'STREET',
      defaultRole: 'Patron du Velvet Lounge',
      imagePath: 'assets/images/characters/street/ST_003_Gerant_Club.png',
      cardIds: ['ST_003', 'ST_014', 'ST_034', 'EM_007'],
    ),
    'ST_004': CharacterAsset(
      id: 'ST_004',
      name: 'Rain',
      faction: 'STREET',
      defaultRole: 'Danseuse Étoile & Informateur Clandestin',
      imagePath: 'assets/images/characters/street/ST_004_Rain.png',
      cardIds: ['ST_004', 'ST_016', 'ST_026', 'EM_012'],
    ),
    'ST_005': CharacterAsset(
      id: 'ST_005',
      name: 'Norman',
      faction: 'STREET',
      defaultRole: 'Videur en Chef & Sécurité',
      imagePath: 'assets/images/characters/street/ST_005_Norman.png',
      cardIds: ['ST_005', 'ST_018', 'ST_025', 'ST_037', 'ST_045'],
    ),
    'ST_006': CharacterAsset(
      id: 'ST_006',
      name: 'Petite Sœur',
      faction: 'STREET',
      defaultRole: 'Famille / Appel Téléphonique',
      imagePath: 'assets/images/characters/street/ST_006_Petite_Soeur.png',
      cardIds: ['ST_006', 'ST_019', 'ST_049'],
    ),
    'ST_007': CharacterAsset(
      id: 'ST_007',
      name: 'Client Éméché',
      faction: 'STREET',
      defaultRole: 'Clientèle Nocturne',
      imagePath: 'assets/images/characters/street/ST_007_Client_Emeche.png',
      cardIds: ['ST_007'],
    ),
    'ST_008': CharacterAsset(
      id: 'ST_008',
      name: 'Contrôle de Police',
      faction: 'STREET',
      defaultRole: 'Patrouille de Nuit',
      imagePath: 'assets/images/characters/street/ST_008_Controle_Police.png',
      cardIds: ['ST_008'],
    ),
    'ST_009': CharacterAsset(
      id: 'ST_009',
      name: 'Gillian',
      faction: 'STREET',
      defaultRole: 'Danseuse Rivale',
      imagePath: 'assets/images/characters/street/ST_009_Gillian.png',
      cardIds: ['ST_009'],
    ),
    'ST_010': CharacterAsset(
      id: 'ST_010',
      name: 'Détective Davis',
      faction: 'STREET',
      defaultRole: 'Police Judiciaire / Brigade Criminelle',
      imagePath: 'assets/images/characters/street/ST_010_Detective_Davis.png',
      cardIds: ['ST_010', 'ST_017', 'ST_022', 'ST_038', 'EM_026'],
    ),
    'ST_013': CharacterAsset(
      id: 'ST_013',
      name: 'Banquette VIP',
      faction: 'STREET',
      defaultRole: 'Lieu / Objet de Narration',
      imagePath: 'assets/images/characters/street/ST_013_Banquette_VIP.png',
      cardIds: ['ST_013'],
    ),
    'ST_015': CharacterAsset(
      id: 'ST_015',
      name: 'Cipher',
      faction: 'STREET',
      defaultRole: 'Hacker Clandestin',
      imagePath: 'assets/images/characters/street/ST_015_Cipher.png',
      cardIds: ['ST_015', 'ST_023'],
    ),
    'ST_020': CharacterAsset(
      id: 'ST_020',
      name: 'Sbires Bell',
      faction: 'STREET',
      defaultRole: 'Hommes de main en filature',
      imagePath: 'assets/images/characters/street/ST_020_Sbires_Bell.png',
      cardIds: ['ST_020'],
    ),
    'ST_021': CharacterAsset(
      id: 'ST_021',
      name: 'Réceptionniste de Luxe',
      faction: 'STREET',
      defaultRole: 'Palace Bell Tower',
      imagePath: 'assets/images/characters/street/ST_021_Receptionniste.png',
      cardIds: ['ST_021'],
    ),
    'ST_024': CharacterAsset(
      id: 'ST_024',
      name: 'Agent Corrompu',
      faction: 'STREET',
      defaultRole: 'Flic à la solde des Bell',
      imagePath: 'assets/images/characters/street/ST_024_Agent_Corrompu.png',
      cardIds: ['ST_024'],
    ),
    'ST_027': CharacterAsset(
      id: 'ST_027',
      name: 'Vidéosurveillance',
      faction: 'STREET',
      defaultRole: 'Système d\'alerte',
      imagePath: 'assets/images/characters/street/ST_027_Videosurveillance.png',
      cardIds: ['ST_027'],
    ),
    'ST_028': CharacterAsset(
      id: 'ST_028',
      name: 'Marco',
      faction: 'STREET',
      defaultRole: 'Faussaire & Papiers Clandestins',
      imagePath: 'assets/images/characters/street/ST_028_Marco.png',
      cardIds: ['ST_028'],
    ),
    'ST_030': CharacterAsset(
      id: 'ST_030',
      name: 'Panne de Secteur',
      faction: 'STREET',
      defaultRole: 'Sabotage Urbain',
      imagePath: 'assets/images/characters/street/ST_030_Panne_Secteur.png',
      cardIds: ['ST_030'],
    ),
    'ST_032': CharacterAsset(
      id: 'ST_032',
      name: 'L\'Incendie du Velvet',
      faction: 'STREET',
      defaultRole: 'Sinistre Criminel',
      imagePath: 'assets/images/characters/street/ST_032_Incendie_Velvet.png',
      cardIds: ['ST_032'],
    ),
    'ST_033': CharacterAsset(
      id: 'ST_033',
      name: 'Sbire Armé',
      faction: 'STREET',
      defaultRole: 'Tueur à gages de Roy Bell',
      imagePath: 'assets/images/characters/street/ST_033_Sbire_Arme.png',
      cardIds: ['ST_033'],
    ),
    'ST_035': CharacterAsset(
      id: 'ST_035',
      name: 'SWAT & Pompiers',
      faction: 'STREET',
      defaultRole: 'Forces d\'intervention',
      imagePath: 'assets/images/characters/street/ST_035_SWAT_Pompiers.png',
      cardIds: ['ST_035'],
    ),
    'ST_040': CharacterAsset(
      id: 'ST_040',
      name: 'Chambre Forte Bell',
      faction: 'STREET',
      defaultRole: 'Coffre Secret / Dossiers Confidentiels',
      imagePath: 'assets/images/characters/street/ST_040_Chambre_Forte.png',
      cardIds: ['ST_040'],
    ),
    'ST_041': CharacterAsset(
      id: 'ST_041',
      name: 'Président du Jury',
      faction: 'STREET',
      defaultRole: 'Cour Fédérale',
      imagePath: 'assets/images/characters/street/ST_041_President_Jury.png',
      cardIds: ['ST_041'],
    ),
    'ST_042': CharacterAsset(
      id: 'ST_042',
      name: 'Avocat des Bell',
      faction: 'STREET',
      defaultRole: 'Défense Agressive',
      imagePath: 'assets/images/characters/street/ST_042_Avocat_Bell.png',
      cardIds: ['ST_042'],
    ),
    'ST_044': CharacterAsset(
      id: 'ST_044',
      name: 'Procureur Fédéral',
      faction: 'STREET',
      defaultRole: 'Accusation Fédérale',
      imagePath: 'assets/images/characters/street/ST_044_Procureur_Federal.png',
      cardIds: ['ST_044', 'ST_048'],
    ),
    'ST_046': CharacterAsset(
      id: 'ST_046',
      name: 'Collectif des Danseuses',
      faction: 'STREET',
      defaultRole: 'Solidarité Ouvrière Nocturne',
      imagePath: 'assets/images/characters/street/ST_046_Collectif_Danseuses.png',
      cardIds: ['ST_046'],
    ),
    'ST_047': CharacterAsset(
      id: 'ST_047',
      name: 'Le Greffier',
      faction: 'STREET',
      defaultRole: 'Service de Greffe',
      imagePath: 'assets/images/characters/street/ST_047_Le_Greffier.png',
      cardIds: ['ST_047'],
    ),
    'ST_050': CharacterAsset(
      id: 'ST_050',
      name: 'Kimmie',
      faction: 'STREET',
      defaultRole: 'Protagoniste Street / Nouvelle Propriétaire',
      imagePath: 'assets/images/characters/street/ST_050_Kimmie.png',
      cardIds: ['ST_050', 'EM_032'],
    ),

    // =========================================================================
    // EMPIRE FACTION INTERLOCUTORS (32 unique characters)
    // =========================================================================
    'EM_001': CharacterAsset(
      id: 'EM_001',
      name: 'Directeur Financier',
      faction: 'EMPIRE',
      defaultRole: 'Comptabilité Bell Corp',
      imagePath: 'assets/images/characters/empire/EM_001_Directeur_Financier.png',
      cardIds: ['EM_001'],
    ),
    'EM_002': CharacterAsset(
      id: 'EM_002',
      name: 'Horace Bell',
      faction: 'EMPIRE',
      defaultRole: 'Patriarche Fondateur Bell Corporation',
      imagePath: 'assets/images/characters/empire/EM_002_Horace_Bell.png',
      cardIds: ['EM_002', 'EM_009', 'EM_018', 'EM_029', 'EM_035', 'EM_044', 'ST_039'],
    ),
    'EM_003': CharacterAsset(
      id: 'EM_003',
      name: 'Chimiste en Chef',
      faction: 'EMPIRE',
      defaultRole: 'R&D Cosmétiques & Blanchiment',
      imagePath: 'assets/images/characters/empire/EM_003_Chimiste_Chef.png',
      cardIds: ['EM_003'],
    ),
    'EM_004': CharacterAsset(
      id: 'EM_004',
      name: 'Roy Bell',
      faction: 'EMPIRE',
      defaultRole: 'Frère Aîné Violent / Héritier Radical',
      imagePath: 'assets/images/characters/empire/EM_004_Roy_Bell.png',
      cardIds: ['EM_004', 'EM_011', 'EM_023', 'ST_012', 'ST_031'],
    ),
    'EM_005': CharacterAsset(
      id: 'EM_005',
      name: 'Journaliste TV',
      faction: 'EMPIRE',
      defaultRole: 'Presse Nationale & Médias',
      imagePath: 'assets/images/characters/empire/EM_005_Journaliste_TV.png',
      cardIds: ['EM_005'],
    ),
    'EM_006': CharacterAsset(
      id: 'EM_006',
      name: 'Procureur Miller',
      faction: 'EMPIRE',
      defaultRole: 'Magistrat Instructeur Anti-Blanchiment',
      imagePath: 'assets/images/characters/empire/EM_006_Procureur_Miller.png',
      cardIds: ['EM_006', 'EM_033'],
    ),
    'EM_008': CharacterAsset(
      id: 'EM_008',
      name: 'Jules Bell',
      faction: 'EMPIRE',
      defaultRole: 'Frère Cadet Décadent / Joueur & Jet-Set',
      imagePath: 'assets/images/characters/empire/EM_008_Jules_Bell.png',
      cardIds: ['EM_008', 'EM_015', 'EM_025', 'EM_048', 'ST_011', 'ST_036'],
    ),
    'EM_010': CharacterAsset(
      id: 'EM_010',
      name: 'Raid Fiscal',
      faction: 'EMPIRE',
      defaultRole: 'Contrôle Fédéral Inopiné',
      imagePath: 'assets/images/characters/empire/EM_010_Raid_Fiscal.png',
      cardIds: ['EM_010'],
    ),
    'EM_013': CharacterAsset(
      id: 'EM_013',
      name: 'Directrice Marketing',
      faction: 'EMPIRE',
      defaultRole: 'Communication & Image Publique',
      imagePath: 'assets/images/characters/empire/EM_013_Directrice_Marketing.png',
      cardIds: ['EM_013'],
    ),
    'EM_014': CharacterAsset(
      id: 'EM_014',
      name: 'Commissaire du District',
      faction: 'EMPIRE',
      defaultRole: 'Commandement de Police Métropolitain',
      imagePath: 'assets/images/characters/empire/EM_014_Commissaire_District.png',
      cardIds: ['EM_014'],
    ),
    'EM_016': CharacterAsset(
      id: 'EM_016',
      name: 'Conseil d\'Administration',
      faction: 'EMPIRE',
      defaultRole: 'Actionnaires Majoritaires Bell Corp',
      imagePath: 'assets/images/characters/empire/EM_016_Conseil_Administration.png',
      cardIds: ['EM_016', 'EM_042'],
    ),
    'EM_017': CharacterAsset(
      id: 'EM_017',
      name: 'Banquier Suisse',
      faction: 'EMPIRE',
      defaultRole: 'Gestion de Fortune Offshore',
      imagePath: 'assets/images/characters/empire/EM_017_Banquier_Suisse.png',
      cardIds: ['EM_017'],
    ),
    'EM_019': CharacterAsset(
      id: 'EM_019',
      name: 'Journaliste du Times',
      faction: 'EMPIRE',
      defaultRole: 'Presse d\'Investigation Économique',
      imagePath: 'assets/images/characters/empire/EM_019_Journaliste_Times.png',
      cardIds: ['EM_019'],
    ),
    'EM_020': CharacterAsset(
      id: 'EM_020',
      name: 'Ligne d\'Urgence Bell',
      faction: 'EMPIRE',
      defaultRole: 'Canal Crypté Privé',
      imagePath: 'assets/images/characters/empire/EM_020_Ligne_Urgence.png',
      cardIds: ['EM_020'],
    ),
    'EM_021': CharacterAsset(
      id: 'EM_021',
      name: 'Don Salazar',
      faction: 'EMPIRE',
      defaultRole: 'Cartel Partenaire / Parrain de la Pègre',
      imagePath: 'assets/images/characters/empire/EM_021_Don_Salazar.png',
      cardIds: ['EM_021', 'EM_037', 'ST_029'],
    ),
    'EM_022': CharacterAsset(
      id: 'EM_022',
      name: 'Silas',
      faction: 'EMPIRE',
      defaultRole: 'Chef de la Sécurité Privée Bell',
      imagePath: 'assets/images/characters/empire/EM_022_Silas.png',
      cardIds: ['EM_022', 'EM_034'],
    ),
    'EM_024': CharacterAsset(
      id: 'EM_024',
      name: 'Juge Vandermeer',
      faction: 'EMPIRE',
      defaultRole: 'Magistrat Influent Cour d\'Appel',
      imagePath: 'assets/images/characters/empire/EM_024_Juge_Vandermeer.png',
      cardIds: ['EM_024'],
    ),
    'EM_027': CharacterAsset(
      id: 'EM_027',
      name: 'L\'Archiviste des Bell',
      faction: 'EMPIRE',
      defaultRole: 'Gardien des Secrets & Registres Noirs',
      imagePath: 'assets/images/characters/empire/EM_027_Archiviste.png',
      cardIds: ['EM_027'],
    ),
    'EM_028': CharacterAsset(
      id: 'EM_028',
      name: 'Analyste Financier',
      faction: 'EMPIRE',
      defaultRole: 'Cabinet d\'Audit Stratégique',
      imagePath: 'assets/images/characters/empire/EM_028_Analyste_Financier.png',
      cardIds: ['EM_028'],
    ),
    'EM_030': CharacterAsset(
      id: 'EM_030',
      name: 'Réseau SWIFT',
      faction: 'EMPIRE',
      defaultRole: 'Flux Bancaires Internationaux',
      imagePath: 'assets/images/characters/empire/EM_030_Reseau_SWIFT.png',
      cardIds: ['EM_030'],
    ),
    'EM_031': CharacterAsset(
      id: 'EM_031',
      name: 'Président du Tribunal',
      faction: 'EMPIRE',
      defaultRole: 'Cour Suprême d\'État',
      imagePath: 'assets/images/characters/empire/EM_031_President_Tribunal.png',
      cardIds: ['EM_031'],
    ),
    'EM_036': CharacterAsset(
      id: 'EM_036',
      name: 'Mandataire Judiciaire',
      faction: 'EMPIRE',
      defaultRole: 'Liquidation & Mise sous Tutelle',
      imagePath: 'assets/images/characters/empire/EM_036_Mandataire_Judiciaire.png',
      cardIds: ['EM_036'],
    ),
    'EM_038': CharacterAsset(
      id: 'EM_038',
      name: 'Maître Sterling',
      faction: 'EMPIRE',
      defaultRole: 'Avocat d\'Affaires Senior Bell Corp',
      imagePath: 'assets/images/characters/empire/EM_038_Maitre_Sterling.png',
      cardIds: ['EM_038'],
    ),
    'EM_039': CharacterAsset(
      id: 'EM_039',
      name: 'Attaché de Presse',
      faction: 'EMPIRE',
      defaultRole: 'Porte-Parole Officiel',
      imagePath: 'assets/images/characters/empire/EM_039_Attache_Presse.png',
      cardIds: ['EM_039'],
    ),
    'EM_040': CharacterAsset(
      id: 'EM_040',
      name: 'Salle d\'Attente Fédérale',
      faction: 'EMPIRE',
      defaultRole: 'Couloir Judiciaire / Tribunal',
      imagePath: 'assets/images/characters/empire/EM_040_Salle_Attente.png',
      cardIds: ['EM_040'],
    ),
    'EM_041': CharacterAsset(
      id: 'EM_041',
      name: 'Greffier Fédéral',
      faction: 'EMPIRE',
      defaultRole: 'Enregistrement des Jugements',
      imagePath: 'assets/images/characters/empire/EM_041_Greffier_Federal.png',
      cardIds: ['EM_041'],
    ),
    'EM_043': CharacterAsset(
      id: 'EM_043',
      name: 'Chef de Marque Luxe',
      faction: 'EMPIRE',
      defaultRole: 'Haute Couture & Partenaires Prestige',
      imagePath: 'assets/images/characters/empire/EM_043_Chef_Marque_Luxe.png',
      cardIds: ['EM_043'],
    ),
    'EM_045': CharacterAsset(
      id: 'EM_045',
      name: 'Commissaire-Priseur',
      faction: 'EMPIRE',
      defaultRole: 'Ventes aux Enchères Exclusives',
      imagePath: 'assets/images/characters/empire/EM_045_Commissaire_Priseur.png',
      cardIds: ['EM_045'],
    ),
    'EM_046': CharacterAsset(
      id: 'EM_046',
      name: 'Consortium d\'Asie',
      faction: 'EMPIRE',
      defaultRole: 'Investisseurs Singapour / Shanghai',
      imagePath: 'assets/images/characters/empire/EM_046_Consortium_Asie.png',
      cardIds: ['EM_046'],
    ),
    'EM_047': CharacterAsset(
      id: 'EM_047',
      name: 'Le Gouverneur',
      faction: 'EMPIRE',
      defaultRole: 'Exécutif Politique de l\'État',
      imagePath: 'assets/images/characters/empire/EM_047_Gouverneur.png',
      cardIds: ['EM_047'],
    ),
    'EM_049': CharacterAsset(
      id: 'EM_049',
      name: 'Président du Sommet',
      faction: 'EMPIRE',
      defaultRole: 'Forum Économique Mondial',
      imagePath: 'assets/images/characters/empire/EM_049_President_Sommet.png',
      cardIds: ['EM_049'],
    ),
    'EM_050': CharacterAsset(
      id: 'EM_050',
      name: 'Mallory Bell',
      faction: 'EMPIRE',
      defaultRole: 'Protagoniste Empire / Présidente Bell Corp',
      imagePath: 'assets/images/characters/empire/EM_050_Mallory_Bell.png',
      cardIds: ['EM_050', 'ST_043'],
    ),
  };

  /// Complete 100-card direct mapping to canonical character ID.
  static const Map<String, String> cardToCharacterId = {
    // Street Campaign (ST_001 to ST_050)
    'ST_001': 'ST_001',
    'ST_002': 'ST_002',
    'ST_003': 'ST_003',
    'ST_004': 'ST_004',
    'ST_005': 'ST_005',
    'ST_006': 'ST_006',
    'ST_007': 'ST_007',
    'ST_008': 'ST_008',
    'ST_009': 'ST_009',
    'ST_010': 'ST_010',
    'ST_011': 'EM_008', // Jules Bell
    'ST_012': 'EM_004', // Roy Bell
    'ST_013': 'ST_013',
    'ST_014': 'ST_003', // Gérant du Club
    'ST_015': 'ST_015',
    'ST_016': 'ST_004', // Rain
    'ST_017': 'ST_010', // Détective Davis
    'ST_018': 'ST_005', // Norman
    'ST_019': 'ST_006', // Petite Sœur
    'ST_020': 'ST_020',
    'ST_021': 'ST_021',
    'ST_022': 'ST_010', // Détective Davis
    'ST_023': 'ST_015', // Cipher
    'ST_024': 'ST_024',
    'ST_025': 'ST_005', // Norman
    'ST_026': 'ST_004', // Rain
    'ST_027': 'ST_027',
    'ST_028': 'ST_028',
    'ST_029': 'EM_021', // Don Salazar
    'ST_030': 'ST_030',
    'ST_031': 'EM_004', // Roy Bell
    'ST_032': 'ST_032',
    'ST_033': 'ST_033',
    'ST_034': 'ST_003', // Gérant du Club
    'ST_035': 'ST_035',
    'ST_036': 'EM_008', // Jules Bell
    'ST_037': 'ST_005', // Norman
    'ST_038': 'ST_010', // Détective Davis
    'ST_039': 'EM_002', // Horace Bell
    'ST_040': 'ST_040',
    'ST_041': 'ST_041',
    'ST_042': 'ST_042',
    'ST_043': 'EM_050', // Mallory Bell
    'ST_044': 'ST_044',
    'ST_045': 'ST_005', // Norman
    'ST_046': 'ST_046',
    'ST_047': 'ST_047',
    'ST_048': 'ST_044', // Procureur Fédéral
    'ST_049': 'ST_006', // Petite Sœur
    'ST_050': 'ST_050', // Kimmie

    // Empire Campaign (EM_001 to EM_050)
    'EM_001': 'EM_001',
    'EM_002': 'EM_002',
    'EM_003': 'EM_003',
    'EM_004': 'EM_004',
    'EM_005': 'EM_005',
    'EM_006': 'EM_006',
    'EM_007': 'ST_003', // Gérant du Club
    'EM_008': 'EM_008',
    'EM_009': 'EM_002', // Horace Bell
    'EM_010': 'EM_010',
    'EM_011': 'EM_004', // Roy Bell
    'EM_012': 'ST_004', // Rain
    'EM_013': 'EM_013',
    'EM_014': 'EM_014',
    'EM_015': 'EM_008', // Jules Bell
    'EM_016': 'EM_016',
    'EM_017': 'EM_017',
    'EM_018': 'EM_002', // Horace Bell
    'EM_019': 'EM_019',
    'EM_020': 'EM_020',
    'EM_021': 'EM_021',
    'EM_022': 'EM_022',
    'EM_023': 'EM_004', // Roy Bell
    'EM_024': 'EM_024',
    'EM_025': 'EM_008', // Jules Bell
    'EM_026': 'ST_010', // Détective Davis
    'EM_027': 'EM_027',
    'EM_028': 'EM_028',
    'EM_029': 'EM_002', // Horace Bell
    'EM_030': 'EM_030',
    'EM_031': 'EM_031',
    'EM_032': 'ST_050', // Kimmie
    'EM_033': 'EM_006', // Procureur Miller
    'EM_034': 'EM_022', // Silas
    'EM_035': 'EM_002', // Horace sous menottes
    'EM_036': 'EM_036',
    'EM_037': 'EM_021', // Don Salazar
    'EM_038': 'EM_038',
    'EM_039': 'EM_039',
    'EM_040': 'EM_040',
    'EM_041': 'EM_041',
    'EM_042': 'EM_016', // Conseil d'Administration
    'EM_043': 'EM_043',
    'EM_044': 'EM_002', // Horace Bell
    'EM_045': 'EM_045',
    'EM_046': 'EM_046',
    'EM_047': 'EM_047',
    'EM_048': 'EM_008', // Jules Bell
    'EM_049': 'EM_049',
    'EM_050': 'EM_050', // Mallory Bell
  };

  /// Fallback name-based mapping.
  static const Map<String, String> speakerNameToCharacterId = {
    'Mère de Kimmie': 'ST_001',
    'Gérant du Motel': 'ST_002',
    'Gérant du Club': 'ST_003',
    'Rain': 'ST_004',
    'Norman': 'ST_005',
    'Petite Sœur': 'ST_006',
    'Client Éméché': 'ST_007',
    'Contrôle de Police': 'ST_008',
    'Gillian': 'ST_009',
    'Détective Davis': 'ST_010',
    'Banquette VIP': 'ST_013',
    'Cipher': 'ST_015',
    'Sbires Bell': 'ST_020',
    'Réceptionniste de Luxe': 'ST_021',
    'Agent Corrompu': 'ST_024',
    'Vidéosurveillance': 'ST_027',
    'Marco': 'ST_028',
    'Panne de Secteur': 'ST_030',
    'L\'Incendie du Velvet': 'ST_032',
    'Sbire Armé': 'ST_033',
    'SWAT & Pompiers': 'ST_035',
    'Chambre Forte Bell': 'ST_040',
    'Président du Jury': 'ST_041',
    'Avocat des Bell': 'ST_042',
    'Procureur Fédéral': 'ST_044',
    'Collectif des Danseuses': 'ST_046',
    'Le Greffier': 'ST_047',
    'Kimmie': 'ST_050',
    'Directeur Financier': 'EM_001',
    'Horace Bell': 'EM_002',
    'Horace (sous menottes)': 'EM_002',
    'Chimiste en Chef': 'EM_003',
    'Roy Bell': 'EM_004',
    'Journaliste TV': 'EM_005',
    'Procureur Miller': 'EM_006',
    'Jules Bell': 'EM_008',
    'Raid Fiscal': 'EM_010',
    'Directrice Marketing': 'EM_013',
    'Commissaire du District': 'EM_014',
    'Conseil d\'Administration': 'EM_016',
    'Banquier Suisse': 'EM_017',
    'Journaliste du Times': 'EM_019',
    'Ligne d\'Urgence Bell': 'EM_020',
    'Don Salazar': 'EM_021',
    'Silas': 'EM_022',
    'Juge Vandermeer': 'EM_024',
    'L\'Archiviste des Bell': 'EM_027',
    'Analyste Financier': 'EM_028',
    'Réseau SWIFT': 'EM_030',
    'Président du Tribunal': 'EM_031',
    'Mandataire Judiciaire': 'EM_036',
    'Maître Sterling': 'EM_038',
    'Attaché de Presse': 'EM_039',
    'Salle d\'Attente Fédérale': 'EM_040',
    'Greffier Fédéral': 'EM_041',
    'Chef de Marque Luxe': 'EM_043',
    'Commissaire-Priseur': 'EM_045',
    'Consortium d\'Asie': 'EM_046',
    'Le Gouverneur': 'EM_047',
    'Président du Sommet': 'EM_049',
    'Mallory Bell': 'EM_050',
  };

  /// Lookup a canonical character asset by their canonical ID.
  static CharacterAsset? getById(String? id) {
    if (id == null) return null;
    return characters[id];
  }

  /// Lookup the canonical character asset associated with a given [cardId].
  static CharacterAsset? getByCardId(String cardId) {
    final charId = cardToCharacterId[cardId];
    if (charId != null) {
      return characters[charId];
    }
    return null;
  }

  /// Lookup a canonical character asset by speaker name.
  static CharacterAsset? getByName(String speakerName) {
    final charId = speakerNameToCharacterId[speakerName];
    if (charId != null) {
      return characters[charId];
    }
    return null;
  }

  /// Determines the definitive image asset path for any [GameCard].
  ///
  /// Resolution order:
  /// 1. Card's explicit [interlocutorId]
  /// 2. Card's [id] (ST_001 -> ST_050, EM_001 -> EM_050)
  /// 3. Card's [speakerName]
  /// 4. Card's [speakerAvatar] if non-empty
  /// 5. Universal fallback [defaultAssetPath]
  static String getImagePathForCard(GameCard card) {
    if (card.interlocutorId != null &&
        characters.containsKey(card.interlocutorId)) {
      return characters[card.interlocutorId]!.imagePath;
    }

    final byCard = getByCardId(card.id);
    if (byCard != null) {
      return byCard.imagePath;
    }

    final byName = getByName(card.speakerName);
    if (byName != null) {
      return byName.imagePath;
    }

    if (card.speakerAvatar.isNotEmpty) {
      return card.speakerAvatar;
    }

    return defaultAssetPath;
  }

  /// Returns all 60 registered canonical character assets.
  static List<CharacterAsset> get allCharacters => characters.values.toList();
}
