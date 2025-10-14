import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:appcheck/appcheck.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../component_library.dart';


typedef AppSelected = Future<void> Function(String appName,String packageName, dynamic icon, String link);

class AppSupportedNavs {
  AppSupportedNavs({
    required this.onAppSelected
});

  AppSelected onAppSelected;

   List<dynamic> supportedNavAppsList = [
    {
      "name" : "Google Maps",
      "searchString" : "com.google.android.apps.maps",
      "needsInternet":true,
      "textLink" : "http://maps.google.com/?q={lat},{long}",
      "link" : "http://maps.google.com/?q={lat},{long}" //https://www.google.com/maps/search/?api=1&query=36.26577,-92.54324
    },
    {
      "name" : "Google Navigation",
      "searchString" : "com.google.android.apps.maps",
      "needsInternet":true,
      "link" : "https://www.google.com/maps/dir/?api=1&destination={lat},{long}&dir_action=navigate",
      "textLink" : "https://www.google.com/maps/dir/?api=1&destination={lat},{long}&dir_action=navigate",
      //"link" : "https://www.google.com/maps/dir/?api=1&waypoints={lat}%2C{long}"
      //"link" : "https://www.google.com/maps/search/?api=1&query={lat},{long}" //https://www.google.com/maps/search/?api=1&query=36.26577,-92.54324
      //"link" : "https://www.google.com/maps/search/?api=1&query={lat},{long}" //https://www.google.com/maps/search/?api=1&query=36.26577,-92.54324
    },
    {
      "name" : "Here WeGo",
      "searchString" : "com.here.app.maps",
      "needsInternet":true,
      "textLink" : "",
      //"link" : "here.directions://v1.0/mylocation/{lat},{long}" // here.directions://v1.0/mylocation/37.870090,-122.268150,Downtown%20Berkeley?ref=<Referrer>&m=w
      "link" : "http://share.here.com/l/{lat},{long}?p=yes"
    },
    {
      "name" : "iGo Primo",
      "searchString" : "com.nng.igoprimong.nextgen",
      "needsInternet":false,
      "textLink" : "",
      "link" : "geo:{lat},{long}"
      //"link" : "igomyway://G{long};{lat}" //igomyway://G47.498562;19.040910
    },
    {
      "name" : "iGo Primo Gift",
      "searchString" : "com.nng.igoprimong.gift",
      "needsInternet":false,
      "textLink" : "",
      "link" : "geo:{lat},{long}"
      //"link" : "igomyway://G{long};{lat}" //igomyway://G47.498562;19.040910
    },
    {
      "name" : "iGo Navigation",
      "searchString" : "com.nng.igo.primong.igoworld",
      "needsInternet":false,
      "textLink" : "",
      "link" : "geo:{lat},{long}"
      //"link" : "igomyway://G{long};{lat}" //igomyway://G47.498562;19.040910
    },
    {
      "name" : "Locus Map Classic",
      //"searchString" : "locus.",
      "searchString" : "menion.android.locus.pro",
      "needsInternet":false,
      "textLink" : "",
      //"link" : "https://www.google.com/maps/search/?api=1&query={lat},{long}" //https://www.google.com/maps/search/?api=1&query=36.26577,-92.54324
      "link" : "geo:{lat},{long}"
    },
    {
      "name" : "Locus Map",
      //"searchString" : "locus.",
      "searchString" : "menion.android.locus",
      "needsInternet":false,
      "textLink" : "",
      //"link" : "https://www.google.com/maps/search/?api=1&query={lat},{long}" //https://www.google.com/maps/search/?api=1&query=36.26577,-92.54324
      "link" : "geo:{lat},{long}"
    },
    {
      "name" : "Maps.me",
      "searchString" : "com.mapswithme.maps.pro",
      "needsInternet":false,
      "textLink" : "",
      "link" : "https://dlink.maps.me/map?v=1&ll={lat},{long}" //https://dlink.maps.me/map?v=1&ll=54.32123,12.34562
    },
     {
       "name" : "OsmAnd — Maps & GPS Offline",
       "searchString" : "net.osmand",
       "needsInternet":false,
       "textLink" : "",
       "link" : "https://osmand.net/go?lat={lat}&lon={long}&z=20"
     },
    {
      "name" : "Sygic",
      "searchString" : "com.sygic.aura",
      "needsInternet":false,
      "textLink" : "",
      "link" : "com.sygic.aura://coordinate|{long}|{lat}|show" //com.sygic.aura://coordinate|15.06591|47.73341|show
    },
    {
      "name" : "Waze",
      "searchString" : "com.waze",
      "needsInternet":true,
      "textLink" : "https://www.waze.com/ul?ll={lat},{long}&navigate=yes",
      "linkView" : "https://www.waze.com/ul?ll={lat},{long}&zoom=15", //https://www.waze.com/ul?ll=40.75889500%2C-73.98513100&navigate=yes&zoom=17
      "link" :     "https://www.waze.com/ul?ll={lat},{long}&navigate=yes" //https://www.waze.com/ul?ll=40.75889500,-73.98513100&z=6
    },
  ];

  Future<List> generateSupportedAppsList() async {
    List appsList = [];
    try {
      bool addToList = false;
      for (Map supportedNavApp in supportedNavAppsList){
        addToList = false;
        try {
          await AppCheck.checkAvailability(supportedNavApp['searchString']).then((app) async{
            //print('');
            if(app != null){
              bool isEnabled = await AppCheck.isAppEnabled(supportedNavApp['searchString']);
              if(isEnabled){
                if (supportedNavApp['searchString'].contains('nng.igoprimo')){
                  if(app.versionName!.substring(0, 4) == '9.6.'){
                    addToList = true;
                  }
                } else {
                  addToList = true;
                }
                if (addToList){
                  String? name = app.appName;
                  List<int>? list = app.appIcon?.codeUnits;
                  var icon =  Uint8List.fromList(list!);
                  if (supportedNavApp['name'].contains('Google')){
                    name = supportedNavApp['name'];
                  }
                  appsList.add(
                      {
                        "appName": name,
                        "packageName": app.packageName,
                        "versionName": app.versionName,
                        "icon": icon,
                        "link": supportedNavApp['link'],
                        "linkView": supportedNavApp['linkView'] ?? '',
                        "textLink": supportedNavApp['textLink'],
                      }
                  );
                }
              }
            }

          });
        } on PlatformException catch (e, stackTrace) {
          if (kDebugMode) {
            print(e.toString());
            print(stackTrace.toString());
          }
        }
      }
    } catch (e, stackTrace) {
      //appResources.sendError('func017', e.toString(), stackTrace.toString());
      if (kDebugMode) {
        print(e.toString());
        print(stackTrace.toString());
      }
      rethrow;
    }
    return appsList;
  }


  getApp(BuildContext context) async {
    try {
     // const ManagedProgressIndicator().showMyProgressIndicator(context, 'loading',('loading').tr(), false);

      var supportedApps = await generateSupportedAppsList();

      if(context.mounted){
       // const ManagedProgressIndicator().dismissMyProgressIndicator(context,'loading');
      }

      String myTitle = '';
      if(supportedApps.isNotEmpty){
      //if(false){
        myTitle = ('select_app').tr();
      } else {
        myTitle = ('no_app').tr();
      }
      if(context.mounted){
        await showDialog(
          barrierDismissible: true,
          context: context,
          builder: (context) {
            return AlertDialog(
                contentPadding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 5.0, bottom: 5.0 ),
                titlePadding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 15.0, bottom: 10.0 ),
                title: Text(myTitle, textAlign: TextAlign.center, style: appTheme.defaultTitleStyle),
                content: SingleChildScrollView(
                  padding: const EdgeInsets.all(0.0),
                  child: Column(
                      children: generateGridItems(context, supportedApps)//<Widget>[
                  ),
                )
            );
          },
        );
      }

    } catch (e, stackTrace) {
      //appResources.sendError('func108', e.toString(), stackTrace.toString());
      rethrow;
    }
  }

  generateGridItems(context, supportedApps )  {
    List<Widget> appsRowsList = [];
    try {
      if(supportedApps.isNotEmpty){
        //if(false){
        for (var app in supportedApps) {
          //List<int> list = app['icon'].codeUnits;
          var icon =   MemoryImage(app['icon']);
          appsRowsList.add(
              ListTile(
                contentPadding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                title: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    //const SizedBox(height: 5.0,),
                    CircleAvatar(
                      backgroundImage: app['icon'].isEmpty ? null : icon,
                      backgroundColor: Colors.white,
                    ),
                    const SizedBox(width: 10.0,),
                    Expanded(
                      child: Text(
                        app['appName'],
                        maxLines: null,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        style: appTheme.defaultSubheadStyle,
                      ),
                    ),
                  ],
                ),
                onTap: () async {
                  if (Navigator.of(context).canPop()) Navigator.of(context).pop();
                  String myLink = app['link'];
/*              if (myLink.contains('waze')){
                if (appResources.wazeLink'] == 'view'){
                  myLink = app['linkView'] ?? '';
                }
              }*/
                  await onAppSelected(app['appName'],app['packageName'],app['icon'],myLink);
                  //await handleDefaultNavApp(app['appName'],app['packageName'],app['icon'],myLink);
                },
              )

          );
        }
      } else {
        //no suported apps installed

        appsRowsList.add(
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              //const SizedBox(width: 10.0,),
              SizedBox(
                height: 30.0,
                //width: myColumnWidth -10,
                child: Text(
                  ('supported_apps').tr(),
                  maxLines: null,
                  softWrap: true,
                  textAlign: TextAlign.start,
                  //style: Theme.of(appResources.).textTheme.titleMedium,
                ),
              ),
            ],
          ),
        );

        for (var app in supportedNavAppsList) {
          appsRowsList.add(
              ListTile(
                contentPadding: const EdgeInsets.only(left: 5.0, top: 0.0, bottom: 0.0),
                title: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    //const SizedBox(width: 10.0,),
                    Expanded(
                      child: Text(
                        app['name'],
                        //maxLines: null,
                        //softWrap: true,
                        //overflow: TextOverflow.ellipsis,
                        //style: defaultSubheadStyle,
                      ),
                    ),
                  ],
                ),
                onTap: () async {
                },
              )
          );
        }

        appsRowsList.add(
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    textStyle:  const TextStyle(color: AppTheme.myColor50),
                    side: const BorderSide(width: 1.0, color: AppTheme.myColor100),
                    shape: RoundedRectangleBorder(borderRadius: AppTheme.buttonBorderRadius),
                  ),
                  onPressed: () {
                    if (Navigator.of(context).canPop()) Navigator.of(context).pop();
                  },
                  child: Text(('ok').tr(),),
                ),
              ],
            )
        );
      }
    } catch (e, stackTrace) {
        //appResources.sendError('func019', e.toString(), stackTrace.toString());
      rethrow;
    }
      return appsRowsList;
  }


 /* Future<void> handleDefaultNavApp(String appName, String packageName, icon, String link) async {
    await keyValueStorage.upsertValue(key: 'defaultNavAppIcon', value: MemoryImage(icon));
    await keyValueStorage.upsertValue(key: 'defaultNavAppName', value: appName);
    await keyValueStorage.upsertValue(key: 'defaultNavAppPackageName', value: packageName);
    await keyValueStorage.upsertValue(key: 'defaultNavLink', value: link);

    // appResources.appPreferences['defaultNavAppIcon'] = MemoryImage(icon);

    // await appResources.saveOnePreference('defaultNavAppIcon', String.fromCharCodes(icon));

  }*/

}









