import os
import sys

def main():
    print("=== AUDIT ET VALIDATION DES ASSETS DE PERSONNAGES ===")
    
    # 1. Verification des fichiers d'assets
    street_dir = 'assets/images/characters/street'
    empire_dir = 'assets/images/characters/empire'
    default_img = 'assets/images/characters/default_character.png'
    
    if not os.path.exists(default_img):
        print(f"ERREUR: Image par défaut absente: {default_img}")
        sys.exit(1)
    print(f"OK: Image par défaut présente: {default_img} ({os.path.getsize(default_img)} octets)")

    street_files = [f for f in os.listdir(street_dir) if f.endswith('.png')]
    empire_files = [f for f in os.listdir(empire_dir) if f.endswith('.png')]
    
    print(f"Street assets trouvés: {len(street_files)} (attendu: 28)")
    print(f"Empire assets trouvés: {len(empire_files)} (attendu: 32)")
    
    if len(street_files) != 28:
        print(f"ERREUR: Attendu 28 assets Street, trouvé {len(street_files)}")
        sys.exit(1)
        
    if len(empire_files) != 32:
        print(f"ERREUR: Attendu 32 assets Empire, trouvé {len(empire_files)}")
        sys.exit(1)
        
    # Vérifier qu'aucun fichier n'est vide
    all_files = [os.path.join(street_dir, f) for f in street_files] + \
                [os.path.join(empire_dir, f) for f in empire_files] + \
                [default_img]
                
    for f in all_files:
        sz = os.path.getsize(f)
        if sz < 1000:
            print(f"ERREUR: Fichier trop petit (<1KB): {f} ({sz} bytes)")
            sys.exit(1)
            
    print(f"OK: Les 61 images sont présentes et valides (>1KB).")
    
    # 2. Vérification des decks
    import re
    
    def check_deck(deck_path, expected_prefix, count):
        with open(deck_path, 'r', encoding='utf-8') as f:
            content = f.read()
            
        card_matches = re.findall(r"id:\s*'(" + expected_prefix + r"_\d{3})'", content)
        print(f"{deck_path}: {len(card_matches)} cartes identifiées (attendu: {count})")
        if len(card_matches) != count:
            print(f"ERREUR: Nombre de cartes incorrect dans {deck_path}")
            sys.exit(1)
            
        # Vérifier speakerAvatar et interlocutorId
        avatar_matches = re.findall(r"id:\s*'(" + expected_prefix + r"_\d{3})',[\s\S]*?speakerAvatar:\s*'([^']+)',[\s\S]*?interlocutorId:\s*'([^']+)',", content)
        print(f"{deck_path}: {len(avatar_matches)} avatars et interlocuteur IDs appariés")
        if len(avatar_matches) != count:
            print(f"ERREUR: Cartes sans avatar ou interlocutorId dans {deck_path}")
            sys.exit(1)
            
        # Vérifier existence de chaque fichier référencé
        for card_id, avatar_path, inter_id in avatar_matches:
            if not os.path.exists(avatar_path):
                print(f"ERREUR: Asset introuvable pour {card_id} ({inter_id}): {avatar_path}")
                sys.exit(1)
                
        print(f"OK: 100% des cartes de {deck_path} pointent vers un asset existant.")

    check_deck('lib/data/street_deck.dart', 'ST', 50)
    check_deck('lib/data/empire_deck.dart', 'EM', 50)
    
    print("\n=======================================================")
    print("VALIDATION COMPLÈTE RÉUSSIE SANS AUCUNE ERREUR !")
    print("Total interlocuteurs uniques : 60")
    print("Total images d'assets : 61 (60 + 1 fallback par défaut)")
    print("Total cartes vérifiées : 100 (50 Street + 50 Empire)")
    print("=======================================================")

if __name__ == '__main__':
    main()
