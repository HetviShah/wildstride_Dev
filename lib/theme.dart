import 'package:flutter/material.dart';

class WildstrideTheme {
  // Font families
  static const String fontFamilyHeadline = 'Montserrat';
  static const String fontFamilyBody = 'Noto Sans';
  static const String fontFamilyCaption = 'Source Sans Pro';
  
  // Font weights
  static const FontWeight fontWeightLight = FontWeight.w300;
  static const FontWeight fontWeightNormal = FontWeight.w400;
  static const FontWeight fontWeightMedium = FontWeight.w500;
  static const FontWeight fontWeightSemibold = FontWeight.w600;
  static const FontWeight fontWeightBold = FontWeight.w700;
  static const FontWeight fontWeightExtrabold = FontWeight.w800;
  
  // Typography scale
  static const double textHeadlineXl = 32.0; // 32pt
  static const double textHeadlineLg = 28.0; // 28pt
  static const double textBodyLg = 18.0;    // 18pt
  static const double textBody = 16.0;      // 16pt
  static const double textBodySm = 14.0;    // 14pt
  static const double textCaption = 12.0;   // 12pt
  
  // Core colors
  static const Color primary = Color(0xFF003B2E); // Forest Green
  static const Color secondary = Color(0xFFE66A00); // Fox Orange
  static const Color neutral = Color(0xFFE8D9B5); // Earth Sand
  static const Color destructive = Color(0xFFD72638); // Lucky Red
  static const Color gold = Color(0xFFFFD700); // Gold
  static const Color skyBlue = Color(0xFF4A90E2); // Sky Blue
  static const Color mountainGray = Color(0xFF6B6B6B); // Mountain Gray
  
  // Light theme colors
  static const _lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF003B2E),
    onPrimary: Colors.white,
    secondary: Color(0xFFE66A00),
    onSecondary: Colors.white,
    error: Color(0xFFD72638),
    onError: Colors.white,
    background: Colors.white,
    onBackground: Color(0xFF003B2E),
    surface: Colors.white,
    onSurface: Color(0xFF003B2E),
    surfaceVariant: Color(0xFFE8D9B5),
    onSurfaceVariant: Color(0xFF003B2E),
  );
  
  // Dark theme colors
  static const _darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Colors.white,
    onPrimary: Color(0xFF003B2E),
    secondary: Color(0xFF4A4A4A),
    onSecondary: Colors.white,
    error: Color(0xFFD72638),
    onError: Colors.white,
    background: Color(0xFF121212),
    onBackground: Colors.white,
    surface: Color(0xFF121212),
    onSurface: Colors.white,
    surfaceVariant: Color(0xFF2A2A2A),
    onSurfaceVariant: Colors.white,
  );

  // Light theme
  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: _lightColorScheme,
      fontFamily: fontFamilyBody,
      
      // Text theme
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontFamily: fontFamilyHeadline,
          fontSize: textHeadlineXl,
          fontWeight: fontWeightBold,
          height: 1.2,
          color: primary,
        ),
        displayMedium: TextStyle(
          fontFamily: fontFamilyHeadline,
          fontSize: textHeadlineLg,
          fontWeight: fontWeightBold,
          height: 1.3,
          color: primary,
        ),
        displaySmall: TextStyle(
          fontFamily: fontFamilyHeadline,
          fontSize: textBodyLg,
          fontWeight: fontWeightSemibold,
          height: 1.4,
          color: primary,
        ),
        headlineMedium: TextStyle(
          fontFamily: fontFamilyBody,
          fontSize: textBody,
          fontWeight: fontWeightSemibold,
          height: 1.4,
          color: primary,
        ),
        bodyLarge: TextStyle(
          fontFamily: fontFamilyBody,
          fontSize: textBodySm,
          fontWeight: fontWeightNormal,
          height: 1.6,
          color: _lightColorScheme.onBackground,
        ),
        bodyMedium: TextStyle(
          fontFamily: fontFamilyBody,
          fontSize: textBodySm,
          fontWeight: fontWeightNormal,
          height: 1.6,
          color: _lightColorScheme.onBackground,
        ),
        labelLarge: TextStyle(
          fontFamily: fontFamilyBody,
          fontSize: textBodySm,
          fontWeight: fontWeightMedium,
          height: 1.4,
          color: primary,
        ),
        bodySmall: TextStyle(
          fontFamily: fontFamilyCaption,
          fontSize: textCaption,
          fontWeight: fontWeightLight,
          height: 1.4,
          color: mountainGray,
        ),
        labelSmall: TextStyle(
          fontFamily: fontFamilyCaption,
          fontSize: textCaption,
          fontWeight: fontWeightLight,
          height: 1.4,
          color: mountainGray,
        ),
      ),
      
      // Button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          textStyle: TextStyle(
            fontFamily: fontFamilyBody,
            fontSize: textBodySm,
            fontWeight: fontWeightMedium,
            height: 1.4,
          ),
        ),
      ),
      
      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF8F6F3),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: secondary, width: 2),
        ),
        labelStyle: TextStyle(
          fontFamily: fontFamilyBody,
          fontSize: textBodySm,
          fontWeight: fontWeightMedium,
          height: 1.4,
          color: primary,
        ),
        hintStyle: TextStyle(
          fontFamily: fontFamilyBody,
          fontSize: textBodySm,
          fontWeight: fontWeightNormal,
          height: 1.4,
        ),
      ),
      
      // Card theme
      cardTheme: const CardThemeData(
        color: Colors.white,
        elevation: 4,
        margin: EdgeInsets.all(8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
      
      // App bar theme
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: primary,
        elevation: 0,
        titleTextStyle: TextStyle(
          fontFamily: fontFamilyHeadline,
          fontSize: textHeadlineLg,
          fontWeight: fontWeightBold,
          color: primary,
        ),
      ),
    );
  }

  // Dark theme
  static ThemeData dark() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: _darkColorScheme,
      fontFamily: fontFamilyBody,
      brightness: Brightness.dark,
      
      // Text theme
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontFamily: fontFamilyHeadline,
          fontSize: textHeadlineXl,
          fontWeight: fontWeightBold,
          height: 1.2,
          color: Colors.white,
        ),
        displayMedium: TextStyle(
          fontFamily: fontFamilyHeadline,
          fontSize: textHeadlineLg,
          fontWeight: fontWeightBold,
          height: 1.3,
          color: Colors.white,
        ),
        displaySmall: TextStyle(
          fontFamily: fontFamilyHeadline,
          fontSize: textBodyLg,
          fontWeight: fontWeightSemibold,
          height: 1.4,
          color: Colors.white,
        ),
        headlineMedium: TextStyle(
          fontFamily: fontFamilyBody,
          fontSize: textBody,
          fontWeight: fontWeightSemibold,
          height: 1.4,
          color: Colors.white,
        ),
        bodyLarge: TextStyle(
          fontFamily: fontFamilyBody,
          fontSize: textBodySm,
          fontWeight: fontWeightNormal,
          height: 1.6,
          color: Colors.white,
        ),
        bodyMedium: TextStyle(
          fontFamily: fontFamilyBody,
          fontSize: textBodySm,
          fontWeight: fontWeightNormal,
          height: 1.6,
          color: Colors.white,
        ),
        labelLarge: TextStyle(
          fontFamily: fontFamilyBody,
          fontSize: textBodySm,
          fontWeight: fontWeightMedium,
          height: 1.4,
          color: Colors.white,
        ),
        bodySmall: TextStyle(
          fontFamily: fontFamilyCaption,
          fontSize: textCaption,
          fontWeight: fontWeightLight,
          height: 1.4,
          color: Colors.grey[400],
        ),
        labelSmall: TextStyle(
          fontFamily: fontFamilyCaption,
          fontSize: textCaption,
          fontWeight: fontWeightLight,
          height: 1.4,
          color: Colors.grey[400],
        ),
      ),
      
      // Button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          textStyle: TextStyle(
            fontFamily: fontFamilyBody,
            fontSize: textBodySm,
            fontWeight: fontWeightMedium,
            height: 1.4,
          ),
        ),
      ),
      
      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF2A2A2A),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: secondary, width: 2),
        ),
        labelStyle: TextStyle(
          fontFamily: fontFamilyBody,
          fontSize: textBodySm,
          fontWeight: fontWeightMedium,
          height: 1.4,
          color: Colors.white,
        ),
        hintStyle: TextStyle(
          fontFamily: fontFamilyBody,
          fontSize: textBodySm,
          fontWeight: fontWeightNormal,
          height: 1.4,
          color: Colors.grey[400],
        ),
      ),

      // Card theme
      cardTheme: const CardThemeData(
        color: Color(0xFF1E1E1E),
        surfaceTintColor: Color(0xFF1E1E1E),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),

      // App bar theme
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFF1E1E1E),
        foregroundColor: Colors.white,
        elevation: 0,
        titleTextStyle: TextStyle(
          fontFamily: fontFamilyHeadline,
          fontSize: textHeadlineLg,
          fontWeight: fontWeightBold,
          color: Colors.white,
        ),
      ),
    );
  }
}

// Utility extension for easy access to brand colors
extension WildstrideColors on ColorScheme {
  Color get forestGreen => WildstrideTheme.primary;
  Color get foxOrange => WildstrideTheme.secondary;
  Color get earthSand => WildstrideTheme.neutral;
  Color get luckyRed => WildstrideTheme.destructive;
  Color get gold => WildstrideTheme.gold;
  Color get skyBlue => WildstrideTheme.skyBlue;
  Color get mountainGray => WildstrideTheme.mountainGray;
}

// Utility extension for text styles
extension WildstrideTextStyles on TextTheme {
  TextStyle get headlineXl => displayLarge!;
  TextStyle get headlineLg => displayMedium!;
  TextStyle get bodyLg => displaySmall!;
  TextStyle get body => bodyMedium!;
  TextStyle get bodySm => bodyMedium!;
  TextStyle get caption => bodySmall!;
}

// Usage example:
/*
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: WildstrideTheme.light(),
      darkTheme: WildstrideTheme.dark(),
      themeMode: ThemeMode.system,
      home: MyHomePage(),
    );
  }
}
*/