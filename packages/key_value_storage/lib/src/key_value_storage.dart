import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KeyValueStorage {
  static const appStorageKey = "GanAssist_";
  static KeyValueStorage? _instance;
  final SharedPreferences _sharedPreferences;

  static Future<KeyValueStorage> getInstance() async {
    if (_instance == null) {
      final sharedPreferences = await SharedPreferences.getInstance();
      _instance = KeyValueStorage._(sharedPreferences);
    }
    return _instance!;
  }

  KeyValueStorage._(SharedPreferences sharedPreferences)
      : _sharedPreferences = sharedPreferences {
          upsertDefaultValues();
        }

  static Future<dynamic> loadAppPrefsJson() async {
    String jsonContent = await rootBundle.loadString("packages/key_value_storage/assets/preferences.json");
    return json.decode(jsonContent);
  }

   Future<void>  upsertDefaultValues() async {
    try {
      dynamic value;
      var myAppPrefs = await loadAppPrefsJson();

      myAppPrefs.forEach((jsonPref) {
        final String name = jsonPref['name'];
        if(jsonPref['default'] is List) {
          value = _sharedPreferences.getStringList(appStorageKey + name);
        } else {
          value = _sharedPreferences.get(appStorageKey + name);
        }
        if (value == null){
          if(jsonPref['default'] is List) {
            value = [];
          } else {
            value = jsonPref['default'];
          }
          upsertValue(key: name, value: value);
        }
      });

    } catch (e, stackTrace) {
      //appResources.sendError('func010', e.toString(), stackTrace.toString());
      if (kDebugMode) {
        print(e.toString());
        print(stackTrace.toString());
      }
      rethrow;
    }
  }

  Future<dynamic> getValue({
    required String key,
    required Type type
  }) async {
    if(type == List){
      return _sharedPreferences.getStringList(appStorageKey + key);
    } else {
      return _sharedPreferences.get(appStorageKey + key);
    }
  }

  Future<void> upsertValue({
    required String key,
    required dynamic value
  }) async {
    switch (value.runtimeType) {
      case String:
        await _sharedPreferences.setString(appStorageKey + key, value);
        break;
      case int:
        await _sharedPreferences.setInt(appStorageKey + key, value);
        break;
      case double:
        await _sharedPreferences.setDouble(appStorageKey + key, value);
        break;
      case bool:
        await _sharedPreferences.setBool(appStorageKey + key, value);
        break;
      default:
        List<String> myList = [];
        if (value.isNotEmpty){
          for(var item in value){
            if(item !is String){
              item = item.toString();
            }
            myList.add(item);
          }
          await _sharedPreferences.setStringList(appStorageKey + key, myList );
        } else {
          await _sharedPreferences.setStringList(appStorageKey + key, myList);
        }
        break;
    }
  }
}

class KeyValueStorage2 {
  static const appStorageKey = "GanAssist_";
  static final KeyValueStorage2 _singleton = KeyValueStorage2._internal();

  factory KeyValueStorage2() {
    return _singleton;
  }

  KeyValueStorage2._internal();

  static SharedPreferences? _sharedPreferences;

  static Future<void> init() async {
    if(_sharedPreferences == null){
      final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      _sharedPreferences = sharedPreferences;
    }
    return;
  }


  static Future<dynamic> getValue(key) async {
    return _sharedPreferences?.get(appStorageKey + key);
  }


}

/*
class MyComponent{
  /// Private constructor
  MyComponent._create() {
    print("_create() (private constructor)");

    // Do most of your initialization here, that's what a constructor is for
    //...
  }

  /// Public factory
  static Future<MyComponent> create() async {
    print("create() (public factory)");

    // Call the private constructor
    var component = MyComponent._create();

    // Do initialization that requires async
    //await component._complexAsyncInit();

    // Return the fully initialized object
    return component;
  }
}*/



class FileSystemManager {
  static final FileSystemManager _instance = FileSystemManager._internal();
  static const appStorageKey = "GanAssist_";
  static SharedPreferences? _sharedPreferences;

  factory FileSystemManager() {
    return _instance;
  }

  FileSystemManager._internal() {
    init();
  }

  static Future<void> init() async{
    if(_sharedPreferences == null){
      final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      _sharedPreferences = sharedPreferences;
    }
  }

  static Future<dynamic> getValue(String key) async {
    return _sharedPreferences?.get(appStorageKey + key);
  }

  void openFile() {}
  void writeFile() {}
}

class StoreService {
  static const appStorageKey = "GanAssist_";
  static StoreService? _instance;
  static SharedPreferences? _sharedPreferences;

  StoreService._();

  static Future<StoreService> instance() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _instance ??= StoreService._();
    return _instance!;
  }

  static Future<dynamic> getValue(String key) async {
    //await init();
    //await _sharedPreferences?.reload();
    return _sharedPreferences?.get(appStorageKey + key);
  }
}

class KeyValueStorage3 {
  static const appStorageKey = "GanAssist_";

  // KeyValueStorage2();

  static SharedPreferences? _sharedPreferences;

  static Future<void> init() async{
    if(_sharedPreferences == null){
      final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      _sharedPreferences = sharedPreferences;
    }
  }

  static Future<dynamic> getValue(key) async {
    //await init();
    //await _sharedPreferences?.reload();
    return _sharedPreferences?.get(appStorageKey + key);
  }


}



