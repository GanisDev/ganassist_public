import 'dart:async';
import 'dart:isolate';

import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wakelock/wakelock.dart';

import 'package:component_library/component_library.dart';
import 'package:home/home.dart';
import 'package:monitoring/monitoring.dart';
import 'package:key_value_storage/key_value_storage.dart';


void main() async {

  late final errorReportingService = ErrorReportingService();

  runZonedGuarded<Future<void>>(() async {
      WidgetsFlutterBinding.ensureInitialized();
      await EasyLocalization.ensureInitialized();
      EasyLocalization.logger.enableBuildModes = [];
      await initializeMonitoringPackage();

      FlutterError.onError = errorReportingService.recordFlutterError;

      Isolate.current.addErrorListener(
        RawReceivePort((pair) async {
          final List<dynamic> errorAndStacktrace = pair;
          await errorReportingService.recordError(
            errorAndStacktrace.first,
            errorAndStacktrace.last,
          );
        }).sendPort,
      );

      KeyValueStorage  keyValueStorage = await KeyValueStorage.getInstance();
      ThemeMode themeMode = await getThemeMode(keyValueStorage);
      double textSize = (await keyValueStorage.getValue(key: 'textSize', type: int) ?? 14) +.0;
      double appScaleFactor = textSize/14;

      runApp(EasyLocalization(
        supportedLocales: AppLanguages.supportedLocales,
        path: 'packages/component_library/lib/src/translations',
        //startLocale: const Locale('ro', 'RO'),
        fallbackLocale: const Locale('en', 'US'),
        saveLocale: true,
        useOnlyLangCode: true,
        child: MyApp(themeMode : themeMode, keyValueStorage: keyValueStorage, appScaleFactor: appScaleFactor),
      ));
    },
      (error, stack) => errorReportingService.recordError(
          error,
          stack,
          fatal: true,
        ),
  );
}


class MyApp extends StatefulWidget {
    MyApp({
     super.key, required this.themeMode, required this.keyValueStorage, required this.appScaleFactor}) : navigatorKey = GlobalKey<NavigatorState>();

   final ThemeMode themeMode;
   final KeyValueStorage keyValueStorage;
   final GlobalKey<NavigatorState> navigatorKey;
    final double appScaleFactor;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final ThemeMode _themeMode = widget.themeMode;

  @override
  void initState()  {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge); // Enable Edge-to-Edge on Android 10+
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent, // Setting a transparent navigation bar color
    ));
    _appInitState();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    AppTheme appTheme = AppTheme();
    appTheme.init();
    List<LocalizationsDelegate> appLocalizationsDelegates =  makeLocalizationsDelegates();
    return PlatformProvider(
      settings: PlatformSettingsData(
        iosUsesMaterialWidgets: true,
        iosUseZeroPaddingForAppbarPlatformIcon: true,
      ),
      builder: (context) => PlatformTheme(
        themeMode: _themeMode,
        materialLightTheme: appTheme.materialLightTheme,
        materialDarkTheme: appTheme.materialDarkTheme,
        cupertinoLightTheme: appTheme.cupertinoLightTheme,
        cupertinoDarkTheme: appTheme.cupertinoDarkTheme,
        matchCupertinoSystemChromeBrightness: true,
/*        onThemeModeChanged: (themeMode) {
          _themeMode = themeMode;
*//*          bool darkMode = _themeMode == ThemeMode.dark;
          widget.keyValueStorage.upsertValue(key: 'darkMode', value: darkMode);*//*
        },*/
        builder: (context) {
          appTheme.initTextStyles(context);
          return PlatformApp(
            navigatorKey: widget.navigatorKey,
            debugShowCheckedModeBanner: false,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            //localizationsDelegates: context.localizationDelegates ,
            localizationsDelegates: appLocalizationsDelegates,
            title: 'GanAssist',
            home:  HomeScreen(keyValueStorage: widget.keyValueStorage, navigatorKey:  widget.navigatorKey, appScaleFactor: widget.appScaleFactor),
          );
        },
      ),
      // ),
    );
  }

  _appInitState() async {
    if(mounted){
    }
    bool  screenAlwaysOn = await widget.keyValueStorage.getValue(key: 'screenAlwaysOn', type: bool) ?? false;
    if(screenAlwaysOn) {
      if (!await Wakelock.enabled) {
        await Wakelock.enable();
      }
    }
  }

  List<LocalizationsDelegate> makeLocalizationsDelegates(){
    List<LocalizationsDelegate> appLocalizationsDelegates =  [];
    appLocalizationsDelegates.addAll(EasyLocalization.of(context)!.delegates);
    appLocalizationsDelegates.addAll([
      DefaultMaterialLocalizations.delegate,
      DefaultWidgetsLocalizations.delegate,
      DefaultCupertinoLocalizations.delegate,
    ]);
    return appLocalizationsDelegates;
  }

}


Future<ThemeMode> getThemeMode(KeyValueStorage keyValueStorage) async {
  bool? darkMode = await keyValueStorage.getValue(key:'darkMode', type: bool);

  if(darkMode == null){
    var brightness = SchedulerBinding.instance.platformDispatcher.platformBrightness;
    bool isOSDarkMode = brightness == Brightness.dark;
    if(isOSDarkMode){
      darkMode = true;
      await keyValueStorage.upsertValue(key: 'darkMode', value: true);
    } else {
      darkMode = false;
    }
  }

  switch(darkMode){
    case true:
      return ThemeMode.dark;
    case false:
      return ThemeMode.light;
/*    case 'system':
      return ThemeMode.system;*/
    default:
      return ThemeMode.light;
  }
}


