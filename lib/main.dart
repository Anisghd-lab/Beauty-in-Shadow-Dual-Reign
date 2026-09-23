import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/constants/app_colors.dart';
import 'ui/screens/menu_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock orientation to portrait up
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  // Edge-to-edge transparent system overlay bars with light icons
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const BeautyInShadowApp());
}

/// The root application widget for Beauty in Shadow: Dual Reign.
class BeautyInShadowApp extends StatelessWidget {
  const BeautyInShadowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Beauty in Shadow: Dual Reign',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: AppColors.obsidian,
        primaryColor: AppColors.neonViolet,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.neonViolet,
          secondary: AppColors.champagneGold,
          surface: AppColors.darkSurface,
          error: AppColors.statusDanger,
        ),
        textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
      ),
      home: const MenuScreen(),
    );
  }
}

/// Backward compatibility alias.
typedef MyApp = BeautyInShadowApp;
