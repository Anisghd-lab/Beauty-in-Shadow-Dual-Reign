import re

card_to_char = {
    # Street Campaign (ST_001 to ST_050)
    'ST_001': ('ST_001', 'assets/images/characters/street/ST_001_Mere_Kimmie.png'),
    'ST_002': ('ST_002', 'assets/images/characters/street/ST_002_Gerant_Motel.png'),
    'ST_003': ('ST_003', 'assets/images/characters/street/ST_003_Gerant_Club.png'),
    'ST_004': ('ST_004', 'assets/images/characters/street/ST_004_Rain.png'),
    'ST_005': ('ST_005', 'assets/images/characters/street/ST_005_Norman.png'),
    'ST_006': ('ST_006', 'assets/images/characters/street/ST_006_Petite_Soeur.png'),
    'ST_007': ('ST_007', 'assets/images/characters/street/ST_007_Client_Emeche.png'),
    'ST_008': ('ST_008', 'assets/images/characters/street/ST_008_Controle_Police.png'),
    'ST_009': ('ST_009', 'assets/images/characters/street/ST_009_Gillian.png'),
    'ST_010': ('ST_010', 'assets/images/characters/street/ST_010_Detective_Davis.png'),
    'ST_011': ('EM_008', 'assets/images/characters/empire/EM_008_Jules_Bell.png'),
    'ST_012': ('EM_004', 'assets/images/characters/empire/EM_004_Roy_Bell.png'),
    'ST_013': ('ST_013', 'assets/images/characters/street/ST_013_Banquette_VIP.png'),
    'ST_014': ('ST_003', 'assets/images/characters/street/ST_003_Gerant_Club.png'),
    'ST_015': ('ST_015', 'assets/images/characters/street/ST_015_Cipher.png'),
    'ST_016': ('ST_004', 'assets/images/characters/street/ST_004_Rain.png'),
    'ST_017': ('ST_010', 'assets/images/characters/street/ST_010_Detective_Davis.png'),
    'ST_018': ('ST_005', 'assets/images/characters/street/ST_005_Norman.png'),
    'ST_019': ('ST_006', 'assets/images/characters/street/ST_006_Petite_Soeur.png'),
    'ST_020': ('ST_020', 'assets/images/characters/street/ST_020_Sbires_Bell.png'),
    'ST_021': ('ST_021', 'assets/images/characters/street/ST_021_Receptionniste.png'),
    'ST_022': ('ST_010', 'assets/images/characters/street/ST_010_Detective_Davis.png'),
    'ST_023': ('ST_015', 'assets/images/characters/street/ST_015_Cipher.png'),
    'ST_024': ('ST_024', 'assets/images/characters/street/ST_024_Agent_Corrompu.png'),
    'ST_025': ('ST_005', 'assets/images/characters/street/ST_005_Norman.png'),
    'ST_026': ('ST_004', 'assets/images/characters/street/ST_004_Rain.png'),
    'ST_027': ('ST_027', 'assets/images/characters/street/ST_027_Videosurveillance.png'),
    'ST_028': ('ST_028', 'assets/images/characters/street/ST_028_Marco.png'),
    'ST_029': ('EM_021', 'assets/images/characters/empire/EM_021_Don_Salazar.png'),
    'ST_030': ('ST_030', 'assets/images/characters/street/ST_030_Panne_Secteur.png'),
    'ST_031': ('EM_004', 'assets/images/characters/empire/EM_004_Roy_Bell.png'),
    'ST_032': ('ST_032', 'assets/images/characters/street/ST_032_Incendie_Velvet.png'),
    'ST_033': ('ST_033', 'assets/images/characters/street/ST_033_Sbire_Arme.png'),
    'ST_034': ('ST_003', 'assets/images/characters/street/ST_003_Gerant_Club.png'),
    'ST_035': ('ST_035', 'assets/images/characters/street/ST_035_SWAT_Pompiers.png'),
    'ST_036': ('EM_008', 'assets/images/characters/empire/EM_008_Jules_Bell.png'),
    'ST_037': ('ST_005', 'assets/images/characters/street/ST_005_Norman.png'),
    'ST_038': ('ST_010', 'assets/images/characters/street/ST_010_Detective_Davis.png'),
    'ST_039': ('EM_002', 'assets/images/characters/empire/EM_002_Horace_Bell.png'),
    'ST_040': ('ST_040', 'assets/images/characters/street/ST_040_Chambre_Forte.png'),
    'ST_041': ('ST_041', 'assets/images/characters/street/ST_041_President_Jury.png'),
    'ST_042': ('ST_042', 'assets/images/characters/street/ST_042_Avocat_Bell.png'),
    'ST_043': ('EM_050', 'assets/images/characters/empire/EM_050_Mallory_Bell.png'),
    'ST_044': ('ST_044', 'assets/images/characters/street/ST_044_Procureur_Federal.png'),
    'ST_045': ('ST_005', 'assets/images/characters/street/ST_005_Norman.png'),
    'ST_046': ('ST_046', 'assets/images/characters/street/ST_046_Collectif_Danseuses.png'),
    'ST_047': ('ST_047', 'assets/images/characters/street/ST_047_Le_Greffier.png'),
    'ST_048': ('ST_044', 'assets/images/characters/street/ST_044_Procureur_Federal.png'),
    'ST_049': ('ST_006', 'assets/images/characters/street/ST_006_Petite_Soeur.png'),
    'ST_050': ('ST_050', 'assets/images/characters/street/ST_050_Kimmie.png'),

    # Empire Campaign (EM_001 to EM_050)
    'EM_001': ('EM_001', 'assets/images/characters/empire/EM_001_Directeur_Financier.png'),
    'EM_002': ('EM_002', 'assets/images/characters/empire/EM_002_Horace_Bell.png'),
    'EM_003': ('EM_003', 'assets/images/characters/empire/EM_003_Chimiste_Chef.png'),
    'EM_004': ('EM_004', 'assets/images/characters/empire/EM_004_Roy_Bell.png'),
    'EM_005': ('EM_005', 'assets/images/characters/empire/EM_005_Journaliste_TV.png'),
    'EM_006': ('EM_006', 'assets/images/characters/empire/EM_006_Procureur_Miller.png'),
    'EM_007': ('ST_003', 'assets/images/characters/street/ST_003_Gerant_Club.png'),
    'EM_008': ('EM_008', 'assets/images/characters/empire/EM_008_Jules_Bell.png'),
    'EM_009': ('EM_002', 'assets/images/characters/empire/EM_002_Horace_Bell.png'),
    'EM_010': ('EM_010', 'assets/images/characters/empire/EM_010_Raid_Fiscal.png'),
    'EM_011': ('EM_004', 'assets/images/characters/empire/EM_004_Roy_Bell.png'),
    'EM_012': ('ST_004', 'assets/images/characters/street/ST_004_Rain.png'),
    'EM_013': ('EM_013', 'assets/images/characters/empire/EM_013_Directrice_Marketing.png'),
    'EM_014': ('EM_014', 'assets/images/characters/empire/EM_014_Commissaire_District.png'),
    'EM_015': ('EM_008', 'assets/images/characters/empire/EM_008_Jules_Bell.png'),
    'EM_016': ('EM_016', 'assets/images/characters/empire/EM_016_Conseil_Administration.png'),
    'EM_017': ('EM_017', 'assets/images/characters/empire/EM_017_Banquier_Suisse.png'),
    'EM_018': ('EM_002', 'assets/images/characters/empire/EM_002_Horace_Bell.png'),
    'EM_019': ('EM_019', 'assets/images/characters/empire/EM_019_Journaliste_Times.png'),
    'EM_020': ('EM_020', 'assets/images/characters/empire/EM_020_Ligne_Urgence.png'),
    'EM_021': ('EM_021', 'assets/images/characters/empire/EM_021_Don_Salazar.png'),
    'EM_022': ('EM_022', 'assets/images/characters/empire/EM_022_Silas.png'),
    'EM_023': ('EM_004', 'assets/images/characters/empire/EM_004_Roy_Bell.png'),
    'EM_024': ('EM_024', 'assets/images/characters/empire/EM_024_Juge_Vandermeer.png'),
    'EM_025': ('EM_008', 'assets/images/characters/empire/EM_008_Jules_Bell.png'),
    'EM_026': ('ST_010', 'assets/images/characters/street/ST_010_Detective_Davis.png'),
    'EM_027': ('EM_027', 'assets/images/characters/empire/EM_027_Archiviste.png'),
    'EM_028': ('EM_028', 'assets/images/characters/empire/EM_028_Analyste_Financier.png'),
    'EM_029': ('EM_002', 'assets/images/characters/empire/EM_002_Horace_Bell.png'),
    'EM_030': ('EM_030', 'assets/images/characters/empire/EM_030_Reseau_SWIFT.png'),
    'EM_031': ('EM_031', 'assets/images/characters/empire/EM_031_President_Tribunal.png'),
    'EM_032': ('ST_050', 'assets/images/characters/street/ST_050_Kimmie.png'),
    'EM_033': ('EM_006', 'assets/images/characters/empire/EM_006_Procureur_Miller.png'),
    'EM_034': ('EM_022', 'assets/images/characters/empire/EM_022_Silas.png'),
    'EM_035': ('EM_002', 'assets/images/characters/empire/EM_002_Horace_Bell.png'),
    'EM_036': ('EM_036', 'assets/images/characters/empire/EM_036_Mandataire_Judiciaire.png'),
    'EM_037': ('EM_021', 'assets/images/characters/empire/EM_021_Don_Salazar.png'),
    'EM_038': ('EM_038', 'assets/images/characters/empire/EM_038_Maitre_Sterling.png'),
    'EM_039': ('EM_039', 'assets/images/characters/empire/EM_039_Attache_Presse.png'),
    'EM_040': ('EM_040', 'assets/images/characters/empire/EM_040_Salle_Attente.png'),
    'EM_041': ('EM_041', 'assets/images/characters/empire/EM_041_Greffier_Federal.png'),
    'EM_042': ('EM_016', 'assets/images/characters/empire/EM_016_Conseil_Administration.png'),
    'EM_043': ('EM_043', 'assets/images/characters/empire/EM_043_Chef_Marque_Luxe.png'),
    'EM_044': ('EM_002', 'assets/images/characters/empire/EM_002_Horace_Bell.png'),
    'EM_045': ('EM_045', 'assets/images/characters/empire/EM_045_Commissaire_Priseur.png'),
    'EM_046': ('EM_046', 'assets/images/characters/empire/EM_046_Consortium_Asie.png'),
    'EM_047': ('EM_047', 'assets/images/characters/empire/EM_047_Gouverneur.png'),
    'EM_048': ('EM_008', 'assets/images/characters/empire/EM_008_Jules_Bell.png'),
    'EM_049': ('EM_049', 'assets/images/characters/empire/EM_049_President_Sommet.png'),
    'EM_050': ('EM_050', 'assets/images/characters/empire/EM_050_Mallory_Bell.png'),
}

def update_file(filepath):
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()

    # Pattern: id: 'ST_001', ... speakerAvatar: '...',
    def replacer(match):
        card_id = match.group(1)
        if card_id in card_to_char:
            char_id, asset_path = card_to_char[card_id]
            # Replace speakerAvatar and inject interlocutorId
            chunk = match.group(0)
            chunk = re.sub(r"speakerAvatar:\s*'[^']+',", f"speakerAvatar: '{asset_path}',\n    interlocutorId: '{char_id}',", chunk)
            return chunk
        return match.group(0)

    # Match each GameCard block
    card_pattern = re.compile(r"id:\s*'(ST_\d{3}|EM_\d{3})',[\s\S]*?speakerAvatar:\s*'[^']+',")
    new_content = card_pattern.sub(replacer, content)

    with open(filepath, 'w', encoding='utf-8') as f:
        f.write(new_content)
    print(f"Successfully processed {filepath}")

update_file('lib/data/street_deck.dart')
update_file('lib/data/empire_deck.dart')
