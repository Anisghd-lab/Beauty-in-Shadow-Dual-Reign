import os
import sys
import json
import urllib.request
import urllib.parse
from PIL import Image, ImageEnhance, ImageFilter, ImageOps

# Mapping of canonical character ID to target file and Wikimedia File title or direct URL
ASSET_MAPPINGS = {
    # -------------------------------------------------------------
    # STREET CAMPAIGN (28 items)
    # -------------------------------------------------------------
    'ST_001': {
        'path': 'assets/images/characters/street/ST_001_Mere_Kimmie.png',
        'file': 'File:Debbi Morgan (1984).jpg',
        'role': 'Mère de Kimmie',
        'faction': 'street',
        'focus_y': 0.35
    },
    'ST_002': {
        'path': 'assets/images/characters/street/ST_002_Gerant_Motel.png',
        'file': 'File:Bokeem Woodbine by Gage Skidmore.jpg',
        'fallback_file': 'File:David Ramsey by Gage Skidmore.jpg',
        'role': 'Gérant du Motel',
        'faction': 'street',
        'focus_y': 0.35
    },
    'ST_003': {
        'path': 'assets/images/characters/street/ST_003_Gerant_Club.png',
        'file': 'File:Anthony Mackie by Gage Skidmore.jpg',
        'role': 'Gérant du Club',
        'faction': 'street',
        'focus_y': 0.35
    },
    'ST_004': {
        'path': 'assets/images/characters/street/ST_004_Rain.png',
        'file': 'File:Tessa Thompson by Gage Skidmore.jpg',
        'role': 'Rain',
        'faction': 'street',
        'focus_y': 0.35
    },
    'ST_005': {
        'path': 'assets/images/characters/street/ST_005_Norman.png',
        'file': 'File:RichardLawsonBlackFist.JPG',
        'role': 'Norman (Richard Lawson)',
        'faction': 'street',
        'focus_y': 0.40
    },
    'ST_006': {
        'path': 'assets/images/characters/street/ST_006_Petite_Soeur.png',
        'file': 'File:Letitia Wright by Gage Skidmore.jpg',
        'role': 'Petite Sœur',
        'faction': 'street',
        'focus_y': 0.35
    },
    'ST_007': {
        'path': 'assets/images/characters/street/ST_007_Client_Emeche.png',
        'file': 'File:John Boyega by Gage Skidmore.jpg',
        'role': 'Client Éméché',
        'faction': 'street',
        'focus_y': 0.35
    },
    'ST_008': {
        'path': 'assets/images/characters/street/ST_008_Controle_Police.png',
        'file': 'File:Mike Colter by Gage Skidmore.jpg',
        'role': 'Contrôle de Police',
        'faction': 'street',
        'focus_y': 0.35
    },
    'ST_009': {
        'path': 'assets/images/characters/street/ST_009_Gillian.png',
        'file': 'File:Sanaa Lathan by Gage Skidmore.jpg',
        'role': 'Gillian',
        'faction': 'street',
        'focus_y': 0.35
    },
    'ST_010': {
        'path': 'assets/images/characters/street/ST_010_Detective_Davis.png',
        'file': 'File:Mahershala Ali by Gage Skidmore.jpg',
        'role': 'Détective Davis',
        'faction': 'street',
        'focus_y': 0.35
    },
    'ST_013': {
        'path': 'assets/images/characters/street/ST_013_Banquette_VIP.png',
        'file': 'File:CocoonClub - VIP Coccon.jpg',
        'role': 'Banquette VIP',
        'faction': 'street',
        'focus_y': 0.50
    },
    'ST_015': {
        'path': 'assets/images/characters/street/ST_015_Cipher.png',
        'file': 'File:Caleb McLaughlin by Gage Skidmore.jpg',
        'role': 'Cipher',
        'faction': 'street',
        'focus_y': 0.35
    },
    'ST_020': {
        'path': 'assets/images/characters/street/ST_020_Sbires_Bell.png',
        'file': 'File:David Ramsey by Gage Skidmore.jpg',
        'role': 'Sbires Bell',
        'faction': 'street',
        'focus_y': 0.35
    },
    'ST_021': {
        'path': 'assets/images/characters/street/ST_021_Receptionniste.png',
        'file': 'File:Lupita Nyong\'o by Gage Skidmore.jpg',
        'role': 'Réceptionniste de Luxe',
        'faction': 'street',
        'focus_y': 0.35
    },
    'ST_024': {
        'path': 'assets/images/characters/street/ST_024_Agent_Corrompu.png',
        'file': 'File:Daniel Kaluuya by Gage Skidmore.jpg',
        'role': 'Agent Corrompu',
        'faction': 'street',
        'focus_y': 0.35
    },
    'ST_027': {
        'path': 'assets/images/characters/street/ST_027_Videosurveillance.png',
        'file': 'File:CCTV control room monitor wall.jpg',
        'role': 'Vidéosurveillance',
        'faction': 'street',
        'focus_y': 0.50
    },
    'ST_028': {
        'path': 'assets/images/characters/street/ST_028_Marco.png',
        'file': 'File:Yahya Abdul-Mateen II by Gage Skidmore.jpg',
        'role': 'Marco',
        'faction': 'street',
        'focus_y': 0.35
    },
    'ST_030': {
        'path': 'assets/images/characters/street/ST_030_Panne_Secteur.png',
        'file': 'File:Blackout Flatiron (8147572701).jpg',
        'role': 'Panne de Secteur',
        'faction': 'street',
        'focus_y': 0.50
    },
    'ST_032': {
        'path': 'assets/images/characters/street/ST_032_Incendie_Velvet.png',
        'file': 'File:Fire engine crews receiving night operations briefing for Bear Fire 03.jpg',
        'role': 'L\'Incendie du Velvet',
        'faction': 'street',
        'focus_y': 0.50
    },
    'ST_033': {
        'path': 'assets/images/characters/street/ST_033_Sbire_Arme.png',
        'file': 'File:Terry Crews by Gage Skidmore.jpg',
        'role': 'Sbire Armé',
        'faction': 'street',
        'focus_y': 0.35
    },
    'ST_035': {
        'path': 'assets/images/characters/street/ST_035_SWAT_Pompiers.png',
        'file': 'File:2024 RNC Swat assemble.jpg',
        'role': 'SWAT & Pompiers',
        'faction': 'street',
        'focus_y': 0.50
    },
    'ST_040': {
        'path': 'assets/images/characters/street/ST_040_Chambre_Forte.png',
        'file': 'File:Bank vault door.jpg',
        'role': 'Chambre Forte Bell',
        'faction': 'street',
        'focus_y': 0.50
    },
    'ST_041': {
        'path': 'assets/images/characters/street/ST_041_President_Jury.png',
        'file': 'File:Forest Whitaker by Gage Skidmore.jpg',
        'role': 'Président du Jury',
        'faction': 'street',
        'focus_y': 0.35
    },
    'ST_042': {
        'path': 'assets/images/characters/street/ST_042_Avocat_Bell.png',
        'file': 'File:Chiwetel Ejiofor by Gage Skidmore.jpg',
        'role': 'Avocat des Bell',
        'faction': 'street',
        'focus_y': 0.35
    },
    'ST_044': {
        'path': 'assets/images/characters/street/ST_044_Procureur_Federal.png',
        'file': 'File:Regina King by Gage Skidmore.jpg',
        'role': 'Procureur Fédéral',
        'faction': 'street',
        'focus_y': 0.35
    },
    'ST_046': {
        'path': 'assets/images/characters/street/ST_046_Collectif_Danseuses.png',
        'file': 'File:Danai Gurira by Gage Skidmore.jpg',
        'role': 'Collectif des Danseuses',
        'faction': 'street',
        'focus_y': 0.35
    },
    'ST_047': {
        'path': 'assets/images/characters/street/ST_047_Le_Greffier.png',
        'file': 'File:Aisha Tyler by Gage Skidmore.jpg',
        'role': 'Le Greffier',
        'faction': 'street',
        'focus_y': 0.35
    },
    'ST_050': {
        'path': 'assets/images/characters/street/ST_050_Kimmie.png',
        'file': 'File:Taylor Polidore on 2025 Essence Festival of Culture Carpet (cropped).jpg',
        'role': 'Kimmie (Taylor Polidore Williams)',
        'faction': 'street',
        'focus_y': 0.38
    },

    # -------------------------------------------------------------
    # EMPIRE CAMPAIGN (32 items)
    # -------------------------------------------------------------
    'EM_001': {
        'path': 'assets/images/characters/empire/EM_001_Directeur_Financier.png',
        'file': 'File:Colman Domingo by Gage Skidmore.jpg',
        'role': 'Directeur Financier',
        'faction': 'empire',
        'focus_y': 0.35
    },
    'EM_002': {
        'path': 'assets/images/characters/empire/EM_002_Horace_Bell.png',
        'file': 'File:Ricco Ross at EssenceFest 2025 - cropped.jpg',
        'role': 'Horace Bell (Ricco Ross)',
        'faction': 'empire',
        'focus_y': 0.35
    },
    'EM_003': {
        'path': 'assets/images/characters/empire/EM_003_Chimiste_Chef.png',
        'file': 'File:Jeffrey Wright by Gage Skidmore.jpg',
        'role': 'Chimiste en Chef',
        'faction': 'empire',
        'focus_y': 0.35
    },
    'EM_004': {
        'path': 'assets/images/characters/empire/EM_004_Roy_Bell.png',
        'file': 'File:Julian Horton at EssenceFest 2025 (cropped).jpg',
        'role': 'Roy Bell (Julian Horton)',
        'faction': 'empire',
        'focus_y': 0.38
    },
    'EM_005': {
        'path': 'assets/images/characters/empire/EM_005_Journaliste_TV.png',
        'file': 'File:Rosario Dawson by Gage Skidmore.jpg',
        'role': 'Journaliste TV',
        'faction': 'empire',
        'focus_y': 0.35
    },
    'EM_006': {
        'path': 'assets/images/characters/empire/EM_006_Procureur_Miller.png',
        'file': 'File:Sterling K. Brown by Gage Skidmore.jpg',
        'role': 'Procureur Miller',
        'faction': 'empire',
        'focus_y': 0.35
    },
    'EM_008': {
        'path': 'assets/images/characters/empire/EM_008_Jules_Bell.png',
        'file': 'File:Michael B. Jordan by Gage Skidmore.jpg',
        'role': 'Jules Bell',
        'faction': 'empire',
        'focus_y': 0.35
    },
    'EM_010': {
        'path': 'assets/images/characters/empire/EM_010_Raid_Fiscal.png',
        'file': 'File:2024 RNC Swat assemble.jpg',
        'role': 'Raid Fiscal',
        'faction': 'empire',
        'focus_y': 0.50
    },
    'EM_013': {
        'path': 'assets/images/characters/empire/EM_013_Directrice_Marketing.png',
        'file': 'File:Garcelle Beauvais by Gage Skidmore.jpg',
        'role': 'Directrice Marketing',
        'faction': 'empire',
        'focus_y': 0.35
    },
    'EM_014': {
        'path': 'assets/images/characters/empire/EM_014_Commissaire_District.png',
        'file': 'File:Lance Reddick by Gage Skidmore.jpg',
        'role': 'Commissaire du District',
        'faction': 'empire',
        'focus_y': 0.35
    },
    'EM_016': {
        'path': 'assets/images/characters/empire/EM_016_Conseil_Administration.png',
        'file': 'File:Djimon Hounsou by Gage Skidmore.jpg',
        'role': 'Conseil d\'Administration',
        'faction': 'empire',
        'focus_y': 0.35
    },
    'EM_017': {
        'path': 'assets/images/characters/empire/EM_017_Banquier_Suisse.png',
        'file': 'File:Morris Chestnut by Gage Skidmore.jpg',
        'role': 'Banquier Suisse',
        'faction': 'empire',
        'focus_y': 0.35
    },
    'EM_019': {
        'path': 'assets/images/characters/empire/EM_019_Journaliste_Times.png',
        'file': 'File:Zoe Saldana by Gage Skidmore.jpg',
        'role': 'Journaliste du Times',
        'faction': 'empire',
        'focus_y': 0.35
    },
    'EM_020': {
        'path': 'assets/images/characters/empire/EM_020_Ligne_Urgence.png',
        'file': 'File:CCTV control room monitor wall.jpg',
        'role': 'Ligne d\'Urgence Bell',
        'faction': 'empire',
        'focus_y': 0.50
    },
    'EM_021': {
        'path': 'assets/images/characters/empire/EM_021_Don_Salazar.png',
        'file': 'File:Pedro Pascal by Gage Skidmore.jpg',
        'role': 'Don Salazar',
        'faction': 'empire',
        'focus_y': 0.35
    },
    'EM_022': {
        'path': 'assets/images/characters/empire/EM_022_Silas.png',
        'file': 'File:Winston Duke by Gage Skidmore.jpg',
        'role': 'Silas',
        'faction': 'empire',
        'focus_y': 0.35
    },
    'EM_024': {
        'path': 'assets/images/characters/empire/EM_024_Juge_Vandermeer.png',
        'file': 'File:Viola Davis by Gage Skidmore.jpg',
        'role': 'Juge Vandermeer',
        'faction': 'empire',
        'focus_y': 0.35
    },
    'EM_027': {
        'path': 'assets/images/characters/empire/EM_027_Archiviste.png',
        'file': 'File:Giancarlo Esposito by Gage Skidmore.jpg',
        'role': 'L\'Archiviste des Bell',
        'faction': 'empire',
        'focus_y': 0.35
    },
    'EM_028': {
        'path': 'assets/images/characters/empire/EM_028_Analyste_Financier.png',
        'file': 'File:Yahya Abdul-Mateen II by Gage Skidmore.jpg',
        'role': 'Analyste Financier',
        'faction': 'empire',
        'focus_y': 0.35
    },
    'EM_030': {
        'path': 'assets/images/characters/empire/EM_030_Reseau_SWIFT.png',
        'file': 'File:CCTV control room monitor wall.jpg',
        'role': 'Réseau SWIFT',
        'faction': 'empire',
        'focus_y': 0.50
    },
    'EM_031': {
        'path': 'assets/images/characters/empire/EM_031_President_Tribunal.png',
        'file': 'File:Forest Whitaker by Gage Skidmore.jpg',
        'role': 'Président du Tribunal',
        'faction': 'empire',
        'focus_y': 0.35
    },
    'EM_036': {
        'path': 'assets/images/characters/empire/EM_036_Mandataire_Judiciaire.png',
        'file': 'File:David Ramsey by Gage Skidmore.jpg',
        'role': 'Mandataire Judiciaire',
        'faction': 'empire',
        'focus_y': 0.35
    },
    'EM_038': {
        'path': 'assets/images/characters/empire/EM_038_Maitre_Sterling.png',
        'file': 'File:Chiwetel Ejiofor by Gage Skidmore.jpg',
        'role': 'Maître Sterling',
        'faction': 'empire',
        'focus_y': 0.35
    },
    'EM_039': {
        'path': 'assets/images/characters/empire/EM_039_Attache_Presse.png',
        'file': 'File:Nathalie Emmanuel by Gage Skidmore.jpg',
        'role': 'Attaché de Presse',
        'faction': 'empire',
        'focus_y': 0.35
    },
    'EM_040': {
        'path': 'assets/images/characters/empire/EM_040_Salle_Attente.png',
        'file': 'File:Main hallway of the Conway County Courthouse in Morrilton, AR.jpg',
        'role': 'Salle d\'Attente Fédérale',
        'faction': 'empire',
        'focus_y': 0.50
    },
    'EM_041': {
        'path': 'assets/images/characters/empire/EM_041_Greffier_Federal.png',
        'file': 'File:Aisha Tyler by Gage Skidmore.jpg',
        'role': 'Greffier Fédéral',
        'faction': 'empire',
        'focus_y': 0.35
    },
    'EM_043': {
        'path': 'assets/images/characters/empire/EM_043_Chef_Marque_Luxe.png',
        'file': 'File:Keke Palmer by Gage Skidmore.jpg',
        'role': 'Chef de Marque Luxe',
        'faction': 'empire',
        'focus_y': 0.35
    },
    'EM_045': {
        'path': 'assets/images/characters/empire/EM_045_Commissaire_Priseur.png',
        'file': 'File:Morris Chestnut by Gage Skidmore.jpg',
        'role': 'Commissaire-Priseur',
        'faction': 'empire',
        'focus_y': 0.35
    },
    'EM_046': {
        'path': 'assets/images/characters/empire/EM_046_Consortium_Asie.png',
        'file': 'File:Anthony Mackie by Gage Skidmore.jpg',
        'role': 'Consortium d\'Asie',
        'faction': 'empire',
        'focus_y': 0.35
    },
    'EM_047': {
        'path': 'assets/images/characters/empire/EM_047_Gouverneur.png',
        'file': 'File:Colman Domingo by Gage Skidmore.jpg',
        'role': 'Le Gouverneur',
        'faction': 'empire',
        'focus_y': 0.35
    },
    'EM_049': {
        'path': 'assets/images/characters/empire/EM_049_President_Sommet.png',
        'file': 'File:Forest Whitaker by Gage Skidmore.jpg',
        'role': 'Président du Sommet',
        'faction': 'empire',
        'focus_y': 0.35
    },
    'EM_050': {
        'path': 'assets/images/characters/empire/EM_050_Mallory_Bell.png',
        'file': 'File:Miss USA Crystle Stewart at Mercedes-Benz Fashion Week.jpg',
        'role': 'Mallory Bell (Crystle Stewart)',
        'faction': 'empire',
        'focus_y': 0.28
    },
}

CACHE_DIR = '/tmp/wikimedia_cache'
os.makedirs(CACHE_DIR, exist_ok=True)

def resolve_wikimedia_urls(file_titles):
    headers = {'User-Agent': 'BeautyInBlackGame/1.0 (https://github.com/Anisghd-lab/Beauty-in-Shadow-Dual-Reign; dev@beautyinblack.game)'}
    urls = {}
    
    chunk_size = 15
    titles_list = list(file_titles)
    for i in range(0, len(titles_list), chunk_size):
        chunk = titles_list[i:i + chunk_size]
        query_str = '|'.join(urllib.parse.quote(t) for t in chunk)
        api_url = f'https://commons.wikimedia.org/w/api.php?action=query&titles={query_str}&prop=imageinfo&iiprop=url&iiurlwidth=800&format=json'
        req = urllib.request.Request(api_url, headers=headers)
        try:
            with urllib.request.urlopen(req) as resp:
                data = json.loads(resp.read().decode('utf-8'))
                for pid, p in data.get('query', {}).get('pages', {}).items():
                    title = p.get('title')
                    info = p.get('imageinfo', [{}])[0]
                    thumb = info.get('thumburl') or info.get('url')
                    if thumb:
                        urls[title] = thumb
        except Exception as e:
            print(f'Batch resolution error: {e}')
    return urls

def download_file(url, target_path):
    if os.path.exists(target_path) and os.path.getsize(target_path) > 1000:
        return True
    headers = {'User-Agent': 'BeautyInBlackGame/1.0 (https://github.com/Anisghd-lab/Beauty-in-Shadow-Dual-Reign; dev@beautyinblack.game)'}
    req = urllib.request.Request(url, headers=headers)
    try:
        with urllib.request.urlopen(req) as resp, open(target_path, 'wb') as out:
            out.write(resp.read())
        return True
    except Exception as e:
        print(f'Error downloading {url}: {e}')
        return False

def grade_and_crop(src_path, dst_path, faction='street', focus_y=0.35):
    try:
        im = Image.open(src_path).convert('RGB')
        w, h = im.size
        
        # Calculate bounding box for 480x640 (aspect ratio 3:4)
        target_ratio = 480 / 640  # 0.75
        img_ratio = w / h
        
        if img_ratio > target_ratio:
            # Image is wider than 3:4 -> crop width
            crop_h = h
            crop_w = int(h * target_ratio)
            left = max(0, (w - crop_w) // 2)
            top = 0
        else:
            # Image is taller than 3:4 -> crop height centered on focus_y
            crop_w = w
            crop_h = int(w / target_ratio)
            left = 0
            center_y = int(h * focus_y)
            top = max(0, center_y - crop_h // 2)
            if top + crop_h > h:
                top = max(0, h - crop_h)
                
        cropped = im.crop((left, top, min(w, left + crop_w), min(h, top + crop_h)))
        resized = cropped.resize((480, 640), Image.Resampling.LANCZOS)
        
        # Apply dark-luxury neo-noir grading tailored to faction
        if faction == 'street':
            # Neo-noir night atmosphere: deep blacks, punchy highlights, cool shadows
            enhancer = ImageEnhance.Contrast(resized)
            graded = enhancer.enhance(1.22)
            enhancer = ImageEnhance.Color(graded)
            graded = enhancer.enhance(1.10)
            
            # Subtle vignette
            vignette = Image.new('L', (480, 640), 255)
            # Vignette effect
            v_draw = Image.new('RGBA', (480, 640), (0, 0, 0, 0))
        else:
            # Empire luxury gold atmosphere: rich warm tones, glossy high contrast
            enhancer = ImageEnhance.Contrast(resized)
            graded = enhancer.enhance(1.25)
            enhancer = ImageEnhance.Color(graded)
            graded = enhancer.enhance(1.15)
            
        os.makedirs(os.path.dirname(dst_path), exist_ok=True)
        graded.save(dst_path, 'PNG', optimize=True)
        return True
    except Exception as e:
        print(f'Error grading {src_path} -> {dst_path}: {e}')
        return False

import time

def main():
    print("=== DÉMARRAGE DE L'INTÉGRATION PHOTOGRAPHIQUE 8K BEAUTY IN BLACK ===")
    
    # 1. Resolve URLs
    all_files = set()
    for item in ASSET_MAPPINGS.values():
        all_files.add(item['file'])
        if 'fallback_file' in item:
            all_files.add(item['fallback_file'])
            
    print(f"Résolution de {len(all_files)} fichiers sources Wikimedia...")
    resolved = resolve_wikimedia_urls(all_files)
    print(f"Résolus avec succès: {len(resolved)} / {len(all_files)}")
    
    # Pre-select verified emergency fallbacks
    street_fallback_url = resolved.get('File:Taylor Polidore on 2025 Essence Festival of Culture Carpet (cropped).jpg') or resolved.get('File:Anthony Mackie by Gage Skidmore.jpg')
    empire_fallback_url = resolved.get('File:Miss USA Crystle Stewart at Mercedes-Benz Fashion Week.jpg') or resolved.get('File:Julian Horton at EssenceFest 2025 (cropped).jpg')

    # 2. Download and grade each asset
    success_count = 0
    for char_id, conf in ASSET_MAPPINGS.items():
        file_title = conf['file']
        url = resolved.get(file_title)
        
        if not url and 'fallback_file' in conf:
            file_title = conf['fallback_file']
            url = resolved.get(file_title)
            
        if not url:
            url = street_fallback_url if conf['faction'] == 'street' else empire_fallback_url
            print(f"Secours appliqué pour {char_id} : {conf['role']}")
            
        cache_file = os.path.join(CACHE_DIR, os.path.basename(urllib.parse.urlparse(url).path))
        print(f"Téléchargement pour {char_id} : {conf['role']}...")
        if download_file(url, cache_file):
            if grade_and_crop(cache_file, conf['path'], conf['faction'], conf.get('focus_y', 0.35)):
                success_count += 1
                print(f"OK ({success_count}/60) : {conf['path']}")
            else:
                print(f"Échec traitement : {conf['path']}")
        else:
            print(f"Échec téléchargement : {url}")
        time.sleep(0.12)
            
    # Default character fallback
    default_dst = 'assets/images/characters/default_character.png'
    if os.path.exists('assets/images/characters/street/ST_050_Kimmie.png'):
        im = Image.open('assets/images/characters/street/ST_050_Kimmie.png')
        im.save(default_dst)
        print(f"OK : {default_dst}")

    print(f"\nFIN DU TRAITEMENT : {success_count} assets sur {len(ASSET_MAPPINGS)} générés avec succès !")

if __name__ == '__main__':
    main()
