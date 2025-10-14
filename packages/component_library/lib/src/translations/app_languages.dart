import 'dart:ui';

class AppLanguages {
  const AppLanguages();

  static  const List<Locale> supportedLocales =  [
    Locale('en', 'US'),
    Locale('ro', 'RO'),
  ];
  //static const List<String> appSupportedLanguages = ['en','ro'];

  static const List<Map<String, String>> appLanguages = [
  {
  "language" : "en",
  "name" : "English",
  "countryCode" : "US",
  "dateFormat": "yyyy_MM_dd"
  },
/*  {
    "language" : "de",
    "name" : "German",
    "countryCode" : "DE"
  },*/
/*  {
    "language" : "es",
    "name" : "Espaniol",
    "countryCode" : "ES"
  },*/
  /* {
    "language" : "fr",
    "name" : "Francais",
    "countryCode" : "FR"
  },*/
/*  {
    "language" : "it",
    "name" : "Italiano",
    "countryCode" : "IT",
    "dateFormat": "dd_MM_yyyy"
  },*/
  /* {
    "language" : "pt",
    "name" : "Portuges",
    "countryCode" : "PT"
  },*/
  {
  "language" : "ro",
  "name" : "Română",
  "countryCode" : "RO",
  "dateFormat": "dd_MM_yyyy"
  },
/*  {
    "language" : "ru",
    "name" : "Rusa",
    "countryCode" : "RU"
  }*/
  ];

}
