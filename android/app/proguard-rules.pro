# =====================================================================
# ProGuard Rules for Beauty in Shadow: Dual Reign (Production Release)
# =====================================================================

# --------------------------------------------------
# Flutter Core & Engine
# --------------------------------------------------
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Preserve native JNI methods
-keepclasseswithmembers class * {
    native <methods>;
}

# Preserve GeneratedPluginRegistrant
-keep class io.flutter.plugins.GeneratedPluginRegistrant { *; }

# --------------------------------------------------
# Audioplayers & Audio Decoders (ExoPlayer / Media3)
# --------------------------------------------------
-keep class xyz.luan.audioplayers.** { *; }
-dontwarn xyz.luan.audioplayers.**
-keep class com.google.android.exoplayer2.** { *; }
-dontwarn com.google.android.exoplayer2.**
-keep class androidx.media3.** { *; }
-dontwarn androidx.media3.**

# --------------------------------------------------
# Google Fonts & Support Library Font Providers
# --------------------------------------------------
-keep class androidx.core.provider.FontsContractCompat { *; }
-keep class androidx.core.provider.FontRequest { *; }
-dontwarn androidx.core.provider.**

# --------------------------------------------------
# Card Swiper & Gesture Engine
# --------------------------------------------------
-keep class com.flutter.cardswiper.** { *; }
-dontwarn com.flutter.cardswiper.**

# --------------------------------------------------
# SharedPreferences Storage Plugin
# --------------------------------------------------
-keep class io.flutter.plugins.sharedpreferences.** { *; }
-dontwarn io.flutter.plugins.sharedpreferences.**

# --------------------------------------------------
# Reflection, Attributes & Line Numbers for Symbolication
# --------------------------------------------------
-keepattributes *Annotation*
-keepattributes SourceFile,LineNumberTable
-keepattributes Signature
-keepattributes InnerClasses
-keepattributes EnclosingMethod

# Suppress harmless warnings from framework wrappers
-dontwarn io.flutter.embedding.**
-dontwarn okhttp3.**
-dontwarn okio.**
