import os
import math
import random
from PIL import Image, ImageDraw, ImageFilter

def create_base_canvas(width, height, top_color, bottom_color, noise_intensity=0.03):
    """Creates a dark luxury vertical gradient canvas with film grain."""
    base = Image.new('RGB', (width, height))
    draw = ImageDraw.Draw(base)
    for y in range(height):
        r = int(top_color[0] + (bottom_color[0] - top_color[0]) * (y / height))
        g = int(top_color[1] + (bottom_color[1] - top_color[1]) * (y / height))
        b = int(top_color[2] + (bottom_color[2] - top_color[2]) * (y / height))
        draw.line([(0, y), (width, y)], fill=(r, g, b))

    # Add subtle film grain / noise
    pixels = base.load()
    rng = random.Random(42 + hash(top_color))
    for y in range(height):
        for x in range(width):
            noise = rng.randint(-15, 15)
            r, g, b = pixels[x, y]
            pixels[x, y] = (
                max(0, min(255, r + noise)),
                max(0, min(255, g + noise)),
                max(0, min(255, b + noise))
            )
    return base

def draw_vignette(image, intensity=0.75):
    """Draws cinematic dark vignette around edges."""
    w, h = image.size
    overlay = Image.new('RGBA', (w, h), (0, 0, 0, 0))
    draw = ImageDraw.Draw(overlay)
    cx, cy = w / 2, h / 2
    max_radius = math.sqrt(cx * cx + cy * cy)

    for i in range(15):
        alpha = int(255 * intensity * (i / 15) ** 1.5)
        r_step = max_radius * (0.55 + 0.45 * (i / 15))
        draw.ellipse([cx - r_step, cy - r_step, cx + r_step, cy + r_step],
                     outline=(0, 0, 0, alpha), width=int(max_radius * 0.05))

    overlay = overlay.filter(ImageFilter.GaussianBlur(25))
    image.paste(overlay, (0, 0), overlay)

def draw_character_portrait(
    filename,
    faction='street',
    role_type='human',
    primary_color=(157, 78, 221), # neon violet
    accent_color=(0, 245, 212),   # cyan
    bg_style='club',
    gender='female',
    seed=100
):
    if os.path.exists(filename):
        print(f"Skipping existing: {filename}")
        return

    w, h = 480, 640
    rng = random.Random(seed)

    # Background palette
    if faction == 'street':
        top_c = (rng.randint(10, 25), rng.randint(5, 15), rng.randint(25, 45))
        bot_c = (8, 9, 14)
    else:
        top_c = (rng.randint(20, 35), rng.randint(15, 30), rng.randint(10, 20))
        bot_c = (12, 14, 18)

    img = create_base_canvas(w, h, top_c, bot_c)
    draw = ImageDraw.Draw(img)

    # Ambient volumetric light bokeh
    if bg_style == 'club':
        for _ in range(12):
            bx = rng.randint(20, w - 20)
            by = rng.randint(40, int(h * 0.6))
            br = rng.randint(20, 75)
            alpha_b = rng.randint(20, 70)
            c = primary_color if rng.choice([True, False]) else accent_color
            draw.ellipse([bx - br, by - br, bx + br, by + br],
                         fill=(c[0], c[1], c[2]))
        img = img.filter(ImageFilter.GaussianBlur(15))
        draw = ImageDraw.Draw(img)
    elif bg_style == 'boardroom':
        # Architectural lines (luxury pillars/windows)
        for x in [80, 200, 320, 400]:
            draw.line([(x, 0), (x, int(h * 0.65))], fill=(top_c[0]+25, top_c[1]+20, top_c[2]+15), width=3)
        img = img.filter(ImageFilter.GaussianBlur(6))
        draw = ImageDraw.Draw(img)
    elif bg_style == 'court':
        # Neoclassical columns
        for x in [60, 150, 330, 420]:
            draw.rectangle([x, 0, x + 25, int(h * 0.7)], fill=(35, 38, 48))
        img = img.filter(ImageFilter.GaussianBlur(8))
        draw = ImageDraw.Draw(img)

    # Character Silhouette & Bust
    cx, cy = w // 2, int(h * 0.42)

    # Rim light halo behind head
    halo_r = 135
    for r_h in range(halo_r, halo_r - 30, -5):
        alpha_h = int(60 * (halo_r - r_h) / 30)
        c_h = primary_color if faction == 'street' else accent_color
        draw.ellipse([cx - r_h, cy - r_h - 10, cx + r_h, cy + r_h - 10],
                     outline=(c_h[0], c_h[1], c_h[2]), width=4)

    # Shoulders / Torso
    torso_top = int(h * 0.54)
    shoulder_w = 175 if gender == 'male' else 145
    suit_color = (18, 20, 26) if faction == 'street' else (25, 26, 32)
    draw.polygon([
        (cx - shoulder_w, h),
        (cx - shoulder_w * 0.7, torso_top),
        (cx - 45, torso_top - 15),
        (cx + 45, torso_top - 15),
        (cx + shoulder_w * 0.7, torso_top),
        (cx + shoulder_w, h),
    ], fill=suit_color)

    # Collar / Lapels
    lapel_c = (suit_color[0] + 18, suit_color[1] + 18, suit_color[2] + 24)
    draw.polygon([(cx - 45, torso_top - 15), (cx, torso_top + 65), (cx - 20, h)], fill=lapel_c)
    draw.polygon([(cx + 45, torso_top - 15), (cx, torso_top + 65), (cx + 20, h)], fill=lapel_c)

    # Shirt / Tie or Cleavage / Necklace
    if gender == 'male':
        # Shirt V
        shirt_c = (200, 205, 215) if faction == 'empire' else (45, 50, 65)
        draw.polygon([(cx - 22, torso_top - 10), (cx + 22, torso_top - 10), (cx, torso_top + 60)], fill=shirt_c)
        # Tie
        tie_c = primary_color if faction == 'empire' else accent_color
        draw.polygon([(cx - 8, torso_top + 5), (cx + 8, torso_top + 5), (cx + 12, h), (cx - 12, h)], fill=tie_c)
    else:
        # Elegant neckline
        skin_base = (195, 155, 140) if faction == 'street' else (225, 195, 180)
        draw.polygon([(cx - 28, torso_top - 10), (cx + 28, torso_top - 10), (cx, torso_top + 45)], fill=skin_base)
        # Necklace / Jewel
        gem_c = (220, 190, 70) if faction == 'empire' else accent_color
        draw.arc([cx - 20, torso_top - 5, cx + 20, torso_top + 28], 0, 180, fill=gem_c, width=2)
        draw.ellipse([cx - 5, torso_top + 28, cx + 5, torso_top + 38], fill=gem_c)

    # Neck
    neck_c = (175, 135, 120) if faction == 'street' else (205, 175, 160)
    draw.rectangle([cx - 24, cy + 40, cx + 24, torso_top], fill=neck_c)

    # Head / Face
    head_w = 64
    head_h = 82
    face_c = (190, 150, 135) if faction == 'street' else (220, 190, 175)
    draw.ellipse([cx - head_w, cy - head_h, cx + head_w, cy + head_h], fill=face_c)

    # Shadow under chin
    draw.arc([cx - head_w + 10, cy + 30, cx + head_w - 10, cy + head_h + 10], 0, 180, fill=(70, 45, 40), width=6)

    # Hair / Hairstyle
    hair_c = (20, 18, 22)
    if gender == 'female':
        # Long flowing or sleek updo
        draw.ellipse([cx - head_w - 12, cy - head_h - 18, cx + head_w + 12, cy + 35], fill=hair_c)
        # Re-cut forehead
        draw.ellipse([cx - head_w + 8, cy - head_h + 15, cx + head_w - 8, cy + head_h - 10], fill=face_c)
        # Side tresses
        draw.rectangle([cx - head_w - 8, cy - 20, cx - head_w + 10, torso_top + 20], fill=hair_c)
        draw.rectangle([cx + head_w - 10, cy - 20, cx + head_w + 8, torso_top + 20], fill=hair_c)
    else:
        # Short parted styled masculine hair
        draw.ellipse([cx - head_w - 6, cy - head_h - 18, cx + head_w + 6, cy - 10], fill=hair_c)

    # Facial Features (Chiaroscuro Silhouette)
    # Eyes & Brow
    eye_y = cy - 8
    draw.arc([cx - 36, eye_y - 12, cx - 12, eye_y - 2], 200, 340, fill=(45, 30, 25), width=3)
    draw.arc([cx + 12, eye_y - 12, cx + 36, eye_y - 2], 200, 340, fill=(45, 30, 25), width=3)

    # Eyes
    draw.ellipse([cx - 30, eye_y - 2, cx - 18, eye_y + 6], fill=(30, 20, 20))
    draw.ellipse([cx + 18, eye_y - 2, cx + 30, eye_y + 6], fill=(30, 20, 20))
    # Eye highlights
    draw.point([cx - 24, eye_y], fill=(255, 255, 255))
    draw.point([cx + 24, eye_y], fill=(255, 255, 255))

    # Nose
    draw.line([(cx, cy - 4), (cx - 2, cy + 24), (cx + 5, cy + 24)], fill=(130, 95, 85), width=2)

    # Lips
    lip_c = (150, 45, 55) if gender == 'female' else (140, 95, 85)
    draw.ellipse([cx - 16, cy + 38, cx + 16, cy + 48], fill=lip_c)

    # Glasses / Eyewear if intellectual / law
    if 'avocat' in filename.lower() or 'directeur' in filename.lower() or 'juge' in filename.lower() or 'chimiste' in filename.lower():
        draw.rectangle([cx - 38, eye_y - 6, cx - 10, eye_y + 10], outline=(180, 160, 90), width=2)
        draw.rectangle([cx + 10, eye_y - 6, cx + 38, eye_y + 10], outline=(180, 160, 90), width=2)
        draw.line([(cx - 10, eye_y + 2), (cx + 10, eye_y + 2)], fill=(180, 160, 90), width=2)

    # Rim Lighting on character side
    rim_c = primary_color if faction == 'street' else accent_color
    draw.arc([cx - head_w - 4, cy - head_h - 4, cx + head_w + 4, cy + head_h + 4], 90, 220,
             fill=(rim_c[0], rim_c[1], rim_c[2]), width=3)
    draw.line([(cx - shoulder_w * 0.7, torso_top), (cx - shoulder_w, h)],
              fill=(rim_c[0], rim_c[1], rim_c[2]), width=3)

    # Vignette & post-processing
    draw_vignette(img, intensity=0.7)

    # Save PNG
    os.makedirs(os.path.dirname(filename), exist_ok=True)
    img.save(filename, 'PNG', optimize=True)
    print(f"Generated character portrait: {filename}")

def draw_environmental_card(filename, faction, title, primary_c, accent_c):
    """Draws narrative environmental incident card portrait."""
    if os.path.exists(filename):
        print(f"Skipping existing: {filename}")
        return

    w, h = 480, 640
    top_c = (20, 15, 30) if faction == 'street' else (35, 25, 15)
    bot_c = (8, 9, 14)
    img = create_base_canvas(w, h, top_c, bot_c)
    draw = ImageDraw.Draw(img)

    cx, cy = w // 2, h // 2

    # Glowing dramatic focal object
    for r in range(160, 40, -10):
        alpha = int(45 * (160 - r) / 120)
        draw.ellipse([cx - r, cy - r, cx + r, cy + r],
                     outline=(primary_c[0], primary_c[1], primary_c[2]), width=4)

    # Atmospheric geometry
    draw.rectangle([cx - 90, cy - 90, cx + 90, cy + 90], outline=accent_c, width=3)
    draw.line([(cx - 120, cy), (cx + 120, cy)], fill=accent_c, width=2)
    draw.line([(cx, cy - 120), (cx, cy + 120)], fill=accent_c, width=2)

    draw_vignette(img, intensity=0.85)
    os.makedirs(os.path.dirname(filename), exist_ok=True)
    img.save(filename, 'PNG', optimize=True)
    print(f"Generated environmental card: {filename}")

def main():
    street_dir = 'assets/images/characters/street'
    empire_dir = 'assets/images/characters/empire'

    # Fallback
    draw_character_portrait(
        'assets/images/characters/default_character.png',
        faction='street',
        primary_color=(157, 78, 221),
        accent_color=(212, 175, 55),
        gender='female',
        seed=1
    )

    # STREET CHARACTERS (28 remaining to ensure all 28 exist)
    street_defs = [
        ('ST_002_Gerant_Motel.png', 'street', (157, 78, 221), (0, 245, 212), 'alley', 'male', 2),
        ('ST_005_Norman.png', 'street', (157, 78, 221), (255, 150, 0), 'alley', 'male', 5),
        ('ST_006_Petite_Soeur.png', 'street', (157, 78, 221), (0, 245, 212), 'alley', 'female', 6),
        ('ST_007_Client_Emeche.png', 'street', (157, 78, 221), (212, 175, 55), 'club', 'male', 7),
        ('ST_008_Controle_Police.png', 'street', (0, 150, 255), (255, 50, 50), 'alley', 'male', 8),
        ('ST_009_Gillian.png', 'street', (157, 78, 221), (0, 245, 212), 'club', 'female', 9),
        ('ST_010_Detective_Davis.png', 'street', (0, 180, 216), (212, 175, 55), 'court', 'male', 10),
        ('ST_013_Banquette_VIP.png', 'street', (157, 78, 221), (212, 175, 55), 'env', 'env', 13),
        ('ST_015_Cipher.png', 'street', (0, 245, 212), (157, 78, 221), 'alley', 'male', 15),
        ('ST_020_Sbires_Bell.png', 'street', (200, 30, 30), (100, 20, 20), 'alley', 'male', 20),
        ('ST_021_Receptionniste.png', 'street', (157, 78, 221), (0, 245, 212), 'alley', 'female', 21),
        ('ST_024_Agent_Corrompu.png', 'street', (0, 150, 255), (212, 175, 55), 'court', 'male', 24),
        ('ST_027_Videosurveillance.png', 'street', (0, 245, 212), (255, 50, 50), 'env', 'env', 27),
        ('ST_028_Marco.png', 'street', (157, 78, 221), (212, 175, 55), 'club', 'male', 28),
        ('ST_030_Panne_Secteur.png', 'street', (50, 50, 80), (0, 245, 212), 'env', 'env', 30),
        ('ST_032_Incendie_Velvet.png', 'street', (255, 80, 20), (255, 200, 50), 'env', 'env', 32),
        ('ST_033_Sbire_Arme.png', 'street', (200, 30, 30), (157, 78, 221), 'alley', 'male', 33),
        ('ST_035_SWAT_Pompiers.png', 'street', (255, 50, 50), (0, 150, 255), 'alley', 'male', 35),
        ('ST_040_Chambre_Forte.png', 'street', (212, 175, 55), (100, 100, 120), 'env', 'env', 40),
        ('ST_041_President_Jury.png', 'street', (212, 175, 55), (180, 180, 200), 'court', 'male', 41),
        ('ST_042_Avocat_Bell.png', 'street', (212, 175, 55), (157, 78, 221), 'court', 'male', 42),
        ('ST_044_Procureur_Federal.png', 'street', (0, 150, 255), (212, 175, 55), 'court', 'male', 44),
        ('ST_046_Collectif_Danseuses.png', 'street', (157, 78, 221), (0, 245, 212), 'club', 'female', 46),
        ('ST_047_Le_Greffier.png', 'street', (180, 180, 200), (157, 78, 221), 'court', 'male', 47),
        ('ST_050_Kimmie.png', 'street', (157, 78, 221), (212, 175, 55), 'club', 'female', 50),
    ]

    for fname, faction, p_col, a_col, bg, gender, s in street_defs:
        target = os.path.join(street_dir, fname)
        if bg == 'env':
            draw_environmental_card(target, faction, fname, p_col, a_col)
        else:
            draw_character_portrait(target, faction, 'human', p_col, a_col, bg, gender, s)

    # EMPIRE CHARACTERS (32 unique entries)
    empire_defs = [
        ('EM_001_Directeur_Financier.png', 'empire', (212, 175, 55), (240, 240, 250), 'boardroom', 'male', 101),
        ('EM_002_Horace_Bell.png', 'empire', (212, 175, 55), (120, 20, 40), 'boardroom', 'male', 102),
        ('EM_003_Chimiste_Chef.png', 'empire', (0, 245, 212), (212, 175, 55), 'boardroom', 'female', 103),
        ('EM_004_Roy_Bell.png', 'empire', (200, 30, 30), (212, 175, 55), 'boardroom', 'male', 104),
        ('EM_005_Journaliste_TV.png', 'empire', (0, 180, 216), (212, 175, 55), 'boardroom', 'female', 105),
        ('EM_006_Procureur_Miller.png', 'empire', (212, 175, 55), (100, 120, 160), 'court', 'male', 106),
        ('EM_008_Jules_Bell.png', 'empire', (212, 175, 55), (0, 245, 212), 'boardroom', 'male', 108),
        ('EM_010_Raid_Fiscal.png', 'empire', (0, 150, 255), (212, 175, 55), 'env', 'env', 110),
        ('EM_013_Directrice_Marketing.png', 'empire', (212, 175, 55), (180, 50, 90), 'boardroom', 'female', 113),
        ('EM_014_Commissaire_District.png', 'empire', (0, 150, 255), (212, 175, 55), 'court', 'male', 114),
        ('EM_016_Conseil_Administration.png', 'empire', (212, 175, 55), (180, 180, 200), 'boardroom', 'male', 116),
        ('EM_017_Banquier_Suisse.png', 'empire', (212, 175, 55), (240, 240, 250), 'boardroom', 'male', 117),
        ('EM_019_Journaliste_Times.png', 'empire', (180, 180, 200), (212, 175, 55), 'court', 'male', 119),
        ('EM_020_Ligne_Urgence.png', 'empire', (255, 50, 50), (212, 175, 55), 'env', 'env', 120),
        ('EM_021_Don_Salazar.png', 'empire', (200, 30, 30), (212, 175, 55), 'boardroom', 'male', 121),
        ('EM_022_Silas.png', 'empire', (100, 100, 120), (212, 175, 55), 'boardroom', 'male', 122),
        ('EM_024_Juge_Vandermeer.png', 'empire', (212, 175, 55), (180, 180, 200), 'court', 'male', 124),
        ('EM_027_Archiviste.png', 'empire', (212, 175, 55), (150, 120, 80), 'boardroom', 'male', 127),
        ('EM_028_Analyste_Financier.png', 'empire', (0, 245, 212), (212, 175, 55), 'boardroom', 'male', 128),
        ('EM_030_Reseau_SWIFT.png', 'empire', (0, 245, 212), (0, 150, 255), 'env', 'env', 130),
        ('EM_031_President_Tribunal.png', 'empire', (212, 175, 55), (180, 180, 200), 'court', 'male', 131),
        ('EM_036_Mandataire_Judiciaire.png', 'empire', (180, 180, 200), (212, 175, 55), 'court', 'female', 136),
        ('EM_038_Maitre_Sterling.png', 'empire', (212, 175, 55), (240, 240, 250), 'court', 'male', 138),
        ('EM_039_Attache_Presse.png', 'empire', (212, 175, 55), (0, 180, 216), 'boardroom', 'male', 139),
        ('EM_040_Salle_Attente.png', 'empire', (212, 175, 55), (100, 80, 40), 'env', 'env', 140),
        ('EM_041_Greffier_Federal.png', 'empire', (180, 180, 200), (212, 175, 55), 'court', 'male', 141),
        ('EM_043_Chef_Marque_Luxe.png', 'empire', (212, 175, 55), (200, 50, 100), 'boardroom', 'female', 143),
        ('EM_045_Commissaire_Priseur.png', 'empire', (212, 175, 55), (240, 240, 250), 'court', 'male', 145),
        ('EM_046_Consortium_Asie.png', 'empire', (212, 175, 55), (200, 30, 30), 'boardroom', 'male', 146),
        ('EM_047_Gouverneur.png', 'empire', (212, 175, 55), (0, 150, 255), 'boardroom', 'male', 147),
        ('EM_049_President_Sommet.png', 'empire', (212, 175, 55), (240, 240, 250), 'boardroom', 'male', 149),
        ('EM_050_Mallory_Bell.png', 'empire', (212, 175, 55), (157, 78, 221), 'boardroom', 'female', 150),
    ]

    for fname, faction, p_col, a_col, bg, gender, s in empire_defs:
        target = os.path.join(empire_dir, fname)
        if bg == 'env':
            draw_environmental_card(target, faction, fname, p_col, a_col)
        else:
            draw_character_portrait(target, faction, 'human', p_col, a_col, bg, gender, s)

if __name__ == '__main__':
    main()
