# Flutter ProGuard Rules
# https://docs.flutter.dev/deployment/android#obfuscating-your-app

# Flutter-specific keep rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Keep shared_preferences
-keep class com.russhwolf.settings.** { *; }

# Ignore missing Google Play Core classes (common Flutter R8 issue)
-dontwarn com.google.android.play.core.**
