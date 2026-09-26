import '../models/card_model.dart';

/// The calibrated complete narrative card deck for Kimmie in the Street Syndicate campaign (ST_001 to ST_050).
///
/// Gauges:
/// - Gauge 1: Dignité (Fierté personelle, intégrité morale)
/// - Gauge 2: Cash (Argent liquide, économies clandestines)
/// - Gauge 3: Club (Statut et réputation au Velvet Lounge)
/// - Gauge 4: Discrétion (Invisibilité face à la police et aux cartels)
///
/// Narrative Arcs across 5 Chapters:
/// - Ch. 1 (ST_001-ST_010): L'Expulsion & Les Vestiaires du Velvet Lounge.
/// - Ch. 2 (ST_011-ST_020): La Nuit VIP & Le Dérapage des Frères Bell.
/// - Ch. 3 (ST_021-ST_030): La Traque Fédérale & L'Infiltration.
/// - Ch. 4 (ST_031-ST_040): L'Affrontement Armé & L'Incendie.
/// - Ch. 5 (ST_041-ST_050): Le Grand Jury & La Rédemption.
final List<GameCard> initialStreetDeck = [
  // =========================================================================
  // CHAPTER 1: L'Expulsion & Les Vestiaires du Velvet Lounge (ST_001 - ST_010)
  // =========================================================================

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
      deltaGauge2: -15,
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
      deltaGauge2: -10,
      deltaGauge4: 5,
    ),
    rightChoice: ChoiceImpact(
      text: 'Faire le ménage',
      deltaGauge1: -10,
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
      deltaGauge2: 15,
      deltaGauge3: 10,
      setFlags: ['danseuse_active'],
    ),
    rightChoice: ChoiceImpact(
      text: 'Exiger le bar',
      deltaGauge1: 10,
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
      deltaGauge1: 10,
      deltaGauge3: 10,
      deltaGauge4: -15,
      setFlags: ['rivalite_rain'],
    ),
    rightChoice: ChoiceImpact(
      text: 'Baisser les yeux',
      deltaGauge1: -10,
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
      deltaGauge2: 15,
      deltaGauge3: 10,
      deltaGauge4: -15,
      setFlags: ['enveloppe_acceptee'],
    ),
    rightChoice: ChoiceImpact(
      text: 'Refuser net',
      deltaGauge1: 10,
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
      deltaGauge1: 10,
      deltaGauge2: -15,
      deltaGauge4: 5,
    ),
    rightChoice: ChoiceImpact(
      text: 'Reporter l\'aide',
      deltaGauge1: -15,
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
      deltaGauge1: 10,
      deltaGauge2: -15,
      deltaGauge3: -10,
    ),
    rightChoice: ChoiceImpact(
      text: 'L\'amadouer au bar',
      deltaGauge1: -10,
      deltaGauge2: 15,
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
      deltaGauge2: -15,
      deltaGauge4: 10,
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
      deltaGauge1: 10,
      deltaGauge2: 10,
      deltaGauge3: 10,
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
      deltaGauge3: -15,
      deltaGauge4: 15,
      setFlags: ['contact_police'],
    ),
    rightChoice: ChoiceImpact(
      text: 'Se taire et partir',
      deltaGauge1: 10,
      deltaGauge3: 15,
      deltaGauge4: -10,
    ),
  ),

  // =========================================================================
  // CHAPTER 2: La Nuit VIP & Le Dérapage des Frères Bell (ST_011 - ST_020)
  // =========================================================================

  // ST_011: Jules Bell (Salon VIP Opale)
  const GameCard(
    id: 'ST_011',
    campaign: 'STREET',
    speakerName: 'Jules Bell',
    speakerRole: 'Héritier Bell Logistics',
    speakerAvatar: 'assets/images/characters/street/jules_vip.png',
    dialogue:
        'Apporte une bouteille de Dom Pérignon et ferme le rideau, beauté. On a des chiffres confidentiels à fêter.',
    leftChoice: ChoiceImpact(
      text: 'Servir avec grâce',
      deltaGauge1: -10,
      deltaGauge2: 15,
      deltaGauge3: 15,
      deltaGauge4: -10,
    ),
    rightChoice: ChoiceImpact(
      text: 'Refuser le salon',
      deltaGauge1: 10,
      deltaGauge2: -15,
      deltaGauge3: -10,
      deltaGauge4: 10,
    ),
  ),

  // ST_012: Roy Bell (Accès de fureur et cocaïne)
  const GameCard(
    id: 'ST_012',
    campaign: 'STREET',
    speakerName: 'Roy Bell',
    speakerRole: 'Le cogneur des Bell',
    speakerAvatar: 'assets/images/characters/street/roy_rage.png',
    dialogue:
        'Où est ma sacoche en cuir ?! Si une de ces traînées y a touché, je réduis ce club en cendres dans l\'heure !',
    leftChoice: ChoiceImpact(
      text: 'Désamorcer la crise',
      deltaGauge1: -15,
      deltaGauge2: 10,
      deltaGauge3: 10,
      deltaGauge4: -15,
      setFlags: ['roy_calme'],
    ),
    rightChoice: ChoiceImpact(
      text: 'Alerter la sécurité',
      deltaGauge1: 10,
      deltaGauge2: -10,
      deltaGauge3: -15,
      deltaGauge4: -15,
      setFlags: ['roy_enrage'],
    ),
  ),

  // ST_013: Clé USB en or noir (Trouvaille sous la banquette)
  const GameCard(
    id: 'ST_013',
    campaign: 'STREET',
    speakerName: 'Banquette VIP',
    speakerRole: 'Preuve compromettante',
    speakerAvatar: 'assets/images/characters/street/usb_key.png',
    dialogue:
        'Dans la panique de Roy, une clé USB sertie d\'or noir gît sur le velours pourpre. Ses fichiers portent le sceau Bell Cosmetics.',
    leftChoice: ChoiceImpact(
      text: 'Glisser dans son corset',
      deltaGauge1: 10,
      deltaGauge2: -10,
      deltaGauge3: -15,
      deltaGauge4: -10,
      setFlags: ['kimmie_a_la_cle'],
    ),
    rightChoice: ChoiceImpact(
      text: 'Laisser au gérant',
      deltaGauge1: -15,
      deltaGauge2: 15,
      deltaGauge3: 15,
      deltaGauge4: 15,
    ),
  ),

  // ST_014: Gérant du Club (Suspicion sur le salon VIP)
  const GameCard(
    id: 'ST_014',
    campaign: 'STREET',
    speakerName: 'Gérant du Club',
    speakerRole: 'Patron du Velvet Lounge',
    speakerAvatar: 'assets/images/characters/street/club_manager.png',
    dialogue:
        'Roy Bell prétend qu\'on lui a tiré un objet crucial. Si je découvre que c\'est une de mes filles, je la jette aux dobermans.',
    leftChoice: ChoiceImpact(
      text: 'Plaider l\'ignorance',
      deltaGauge1: -10,
      deltaGauge2: 5,
      deltaGauge3: 10,
      deltaGauge4: 15,
    ),
    rightChoice: ChoiceImpact(
      text: 'Dénoncer une rivale',
      deltaGauge1: -15,
      deltaGauge2: 15,
      deltaGauge3: 10,
      deltaGauge4: -15,
      setFlags: ['rivale_accusee'],
    ),
  ),

  // ST_015: Hacker des ruelles 'Cipher' (Tentative de décryptage)
  const GameCard(
    id: 'ST_015',
    campaign: 'STREET',
    speakerName: 'Cipher',
    speakerRole: 'Hacker underground',
    speakerAvatar: 'assets/images/characters/street/cipher.png',
    dialogue:
        'Cette clé contient la double comptabilité des Bell et la formule d\'une toxine masquée. Tu veux que je craque le code ?',
    requiredFlags: ['kimmie_a_la_cle'],
    leftChoice: ChoiceImpact(
      text: 'Décrypter les données',
      deltaGauge1: 10,
      deltaGauge2: -15,
      deltaGauge3: -10,
      deltaGauge4: -10,
      setFlags: ['donnees_decryptees'],
    ),
    rightChoice: ChoiceImpact(
      text: 'Faire une copie miroir',
      deltaGauge1: 10,
      deltaGauge2: -15,
      deltaGauge3: -5,
      deltaGauge4: 10,
      setFlags: ['copie_cle_usb'],
    ),
  ),

  // ST_016: Rain (Proposition de trêve vénale)
  const GameCard(
    id: 'ST_016',
    campaign: 'STREET',
    speakerName: 'Rain',
    speakerRole: 'Rival du bar',
    speakerAvatar: 'assets/images/characters/street/rain.png',
    dialogue:
        'J\'ai vu que tu avais récupéré le matos de Roy. Vends-le moi et on partage 50 000\$. Sinon je parle à Mallory Bell.',
    leftChoice: ChoiceImpact(
      text: 'Pacte avec le diable',
      deltaGauge1: -10,
      deltaGauge2: 15,
      deltaGauge3: 10,
      deltaGauge4: -10,
      setFlags: ['pacte_rain'],
    ),
    rightChoice: ChoiceImpact(
      text: 'La rembarrer net',
      deltaGauge1: 10,
      deltaGauge2: -10,
      deltaGauge3: -15,
      deltaGauge4: -15,
    ),
  ),

  // ST_017: Détective Davis (Planque dans la voiture banalisée)
  const GameCard(
    id: 'ST_017',
    campaign: 'STREET',
    speakerName: 'Détective Davis',
    speakerRole: 'Brigade financière',
    speakerAvatar: 'assets/images/characters/street/detective_davis.png',
    dialogue:
        'Kimmie, les Bell sont en panique. Si tu as ce qu\'ils cherchent, donne-le-moi avant que leurs tueurs ne te nettoient.',
    leftChoice: ChoiceImpact(
      text: 'Révéler la clé',
      deltaGauge1: 10,
      deltaGauge2: -10,
      deltaGauge3: -15,
      deltaGauge4: 15,
      setFlags: ['davis_briefe'],
    ),
    rightChoice: ChoiceImpact(
      text: 'Exiger une protection',
      deltaGauge1: 10,
      deltaGauge2: -10,
      deltaGauge3: -10,
      deltaGauge4: 15,
      setFlags: ['protection_police'],
    ),
  ),

  // ST_018: Norman (Achat d'arme de poing)
  const GameCard(
    id: 'ST_018',
    campaign: 'STREET',
    speakerName: 'Norman',
    speakerRole: 'Usurier & Recéleur',
    speakerAvatar: 'assets/images/characters/street/norman.png',
    dialogue:
        'Les hommes de Roy arpentent le quartier. Pour 800\$, j\'ai un calibre 9mm sans numéro de série sous le comptoir.',
    leftChoice: ChoiceImpact(
      text: 'Acheter le calibre',
      deltaGauge1: -10,
      deltaGauge2: -15,
      deltaGauge3: 10,
      deltaGauge4: -15,
      setFlags: ['kimmie_armee'],
    ),
    rightChoice: ChoiceImpact(
      text: 'Refuser les armes',
      deltaGauge1: 10,
      deltaGauge2: 15,
      deltaGauge3: -10,
      deltaGauge4: 10,
    ),
  ),

  // ST_019: Petite Sœur (Menaces téléphoniques)
  const GameCard(
    id: 'ST_019',
    campaign: 'STREET',
    speakerName: 'Petite Sœur',
    speakerRole: 'Famille en danger',
    speakerAvatar: 'assets/images/characters/street/sister.png',
    dialogue:
        'Kimmie ! Un homme en costume noir m\'attendait devant le lycée... Il m\'a dit de te demander si la clé brillait toujours !',
    leftChoice: ChoiceImpact(
      text: 'La cacher en banlieue',
      deltaGauge1: 10,
      deltaGauge2: -15,
      deltaGauge3: -15,
      deltaGauge4: 10,
      setFlags: ['soeur_cachee'],
    ),
    rightChoice: ChoiceImpact(
      text: 'Lui dire de se taire',
      deltaGauge1: -15,
      deltaGauge2: 10,
      deltaGauge3: 5,
      deltaGauge4: -10,
    ),
  ),

  // ST_020: Hommes de main des Bell (Embuscade sur le parking)
  const GameCard(
    id: 'ST_020',
    campaign: 'STREET',
    speakerName: 'Sbires des Bell',
    speakerRole: 'Escadron de Roy',
    speakerAvatar: 'assets/images/characters/street/bell_goons.png',
    dialogue:
        'Doucement, poupée. M. Bell veut juste récupérer son bien. Entre dans la berline sans crier.',
    leftChoice: ChoiceImpact(
      text: 'Sprayer au lacrymo',
      deltaGauge1: 10,
      deltaGauge2: -5,
      deltaGauge3: -10,
      deltaGauge4: -10,
      setFlags: ['embuscade_repoussee'],
    ),
    rightChoice: ChoiceImpact(
      text: 'Négocier 24 heures',
      deltaGauge1: -10,
      deltaGauge2: 15,
      deltaGauge3: 10,
      deltaGauge4: 15,
    ),
  ),

  // =========================================================================
  // CHAPTER 3: La Traque Fédérale & L'Infiltration (ST_021 - ST_030)
  // =========================================================================

  // ST_021: Réceptionniste du Neon Motel
  const GameCard(
    id: 'ST_021',
    campaign: 'STREET',
    speakerName: 'Réceptionniste',
    speakerRole: 'Refuge miteux',
    speakerAvatar: 'assets/images/characters/street/motel_night.png',
    dialogue:
        'Deux costards surveillent l\'entrée principale. Pour 100\$ de pourboire, je te fais sortir par la cour arrière.',
    leftChoice: ChoiceImpact(
      text: 'Arroser le groom',
      deltaGauge1: -10,
      deltaGauge2: -20,
      deltaGauge3: -10,
      deltaGauge4: 20,
    ),
    rightChoice: ChoiceImpact(
      text: 'Fuir par le toit',
      deltaGauge1: 15,
      deltaGauge2: 10,
      deltaGauge3: -15,
      deltaGauge4: -20,
    ),
  ),

  // ST_022: Détective Davis (Bureau des interrogatoires)
  const GameCard(
    id: 'ST_022',
    campaign: 'STREET',
    speakerName: 'Détective Davis',
    speakerRole: 'Enquêteur sous pression',
    speakerAvatar: 'assets/images/characters/street/detective_davis.png',
    dialogue:
        'Le procureur étouffe mes mandats. Pour coincer Mallory Bell, il faut déposer les doubles des bordereaux sur son bureau.',
    leftChoice: ChoiceImpact(
      text: 'Infiltrer la tour',
      deltaGauge1: 20,
      deltaGauge2: -15,
      deltaGauge3: -20,
      deltaGauge4: -15,
      setFlags: ['infiltration_bell'],
    ),
    rightChoice: ChoiceImpact(
      text: 'Refuser la mission',
      deltaGauge1: -15,
      deltaGauge2: 10,
      deltaGauge3: 15,
      deltaGauge4: 10,
    ),
  ),

  // ST_023: Gillian (Soutien en coulisses)
  const GameCard(
    id: 'ST_023',
    campaign: 'STREET',
    speakerName: 'Gillian',
    speakerRole: 'Danseuse alliée',
    speakerAvatar: 'assets/images/characters/street/gillian.png',
    dialogue:
        'J\'ai chipé le pass magnétique d\'un cadre de Bell Cosmetics hier soir au club. Tu peux entrer par le quai de chargement !',
    leftChoice: ChoiceImpact(
      text: 'Prendre le badge',
      deltaGauge1: 10,
      deltaGauge2: -10,
      deltaGauge3: 15,
      deltaGauge4: -15,
      setFlags: ['badge_recupere'],
    ),
    rightChoice: ChoiceImpact(
      text: 'Trop dangereux',
      deltaGauge1: -10,
      deltaGauge2: 10,
      deltaGauge3: -10,
      deltaGauge4: 15,
    ),
  ),

  // ST_024: Agent corrompu des Stups
  const GameCard(
    id: 'ST_024',
    campaign: 'STREET',
    speakerName: 'Agent corrompu',
    speakerRole: 'Flic sur la sellette',
    speakerAvatar: 'assets/images/characters/street/corrupt_cop.png',
    dialogue:
        'Davis ne te sauvera pas. Les Bell possèdent la moitié de la préfecture. Dis-moi où est la planque et je te laisse partir.',
    leftChoice: ChoiceImpact(
      text: 'Donner fausse piste',
      deltaGauge1: 15,
      deltaGauge2: 10,
      deltaGauge3: -15,
      deltaGauge4: 20,
      setFlags: ['fausse_piste_donnee'],
    ),
    rightChoice: ChoiceImpact(
      text: 'Payer son silence',
      deltaGauge1: -20,
      deltaGauge2: -20,
      deltaGauge3: 5,
      deltaGauge4: 15,
    ),
  ),

  // ST_025: Norman (Cache d'armes & fausse identité)
  const GameCard(
    id: 'ST_025',
    campaign: 'STREET',
    speakerName: 'Norman',
    speakerRole: 'Recéleur du port',
    speakerAvatar: 'assets/images/characters/street/norman.png',
    dialogue:
        'Un faux passeport canadien et un billet de ferry. 5 000\$ et ton nom disparaît des radars pour toujours.',
    leftChoice: ChoiceImpact(
      text: 'Acheter la fuite',
      deltaGauge1: -20,
      deltaGauge2: -20,
      deltaGauge3: -20,
      deltaGauge4: 20,
      setFlags: ['faux_passeport'],
    ),
    rightChoice: ChoiceImpact(
      text: 'Rester et lutter',
      deltaGauge1: 15,
      deltaGauge2: 15,
      deltaGauge3: 10,
      deltaGauge4: -20,
    ),
  ),

  // ST_026: Rain (Blessée et aux abois)
  const GameCard(
    id: 'ST_026',
    campaign: 'STREET',
    speakerName: 'Rain',
    speakerRole: 'Ennemie en déroute',
    speakerAvatar: 'assets/images/characters/street/rain.png',
    dialogue:
        'Roy m\'a battue... Il sait que je t\'ai parlé. Cache-moi Kimmie, par pitié ! Je te donnerai les codes du coffre VIP !',
    leftChoice: ChoiceImpact(
      text: 'L\'abriter et s\'allier',
      deltaGauge1: 15,
      deltaGauge2: -15,
      deltaGauge3: 20,
      deltaGauge4: -20,
      setFlags: ['alliance_rain'],
    ),
    rightChoice: ChoiceImpact(
      text: 'La livrer à son sort',
      deltaGauge1: -20,
      deltaGauge2: 20,
      deltaGauge3: -15,
      deltaGauge4: 20,
    ),
  ),

  // ST_027: Caméra de surveillance du Velvet
  const GameCard(
    id: 'ST_027',
    campaign: 'STREET',
    speakerName: 'Vidéosurveillance',
    speakerRole: 'Archives numériques',
    speakerAvatar: 'assets/images/characters/street/cctv_server.png',
    dialogue:
        'Le serveur interne filme le transfert quotidien des valises de cash vers le manoir Bell. L\'effacer ou l\'extraire ?',
    leftChoice: ChoiceImpact(
      text: 'Extraire les vidéos',
      deltaGauge1: 15,
      deltaGauge2: -10,
      deltaGauge3: -20,
      deltaGauge4: -15,
      setFlags: ['videos_extraites'],
    ),
    rightChoice: ChoiceImpact(
      text: 'Incendier le disque',
      deltaGauge1: -10,
      deltaGauge2: 10,
      deltaGauge3: -20,
      deltaGauge4: 20,
    ),
  ),

  // ST_028: Barmancier Marco (Alerte sur les tueurs)
  const GameCard(
    id: 'ST_028',
    campaign: 'STREET',
    speakerName: 'Marco',
    speakerRole: 'Confident du bar',
    speakerAvatar: 'assets/images/characters/street/bartender_marco.png',
    dialogue:
        'Kimmie, deux tueurs de Salazar rôdent autour de la scène. Ils attendent que la musique monte pour te faire disparaître.',
    leftChoice: ChoiceImpact(
      text: 'Couper le son et crier',
      deltaGauge1: 15,
      deltaGauge2: -10,
      deltaGauge3: -20,
      deltaGauge4: -20,
      setFlags: ['alerte_donnee'],
    ),
    rightChoice: ChoiceImpact(
      text: 'Filer par les cuisines',
      deltaGauge1: -10,
      deltaGauge2: 5,
      deltaGauge3: -10,
      deltaGauge4: 20,
    ),
  ),

  // ST_029: Don Salazar (Émissaire du Cartel)
  const GameCard(
    id: 'ST_029',
    campaign: 'STREET',
    speakerName: 'Don Salazar',
    speakerRole: 'Parrain du Cartel',
    speakerAvatar: 'assets/images/characters/street/salazar.png',
    dialogue:
        'Les Bell nous doivent dix millions. Donne-moi leur clé de blanchiment et je ferai de toi la gérante de tous les clubs.',
    leftChoice: ChoiceImpact(
      text: 'Pacte avec Salazar',
      deltaGauge1: -20,
      deltaGauge2: 20,
      deltaGauge3: 20,
      deltaGauge4: -20,
      setFlags: ['pacte_salazar'],
    ),
    rightChoice: ChoiceImpact(
      text: 'Rejeter son offre',
      deltaGauge1: 20,
      deltaGauge2: -15,
      deltaGauge3: -10,
      deltaGauge4: 15,
    ),
  ),

  // ST_030: Coupure d'électricité générale
  const GameCard(
    id: 'ST_030',
    campaign: 'STREET',
    speakerName: 'Panne secteur',
    speakerRole: 'Nuit noire',
    speakerAvatar: 'assets/images/characters/street/blackout.png',
    dialogue:
        'Toute la ruelle sombre dans le noir. Des sirènes au loin et des bruits de culasse résonnent sur le trottoir humide.',
    leftChoice: ChoiceImpact(
      text: 'Passer à l\'offensive',
      deltaGauge1: 15,
      deltaGauge2: -10,
      deltaGauge3: 10,
      deltaGauge4: -20,
    ),
    rightChoice: ChoiceImpact(
      text: 'Se fondre dans l\'ombre',
      deltaGauge1: -10,
      deltaGauge2: 10,
      deltaGauge3: -15,
      deltaGauge4: 20,
    ),
  ),

  // =========================================================================
  // CHAPTER 4: L'Affrontement Armé & L'Incendie (ST_031 - ST_040)
  // =========================================================================

  // ST_031: Roy Bell (Cocktail Molotov à la main)
  const GameCard(
    id: 'ST_031',
    campaign: 'STREET',
    speakerName: 'Roy Bell',
    speakerRole: 'Psychopathe déchaîné',
    speakerAvatar: 'assets/images/characters/street/roy_fire.png',
    dialogue:
        'Puisque cette garce refuse de cracher la clé, on brûle tout ! Danseuses, clients, registres : en cendres !',
    leftChoice: ChoiceImpact(
      text: 'Tirer sur Roy',
      deltaGauge1: 20,
      deltaGauge2: -10,
      deltaGauge3: -20,
      deltaGauge4: -20,
      setFlags: ['roy_neutralise'],
    ),
    rightChoice: ChoiceImpact(
      text: 'Lancer l\'extincteur',
      deltaGauge1: 10,
      deltaGauge2: -20,
      deltaGauge3: 20,
      deltaGauge4: -15,
      setFlags: ['club_incendie'],
    ),
  ),

  // ST_032: Incendie du Velvet Lounge
  const GameCard(
    id: 'ST_032',
    campaign: 'STREET',
    speakerName: 'Incendie du Velvet',
    speakerRole: 'Piège de flammes',
    speakerAvatar: 'assets/images/characters/street/club_fire.png',
    dialogue:
        'Les rideaux de velours s\'embrasent instantanément. Les sorties de secours sont cadenassées par l\'extérieur !',
    leftChoice: ChoiceImpact(
      text: 'Défoncer la porte',
      deltaGauge1: 15,
      deltaGauge2: -15,
      deltaGauge3: 20,
      deltaGauge4: -15,
    ),
    rightChoice: ChoiceImpact(
      text: 'Piller la caisse',
      deltaGauge1: -20,
      deltaGauge2: 20,
      deltaGauge3: -20,
      deltaGauge4: -15,
    ),
  ),

  // ST_033: Petite Sœur prise en otage
  const GameCard(
    id: 'ST_033',
    campaign: 'STREET',
    speakerName: 'Sbire armé',
    speakerRole: 'Prise d\'otage',
    speakerAvatar: 'assets/images/characters/street/hostage.png',
    dialogue:
        'Un homme de Roy retient ta sœur près des réserves : "Lâche ton arme immédiatement ou elle brûle vive !"',
    leftChoice: ChoiceImpact(
      text: 'Tirer sans trembler',
      deltaGauge1: 20,
      deltaGauge2: -10,
      deltaGauge3: 10,
      deltaGauge4: -20,
      setFlags: ['soeur_sauvee'],
    ),
    rightChoice: ChoiceImpact(
      text: 'Céder la clé USB',
      deltaGauge1: 15,
      deltaGauge2: -20,
      deltaGauge3: -10,
      deltaGauge4: 20,
      setFlags: ['cle_abandonnee'],
    ),
  ),

  // ST_034: Le Gérant calciné (Révélation du coffre)
  const GameCard(
    id: 'ST_034',
    campaign: 'STREET',
    speakerName: 'Gérant du Club',
    speakerRole: 'Agonisant dans les braises',
    speakerAvatar: 'assets/images/characters/street/manager_dying.png',
    dialogue:
        'Kimmie... Le coffre fort... Le code c\'est 4409... Mallory Bell nous a tous trahis depuis le départ...',
    leftChoice: ChoiceImpact(
      text: 'Vider le coffre',
      deltaGauge1: -15,
      deltaGauge2: 20,
      deltaGauge3: -20,
      deltaGauge4: -15,
      setFlags: ['coffre_pille'],
    ),
    rightChoice: ChoiceImpact(
      text: 'Le traîner dehors',
      deltaGauge1: 15,
      deltaGauge2: -20,
      deltaGauge3: 20,
      deltaGauge4: -10,
    ),
  ),

  // ST_035: Sirènes des pompiers et du SWAT
  const GameCard(
    id: 'ST_035',
    campaign: 'STREET',
    speakerName: 'SWAT & Pompiers',
    speakerRole: 'Cordon tactique',
    speakerAvatar: 'assets/images/characters/street/swat_sirens.png',
    dialogue:
        'Le SWAT déploie le cordon de sécurité autour du brasier. Deux tireurs d\'élite scrutent les toits de la ruelle.',
    leftChoice: ChoiceImpact(
      text: 'Se rendre aux secours',
      deltaGauge1: 10,
      deltaGauge2: -10,
      deltaGauge3: -15,
      deltaGauge4: 20,
    ),
    rightChoice: ChoiceImpact(
      text: 'Filer par les égouts',
      deltaGauge1: -15,
      deltaGauge2: 20,
      deltaGauge3: -20,
      deltaGauge4: 20,
    ),
  ),

  // ST_036: Jules Bell (Tentative de fuite)
  const GameCard(
    id: 'ST_036',
    campaign: 'STREET',
    speakerName: 'Jules Bell',
    speakerRole: 'Héritier en panique',
    speakerAvatar: 'assets/images/characters/street/jules_escape.png',
    dialogue:
        'Kimmie ! Monte avec moi ! J\'ai 5 millions en obligations dans le coffre, on oublie tout et on file à Miami !',
    leftChoice: ChoiceImpact(
      text: 'Crever ses pneus',
      deltaGauge1: 20,
      deltaGauge2: -15,
      deltaGauge3: 15,
      deltaGauge4: -20,
      setFlags: ['jules_arrete'],
    ),
    rightChoice: ChoiceImpact(
      text: 'Prendre la valise',
      deltaGauge1: -20,
      deltaGauge2: 20,
      deltaGauge3: -20,
      deltaGauge4: -20,
    ),
  ),

  // ST_037: Gillian (Rescapée du brasier)
  const GameCard(
    id: 'ST_037',
    campaign: 'STREET',
    speakerName: 'Gillian',
    speakerRole: 'Alliée rescapée',
    speakerAvatar: 'assets/images/characters/street/gillian_injured.png',
    dialogue:
        'On est vivantes Kimmie... On a tout perdu, mais toute la presse est massée sur le boulevard. Parle aux caméras !',
    leftChoice: ChoiceImpact(
      text: 'Témoigner en direct',
      deltaGauge1: 15,
      deltaGauge2: -15,
      deltaGauge3: 20,
      deltaGauge4: -20,
      setFlags: ['scandale_public'],
    ),
    rightChoice: ChoiceImpact(
      text: 'Refuser les micros',
      deltaGauge1: -15,
      deltaGauge2: 15,
      deltaGauge3: -15,
      deltaGauge4: 20,
    ),
  ),

  // ST_038: Détective Davis (Reconnaissance officielle)
  const GameCard(
    id: 'ST_038',
    campaign: 'STREET',
    speakerName: 'Détective Davis',
    speakerRole: 'Allié réhabilité',
    speakerAvatar: 'assets/images/characters/street/detective_davis.png',
    dialogue:
        'Grâce à toi, le FBI a pris la main. Roy Bell est neutralisé. Mais Mallory a engagé les plus grands ténors du pays.',
    leftChoice: ChoiceImpact(
      text: 'Signer la déposition',
      deltaGauge1: 15,
      deltaGauge2: -10,
      deltaGauge3: -10,
      deltaGauge4: -15,
      setFlags: ['deposition_signee'],
    ),
    rightChoice: ChoiceImpact(
      text: 'Monnayer son aveu',
      deltaGauge1: -20,
      deltaGauge2: 20,
      deltaGauge3: 15,
      deltaGauge4: -10,
    ),
  ),

  // ST_039: Horace Bell (Appel privé chiffré)
  const GameCard(
    id: 'ST_039',
    campaign: 'STREET',
    speakerName: 'Horace Bell',
    speakerRole: 'Patriarche aux abois',
    speakerAvatar: 'assets/images/characters/street/horace_call.png',
    dialogue:
        'Nommez votre prix, jeune fille. Un million ? Deux ? Dites aux jurés que Roy a agi seul dans un accès de folie.',
    leftChoice: ChoiceImpact(
      text: 'Enregistrer l\'appel',
      deltaGauge1: 15,
      deltaGauge2: -20,
      deltaGauge3: 15,
      deltaGauge4: -10,
      setFlags: ['horace_piege'],
    ),
    rightChoice: ChoiceImpact(
      text: 'Prendre le chèque',
      deltaGauge1: -20,
      deltaGauge2: 20,
      deltaGauge3: -10,
      deltaGauge4: 15,
    ),
  ),

  // ST_040: Nuit blanche en planque sécurisée
  const GameCard(
    id: 'ST_040',
    campaign: 'STREET',
    speakerName: 'Chambre forte',
    speakerRole: 'Veille d\'audience',
    speakerAvatar: 'assets/images/characters/street/safehouse.png',
    dialogue:
        'Demain matin s\'ouvre le procès préliminaire au Tribunal Fédéral. Le destin du syndicat de la nuit se joue maintenant.',
    leftChoice: ChoiceImpact(
      text: 'Préparer ses notes',
      deltaGauge1: 20,
      deltaGauge2: -10,
      deltaGauge3: 15,
      deltaGauge4: 10,
    ),
    rightChoice: ChoiceImpact(
      text: 'Veiller l\'arme au poing',
      deltaGauge1: 10,
      deltaGauge2: 10,
      deltaGauge3: -10,
      deltaGauge4: 15,
    ),
  ),

  // =========================================================================
  // CHAPTER 5: Le Grand Jury & La Rédemption (ST_041 - ST_050)
  // =========================================================================

  // ST_041: L'Hémicycle du Grand Jury
  const GameCard(
    id: 'ST_041',
    campaign: 'STREET',
    speakerName: 'Président du Jury',
    speakerRole: 'Chambre de justice',
    speakerAvatar: 'assets/images/characters/street/jury.png',
    dialogue:
        'Kimmie, sous serment : avez-vous vu Mallory Bell signer les transferts de fonds occultes issus du Velvet Lounge ?',
    leftChoice: ChoiceImpact(
      text: 'Jurer la vérité pure',
      deltaGauge1: 15,
      deltaGauge2: -15,
      deltaGauge3: 20,
      deltaGauge4: -20,
      setFlags: ['temoignage_accablant'],
    ),
    rightChoice: ChoiceImpact(
      text: 'Minorer son rôle',
      deltaGauge1: -20,
      deltaGauge2: 20,
      deltaGauge3: -15,
      deltaGauge4: 20,
    ),
  ),

  // ST_042: Avocat de la Défense (Attaque sur la moralité)
  const GameCard(
    id: 'ST_042',
    campaign: 'STREET',
    speakerName: 'Avocat Bell',
    speakerRole: 'Ténor du barreau',
    speakerAvatar: 'assets/images/characters/street/defense_lawyer.png',
    dialogue:
        'Cette fille n\'est qu\'une effeuilleuse de cabaret sans scrupules, renvoyée par sa propre mère pour vols répétés !',
    leftChoice: ChoiceImpact(
      text: 'Répondre avec cran',
      deltaGauge1: 15,
      deltaGauge2: -10,
      deltaGauge3: 20,
      deltaGauge4: -10,
    ),
    rightChoice: ChoiceImpact(
      text: 'Produire les reçus',
      deltaGauge1: 20,
      deltaGauge2: 10,
      deltaGauge3: -10,
      deltaGauge4: 15,
    ),
  ),

  // ST_043: Mallory Bell (Regard de glace sur le banc)
  const GameCard(
    id: 'ST_043',
    campaign: 'STREET',
    speakerName: 'Mallory Bell',
    speakerRole: 'L\'Impératrice sur le banc',
    speakerAvatar: 'assets/images/characters/street/mallory_glare.png',
    dialogue:
        'Mallory me fixe depuis le banc des accusés. Ses lèvres murmurent sans bruit : "Tu as brûlé notre foyer, mais tu resteras une moins-que-rien."',
    leftChoice: ChoiceImpact(
      text: 'Soutenir son regard',
      deltaGauge1: 15,
      deltaGauge2: -10,
      deltaGauge3: 20,
      deltaGauge4: -15,
    ),
    rightChoice: ChoiceImpact(
      text: 'Ignorer la menace',
      deltaGauge1: -20,
      deltaGauge2: 15,
      deltaGauge3: -15,
      deltaGauge4: 20,
    ),
  ),

  // ST_044: Procureur fédéral (Protection des témoins)
  const GameCard(
    id: 'ST_044',
    campaign: 'STREET',
    speakerName: 'Procureur fédéral',
    speakerRole: 'Programme de protection',
    speakerAvatar: 'assets/images/characters/street/federal_prosecutor.png',
    dialogue:
        'Nouvelle identité en Oregon et bourse d\'études pour votre sœur. Mais vous ne remettrez plus jamais les pieds dans cette métropole.',
    leftChoice: ChoiceImpact(
      text: 'Accepter l\'exil protégé',
      deltaGauge1: 15,
      deltaGauge2: 20,
      deltaGauge3: -20,
      deltaGauge4: 20,
      setFlags: ['programme_protection'],
    ),
    rightChoice: ChoiceImpact(
      text: 'Rester dans sa ville',
      deltaGauge1: 15,
      deltaGauge2: -20,
      deltaGauge3: 20,
      deltaGauge4: -20,
    ),
  ),

  // ST_045: La Mère de Kimmie (Retrouvailles)
  const GameCard(
    id: 'ST_045',
    campaign: 'STREET',
    speakerName: 'Mère de Kimmie',
    speakerRole: 'Foyer réconcilié',
    speakerAvatar: 'assets/images/characters/street/mother_repentant.png',
    dialogue:
        'Kimmie... Je t\'ai vue aux informations. Tu as renversé ces monstres. Pardonne-moi de t\'avoir chassée sous la pluie...',
    leftChoice: ChoiceImpact(
      text: 'Pardonner et aider',
      deltaGauge1: 15,
      deltaGauge2: -20,
      deltaGauge3: 10,
      deltaGauge4: 10,
    ),
    rightChoice: ChoiceImpact(
      text: 'Garder ses distances',
      deltaGauge1: 15,
      deltaGauge2: 20,
      deltaGauge3: -10,
      deltaGauge4: -15,
    ),
  ),

  // ST_046: Les Danseuses du Club en grève
  const GameCard(
    id: 'ST_046',
    campaign: 'STREET',
    speakerName: 'Collectif Danseuses',
    speakerRole: 'Mouvement autonome',
    speakerAvatar: 'assets/images/characters/street/union_dancers.png',
    dialogue:
        'Kimmie, les artistes des cabarets fondent un syndicat autonome ! On veut que tu sois notre porte-parole officielle !',
    leftChoice: ChoiceImpact(
      text: 'Mener la fronde',
      deltaGauge1: 15,
      deltaGauge2: -15,
      deltaGauge3: 20,
      deltaGauge4: -20,
      setFlags: ['leader_syndicat'],
    ),
    rightChoice: ChoiceImpact(
      text: 'Passer la main',
      deltaGauge1: 15,
      deltaGauge2: 15,
      deltaGauge3: -20,
      deltaGauge4: 20,
    ),
  ),

  // ST_047: Le Verdict du Jury
  const GameCard(
    id: 'ST_047',
    campaign: 'STREET',
    speakerName: 'Le Greffier',
    speakerRole: 'Palais de justice',
    speakerAvatar: 'assets/images/characters/street/verdict.png',
    dialogue:
        'Le jury déclare Roy et Horace Bell coupables d\'extorsion aggravée et d\'incendie criminel ! La peine maximale est requise.',
    leftChoice: ChoiceImpact(
      text: 'Savourer la justice',
      deltaGauge1: 15,
      deltaGauge2: 10,
      deltaGauge3: 20,
      deltaGauge4: 10,
      setFlags: ['horace_ecroue'],
    ),
    rightChoice: ChoiceImpact(
      text: 'Pensée aux victimes',
      deltaGauge1: 15,
      deltaGauge2: -10,
      deltaGauge3: 15,
      deltaGauge4: 15,
    ),
  ),

  // ST_048: Norman (Nouvelle affaire propre)
  const GameCard(
    id: 'ST_048',
    campaign: 'STREET',
    speakerName: 'Norman',
    speakerRole: 'Investisseur repenti',
    speakerAvatar: 'assets/images/characters/street/norman_clean.png',
    dialogue:
        'J\'ai racheté un lounge chic sur la marina, 100% légal. 50% des parts t\'attendent si tu rejoins l\'aventure.',
    leftChoice: ChoiceImpact(
      text: 'Devenir associée',
      deltaGauge1: 15,
      deltaGauge2: 20,
      deltaGauge3: 20,
      deltaGauge4: -15,
      setFlags: ['lounge_proprietaire'],
    ),
    rightChoice: ChoiceImpact(
      text: 'Vivre simplement',
      deltaGauge1: 15,
      deltaGauge2: -20,
      deltaGauge3: -20,
      deltaGauge4: 20,
    ),
  ),

  // ST_049: Petite Sœur diplômée
  const GameCard(
    id: 'ST_049',
    campaign: 'STREET',
    speakerName: 'Petite Sœur',
    speakerRole: 'Avenir racheté',
    speakerAvatar: 'assets/images/characters/street/sister_grad.png',
    dialogue:
        'J\'ai décroché mon diplôme d\'avocate avec félicitations ! Sans toi, Kimmie, je n\'aurais jamais survécu à la rue.',
    leftChoice: ChoiceImpact(
      text: 'Pleurer de joie',
      deltaGauge1: 15,
      deltaGauge2: -15,
      deltaGauge3: 15,
      deltaGauge4: 10,
    ),
    rightChoice: ChoiceImpact(
      text: 'Lui offrir son cabinet',
      deltaGauge1: 20,
      deltaGauge2: -20,
      deltaGauge3: 10,
      deltaGauge4: 15,
    ),
  ),

  // ST_050: La Nuit sur la Baie (Épilogue)
  const GameCard(
    id: 'ST_050',
    campaign: 'STREET',
    speakerName: 'Kimmie',
    speakerRole: 'Reine affranchie',
    speakerAvatar: 'assets/images/characters/street/kimmie_sovereign.png',
    dialogue:
        'Debout sur la corniche, les néons de la ville scintillent sous la pluie fine. La nuit ne m\'a pas brisée : j\'en suis la reine.',
    leftChoice: ChoiceImpact(
      text: 'Régner sur la nuit',
      deltaGauge1: 15,
      deltaGauge2: 20,
      deltaGauge3: 20,
      deltaGauge4: -10,
      setFlags: ['reine_de_la_nuit'],
    ),
    rightChoice: ChoiceImpact(
      text: 'Savourer la liberté',
      deltaGauge1: 15,
      deltaGauge2: -10,
      deltaGauge3: -15,
      deltaGauge4: 20,
      setFlags: ['liberte_retrouvee'],
    ),
  ),
];
