import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class AppTheme {
  static final AppTheme _singleton = AppTheme._internal();
  factory AppTheme() {
    return _singleton;
  }
  AppTheme._internal();
  static const myColor50 = Color(0xFF00cc66);
  static const myColor100 = Color(0xFF007b3e);
  static const myColor300 = Color(0xFF004d26);
  static const myColor400 = Color(0xFF00331a);
  static const myFolderColor = Colors.green;
  static const myColor900 = Color(0xFF001a0d);
  static const myColorError = Color(0xFFC5032B);
  static const myColorSurfaceWhite =  Colors.white;
  static const myColorBackgroundWhite =  Colors.white;

  static BorderRadius buttonBorderRadius = BorderRadius.circular(10.0);
  static BorderRadius rectangleBorderRadius = BorderRadius.circular(10.0);
  static const double buttonPadding = 10.0;

  static const TextStyle selectedElementStyle = TextStyle(fontWeight: FontWeight.w900);

  ThemeData? materialLightTheme;
  ThemeData? materialDarkTheme;
  CupertinoThemeData? darkDefaultCupertinoTheme;
  MaterialBasedCupertinoThemeData? cupertinoDarkTheme;
  MaterialBasedCupertinoThemeData? cupertinoLightTheme;

  TextStyle? defaultTitleStyle;
  TextStyle? defaultHeadStyle;
  TextStyle? defaultSubheadStyle;
  TextStyle? defaultLineStyle;
  TextStyle? defaultLargeStyle;
  TextStyle? defaultSmallStyle;
  TextStyle? defaultTitleStyleWhite;
  TextStyle? defaultSubheadStyleWhite;


   init() {
    materialLightTheme = ThemeData(
      colorScheme: ColorScheme.fromSeed(
          seedColor: Color(hexStringToHexInt('#007b3e'))),
      brightness: Brightness.light,
    ).copyWith(
        navigationBarTheme:  const NavigationBarThemeData(
            backgroundColor: Colors.white
        ),
    );

    materialDarkTheme = ThemeData(
      colorScheme: ColorScheme.fromSeed(
          seedColor: Color(hexStringToHexInt('#ff101510')),
          brightness: Brightness.dark,
      ),
      //useMaterial3: true,
    );

    cupertinoLightTheme = MaterialBasedCupertinoThemeData(materialTheme: materialLightTheme!);

    darkDefaultCupertinoTheme =  const CupertinoThemeData(brightness: Brightness.dark);

    cupertinoDarkTheme = MaterialBasedCupertinoThemeData(
      materialTheme: materialDarkTheme!.copyWith(
        cupertinoOverrideTheme: CupertinoThemeData(
          brightness: Brightness.dark,
          barBackgroundColor: darkDefaultCupertinoTheme!.barBackgroundColor,
          textTheme: CupertinoTextThemeData(
            primaryColor: Colors.white,
            navActionTextStyle:
            darkDefaultCupertinoTheme!.textTheme.navActionTextStyle.copyWith(
              color: const Color(0xF0F9F9F9),
            ),
            navLargeTitleTextStyle: darkDefaultCupertinoTheme!
                .textTheme.navLargeTitleTextStyle
                .copyWith(color: const Color(0xF0F9F9F9)),
          ),
        ),
      ),
    );

  }

  void initTextStyles(BuildContext context){
    defaultTitleStyle = platformThemeData(
      context,
      material: (data) => data.textTheme.titleLarge,
      cupertino: (data) => data.textTheme.navTitleTextStyle,
    );

    defaultLargeStyle = platformThemeData(
      context,
      material: (data) => data.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900),
      cupertino: (data) => data.textTheme.navTitleTextStyle,
    );

    defaultSubheadStyle = platformThemeData(
      context,
      material: (data) => data.textTheme.titleLarge?.apply(fontWeightDelta: -1),
      cupertino: (data) => data.textTheme.navTitleTextStyle,
    );

    defaultHeadStyle = platformThemeData(
      context,
      material: (data) => defaultTitleStyle?.copyWith(fontWeight: FontWeight.w600),
      cupertino: (data) => data.textTheme.navTitleTextStyle,
    );

    defaultSmallStyle = platformThemeData(
      context,
      material: (data) => data.textTheme.titleMedium,
      cupertino: (data) => data.textTheme.navTitleTextStyle,
    );

    defaultLineStyle = platformThemeData(
      context,
      material: (data) => data.textTheme.titleMedium,
      cupertino: (data) => data.textTheme.navTitleTextStyle,
    );

    defaultTitleStyleWhite = platformThemeData(
      context,
      material: (data) => defaultTitleStyle?.copyWith(color: Colors.white),
      cupertino: (data) => defaultTitleStyle?.copyWith(color: Colors.white),
    );

    defaultSubheadStyleWhite = platformThemeData(
      context,
      material: (data) => defaultSubheadStyle?.copyWith(color: Colors.white),
      cupertino: (data) => defaultSubheadStyle?.copyWith(color: Colors.white),
    );
  }
  int hexStringToHexInt(String hex) {
    int val =0;
    hex = hex.replaceFirst('#', '');
    hex = hex.length == 6 ? 'ff' + hex : hex;
    val = int.parse(hex, radix: 16);
    return val;
  }


 }

AppTheme appTheme = AppTheme();
/*

AppTheme myPointsPage = AppTheme();


class AppTheme2 {
  ThemeData? materialLightTheme;
  ThemeData? materialDarkTheme;
  CupertinoThemeData? darkDefaultCupertinoTheme;
  MaterialBasedCupertinoThemeData? cupertinoDarkTheme;
  MaterialBasedCupertinoThemeData? cupertinoLightTheme;

  TextStyle? defaultTitleStyle;
  TextStyle? defaultHeadStyle;
  TextStyle? defaultSubheadStyle;
  TextStyle? defaultLineStyle;
  TextStyle? defaultLargeStyle;
  TextStyle? defaultSmallStyle;
  TextStyle? defaultTitleStyleWhite;
  TextStyle? defaultSubheadStyleWhite;



  AppTheme2(){
    materialLightTheme = ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Color(hexStringToHexInt('#007b3e'))
        ),
      );
    materialDarkTheme = ThemeData(
      colorScheme: ColorScheme.fromSeed(
          seedColor: Color(hexStringToHexInt('#007b3e')),
        brightness: Brightness.dark
      ),
    );

    //materialDarkTheme = materialLightTheme!.copyWith(brightness: Brightness.dark);
    //materialDarkTheme = ThemeData.dark();
    cupertinoLightTheme = MaterialBasedCupertinoThemeData(materialTheme: materialLightTheme!);

    darkDefaultCupertinoTheme =  const CupertinoThemeData(brightness: Brightness.dark);

    cupertinoDarkTheme = MaterialBasedCupertinoThemeData(
      materialTheme: materialDarkTheme!.copyWith(
        cupertinoOverrideTheme: CupertinoThemeData(
          brightness: Brightness.dark,
          barBackgroundColor: darkDefaultCupertinoTheme!.barBackgroundColor,
          textTheme: CupertinoTextThemeData(
            primaryColor: Colors.white,
            navActionTextStyle:
            darkDefaultCupertinoTheme!.textTheme.navActionTextStyle.copyWith(
              color: const Color(0xF0F9F9F9),
            ),
            navLargeTitleTextStyle: darkDefaultCupertinoTheme!
                .textTheme.navLargeTitleTextStyle
                .copyWith(color: const Color(0xF0F9F9F9)),
          ),
        ),
      ),
    );

  }

  void initTextStyles(BuildContext context){
    defaultTitleStyle = platformThemeData(
      context,
      material: (data) => data.textTheme.titleLarge,
      cupertino: (data) => data.textTheme.navTitleTextStyle,
    );

    defaultLargeStyle = platformThemeData(
      context,
      material: (data) => data.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900),
      cupertino: (data) => data.textTheme.navTitleTextStyle,
    );

    defaultSubheadStyle = platformThemeData(
      context,
      material: (data) => data.textTheme.titleLarge?.apply(fontWeightDelta: -1),
      cupertino: (data) => data.textTheme.navTitleTextStyle,
    );

    defaultHeadStyle = platformThemeData(
      context,
      material: (data) => defaultTitleStyle?.copyWith(fontWeight: FontWeight.w600),
      cupertino: (data) => data.textTheme.navTitleTextStyle,
    );

    defaultSmallStyle = platformThemeData(
      context,
      material: (data) => data.textTheme.titleMedium,
      cupertino: (data) => data.textTheme.navTitleTextStyle,
    );

    defaultLineStyle = platformThemeData(
      context,
      material: (data) => data.textTheme.titleMedium,
      cupertino: (data) => data.textTheme.navTitleTextStyle,
    );

    defaultTitleStyleWhite = platformThemeData(
      context,
      material: (data) => defaultTitleStyle?.copyWith(color: Colors.white),
      cupertino: (data) => defaultTitleStyle?.copyWith(color: Colors.white),
    );

    defaultSubheadStyleWhite = platformThemeData(
      context,
      material: (data) => defaultSubheadStyle?.copyWith(color: Colors.white),
      cupertino: (data) => defaultSubheadStyle?.copyWith(color: Colors.white),
    );
  }

  int hexStringToHexInt(String hex) {
    int val =0;
    hex = hex.replaceFirst('#', '');
    hex = hex.length == 6 ? 'ff' + hex : hex;
    val = int.parse(hex, radix: 16);
    return val;
  }
}*/
