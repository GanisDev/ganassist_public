import 'package:component_library/component_library.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:key_value_storage/key_value_storage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wakelock/wakelock.dart';
import 'package:others/others.dart';
import 'package:settings/settings.dart';

import 'home_screen_cubit.dart';



class AppDrawer extends StatefulWidget {
  const AppDrawer( {Key? key, required this.keyValueStorage, required this.navigatorKey, required this.cubit, required this.appScaleFactor}) : super(key: key);

  final KeyValueStorage keyValueStorage;
  final GlobalKey<NavigatorState> navigatorKey;
  final NearbyCubit cubit;
  final double appScaleFactor;

  @override
  AppDrawerState createState() {
    return AppDrawerState();
  }
}

class AppDrawerState extends State<AppDrawer> {
  bool _showAutoStart = false;
  bool _showPowerOptions= false;
  String? _name;

  @override
  void initState() {
    _myInit();
    super.initState();
  }

  _myInit()  async {
    try {
      final cubit = context.read<NearbyCubit>();
      _name = await widget.keyValueStorage.getValue(key: 'name', type: String) ?? 'Name???';
      if (defaultTargetPlatform == TargetPlatform.android){
        _showAutoStart = await  cubit.cubitBackgroundSettings(
            level: 'autostart',
            type: 'toShowSettings');
        _showPowerOptions = await  cubit.cubitBackgroundSettings(
            level: 'power',
            type: 'toShowSettings');
      }
       setState(() {});
    } catch (e, stackTrace) {
      //appResources.sendError('func001', e.toString(), stackTrace.toString());
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<NearbyCubit>();
    var myRet;
    try {
      myRet =  Drawer(
        //key: appResources.drawerKey,
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            ListTile(
              dense: true,
              contentPadding: const EdgeInsets.only(left: 16.0, right: 3.0),
              title: Text(
                _name ?? '',
                style: AppTheme.selectedElementStyle,
              ),
            ),

            ListTile(
              dense: true,
              contentPadding: const EdgeInsets.all(0.0),
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      mainAxisAlignment:MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        PlatformIconButton(
                            icon:  Icon(
                              Icons.settings,
                              color: Theme.of(context).colorScheme.primary,
                              size: 32 * widget.appScaleFactor,
                            ),
                            onPressed: () {
                              if (Navigator.of(context).canPop()) Navigator.pop(context);
                             Navigator.push(context, MaterialPageRoute(builder: (_) => SettingsScreen(
                               keyValueStorage: widget.keyValueStorage,
                               navigatorKey: widget.navigatorKey,
                               appScaleFactor: widget.appScaleFactor,
                               cubit: cubit
                             )));

                            }
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: Column(
                      mainAxisAlignment:MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        IconButton(
                            icon: Icon(
                              Icons.power_settings_new,
                              color: Theme.of(context).colorScheme.primary,
                              size: 32 *widget.appScaleFactor,
                            ),
                            onPressed: () async {
                              if (Navigator.of(context).canPop()) Navigator.pop(context);
                              await closeTheApp();
                            }
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),

            ExpansionTile(
              title: Text(('help').tr(),
                style: const TextStyle(fontSize: 14.0,fontWeight: FontWeight.w500,),
              ),
              children: <Widget>[
/*                ListTile(
                  title: Text(('user_manual').tr()),
                  onTap: () {
                    if (Navigator.of(context).canPop()) Navigator.pop(context);

                    switch (appPreferences.appPreferences['language']){

                      case 'it':
                        appResources.launchURL('https://drive.google.com/file/d/1UM3yCv8NytWEwbbb3-1288jtvshzbk1D');
                        break;

                      case 'ro':
                        appResources.launchURL('https://drive.google.com/file/d/1HxxDJj1rBdwSntNHaVwMNmudfqD5yRyP');
                        break;

                      default:
                        appResources.launchURL('https://drive.google.com/file/d/1A5m5ynXUdq-A3jCbK-rxXLJ4cWZm81FY');
                    }

                  },
                ),*/

                _showAutoStart
                    ? ListTile(
                  title: Text(('show_AutoStart').tr()),
                  onTap: () async {
                    if (Navigator.of(context).canPop()) Navigator.pop(context);
                    await  cubit.cubitBackgroundSettings(
                        level: 'autostart',
                        type: 'toCheckSettings');
                  },
                )
                    : const SizedBox(),

                _showPowerOptions
                    ? ListTile(
                  title: Text(('show_power_options').tr()),
                  onTap: () async {
                    if (Navigator.of(context).canPop()) Navigator.pop(context);
                    await  cubit.cubitBackgroundSettings(
                        level: 'power',
                        type: 'toCheckSettings');
                  },
                )
                    : const SizedBox(),

                ListTile(
                  title: Text(('feedback').tr()),
                  onTap: () {
                    if (Navigator.of(context).canPop()) Navigator.pop(context);
                    AppResources.sendFeedback(widget.keyValueStorage, widget.navigatorKey, context.locale.languageCode);
                  },
                ),
                ListTile(
                  title: Text(('rate_us').tr()),
                  onTap: () async {
                    if (Navigator.of(context).canPop()) Navigator.pop(context);
                    widget.keyValueStorage.upsertValue(key: 'rated', value: 'yes');
                    await launchURL('https://play.google.com/store/apps/details?id=com.ganisdev.ganassist');
                    }
                ),

              ],
            ),

            ExpansionTile(
                initiallyExpanded: true,
              title: Text(('about').tr(),
                style: const TextStyle(fontSize: 14.0,fontWeight: FontWeight.w500,),
              ),
              children: <Widget>[
                ListTile(
                  title: Text('${('version').tr()} : ${AppResources.appVersionNumber}'),
                  onTap: () {
                  },
                ),
                ListTile(
                  title: Text(('check_updates').tr()),
                  onTap: () async {
                    await launchURL('https://play.google.com/store/apps/details?id=com.ganisdev.ganassist');
                  },
                ),
                ListTile(
                  title: const Text('EULA'),
                  onTap: () {
                    if (Navigator.of(context).canPop()) Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => OthersScreen(context, 'eula', 'EULA')));
                    //navigatorKey.currentState?.push(MaterialPageRoute(builder: (_) => OthersPage(navigatorKey.currentContext!, 'error', 'EULA')));
                  },
                ),
                ListTile(
                  title: Text(('privacy').tr()),
                  onTap: () {
                    launchURL('https://ganisdev.github.io/ganassist_privacy_policy.html');
                  },
                ),
                ListTile(
                  title: Text(('licenses').tr()),
                  onTap: () {
                    if (Navigator.of(context).canPop()) Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => OthersScreen(context, 'licenses', ('licenses').tr())));

                  },
                ),

                ListTile(
                  title: Text(('changelog').tr()),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => OthersScreen(context, 'changelog', ('changelog').tr())));

                  },
                ),

              ],
            ),


          ],
        ),
      );
    } catch (e, stackTrace) {
      //appResources.sendError('func002', e.toString(), stackTrace.toString());
      rethrow;
    }
    return myRet;
  }

  Future<void> launchURL(dynamic url) async {
    if (url.runtimeType == String){
      url = Uri.parse(url);
    }
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw Exception('Could not launch $url');
    }
  }


Future<void> closeTheApp() async {
    try {
      bool willCloseTheApp = false;
      final cubit = context.read<NearbyCubit>();
      NearbyState cubitState = cubit.state;
      if(cubitState is! NearbyConnected ||  cubitState.connectionId.isEmpty){
        willCloseTheApp = true;
      } else {
        bool myContinue = await cubit.alertDialogModel.showDialogModel(
          title: ('connexion_exists').tr(),
          buttons: {
            ('cancel').tr(): false,
            ('ok').tr(): true,
          },);

        if(myContinue){
          await cubit.handleDisconnect();
          willCloseTheApp = true;
        }
      }

      if(willCloseTheApp){
        if (await Wakelock.enabled){
          await Wakelock.disable();
        }
        SystemChannels.platform.invokeMethod('SystemNavigator.pop');
      }

    } catch (e, stackTrace) {
      //sendError('func3014', e.toString(), stackTrace.toString());
      if (kDebugMode) {
        print(e.toString());
        print(stackTrace.toString());
      }
    }
  }





}




