import 'package:flutter/material.dart';

/// Design tokens and color palette for Beauty in Shadow - Dual Reign.
///
/// Implements a dark neo-noir aesthetic featuring distinct accent palettes
/// for the two rival factions: Street Syndicate and Royal Empire,
/// alongside standard status and surface tokens.
class AppColors {
  AppColors._();

  // ==========================================
  // Dark Neo-Noir Surfaces & Backgrounds
  // ==========================================

  /// Deep obsidian dark background (#0B0C10)
  static const Color obsidian = Color(0xFF0B0C10);
  static const Color background = obsidian;

  /// Elevated dark surface for containers and bars (#12141D)
  static const Color darkSurface = Color(0xFF12141D);
  static const Color surface = darkSurface;

  /// Card surface for swipable cards and modal dialogs (#161922)
  static const Color cardSurface = Color(0xFF161922);

  /// Subtle neo-noir border and divider line (#1F2833)
  static const Color border = Color(0xFF1F2833);

  // ==========================================
  // Street Faction Accents (Neon & Cyber-Noir)
  // ==========================================

  /// Electric neon violet (#8A2BE2) - Primary Street identity
  static const Color neonViolet = Color(0xFF8A2BE2);
  static const Color streetViolet = neonViolet;

  /// Vibrant high-voltage cyan (#00F0FF) - Street tech & intel
  static const Color cyan = Color(0xFF00F0FF);
  static const Color streetCyan = cyan;

  /// Aggressive risk red (#FF0055) - Critical underworld threats & heat
  static const Color riskRed = Color(0xFFFF0055);
  static const Color streetRiskRed = riskRed;

  // ==========================================
  // Empire Faction Accents (Dynastic & Aristocratic)
  // ==========================================

  /// Regnant champagne gold (#D4AF37) - Imperial treasury & prestige
  static const Color champagneGold = Color(0xFFD4AF37);
  static const Color empireGold = champagneGold;

  /// Elegant ivory (#F5F5F7) - Aristocratic clean highlights
  static const Color ivory = Color(0xFFF5F5F7);
  static const Color empireIvory = ivory;

  /// Sinister deep blood (#8B0000) - Royal purges & executive authority
  static const Color deepBlood = Color(0xFF8B0000);
  static const Color empireDeepBlood = deepBlood;

  // ==========================================
  // Status & Gauge Indicators
  // ==========================================

  /// Safe / Positive outcome indicator (#10B981)
  static const Color statusGood = Color(0xFF10B981);
  static const Color good = statusGood;

  /// Warning / Neutral impact indicator (#F59E0B)
  static const Color statusWarning = Color(0xFFF59E0B);
  static const Color warning = statusWarning;

  /// Critical / Lethal danger indicator (#EF4444)
  static const Color statusDanger = Color(0xFFEF4444);
  static const Color danger = statusDanger;

  /// Primary high-contrast readability text (#F3F4F6)
  static const Color text = Color(0xFFF3F4F6);
  static const Color textPrimary = text;

  // ==========================================
  // Secondary Helpers & Gradients
  // ==========================================

  /// Muted secondary text for subtitles and meta information (#9CA3AF)
  static const Color textSecondary = Color(0xFF9CA3AF);

  /// Faint tertiary text / placeholders (#6B7280)
  static const Color textMuted = Color(0xFF6B7280);

  /// Shadow color for ambient lighting and card elevations
  static const Color cardShadow = Color(0x66000000);

  /// Street Neon Gradient: Violet to Cyan
  static const LinearGradient streetGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [neonViolet, cyan],
  );

  /// Empire Dynastic Gradient: Gold to Deep Blood
  static const LinearGradient empireGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [champagneGold, deepBlood],
  );

  /// Neo-noir card border gradient
  static const LinearGradient borderGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF2C3545), border],
  );
}
