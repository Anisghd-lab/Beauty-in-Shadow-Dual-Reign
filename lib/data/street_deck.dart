import '../models/card_model.dart';

/// The calibrated initial narrative card deck for Kimmie in the Street Syndicate campaign.
///
/// Gauges:
/// - Gauge 1: Dignité (Fierté personelle, intégrité morale)
/// - Gauge 2: Cash (Argent liquide, économies clandestines)
/// - Gauge 3: Club (Statut et réputation au Velvet Lounge)
/// - Gauge 4: Discrétion (Invisibilité face à la police et aux cartels)
final List<GameCard> initialStreetDeck = [
  // ST_001: Mère de Kimmie (expulsion du foyer)
  const GameCard(
    id: 'ST_001',
    campaign: 'STREET',
    speakerName: 'Mère de Kimmie',
    speakerRole: 'Foyer familial',
    speakerAvatar: 'assets/images/characters/street/mother.png',
    dialogue:
        'Tu rapportes de l\'argent propre ce soir ou tu prends tes affaires et tu dégages de sous mon toit !',
    leftChoice: ChoiceImpact(
      text: 'Payer le loyer',
      deltaGauge1: 10,
      deltaGauge2: -25,
      deltaGauge4: 5,
    ),
    rightChoice: ChoiceImpact(
      text: 'Faire sa valise',
      deltaGauge1: -15,
      deltaGauge2: 15,
      deltaGauge4: -10,
      setFlags: ['expulsee_du_foyer'],
    ),
  ),

  // ST_002: Gérant du Motel (loyer en cash vs ménage)
  const GameCard(
    id: 'ST_002',
    campaign: 'STREET',
    speakerName: 'Gérant du Motel',
    speakerRole: 'Tenancier louche',
    speakerAvatar: 'assets/images/characters/street/motel_manager.png',
    dialogue:
        'La chambre 14 coûte 50\$ la nuit, petite. Si t\'as pas de liquide, tu peux torcher les chiottes jusqu\'à l\'aube.',
    leftChoice: ChoiceImpact(
      text: 'Payer en cash',
      deltaGauge1: 5,
      deltaGauge2: -20,
      deltaGauge4: 5,
    ),
    rightChoice: ChoiceImpact(
      text: 'Faire le ménage',
      deltaGauge1: -20,
      deltaGauge2: 5,
      deltaGauge3: -10,
    ),
  ),

  // ST_003: Gérant du Club (tenue transparente vs bar)
  const GameCard(
    id: 'ST_003',
    campaign: 'STREET',
    speakerName: 'Gérant du Club',
    speakerRole: 'Patron du Velvet Lounge',
    speakerAvatar: 'assets/images/characters/street/club_manager.png',
    dialogue:
        'Si tu veux bosser ici, Kimmie, c\'est sur la scène centrale avec la tenue résille. Sinon, c\'est la plonge au sous-sol.',
    leftChoice: ChoiceImpact(
      text: 'Enfiler la tenue',
      deltaGauge1: -15,
      deltaGauge2: 25,
      deltaGauge3: 20,
      setFlags: ['danseuse_active'],
    ),
    rightChoice: ChoiceImpact(
      text: 'Exiger le bar',
      deltaGauge1: 15,
      deltaGauge2: -10,
      deltaGauge3: -15,
    ),
  ),

  // ST_004: Rain (menace sur la table VIP)
  const GameCard(
    id: 'ST_004',
    campaign: 'STREET',
    speakerName: 'Rain',
    speakerRole: 'Danseuse star',
    speakerAvatar: 'assets/images/characters/street/rain.png',
    dialogue:
        'La table VIP 4 est à moi depuis six mois, gamine. Approche-toi encore et je te balaie les dents au tesson de bouteille.',
    leftChoice: ChoiceImpact(
      text: 'L\'affronter',
      deltaGauge1: 15,
      deltaGauge3: 10,
      deltaGauge4: -15,
      setFlags: ['rivalite_rain'],
    ),
    rightChoice: ChoiceImpact(
      text: 'Baisser les yeux',
      deltaGauge1: -20,
      deltaGauge3: -10,
      deltaGauge4: 10,
    ),
  ),

  // ST_005: Norman (enveloppe d'argent sale)
  const GameCard(
    id: 'ST_005',
    campaign: 'STREET',
    speakerName: 'Norman',
    speakerRole: 'Usurier & Recéleur',
    speakerAvatar: 'assets/images/characters/street/norman.png',
    dialogue:
        'Garde cette enveloppe dans ton casier jusqu\'à demain matin sans poser de questions. Il y a 3 000\$ pour ta part.',
    leftChoice: ChoiceImpact(
      text: 'Accepter le cash',
      deltaGauge2: 30,
      deltaGauge3: 10,
      deltaGauge4: -25,
      setFlags: ['enveloppe_acceptee'],
    ),
    rightChoice: ChoiceImpact(
      text: 'Refuser net',
      deltaGauge1: 15,
      deltaGauge2: -15,
      deltaGauge4: 15,
    ),
  ),

  // ST_006: Petite Sœur (urgence des frais scolaires)
  const GameCard(
    id: 'ST_006',
    campaign: 'STREET',
    speakerName: 'Petite Sœur',
    speakerRole: 'Famille',
    speakerAvatar: 'assets/images/characters/street/sister.png',
    dialogue:
        'Kimmie... ils vont m\'exclure du lycée privé si l\'inscription de 500\$ n\'est pas réglée avant vendredi...',
    leftChoice: ChoiceImpact(
      text: 'Régler les frais',
      deltaGauge1: 20,
      deltaGauge2: -30,
      deltaGauge4: 5,
    ),
    rightChoice: ChoiceImpact(
      text: 'Reporter l\'aide',
      deltaGauge1: -25,
      deltaGauge2: 15,
      deltaGauge3: -5,
    ),
  ),

  // ST_007: Client éméché (offre vénale au bar)
  const GameCard(
    id: 'ST_007',
    campaign: 'STREET',
    speakerName: 'Client éméché',
    speakerRole: 'Riche habitué',
    speakerAvatar: 'assets/images/characters/street/drunk_client.png',
    dialogue:
        'Allez princesse, un petit tour dans ma suite à l\'hôtel Bellevue et je double ta mise de la soirée en billets bleus.',
    leftChoice: ChoiceImpact(
      text: 'Garder ses distances',
      deltaGauge1: 20,
      deltaGauge2: -15,
      deltaGauge3: -10,
    ),
    rightChoice: ChoiceImpact(
      text: 'L\'amadouer au bar',
      deltaGauge1: -10,
      deltaGauge2: 25,
      deltaGauge3: 15,
    ),
  ),

  // ST_008: Contrôle de police dans la ruelle (papiers vs pot-de-vin)
  const GameCard(
    id: 'ST_008',
    campaign: 'STREET',
    speakerName: 'Contrôle de police',
    speakerRole: 'Patrouille de nuit',
    speakerAvatar: 'assets/images/characters/street/patrol_police.png',
    dialogue:
        'Mains sur le mur, beauté. Qu\'est-ce qu\'une fille comme toi traîne seule dans cette ruelle à trois heures du matin ?',
    leftChoice: ChoiceImpact(
      text: 'Montrer ses papiers',
      deltaGauge1: -10,
      deltaGauge2: 5,
      deltaGauge4: -15,
    ),
    rightChoice: ChoiceImpact(
      text: 'Glisser un billet',
      deltaGauge1: -15,
      deltaGauge2: -25,
      deltaGauge4: 20,
    ),
  ),

  // ST_009: Gillian (sabotage des chaussures par Rain)
  const GameCard(
    id: 'ST_009',
    campaign: 'STREET',
    speakerName: 'Gillian',
    speakerRole: 'Danseuse alliée',
    speakerAvatar: 'assets/images/characters/street/gillian.png',
    dialogue:
        'Kimmie regarde ! Rain a scié les talons de tes escarpins avant ton passage sur scène... On doit faire un scandale !',
    leftChoice: ChoiceImpact(
      text: 'Saboter sa loge',
      deltaGauge1: 10,
      deltaGauge3: -15,
      deltaGauge4: -10,
      setFlags: ['scandale_loge'],
    ),
    rightChoice: ChoiceImpact(
      text: 'Monter pieds nus',
      deltaGauge1: 20,
      deltaGauge2: 10,
      deltaGauge3: 20,
    ),
  ),

  // ST_010: Détective Davis (recrutement comme indic)
  const GameCard(
    id: 'ST_010',
    campaign: 'STREET',
    speakerName: 'Détective Davis',
    speakerRole: 'Brigade financière',
    speakerAvatar: 'assets/images/characters/street/detective_davis.png',
    dialogue:
        'Je sais que le Velvet Lounge blanchit l\'argent des Bell Cosmetics. Donne-moi les registres et ta famille sera intouchable.',
    leftChoice: ChoiceImpact(
      text: 'Accepter l\'accord',
      deltaGauge1: -10,
      deltaGauge3: -25,
      deltaGauge4: 25,
      setFlags: ['contact_police'],
    ),
    rightChoice: ChoiceImpact(
      text: 'Se taire et partir',
      deltaGauge1: 15,
      deltaGauge3: 15,
      deltaGauge4: -20,
    ),
  ),
];
