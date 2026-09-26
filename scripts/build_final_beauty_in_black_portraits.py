import os
import sys
from PIL import Image, ImageEnhance, ImageDraw, ImageFilter

CACHE_DIR = '/tmp/wikimedia_cache'

# Mapping of all 60 canonical characters to source files, framing, and faction
PORTRAIT_CONFIG = {
    # -------------------------------------------------------------------------
    # STREET CAMPAIGN (28 Interlocutors)
    # -------------------------------------------------------------------------
    'ST_001': {
        'target': 'assets/images/characters/street/ST_001_Mere_Kimmie.png',
        'src': '960px-Tamara_Tunie_at_EssenceFest_2025.jpg',
        'role': 'Mère de Kimmie (Tamara Tunie)',
        'faction': 'street',
        'focus_y': 0.32,
        'crop_scale': 0.65,
    },
    'ST_002': {
        'target': 'assets/images/characters/street/ST_002_Gerant_Motel.png',
        'src': '960px-Dex_Robinson_at_EssenceFest_2025.jpg',
        'role': 'Gérant du Motel (Dex Robinson)',
        'faction': 'street',
        'focus_y': 0.30,
        'crop_scale': 0.65,
    },
    'ST_003': {
        'target': 'assets/images/characters/street/ST_003_Gerant_Club.png',
        'src': '960px-Cortez_Smith_at_EssenceFest_2025.jpg',
        'role': 'Gérant du Club - Velvet Lounge (Cortez Smith)',
        'faction': 'street',
        'focus_y': 0.30,
        'crop_scale': 0.65,
    },
    'ST_004': {
        'target': 'assets/images/characters/street/ST_004_Rain.png',
        'src': '960px-Coco_Jones_Essence_Festival_of_Culture_2025.jpg',
        'role': 'Rain - Star Dancer (Coco Jones)',
        'faction': 'street',
        'focus_y': 0.35,
        'crop_scale': 0.58,
    },
    'ST_005': {
        'target': 'assets/images/characters/street/ST_005_Norman.png',
        'src': '960px-Mike_Colter_by_Gage_Skidmore.jpg',
        'role': 'Norman - Bouncer & Sécurité (Mike Colter)',
        'faction': 'street',
        'focus_y': 0.38,
        'crop_scale': 0.70,
    },
    'ST_006': {
        'target': 'assets/images/characters/street/ST_006_Petite_Soeur.png',
        'src': '960px-Jordan_Chiles_on_2025_Essence_Festival_of_Culture_Carpet_%28cropped%29.jpg',
        'role': 'Petite Sœur (Jordan Chiles)',
        'faction': 'street',
        'focus_y': 0.35,
        'crop_scale': 0.70,
    },
    'ST_007': {
        'target': 'assets/images/characters/street/ST_007_Client_Emeche.png',
        'src': '960px-Druski_at_Essence_Festival_of_Culture_2025_01.jpg',
        'role': 'Client Éméché (Druski)',
        'faction': 'street',
        'focus_y': 0.28,
        'crop_scale': 0.60,
    },
    'ST_008': {
        'target': 'assets/images/characters/street/ST_008_Controle_Police.png',
        'src': '960px-Terry_Crews_by_Gage_Skidmore.jpg',
        'role': 'Contrôle de Police (Terry Crews)',
        'faction': 'street',
        'focus_y': 0.36,
        'crop_scale': 0.65,
    },
    'ST_009': {
        'target': 'assets/images/characters/street/ST_009_Gillian.png',
        'src': '960px-Quad_Webb_at_EssenceFest_2025.jpg',
        'role': 'Gillian (Quad Webb)',
        'faction': 'street',
        'focus_y': 0.28,
        'crop_scale': 0.60,
    },
    'ST_010': {
        'target': 'assets/images/characters/street/ST_010_Detective_Davis.png',
        'src': '960px-Noel_Braham_at_EssenceFest_2025.jpg',
        'role': 'Détective Davis (Noel Braham)',
        'faction': 'street',
        'focus_y': 0.32,
        'crop_scale': 0.65,
    },
    'ST_013': {
        'target': 'assets/images/characters/street/ST_013_Banquette_VIP.png',
        'src': '960px-CocoonClub_-_VIP_Coccon.jpg',
        'role': 'Banquette VIP',
        'faction': 'street',
        'focus_y': 0.50,
        'crop_scale': 1.0,
    },
    'ST_015': {
        'target': 'assets/images/characters/street/ST_015_Cipher.png',
        'src': '960px-Kyle_Bary_at_EssenceFest_2025.jpg',
        'role': 'Cipher (Kyle Bary)',
        'faction': 'street',
        'focus_y': 0.32,
        'crop_scale': 0.65,
    },
    'ST_020': {
        'target': 'assets/images/characters/street/ST_020_Sbires_Bell.png',
        'src': '960px-Winston_Duke_by_Gage_Skidmore.jpg',
        'role': 'Sbires Bell (Winston Duke)',
        'faction': 'street',
        'focus_y': 0.35,
        'crop_scale': 0.65,
    },
    'ST_021': {
        'target': 'assets/images/characters/street/ST_021_Receptionniste.png',
        'src': '960px-Crystal_Hayslett_at_EssenceFest_2025.jpg',
        'role': 'Réceptionniste de Luxe (Crystal Hayslett)',
        'faction': 'street',
        'focus_y': 0.30,
        'crop_scale': 0.65,
    },
    'ST_024': {
        'target': 'assets/images/characters/street/ST_024_Agent_Corrompu.png',
        'src': '960px-Daniel_Kaluuya_by_Gage_Skidmore.jpg',
        'role': 'Agent Corrompu (Daniel Kaluuya)',
        'faction': 'street',
        'focus_y': 0.35,
        'crop_scale': 0.65,
    },
    'ST_027': {
        'target': 'assets/images/characters/street/ST_027_Videosurveillance.png',
        'src': '960px-CCTV_control_room_monitor_wall.jpg',
        'role': 'Vidéosurveillance',
        'faction': 'street',
        'focus_y': 0.50,
        'crop_scale': 1.0,
    },
    'ST_028': {
        'target': 'assets/images/characters/street/ST_028_Marco.png',
        'src': '960px-Yahya_Abdul-Mateen_II_by_Gage_Skidmore.jpg',
        'role': 'Marco (Yahya Abdul-Mateen II)',
        'faction': 'street',
        'focus_y': 0.35,
        'crop_scale': 0.65,
    },
    'ST_030': {
        'target': 'assets/images/characters/street/ST_030_Panne_Secteur.png',
        'src': '960px-Blackout_Flatiron_%288147572701%29.jpg',
        'role': 'Panne de Secteur',
        'faction': 'street',
        'focus_y': 0.50,
        'crop_scale': 1.0,
    },
    'ST_032': {
        'target': 'assets/images/characters/street/ST_032_Incendie_Velvet.png',
        'src': '960px-Fire_engine_crews_receiving_night_operations_briefing_for_Bear_Fire_03.jpg',
        'role': 'L\'Incendie du Velvet',
        'faction': 'street',
        'focus_y': 0.50,
        'crop_scale': 1.0,
    },
    'ST_033': {
        'target': 'assets/images/characters/street/ST_033_Sbire_Arme.png',
        'src': '960px-Keith_Lee_on_the_carpet_at_EssenceFest_2025_-_01_-_cropped.jpg',
        'role': 'Sbire Armé (Keith Lee)',
        'faction': 'street',
        'focus_y': 0.32,
        'crop_scale': 0.65,
    },
    'ST_035': {
        'target': 'assets/images/characters/street/ST_035_SWAT_Pompiers.png',
        'src': '960px-2024_RNC_Swat_assemble.jpg',
        'role': 'SWAT & Pompiers',
        'faction': 'street',
        'focus_y': 0.50,
        'crop_scale': 1.0,
    },
    'ST_040': {
        'target': 'assets/images/characters/street/ST_040_Chambre_Forte.png',
        'src': 'Bank_vault_door.jpg',
        'role': 'Chambre Forte Bell',
        'faction': 'street',
        'focus_y': 0.50,
        'crop_scale': 1.0,
    },
    'ST_041': {
        'target': 'assets/images/characters/street/ST_041_President_Jury.png',
        'src': '960px-Forest_Whitaker_by_Gage_Skidmore.jpg',
        'role': 'Président du Jury (Forest Whitaker)',
        'faction': 'street',
        'focus_y': 0.35,
        'crop_scale': 0.65,
    },
    'ST_042': {
        'target': 'assets/images/characters/street/ST_042_Avocat_Bell.png',
        'src': '960px-Chiwetel_Ejiofor_by_Gage_Skidmore.jpg',
        'role': 'Avocat des Bell (Chiwetel Ejiofor)',
        'faction': 'street',
        'focus_y': 0.35,
        'crop_scale': 0.65,
    },
    'ST_044': {
        'target': 'assets/images/characters/street/ST_044_Procureur_Federal.png',
        'src': '960px-Emayatzy_Corinealdi_at_EssenceFest_2025.jpg',
        'role': 'Procureur Fédéral (Emayatzy Corinealdi)',
        'faction': 'street',
        'focus_y': 0.30,
        'crop_scale': 0.65,
    },
    'ST_046': {
        'target': 'assets/images/characters/street/ST_046_Collectif_Danseuses.png',
        'src': '960px-Schelle_Purcell_at_EssenceFest_2025.jpg',
        'role': 'Collectif des Danseuses (Schelle Purcell)',
        'faction': 'street',
        'focus_y': 0.32,
        'crop_scale': 0.65,
    },
    'ST_047': {
        'target': 'assets/images/characters/street/ST_047_Le_Greffier.png',
        'src': '960px-Aisha_Tyler_by_Gage_Skidmore.jpg',
        'role': 'Le Greffier (Aisha Tyler)',
        'faction': 'street',
        'focus_y': 0.35,
        'crop_scale': 0.65,
    },
    'ST_050': {
        'target': 'assets/images/characters/street/ST_050_Kimmie.png',
        'src': '960px-Taylor_Polidore_on_2025_Essence_Festival_of_Culture_Carpet_%28cropped%29.jpg',
        'role': 'Kimmie (Taylor Polidore Williams)',
        'faction': 'street',
        'focus_y': 0.38,
        'crop_scale': 0.70,
    },

    # -------------------------------------------------------------------------
    # EMPIRE CAMPAIGN (32 Interlocutors)
    # -------------------------------------------------------------------------
    'EM_001': {
        'target': 'assets/images/characters/empire/EM_001_Directeur_Financier.png',
        'src': '960px-DeVon_Franklin_on_2025_Essence_Festival_of_Culture_Carpet_%28cropped%29.jpg',
        'role': 'Directeur Financier (DeVon Franklin)',
        'faction': 'empire',
        'focus_y': 0.30,
        'crop_scale': 0.65,
    },
    'EM_002': {
        'target': 'assets/images/characters/empire/EM_002_Horace_Bell.png',
        'src': '960px-Ricco_Ross_at_EssenceFest_2025_-_cropped.jpg',
        'role': 'Horace Bell (Ricco Ross)',
        'faction': 'empire',
        'focus_y': 0.35,
        'crop_scale': 0.65,
    },
    'EM_003': {
        'target': 'assets/images/characters/empire/EM_003_Chimiste_Chef.png',
        'src': '960px-Jeffrey_Wright_by_Gage_Skidmore.jpg',
        'role': 'Chimiste en Chef (Jeffrey Wright)',
        'faction': 'empire',
        'focus_y': 0.35,
        'crop_scale': 0.65,
    },
    'EM_004': {
        'target': 'assets/images/characters/empire/EM_004_Roy_Bell.png',
        'src': '960px-Julian_Horton_at_EssenceFest_2025_%28cropped%29.jpg',
        'role': 'Roy Bell (Julian Horton)',
        'faction': 'empire',
        'focus_y': 0.38,
        'crop_scale': 0.70,
    },
    'EM_005': {
        'target': 'assets/images/characters/empire/EM_005_Journaliste_TV.png',
        'src': '960px-Rosario_Dawson_by_Gage_Skidmore.jpg',
        'role': 'Journaliste TV (Rosario Dawson)',
        'faction': 'empire',
        'focus_y': 0.35,
        'crop_scale': 0.65,
    },
    'EM_006': {
        'target': 'assets/images/characters/empire/EM_006_Procureur_Miller.png',
        'src': '960px-Sterling_K._Brown_by_Gage_Skidmore.jpg',
        'role': 'Procureur Miller (Sterling K. Brown)',
        'faction': 'empire',
        'focus_y': 0.35,
        'crop_scale': 0.60,
    },
    'EM_008': {
        'target': 'assets/images/characters/empire/EM_008_Jules_Bell.png',
        'src': '960px-Maxwell_Essence_Festival_of_Culture_2025.jpg',
        'role': 'Jules Bell (Maxwell)',
        'faction': 'empire',
        'focus_y': 0.36,
        'crop_scale': 0.60,
    },
    'EM_010': {
        'target': 'assets/images/characters/empire/EM_010_Raid_Fiscal.png',
        'src': '960px-2024_RNC_Swat_assemble.jpg',
        'role': 'Raid Fiscal',
        'faction': 'empire',
        'focus_y': 0.50,
        'crop_scale': 1.0,
    },
    'EM_013': {
        'target': 'assets/images/characters/empire/EM_013_Directrice_Marketing.png',
        'src': '960px-Bozoma_Saint_John_at_Essence_Festival_of_Culture_July_2025_%28cropped%29.jpg',
        'role': 'Directrice Marketing (Bozoma Saint John)',
        'faction': 'empire',
        'focus_y': 0.32,
        'crop_scale': 0.65,
    },
    'EM_014': {
        'target': 'assets/images/characters/empire/EM_014_Commissaire_District.png',
        'src': '960px-Lance_Reddick_by_Gage_Skidmore.jpg',
        'role': 'Commissaire du District (Lance Reddick)',
        'faction': 'empire',
        'focus_y': 0.35,
        'crop_scale': 0.65,
    },
    'EM_016': {
        'target': 'assets/images/characters/empire/EM_016_Conseil_Administration.png',
        'src': '960px-Djimon_Hounsou_by_Gage_Skidmore.jpg',
        'role': 'Conseil d\'Administration (Djimon Hounsou)',
        'faction': 'empire',
        'focus_y': 0.35,
        'crop_scale': 0.65,
    },
    'EM_017': {
        'target': 'assets/images/characters/empire/EM_017_Banquier_Suisse.png',
        'src': '960px-Morris_Chestnut_in_2010_by_Gage_Skidmore.jpg',
        'role': 'Banquier Suisse (Morris Chestnut)',
        'faction': 'empire',
        'focus_y': 0.35,
        'crop_scale': 0.65,
    },
    'EM_019': {
        'target': 'assets/images/characters/empire/EM_019_Journaliste_Times.png',
        'src': '960px-Zoe_Saldana_by_Gage_Skidmore.jpg',
        'role': 'Journaliste du Times (Zoe Saldana)',
        'faction': 'empire',
        'focus_y': 0.35,
        'crop_scale': 0.65,
    },
    'EM_020': {
        'target': 'assets/images/characters/empire/EM_020_Ligne_Urgence.png',
        'src': '960px-CCTV_control_room_monitor_wall.jpg',
        'role': 'Ligne d\'Urgence Bell',
        'faction': 'empire',
        'focus_y': 0.50,
        'crop_scale': 1.0,
    },
    'EM_021': {
        'target': 'assets/images/characters/empire/EM_021_Don_Salazar.png',
        'src': '960px-Pedro_Pascal_by_Gage_Skidmore.jpg',
        'role': 'Don Salazar (Pedro Pascal)',
        'faction': 'empire',
        'focus_y': 0.35,
        'crop_scale': 0.60,
    },
    'EM_022': {
        'target': 'assets/images/characters/empire/EM_022_Silas.png',
        'src': '960px-Winston_Duke_by_Gage_Skidmore.jpg',
        'role': 'Silas (Winston Duke)',
        'faction': 'empire',
        'focus_y': 0.35,
        'crop_scale': 0.65,
    },
    'EM_024': {
        'target': 'assets/images/characters/empire/EM_024_Juge_Vandermeer.png',
        'src': '960px-Erika_Alexander_at_EssenceFest_2025_-_cropped.jpg',
        'role': 'Juge Vandermeer (Erika Alexander)',
        'faction': 'empire',
        'focus_y': 0.32,
        'crop_scale': 0.65,
    },
    'EM_027': {
        'target': 'assets/images/characters/empire/EM_027_Archiviste.png',
        'src': '960px-Giancarlo_Esposito_by_Gage_Skidmore.jpg',
        'role': 'L\'Archiviste des Bell (Giancarlo Esposito)',
        'faction': 'empire',
        'focus_y': 0.35,
        'crop_scale': 0.65,
    },
    'EM_028': {
        'target': 'assets/images/characters/empire/EM_028_Analyste_Financier.png',
        'src': '960px-Yahya_Abdul-Mateen_II_by_Gage_Skidmore.jpg',
        'role': 'Analyste Financier (Yahya Abdul-Mateen II)',
        'faction': 'empire',
        'focus_y': 0.35,
        'crop_scale': 0.65,
    },
    'EM_030': {
        'target': 'assets/images/characters/empire/EM_030_Reseau_SWIFT.png',
        'src': '960px-CCTV_control_room_monitor_wall.jpg',
        'role': 'Réseau SWIFT',
        'faction': 'empire',
        'focus_y': 0.50,
        'crop_scale': 1.0,
    },
    'EM_031': {
        'target': 'assets/images/characters/empire/EM_031_President_Tribunal.png',
        'src': '960px-Forest_Whitaker_by_Gage_Skidmore.jpg',
        'role': 'Président du Tribunal (Forest Whitaker)',
        'faction': 'empire',
        'focus_y': 0.35,
        'crop_scale': 0.65,
    },
    'EM_036': {
        'target': 'assets/images/characters/empire/EM_036_Mandataire_Judiciaire.png',
        'src': '960px-David_Ramsey_by_Gage_Skidmore.jpg',
        'role': 'Mandataire Judiciaire (David Ramsey)',
        'faction': 'empire',
        'focus_y': 0.35,
        'crop_scale': 0.60,
    },
    'EM_038': {
        'target': 'assets/images/characters/empire/EM_038_Maitre_Sterling.png',
        'src': '960px-Chiwetel_Ejiofor_by_Gage_Skidmore.jpg',
        'role': 'Maître Sterling (Chiwetel Ejiofor)',
        'faction': 'empire',
        'focus_y': 0.35,
        'crop_scale': 0.65,
    },
    'EM_039': {
        'target': 'assets/images/characters/empire/EM_039_Attache_Presse.png',
        'src': '960px-Nathalie_Emmanuel_by_Gage_Skidmore.jpg',
        'role': 'Attaché de Presse (Nathalie Emmanuel)',
        'faction': 'empire',
        'focus_y': 0.35,
        'crop_scale': 0.65,
    },
    'EM_040': {
        'target': 'assets/images/characters/empire/EM_040_Salle_Attente.png',
        'src': '960px-Main_hallway_of_the_Conway_County_Courthouse_in_Morrilton%2C_AR.jpg',
        'role': 'Salle d\'Attente Fédérale',
        'faction': 'empire',
        'focus_y': 0.50,
        'crop_scale': 1.0,
    },
    'EM_041': {
        'target': 'assets/images/characters/empire/EM_041_Greffier_Federal.png',
        'src': '960px-Aisha_Tyler_by_Gage_Skidmore.jpg',
        'role': 'Greffier Fédéral (Aisha Tyler)',
        'faction': 'empire',
        'focus_y': 0.35,
        'crop_scale': 0.65,
    },
    'EM_043': {
        'target': 'assets/images/characters/empire/EM_043_Chef_Marque_Luxe.png',
        'src': '960px-Yandy_Smith_at_EssenceFest_2025.jpg',
        'role': 'Chef de Marque Luxe (Yandy Smith)',
        'faction': 'empire',
        'focus_y': 0.28,
        'crop_scale': 0.60,
    },
    'EM_045': {
        'target': 'assets/images/characters/empire/EM_045_Commissaire_Priseur.png',
        'src': '960px-Morris_Chestnut_in_2010_by_Gage_Skidmore.jpg',
        'role': 'Commissaire-Priseur (Morris Chestnut)',
        'faction': 'empire',
        'focus_y': 0.35,
        'crop_scale': 0.65,
    },
    'EM_046': {
        'target': 'assets/images/characters/empire/EM_046_Consortium_Asie.png',
        'src': '960px-Anthony_Mackie_by_Gage_Skidmore.jpg',
        'role': 'Consortium d\'Asie (Anthony Mackie)',
        'faction': 'empire',
        'focus_y': 0.35,
        'crop_scale': 0.65,
    },
    'EM_047': {
        'target': 'assets/images/characters/empire/EM_047_Gouverneur.png',
        'src': '960px-Colman_Domingo_by_Gage_Skidmore.jpg',
        'role': 'Le Gouverneur (Colman Domingo)',
        'faction': 'empire',
        'focus_y': 0.35,
        'crop_scale': 0.65,
    },
    'EM_049': {
        'target': 'assets/images/characters/empire/EM_049_President_Sommet.png',
        'src': '960px-Forest_Whitaker_by_Gage_Skidmore.jpg',
        'role': 'Président du Sommet (Forest Whitaker)',
        'faction': 'empire',
        'focus_y': 0.35,
        'crop_scale': 0.65,
    },
    'EM_050': {
        'target': 'assets/images/characters/empire/EM_050_Mallory_Bell.png',
        'src': '960px-Miss_USA_Crystle_Stewart_at_Mercedes-Benz_Fashion_Week.jpg',
        'role': 'Mallory Bell (Crystle Stewart)',
        'faction': 'empire',
        'focus_y': 0.28,
        'crop_scale': 0.70,
    },
}

def process_portrait(src_path, dst_path, faction='street', focus_y=0.35, crop_scale=0.65):
    im = Image.open(src_path).convert('RGB')
    w, h = im.size
    
    # Target aspect ratio 3:4 (480 x 640)
    target_aspect = 480 / 640  # 0.75
    
    # Calculate crop box centered on focus_y
    if crop_scale < 1.0:
        # Scale down the view area to zoom tightly on head & face
        crop_h = int(h * crop_scale)
        crop_w = int(crop_h * target_aspect)
        if crop_w > w:
            crop_w = w
            crop_h = int(w / target_aspect)
            
        center_x = w // 2
        center_y = int(h * focus_y)
        
        left = max(0, center_x - crop_w // 2)
        top = max(0, center_y - crop_h // 2)
        
        if left + crop_w > w:
            left = max(0, w - crop_w)
        if top + crop_h > h:
            top = max(0, h - crop_h)
            
        cropped = im.crop((left, top, min(w, left + crop_w), min(h, top + crop_h)))
    else:
        # Full landscape or environmental image -> standard 3:4 crop
        img_aspect = w / h
        if img_aspect > target_aspect:
            crop_h = h
            crop_w = int(h * target_aspect)
            left = max(0, (w - crop_w) // 2)
            top = 0
        else:
            crop_w = w
            crop_h = int(w / target_aspect)
            left = 0
            center_y = int(h * focus_y)
            top = max(0, center_y - crop_h // 2)
            if top + crop_h > h:
                top = max(0, h - crop_h)
        cropped = im.crop((left, top, min(w, left + crop_w), min(h, top + crop_h)))
        
    resized = cropped.resize((480, 640), Image.Resampling.LANCZOS)
    
    # Dark Luxury Neo-Noir Grading
    if faction == 'street':
        enhancer = ImageEnhance.Contrast(resized)
        graded = enhancer.enhance(1.22)
        enhancer = ImageEnhance.Color(graded)
        graded = enhancer.enhance(1.10)
        bg_color = (10, 11, 16)  # Deep obsidian noir
    else:
        enhancer = ImageEnhance.Contrast(resized)
        graded = enhancer.enhance(1.25)
        enhancer = ImageEnhance.Color(graded)
        graded = enhancer.enhance(1.15)
        bg_color = (12, 10, 8)   # Deep rich dark bronze/gold obsidian

    # Subtle radial feather vignette to dissolve edges into the dark luxury card frame
    mask = Image.new('L', (480, 640), 0)
    draw = ImageDraw.Draw(mask)
    draw.ellipse([(-70, -50), (550, 580)], fill=255)
    mask = mask.filter(ImageFilter.GaussianBlur(75))
    
    bg = Image.new('RGB', (480, 640), bg_color)
    final = Image.composite(graded, bg, mask)
    
    os.makedirs(os.path.dirname(dst_path), exist_ok=True)
    final.save(dst_path, 'PNG', optimize=True)
    return True

def main():
    print("=== DÉMARRAGE DU PIPELINE DE PRODUCTION BEAUTY IN BLACK ===")
    success_count = 0
    
    for cid, conf in PORTRAIT_CONFIG.items():
        src_path = os.path.join(CACHE_DIR, conf['src'])
        if not os.path.exists(src_path):
            print(f"ERREUR: Fichier source manquant: {src_path}")
            continue
            
        dst_path = conf['target']
        faction = conf['faction']
        focus_y = conf.get('focus_y', 0.35)
        crop_scale = conf.get('crop_scale', 0.65)
        
        try:
            process_portrait(src_path, dst_path, faction, focus_y, crop_scale)
            success_count += 1
            sz = os.path.getsize(dst_path) // 1024
            print(f"[{success_count:02d}/60] OK : {cid} -> {dst_path} ({sz} KB) [{conf['role']}]")
        except Exception as e:
            print(f"ERREUR sur {cid}: {e}")
            
    # Default Universal Character Fallback
    default_dst = 'assets/images/characters/default_character.png'
    kimmie_src = 'assets/images/characters/street/ST_050_Kimmie.png'
    if os.path.exists(kimmie_src):
        im = Image.open(kimmie_src)
        im.save(default_dst, 'PNG', optimize=True)
        print(f"[OK] Universal fallback: {default_dst}")
        
    print(f"\nFIN DU TRAITEMENT : {success_count} / {len(PORTRAIT_CONFIG)} portraits générés avec succès !")

if __name__ == '__main__':
    main()
