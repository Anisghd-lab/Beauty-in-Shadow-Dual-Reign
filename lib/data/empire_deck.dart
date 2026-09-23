import '../models/card_model.dart';

/// The calibrated initial narrative card deck for Mallory Bell in the Royal Empire campaign.
///
/// Gauges:
/// - Gauge 1: Prestige (Image publique de luxe, réputation aristocratique)
/// - Gauge 2: Blanchiment (Volume des flux financiers clandestins intégrés)
/// - Gauge 3: Impunité (Bouclier judiciaire, corruption de l'État et des médias)
/// - Gauge 4: Clan (Unité dynastique, respect du patriarche et des frères Bell)
final List<GameCard> initialEmpireDeck = [
  // EM_001: Directeur Financier (audit des capitaux sales de départ)
  const GameCard(
    id: 'EM_001',
    campaign: 'EMPIRE',
    speakerName: 'Directeur Financier',
    speakerRole: 'Cabinet d\'audit Bell',
    speakerAvatar: 'assets/images/characters/empire/cfo.png',
    dialogue:
        'Madame Bell, les fonds de départ proviennent de sociétés écrans des clubs de nuit. Les inspecteurs du fisc demandent les livres de comptes originaux.',
    leftChoice: ChoiceImpact(
      text: 'Créer des filiales',
      deltaGauge1: -10,
      deltaGauge2: 25,
      deltaGauge3: -15,
    ),
    rightChoice: ChoiceImpact(
      text: 'Payer l\'amende',
      deltaGauge1: 15,
      deltaGauge2: -25,
      deltaGauge3: 10,
    ),
  ),

  // EM_002: Horace Bell (injection de 2M en cash des clubs)
  const GameCard(
    id: 'EM_002',
    campaign: 'EMPIRE',
    speakerName: 'Horace Bell',
    speakerRole: 'Patriarche de la dynastie',
    speakerAvatar: 'assets/images/characters/empire/horace.png',
    dialogue:
        'Nos clubs de strip-tease ont dégagé deux millions de dollars non déclarés ce mois-ci. Injecte-les sans délai dans le budget cosmétique.',
    leftChoice: ChoiceImpact(
      text: 'Injecter le cash',
      deltaGauge2: 30,
      deltaGauge3: -20,
      deltaGauge4: 20,
      setFlags: ['cash_injecte'],
    ),
    rightChoice: ChoiceImpact(
      text: 'Refuser l\'argent',
      deltaGauge1: 15,
      deltaGauge2: -20,
      deltaGauge4: -25,
    ),
  ),

  // EM_003: Chimiste en Chef (crème toxique inflammable)
  const GameCard(
    id: 'EM_003',
    campaign: 'EMPIRE',
    speakerName: 'Chimiste en Chef',
    speakerRole: 'Laboratoire R&D Bell',
    speakerAvatar: 'assets/images/characters/empire/chemist.png',
    dialogue:
        'La nouvelle formule de notre crème miracle est instable et hautement inflammable au contact de l\'air. Trois laborantins ont été gravement brûlés ce matin !',
    leftChoice: ChoiceImpact(
      text: 'Étouffer l\'affaire',
      deltaGauge1: -15,
      deltaGauge3: -20,
      deltaGauge4: 15,
      setFlags: ['creme_toxique_etouffee'],
    ),
    rightChoice: ChoiceImpact(
      text: 'Rappeler les lots',
      deltaGauge1: 20,
      deltaGauge2: -25,
      deltaGauge4: -15,
    ),
  ),

  // EM_004: Roy Bell (passage à tabac d'un journaliste)
  const GameCard(
    id: 'EM_004',
    campaign: 'EMPIRE',
    speakerName: 'Roy Bell',
    speakerRole: 'Frère aîné & Bras armé',
    speakerAvatar: 'assets/images/characters/empire/roy.png',
    dialogue:
        'Un fouineur du Daily News prenait des photos de nos quais de livraison maritime. Je lui ai brisé les deux genoux dans un parking.',
    leftChoice: ChoiceImpact(
      text: 'Couvrir ses arrières',
      deltaGauge1: -20,
      deltaGauge3: -15,
      deltaGauge4: 25,
      setFlags: ['roy_couvert'],
    ),
    rightChoice: ChoiceImpact(
      text: 'Le livrer aux flics',
      deltaGauge1: 15,
      deltaGauge3: 15,
      deltaGauge4: -35,
    ),
  ),

  // EM_005: Interview TV en direct (arrogance vs victime)
  const GameCard(
    id: 'EM_005',
    campaign: 'EMPIRE',
    speakerName: 'Journaliste TV',
    speakerRole: 'Édition spéciale en direct',
    speakerAvatar: 'assets/images/characters/empire/tv_anchor.png',
    dialogue:
        'Madame Bell, des fuites anonymes affirment que Bell Cosmetics n\'est qu\'une gigantesque machine à blanchir pour la pègre locale. Que répondez-vous ?',
    leftChoice: ChoiceImpact(
      text: 'Arrogance glaciale',
      deltaGauge1: -20,
      deltaGauge3: 15,
      deltaGauge4: 15,
    ),
    rightChoice: ChoiceImpact(
      text: 'Jouer la victime',
      deltaGauge1: 25,
      deltaGauge3: -10,
      deltaGauge4: -10,
    ),
  ),

  // EM_006: Procureur Miller (pot-de-vin pour suspendre un mandat)
  const GameCard(
    id: 'EM_006',
    campaign: 'EMPIRE',
    speakerName: 'Procureur Miller',
    speakerRole: 'Palais de Justice',
    speakerAvatar: 'assets/images/characters/empire/prosecutor_miller.png',
    dialogue:
        'Un mandat fédéral vise vos entrepôts de transit portuaire. Ma campagne de réélection a un besoin urgent d\'un demi-million en dons discrets.',
    leftChoice: ChoiceImpact(
      text: 'Acheter le magistrat',
      deltaGauge2: -25,
      deltaGauge3: 30,
      deltaGauge4: 5,
      setFlags: ['procureur_achete'],
    ),
    rightChoice: ChoiceImpact(
      text: 'Chantage sur sa famille',
      deltaGauge1: -10,
      deltaGauge3: -25,
      deltaGauge4: 15,
    ),
  ),

  // EM_007: Le Gérant du Club (fronde menée par Kimmie)
  const GameCard(
    id: 'EM_007',
    campaign: 'EMPIRE',
    speakerName: 'Le Gérant du Club',
    speakerRole: 'Émissaire du Velvet Lounge',
    speakerAvatar: 'assets/images/characters/empire/club_delegate.png',
    dialogue:
        'Madame, une employée nommée Kimmie mène une fronde parmi les danseuses du Velvet Lounge. Les transferts d\'argent liquide vers vos comptes sont totalement bloqués !',
    leftChoice: ChoiceImpact(
      text: 'Envoyer les gros bras',
      deltaGauge1: -15,
      deltaGauge2: 20,
      deltaGauge4: 15,
    ),
    rightChoice: ChoiceImpact(
      text: 'Négocier en secret',
      deltaGauge1: 10,
      deltaGauge2: -15,
      deltaGauge4: -20,
    ),
  ),

  // EM_008: Jules Bell (tamponner un conteneur suspect)
  const GameCard(
    id: 'EM_008',
    campaign: 'EMPIRE',
    speakerName: 'Jules Bell',
    speakerRole: 'Frère cadet & Logistique',
    speakerAvatar: 'assets/images/characters/empire/jules.png',
    dialogue:
        'Un cargo chargé de précurseurs chimiques non déclarés est retenu par les douanes du port autonome. Signe l\'autorisation présidentielle prioritaire.',
    leftChoice: ChoiceImpact(
      text: 'Signer l\'ordre',
      deltaGauge2: 20,
      deltaGauge3: -20,
      deltaGauge4: 15,
    ),
    rightChoice: ChoiceImpact(
      text: 'Bloquer le cargo',
      deltaGauge1: 10,
      deltaGauge2: -20,
      deltaGauge4: -25,
    ),
  ),

  // EM_009: Horace Bell (exigence de céder des parts aux fils)
  const GameCard(
    id: 'EM_009',
    campaign: 'EMPIRE',
    speakerName: 'Horace Bell',
    speakerRole: 'Patriarche de la dynastie',
    speakerAvatar: 'assets/images/characters/empire/horace.png',
    dialogue:
        'Tu as bien travaillé, Mallory. Mais Bell Cosmetics doit demeurer sous le contrôle de la descendance mâle. Cède 40% de tes actions à tes deux frères.',
    leftChoice: ChoiceImpact(
      text: 'Céder les parts',
      deltaGauge1: -20,
      deltaGauge2: -15,
      deltaGauge4: 35,
    ),
    rightChoice: ChoiceImpact(
      text: 'Verrouiller les statuts',
      deltaGauge1: 20,
      deltaGauge3: 10,
      deltaGauge4: -35,
    ),
  ),

  // EM_010: Raid fiscal fédéral (effacement magnétique vs accueil légal)
  const GameCard(
    id: 'EM_010',
    campaign: 'EMPIRE',
    speakerName: 'Raid fiscal fédéral',
    speakerRole: 'Agents IRS & Fédéraux',
    speakerAvatar: 'assets/images/characters/empire/federal_raid.png',
    dialogue:
        'Agents fédéraux ! Tous les serveurs informatiques et disques durs de Bell Cosmetics sont saisis sous mandat judiciaire immédiat.',
    leftChoice: ChoiceImpact(
      text: 'Effacement magnétique',
      deltaGauge1: -25,
      deltaGauge2: 20,
      deltaGauge3: -25,
    ),
    rightChoice: ChoiceImpact(
      text: 'Assaut d\'avocats',
      deltaGauge1: 15,
      deltaGauge2: -30,
      deltaGauge3: 20,
    ),
  ),
];
