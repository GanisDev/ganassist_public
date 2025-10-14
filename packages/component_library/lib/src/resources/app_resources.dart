import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

import 'package:component_library/component_library.dart';

class AppResources {
  static const _appVersionNumber = '1.1.1';
  AppResources();

  static String get appVersionNumber => _appVersionNumber;

  static Future<void> sendFeedback(keyValueStorage, navigatorKey, String languageCode) async {
    try {
      String myPlatform = 'Android';
      if(defaultTargetPlatform == TargetPlatform.iOS){
        myPlatform = 'iOS"';
      }
      String osVer = await getOsVer();
      String mySubject = 'GanAssist v. $appVersionNumber $myPlatform $osVer ($languageCode) feedback';
      final Email email = Email(
        body: '',
        subject: mySubject,
        recipients: ['ganisdev@gmail.com'],
      );
      await FlutterEmailSender.send(email);
    } catch (e, stackTrace) {
      //sendError('func3015', e.toString(), stackTrace.toString());
      if(e.toString().contains('No email clients found')){
        double textSize = await keyValueStorage.getValue(key: 'textSize', type: int)+.0;
        double appScaleFactor = textSize/14;
        await AlertDialogModel(navigatorKey, appScaleFactor).showDialogModel(
          title: ('no_email_client').tr(args: ['']),
          buttons: {
            ('ok').tr(): false,
          },);
      } else {
        rethrow;
      }
      if (kDebugMode) {
        print(e.toString());
        print(stackTrace.toString());
      }
    }
  }

  static Future<String> getOsVer() async {
    try {
      var deviceInfo = await getDeviceInfo();
      String osV = '0';
      if (Platform.isIOS) {
        //return deviceInfo.identifierForVendor;
        return ' '; //todo get IOS ver info
      } else {
        if(deviceInfo != null && deviceInfo.version.release != null){
          var stringVer = deviceInfo.version.release;
          if(stringVer is String && stringVer.isNotEmpty){
            osV = stringVer;
          }
        }
      }
      return osV;
    } catch (e) {
      return '0';
    }
  }

  getOsVerInt() async{
    try {
      var xOsVerInt;
      int myOsVerInt = 0;
      var osVer = await getOsVer();
      if(osVer != "0"){
        if(osVer.contains('.')){
          xOsVerInt = double.tryParse(osVer);
          if(xOsVerInt != null){
            myOsVerInt = xOsVerInt.round();
          } else {
            xOsVerInt = int.tryParse(osVer.substring(0, 1));
            if(xOsVerInt != null){
              myOsVerInt = xOsVerInt;
            }
          }
        } else {
          xOsVerInt = int.tryParse(osVer);
          if(xOsVerInt != null){
            myOsVerInt = xOsVerInt;
          }
        }
      }
      return myOsVerInt;
    } catch (e) {
      return 0;
    }
  }

  static Future<dynamic> getDeviceInfo() async {
    var inf = DeviceInfoPlugin();
    late dynamic deviceInfo;
    if(defaultTargetPlatform == TargetPlatform.android){
      deviceInfo  = await inf.androidInfo;
    } else {
      deviceInfo = await inf.iosInfo;
    }
    return deviceInfo;
  }

  getDeviceBrand() async {
    if(defaultTargetPlatform == TargetPlatform.iOS){
      //return deviceInfo.identifierForVendor;
      return ' '; //todo iOS get brand
    } else {
      var deviceInfo = await getDeviceInfo();
      return deviceInfo.brand;
    }
  }



}