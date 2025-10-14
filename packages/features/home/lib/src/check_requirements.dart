part of 'home_screen_cubit.dart';




Future<bool> checkRequirements(NearbyCubit cubit) async {
  bool myRet = false;
  int osVerInt = await AppResources().getOsVerInt();

  // google play services
  if(! await checkPlayServices(cubit)){
     return false;
  }

  //defaultNavAppPackageName
  String defaultNavAppPackageName = await cubit.keyValueStorage.getValue(key: 'defaultNavAppPackageName', type: String) ?? '';
  if (defaultNavAppPackageName.isEmpty) {
    cubit.emitState(const NearbyCheckingRequirements(requestedRequirement: RequestedRequirement.defaultNavApp));
    return false;
  }

  //name
  String name = await cubit.keyValueStorage.getValue(key: 'name', type: String) ?? '';
  if (name.isEmpty || name == 'Name???') {
    cubit.emitState(const NearbyCheckingRequirements(requestedRequirement: RequestedRequirement.name));
    return false;
  }

  //isLocPermissionGranted
  bool isLocPermissionGranted = await Permission.location.isGranted;
  if (!isLocPermissionGranted) {
    String argText = ('allow').tr();
    if (osVerInt >= 11) {
      argText = ('while_in_use').tr();
    }
    var myText = RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(text: ('app_perm').tr(), style: AppTheme().defaultSubheadStyle),
          TextSpan(text: ('access_to').tr(args: [('location').tr()]), style: AppTheme().defaultTitleStyle),
          TextSpan(text: '\n\n${('ok_ask_permission').tr(args: [argText])}', style: AppTheme().defaultSubheadStyle),
        ],
      ),
    );
    final couldRequest = await cubit.alertDialogModel.showDialogModel(
      title: myText, //
      buttons: {
        ('cancel').tr(): false,
        ('ok').tr(): true,
      },);
    if (couldRequest) {
      cubit.emitState(const ShowingSystemWindow());
      PermissionStatus status = await Permission.location.request();
      await Future.delayed(const Duration(milliseconds: 20));
      myRet = status == PermissionStatus.granted;
      cubit.emitState(const NotShowingSystemWindow());
    }
    if (!myRet) {
      await showRequirementsProblemDialog(cubit, 'location');
      return false;
    }
  }

  //isLocEnabled
  ServiceStatus serviceStatus = await Permission.location.serviceStatus;
  bool isLocEnabled = serviceStatus == ServiceStatus.enabled;
  if (!isLocEnabled) {
    var myText = RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(text: ('ensure_functionality').tr(), style: AppTheme().defaultSubheadStyle),
          TextSpan(text: ('please_enable').tr(), style: AppTheme().defaultTitleStyle),
          TextSpan(text: '\n\n${('press_ok_settings').tr()}', style: AppTheme().defaultSubheadStyle),
        ],
      ),
    );
    final couldRequest = await cubit.alertDialogModel.showDialogModel(
      title: myText,
      buttons: {
        ('cancel').tr(): false,
        ('ok').tr(): true,
      },);
    if (couldRequest) {
      //cubit.emitState(const ShowingSystemWindow());
      cubit.isAwaiting = true;
      await AppSettings.openLocationSettings();
      while (cubit.isAwaiting) {
        await Future.delayed(const Duration(milliseconds: 200));
      }

      serviceStatus = await Permission.location.serviceStatus;
      myRet = serviceStatus == ServiceStatus.enabled;
      //cubit.emitState(const NotShowingSystemWindow());
    } else {
      myRet = false;
    }
    if (!myRet) {
      await showRequirementsProblemDialog(cubit, 'location');
      return false;
    }
  }

  //isBluePermissionGranted

  if( osVerInt >= 12){
   bool isBluePermissionGranted = !(await Future.wait([
      Permission.bluetooth.isGranted,
      Permission.bluetoothAdvertise.isGranted,
      Permission.bluetoothConnect.isGranted,
      Permission.bluetoothScan.isGranted,
    ])).any((element) => element == false);

    if(!isBluePermissionGranted){
      var myText = RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: <TextSpan>[
            TextSpan(text: ('app_perm').tr(), style: AppTheme().defaultSubheadStyle),
            TextSpan(text: ('bluetooth_permission').tr(), style: AppTheme().defaultTitleStyle),
            TextSpan(text: '\n\n${('ok_ask_permission').tr(args: [('allow').tr()])}', style: AppTheme().defaultSubheadStyle),
          ],
        ),
      );
      if( osVerInt >= 13){
        myText = RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(text: ('app_perm').tr(), style: AppTheme().defaultSubheadStyle),
              TextSpan(text: ('nearbyWifiDevices_permission').tr(), style: AppTheme().defaultTitleStyle),
              TextSpan(text: '\n\n${('ok_ask_permission').tr(args: [('allow').tr()])}', style: AppTheme().defaultSubheadStyle),
            ],
          ),
        );
      }
      final couldRequest = await cubit.alertDialogModel.showDialogModel(
        title: myText,
        buttons: {
          ('cancel').tr(): false,
          ('ok').tr(): true,
        },);
      if(couldRequest){
        //cubit.emitState(const ShowingSystemWindow());
        cubit.isAwaiting = true;
        await [
          Permission.bluetooth,
          Permission.bluetoothAdvertise,
          Permission.bluetoothConnect,
          Permission.bluetoothScan
        ].request();
/*        await cubit.alertDialogModel.showDialogModel(
          title: '${('app_perm').tr(args: ['Bluetooth'])}\n\n${('press_ok_continue').tr()}',
          buttons: {
            ('ok').tr(): true,
          },);*/
        while (cubit.isAwaiting) {
          await Future.delayed(const Duration(milliseconds: 200));
        }
        myRet = !(await Future.wait([
          Permission.bluetooth.isGranted,
          Permission.bluetoothAdvertise.isGranted,
          Permission.bluetoothConnect.isGranted,
          Permission.bluetoothScan.isGranted,
        ])).any((element) => element == false);
        //cubit.emitState(const NotShowingSystemWindow());
      } else {
        myRet = false;
      }
      if(!myRet){
        await showRequirementsProblemDialog(cubit, 'bluetooth');
        return false;
      }
    }
 }

  if( osVerInt >= 13){
    //nearbyWifiDevices
    bool isNearbyWifiDevicesPermissionGranted = await Permission.nearbyWifiDevices.isGranted;
    if(!isNearbyWifiDevicesPermissionGranted){
      await Permission.nearbyWifiDevices.request();
      myRet = await Permission.nearbyWifiDevices.isGranted;
      if(!myRet){
        await showRequirementsProblemDialog(cubit, 'relative_position');
        return false;
      }
    }
    //todo de verificat ce e mai jos in dart3
 /*   if(!isNearbyWifiDevicesPermissionGranted){
      var myText = RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: <TextSpan>[
            TextSpan(text: ('app_perm').tr(), style: AppTheme().defaultSubheadStyle),
            TextSpan(text: ('nearbyWifiDevices_permission').tr(), style: AppTheme().defaultTitleStyle),
            TextSpan(text: '\n\n${('ok_ask_permission').tr(args: [('allow').tr()])}', style: AppTheme().defaultSubheadStyle),
          ],
        ),
      );
      final couldRequest = await cubit.alertDialogModel.showDialogModel(
        title: myText,
        buttons: {
          ('cancel').tr(): false,
          ('ok').tr(): true,
        },);
      if(couldRequest){
        //cubit.emitState(const ShowingSystemWindow());
        cubit.isAwaiting = true;
        await Permission.nearbyWifiDevices.request();

        while (cubit.isAwaiting) {
          await Future.delayed(const Duration(milliseconds: 200));
        }
        myRet = await Permission.nearbyWifiDevices.isGranted;
        //cubit.emitState(const NotShowingSystemWindow());
      } else {
        myRet = false;
      }
      if(!myRet){
        await showRequirementsProblemDialog(cubit, 'relative_position');
        return false;
      }
    }*/
  }

  if(osVerInt >= 10){
    //systemAlertWindow
    bool permissionGranted = await Permission.systemAlertWindow.isGranted;
    if (!permissionGranted) {
      String finalText = ('ok_systemAlertWindow').tr(args: ['']);
      if (osVerInt >= 13) {
        finalText = ('ok_systemAlertWindow_13').tr();
      }
      var myText = RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: <TextSpan>[
            TextSpan(text: ('ensure_functionality').tr(), style: AppTheme().defaultSubheadStyle),
            TextSpan(text: ('displayed_over').tr(), style: AppTheme().defaultTitleStyle),
            TextSpan(text: '\n\n$finalText', style: AppTheme().defaultSubheadStyle),
          ],
        ),
      );
      final couldRequest = await cubit.alertDialogModel.showDialogModel(
        title: myText, //
        buttons: {
          ('cancel').tr(): false,
          ('ok').tr(): true,
        },);
      if (couldRequest) {
        cubit.isAwaiting = true;
        PermissionStatus status = await Permission.systemAlertWindow.request();
        while (cubit.isAwaiting) {
          await Future.delayed(const Duration(milliseconds: 200));
        }
        myRet = status == PermissionStatus.granted;
      }
      if (!myRet) {
        await showRequirementsProblemDialog(cubit, 'no_systemAlertWindow');
        return false;
      }
    }
  }

  myRet = await handleDisableOptimizeBattery(cubit);
  if(!myRet){
    await showRequirementsProblemDialog(cubit, 'battery_optimization_disabled');
    return false;
  }

  //autostart
  myRet = await handleBackgroundSettings(
      level: 'autostart',
      type: 'toCheckSettings',
      cubit: cubit);
  if(!myRet){
    await showRequirementsProblemDialog(cubit, 'autostart_settings');
    return false;
  }

  //power_settings
  myRet = await handleBackgroundSettings(
      level: 'power',
      type: 'toCheckSettings',
      cubit: cubit);
  if(!myRet){
    await showRequirementsProblemDialog(cubit, 'power_settings');
    return false;
  }
  return true;
}

Future<void> showRequirementsProblemDialog(NearbyCubit cubit, text) async {
  await cubit.alertDialogModel.showDialogModel(
    title: ('unable_nearby_location').tr(args: [('$text').tr()]),
    buttons: {
      ('close').tr(): true,
    },);
}


Future<bool> handleDisableOptimizeBattery(NearbyCubit cubit) async {
  bool isIgnored = false;
  try {
    isIgnored = await OptimizeBattery.isIgnoringBatteryOptimizations();
    if (!isIgnored) {
      var myText =  RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: <TextSpan>[
            TextSpan(text: ('vendor_settings').tr(), style: AppTheme().defaultSubheadStyle),
            TextSpan(text: ('battery_optimization').tr(), style: AppTheme().defaultTitleStyle),
            TextSpan(text: '\n\n${('ok_ask_permission').tr(args: [('allow').tr()])}', style: AppTheme().defaultSubheadStyle),
          ],
        ),
      );
      var myVal = await cubit.alertDialogModel.showDialogModel(
        title: myText,
        buttons: {
          ('cancel').tr(): false,
          ('ok').tr(): true,
        },);
      if(myVal){
        //cubit.emitState(const ShowingSystemWindow());
        cubit.isAwaiting = true;
        isIgnored = await OptimizeBattery.stopOptimizingBatteryUsage();

  /*      myText =  RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(text: ('vendor_settings').tr(), style: AppTheme().defaultSubheadStyle),
              TextSpan(text: ('battery_optimization').tr(), style: AppTheme().defaultSubheadStyle),
              TextSpan(text: '\n\n${('press_ok_continue').tr()}', style: AppTheme().defaultTitleStyle),
            ],
          ),
        );
        myVal = await cubit.alertDialogModel.showDialogModel(
          title: myText,
          buttons: {
            ('ok').tr(): true,
          },);*/
        while (cubit.isAwaiting) {
          await Future.delayed(const Duration(milliseconds: 200));
        }
        isIgnored = await OptimizeBattery.isIgnoringBatteryOptimizations();
        //cubit.emitState(const NotShowingSystemWindow());
      } else {
        return false;
      }
    }
  } catch (e, stackTrace) {
    //appResources.sendError('func003', e.toString(), stackTrace.toString());
    rethrow;
  }
  return isIgnored;
}


handleBackgroundSettings({String? level, String? type,  NearbyCubit? cubit}) async {
  bool myRet = false;
  try {
    if (defaultTargetPlatform == TargetPlatform.android){
      bool preferencesSaved =  await cubit!.keyValueStorage.getValue(key: level == 'autostart' ? 'autoStartChecked' :'manPowerChecked', type: bool);
      if(type == 'toCheckSettings'){
        if(preferencesSaved){
            return true;
        }
      }

      try {
        AndroidIntent intent;
        String deviceBrand = await AppResources().getDeviceBrand();
        String jsonContent = await rootBundle.loadString("packages/features/home/assets/vendor_settings.json");
        List vendorSettingsList =  json.decode(jsonContent);
        vendorSettingsList.removeWhere((i) => i['type'] != level || !i['vendor'].contains(deviceBrand));
        if(vendorSettingsList.isNotEmpty){
          for (var item in vendorSettingsList) {
            myRet = false;
            if(item['category'] != null && item['category'].isNotEmpty){
              intent =  AndroidIntent(
                  action: 'action_view',
                  package: item['package'],
                  componentName: item['componentName'],
                  category: item['category']
              );
            } else if(item['data'] != null && item['data'].isNotEmpty){
              intent =  AndroidIntent(
                  action: 'action_view',
                  package: item['package'],
                  componentName: item['componentName'],
                  data: item['data']
              );
            } else if(item['action'] != null && item['action'].isNotEmpty){
              intent =  AndroidIntent(
                  action: item['action']
              );
            } else {
              intent =  AndroidIntent(
                  action: 'action_view',
                  package: item['package'],
                  componentName: item['componentName']
              );
            }
            bool? canResolveActivity= await intent.canResolveActivity();
            if(canResolveActivity != null && canResolveActivity){
              if(type == 'toShowSettings'){
                return true;
              } else {
                var myText =  RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(text: ('vendor_settings').tr(), style: AppTheme().defaultSubheadStyle),
                      TextSpan(text: '${item['translated']}'.tr(), style: AppTheme().defaultTitleStyle),
                      TextSpan(text: '\n\n${('press_ok_settings').tr()}', style: AppTheme().defaultSubheadStyle),
                    ],
                  ),
                );
                var myVal = await cubit.alertDialogModel.showDialogModel(
                  title: myText,
                  buttons: {
                    ('cancel').tr(): false,
                    ('ok').tr(): true,
                  },);
                if(myVal){
                  myRet = true;
                  //cubit.emitState(const ShowingSystemWindow());
                  cubit.isAwaiting = true;
                  await launchIntent({'intent': intent});
  /*                myText =  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(text: ('vendor_settings').tr(), style: AppTheme().defaultSubheadStyle),
                        TextSpan(text: '${item['translated']}'.tr(), style: AppTheme().defaultSubheadStyle),
                        TextSpan(text: '\n\n${('press_ok_continue').tr()}', style: AppTheme().defaultTitleStyle),
                      ],
                    ),
                  );
                  myVal = await cubit.alertDialogModel.showDialogModel(
                    title: myText,
                    buttons: {
                      ('ok').tr(): true,
                    },);
                  cubit.emitState(const NotShowingSystemWindow());*/
                  while (cubit.isAwaiting) {
                    await Future.delayed(const Duration(milliseconds: 200));
                  }
                } else {
                  await showRequirementsProblemDialog(cubit, 'power_settings');
                  return false;
                }
              }
            } else {
              if(type == 'toShowSettings') {
                return false;
              }
                myRet = true;
            }
          }

          if(type == 'toCheckSettings') {
            await cubit.keyValueStorage.upsertValue(key: level == 'autostart' ?'autoStartChecked' :'manPowerChecked', value: true);
          }
        } else {
          myRet = true;
          if(type == 'toShowSettings') {
            return false;
          } else {
            await cubit.keyValueStorage.upsertValue(key: level == 'autostart' ?'autoStartChecked' :'manPowerChecked', value: true);
          }

        }
      } on PlatformException catch (e, stackTrace) {
        if (kDebugMode) {
          print(e.toString());
          print(stackTrace.toString());
        }
        rethrow;
        //appResources.sendError('func004', e.toString(), stackTrace.toString());
      }


    }
  } catch (e, stackTrace) {
    if (kDebugMode) {
      print(e.toString());
      print(stackTrace.toString());
    }
    rethrow;
    //appResources.sendError('func005', e.toString(), stackTrace.toString());
  }
  return myRet;
}

launchIntent(params) async {
  try {
    if(await params['intent'].canResolveActivity()){
      await params['intent'].launch();
    }
  } catch (e) {
    if(e.toString().contains('No Activity found to handle Intent')){
      //dismissMyManagedDialog('vendor', false);
    }
  }
}


Future checkPlayServicesApp() async {
/*  Map myRet = {
    'available': false,
    'version': ''
  };*/
  String googleVer = '';
  try {
    await AppCheck.checkAvailability('com.google.android.gms').then((app) async{
      //print('');
      if(app != null){
        bool isEnabled = await AppCheck.isAppEnabled('com.google.android.gms');
        if(isEnabled){
/*          myRet = {
            'available': true,
            'version': app.versionName
          };*/
          googleVer = app.versionName ?? '';
          if(googleVer.contains(' (')){
            googleVer = googleVer.split(' (')[0];
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
  return googleVer;
}

Future<bool> checkPlayServices(cubit) async {
  //todo iOS
  bool myRet = false;
  bool showNoServices = true;
  if (Platform.isAndroid) {
    GooglePlayServicesAvailability playStoreAvailability;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      playStoreAvailability = await GoogleApiAvailability.instance.checkGooglePlayServicesAvailability();
      if(playStoreAvailability != GooglePlayServicesAvailability.success){
        List userResolvableList = [
          GooglePlayServicesAvailability.serviceUpdating,
          GooglePlayServicesAvailability.serviceVersionUpdateRequired,
          GooglePlayServicesAvailability.serviceDisabled,
          //GooglePlayServicesAvailability.serviceInvalid
        ];

        if(await isUserResolvable()){
          if(userResolvableList.contains(playStoreAvailability) ){
            showNoServices = false;
            await cubit.alertDialogModel.showDialogModel(
              title: ('google_play_problem').tr(), //
              buttons: {
                ('ok').tr(): true,
              },);
            cubit.emitState(const ShowingSystemWindow());
            await GoogleApiAvailability.instance.checkGooglePlayServicesAvailability(true);
            cubit.emitState(const NotShowingSystemWindow());
          }
        }
      } else {
        myRet = true;
        showNoServices = false;
      }
    } on PlatformException {
      //playStoreAvailability = GooglePlayServicesAvailability.unknown;
    }

  }
  if(showNoServices){
    await cubit.alertDialogModel.showDialogModel(
      title: ('no_google_play_services').tr(), //
      buttons: {
        ('ok').tr(): true,
      },);
  }
  return myRet;

}

Future<bool> isUserResolvable() async {
  bool isUserResolvable;

  try {
    isUserResolvable =
    await GoogleApiAvailability.instance.isUserResolvable();
  } on PlatformException {
    isUserResolvable = false;
  }

  return isUserResolvable;
}