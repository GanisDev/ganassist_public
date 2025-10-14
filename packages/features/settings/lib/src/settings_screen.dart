import 'package:collection/collection.dart';

import 'package:component_library/component_library.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:key_value_storage/key_value_storage.dart';
import 'package:wakelock/wakelock.dart';
import 'package:home/home.dart';



class SettingsScreen extends StatefulWidget {
    const SettingsScreen({
      super.key, required this.keyValueStorage, required this.navigatorKey, required this.appScaleFactor,
      required this.cubit
    });
    final KeyValueStorage keyValueStorage;
    final GlobalKey<NavigatorState> navigatorKey;
    final double appScaleFactor;
    final NearbyCubit cubit;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();

}

class _SettingsScreenState extends State<SettingsScreen> {
  late String  _selectedLanguage;
  late String _defaultNavAppName;
  late String _defaultNavLink;
  late var _defaultNavAppIcon;
  late  bool _screenAlwaysOn;
  late  bool _darkMode;
  late double _soundVolume;
  late double _textSize;
  late double _textScaleFactorx;
  //late String _wazeLink;
  late String _name;
  late final AppSupportedNavs _appSupportedNavs;
  late List<DropdownMenuItem<String>> _languagesDropDownMenuItems;
  late List<String> _acceptedEndpointNames;
  late List <Widget> _alwaysAcceptedList;
  final TextEditingController _nameController = TextEditingController();
  bool _isLoading = true;
  bool _appScaleFactorChanged = false;
  late double _appScaleFactor;

  @override
  void initState() {
    //_selectedLanguage = widget.languageCode;
    super.initState();
    _myInit();
   }

  @override
  void dispose() {
    if(_name != _nameController.text){
      widget.keyValueStorage.upsertValue(key: 'name', value: _nameController.text);
    }
    super.dispose();
  }

  _myInit() async {
    _screenAlwaysOn = await widget.keyValueStorage.getValue(key: 'screenAlwaysOn', type: bool) ?? false;
    _darkMode = await widget.keyValueStorage.getValue(key: 'darkMode', type: bool) ?? false;
    _defaultNavAppName = await widget.keyValueStorage.getValue(key: 'defaultNavAppName', type: String);
    _defaultNavLink = await widget.keyValueStorage.getValue(key: 'defaultNavLink', type: String);
    //_wazeLink = await widget.keyValueStorage.getValue(key: 'wazeLink', type: String);
    _defaultNavAppIcon = await getDefaultNavAppIcon();
    _soundVolume = await widget.keyValueStorage.getValue(key: 'soundVolume', type: int)+.0;
      _nameController.text = _name = await widget.keyValueStorage.getValue(key: 'name', type: String);
    _acceptedEndpointNames = await widget.keyValueStorage.getValue(key: 'acceptedEndpointNames', type: List);
    _textSize = await widget.keyValueStorage.getValue(key: 'textSize', type: int)+.0;
    _appScaleFactor = _textSize/14;
    //_textScaleFactor = 1;

     Future.delayed(Duration.zero,() {
      _selectedLanguage = context.locale.languageCode;
      _languagesDropDownMenuItems = _makeLanguagesListTiles();
      _alwaysAcceptedList = _makeAlwaysAcceptedList();
    });
    _appSupportedNavs = AppSupportedNavs(onAppSelected: handleDefaultNavApp);

/*    double textScale = MediaQuery.of(context).textScaleFactor;
    var style = Theme.of(context).textTheme.bodyMedium?.fontSize;*/
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    try {
      Widget myRet = SizedBox();
      if(_isLoading) {
        myRet = MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor:  widget.appScaleFactor),
          child: WillPopScope(
            onWillPop: willPopCallback,
            child: Scaffold(
                appBar: AppBar(
                    centerTitle: true,
                    title: Text(
                      ('settings').tr(),
                    ),
                    leading: IconButton(
                        iconSize: 24 * widget.appScaleFactor,
                        icon: const Icon(Icons.keyboard_backspace),
                        onPressed: () async {
                        }
                    )
                ),
                body: const SizedBox()
            ),
          ),
        );
      } else {
          myRet = MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor:  _appScaleFactor),
            child: WillPopScope(
              onWillPop: willPopCallback,
              child: Scaffold(
                appBar: AppBar(
                    centerTitle: true,
                    title: Text(
                      ('settings').tr(),
                      //textScaleFactor: _textScaleFactor,
                    ),
                    leading: IconButton(
                        iconSize: 24 *_appScaleFactor,
                        icon: const Icon(Icons.keyboard_backspace),
                        onPressed: () async {
                          bool myRet = await willPopCallback();
                          if(myRet){
                            if(_appScaleFactorChanged){
                              widget.cubit.emitState(NearbyReload(cubitState: widget.cubit.state, appScaleFactor: _appScaleFactor));
                            }
                            Navigator.of(context).pop();
                          }
                        }
                    )
                ),
                body: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[

                      //default nav button
                      const SizedBox(height: 15.0,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          const SizedBox(width: 25.0,),
                          AppOutlinedButton(
                            buttonText: ('default_nav_app').tr(),
                            maximumWidth: 150.0,
                            onTap: () {
                              _appSupportedNavs.getApp(context);
                            },
                          ),
                          const SizedBox(width: 5.0,),

                          Expanded(
                            child: InkWell(
                              //behavior: HitTestBehavior.translucent,
                              onTap: () {
                                _appSupportedNavs.getApp(context);
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  _defaultNavAppIcon != null
                                      ? CircleAvatar(
                                    backgroundImage: _defaultNavAppIcon,
                                    backgroundColor: Theme.of(context).canvasColor,
                                  )
                                      : const SizedBox(),
                                  _defaultNavAppName.isNotEmpty
                                      ? Text(
                                    _defaultNavAppName,
                                    textAlign: TextAlign.center,
                                    maxLines: null,
                                    softWrap: true,
                                    //overflow: TextOverflow.ellipsis,
                                    //style: const TextStyle(fontSize: 17.0,fontWeight: FontWeight.w900,),
                                    //textScaleFactor: _textScaleFactor,
                                  )
                                      : Row(
                                    children: <Widget>[
                                      const SizedBox(width: 20.0),
                                      Expanded(
                                        child: Text(
                                          '${('select_nav_app').tr()}\n${('tap_button').tr()}',
                                          textAlign: TextAlign.center,
                                          maxLines: null,
                                          softWrap: true,
                                          //overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(color: Colors.red),
                                          //textScaleFactor: _textScaleFactor,
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      /*              _defaultNavLink.contains('waze')
                      ? const SizedBox(height: 15.0,)
                      : const SizedBox(),

                  _defaultNavLink.contains('waze')
                      ? Row(
*//*              mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,*//*
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(left: 15.0),
                        child:  Text(
                          '${('link_sent').tr()}  ${('view').tr()}',
                        ),
                      ),
                      Switch(
                        materialTapTargetSize:
                        MaterialTapTargetSize.shrinkWrap,
                        activeColor: AppTheme.myColor100,
                        inactiveThumbColor: AppTheme.myColor100,
                        inactiveTrackColor: Colors.green[200],
                        value: (_wazeLink == 'navigation') ? true : false,
                        onChanged: (value) async {

                          var myItem = _appSupportedNavs.supportedNavAppsList.firstWhereOrNull( (e) => e['name'] == 'Waze');
                          if (value){
                            await widget.keyValueStorage.upsertValue(key: 'defaultNavLink', value: myItem['link']);
                            await widget.keyValueStorage.upsertValue(key: 'wazeLink', value: 'navigation');
                          } else {
                            await widget.keyValueStorage.upsertValue(key: 'defaultNavLink', value: myItem['linkView']);
                            await widget.keyValueStorage.upsertValue(key: 'wazeLink', value: 'view');

                          }
                          setState(() {
                            _wazeLink = value ? 'navigation' : 'view';
                          });
                        },
                      ),
                      Text(
                        ('navigation').tr(),
                      ),
                    ],
                  )
                      : const SizedBox(),*/

                      //language
                      const SizedBox(height: 5.0,),
                      Row(
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.only(left: 15.0, right: 20.0),
                            child:  Text(
                              ('language').tr(),
                              //textScaleFactor: _textScaleFactor,
                            ),
                          ),
                          DropdownButton(
                            value: _selectedLanguage,
                            items: _languagesDropDownMenuItems,
                            onChanged: (dynamic value) async {
                              _changeLanguage(value);
                            },
                          ),
                        ],
                      ),

                      //darkMode
                      const SizedBox(height: 5.0,),
                      Row(
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.only(left: 15.0, right: 20.0),
                            child:  Text(
                              ('dark_mode').tr(),
                              //textScaleFactor: _textScaleFactor,
                              //style: const TextStyle(fontSize: 14.0,fontWeight: FontWeight.w500,),
                            ),
                          ),
                          PlatformSwitch(
                            //materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            activeColor: Theme.of(context).colorScheme.primary,
                            value: _darkMode,
                            onChanged: (value) async {
                              //bool isScreenOn = await Wakelock.enabled;
                              await widget.keyValueStorage.upsertValue(key: 'darkMode', value: value);
                              if(value) {
                                PlatformTheme.of(context)!.themeMode = ThemeMode.dark;
                              } else {
                                PlatformTheme.of(context)!.themeMode = ThemeMode.light;
                              }
                              appTheme.initTextStyles(context);
                              setState(() {
                                _darkMode = value;
                              });
                            },
                          ),
                        ],
                      ),


                      //screen_always_on
                      const SizedBox(height: 5.0,),
                      Row(
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.only(left: 15.0, right: 20.0),
                            child:  Text(
                              ('screen_always_on').tr(),
                              //textScaleFactor: _textScaleFactor,
                              //style: const TextStyle(fontSize: 14.0,fontWeight: FontWeight.w500,),
                            ),
                          ),
                          PlatformSwitch(
                            //materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            activeColor: Theme.of(context).colorScheme.primary,
                            value: _screenAlwaysOn,
                            onChanged: (value) async {
                              //bool isScreenOn = await Wakelock.enabled;
                              await widget.keyValueStorage.upsertValue(key: 'screenAlwaysOn', value: value);
                              if(value) {
                                if (!await Wakelock.enabled) {
                                  await Wakelock.enable();
                                }
                              } else {
                                if (await Wakelock.enabled) {
                                  await Wakelock.disable();
                                }
                              }
                              setState(() {
                                _screenAlwaysOn = value;
                              });
                            },
                          ),
                        ],
                      ),


                      //sound volume
                      const SizedBox(height: 5.0,),
                      Row(
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.only(left: 15.0),
                            child:  Text(
                              '${('sound_volume').tr()}  ${_soundVolume.round()}',
                              //textScaleFactor: _textScaleFactor,
                            ),
                          ),
                          _soundVolume < 10
                              ? Container(width: 8.0,)
                              : Container(),
                          Expanded(
                            child: Slider(
                              value: _soundVolume,
                              min: 0,
                              max: 10,
                              divisions: 10,
                              activeColor: Theme.of(context).colorScheme.primary,
                              onChanged: (value) {
                                setState(() {
                                  _soundVolume = value;
                                });
                              },
                              onChangeEnd: (value) async {
                                await widget.keyValueStorage.upsertValue(key: 'soundVolume', value: value.toDouble());
                              },
                            ),
                          ),
                        ],
                      ),

                      //text size
                      const SizedBox(height: 5.0,),
                      Row(
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.only(left: 15.0),
                            child:  Text(
                              '${('text_size').tr()}  ${_textSize.round()}',
                              //textScaleFactor: _textScaleFactor,
                            ),
                          ),
                          _textSize < 10
                              ? Container(width: 8.0,)
                              : Container(),
                          Expanded(
                            child: Slider(
                              value: _textSize,
                              min: 14,
                              max: 20,
                              divisions: 6,
                              activeColor: Theme.of(context).colorScheme.primary,
                              onChanged: (value) {
                                _languagesDropDownMenuItems = _makeLanguagesListTiles();
                                _alwaysAcceptedList = _makeAlwaysAcceptedList();
                                setState(() {
                                  _textSize = value;
                                  _appScaleFactor = _textSize/14;
                                });
                              },
                              onChangeEnd: (value) async {
                                _appScaleFactorChanged = true;
                                await widget.keyValueStorage.upsertValue(key: 'textSize', value: value.toDouble());
                              },
                            ),
                          ),
                        ],
                      ),


                      //your name
                      const SizedBox(height: 5.0,),
                      Row(
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.only(left: 15.0),
                            child:  Text(
                              ('your_name').tr(),
                              //textScaleFactor: _textScaleFactor,
                            ),
                          ),
                          Flexible(
                            child: Container(
                              margin: const EdgeInsets.only(left: 4.0, right: 4.0),
                              //padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                              child: TextField(
                                textCapitalization: TextCapitalization.words,
                                style: !_nameController.text.contains('Name')
                                    ? AppTheme.selectedElementStyle
                                    : const TextStyle(color: Colors.red),
                                enabled: true,
                                controller: _nameController,
                                onChanged: (value){
                                  setState(() {

                                  });
                                },
                                decoration: const InputDecoration(border: InputBorder.none),
                              ),
                            ),
                          )
                        ],
                      ),


                      //always accept list
                      const SizedBox(height: 5.0,),
                      _acceptedEndpointNames.isNotEmpty
                          ? ExpansionTile(
                        //key: _expansionTile,
                        initiallyExpanded: true,
                        title: Text(('always_accept').tr(),
                          //textScaleFactor: _textScaleFactor,
                        ),
                        children: _alwaysAcceptedList,
                      )
                          : const SizedBox(),

                    ],
                  ),
                ),
              ),
            ),
          );
      }
      return myRet;

    } catch (e, stackTrace) {
      //appResources.sendError('func029', e.toString(), stackTrace.toString());
      if (kDebugMode) {
        print(e.toString());
        print(stackTrace.toString());
      }
      return Container();

    }
  }


  onTextEditingComplete(value){

  }

  _makeLanguagesListTiles() {
    //_selectedLanguage = context.locale.languageCode;
    List<DropdownMenuItem<String>> tiles = [];
    for (var item in AppLanguages.appLanguages) {
      tiles.add(DropdownMenuItem(
          value: item['language'],
          child: Text(
            item['name']!,
            textScaleFactor: _appScaleFactor,
            style: _selectedLanguage == item['language'] ? AppTheme.selectedElementStyle : null,
          )
      ));
    }
    return tiles;
  }


  _changeLanguage(String? newLanguage)  async {
    if (_selectedLanguage != newLanguage) {
      _selectedLanguage = newLanguage!;
       _languagesDropDownMenuItems = _makeLanguagesListTiles();
      for (var item in AppLanguages.appLanguages) {
        if(item['language'] == newLanguage){
          var newLocale = Locale(item['language']!, item['countryCode']!);
          context.setLocale(newLocale);
          break;
        }
      }
      setState(() {
      });
    }
  }

  getDefaultNavAppIcon() async{
    String navAppIcon =  await widget.keyValueStorage.getValue(key: 'defaultNavAppIcon', type: String);//appResources.appPreferences['defaultNavAppIcon'];
    if(navAppIcon.isNotEmpty){
      List<int> list = navAppIcon.codeUnits;
      return MemoryImage(Uint8List.fromList(list));
    } else {
      return null;
    }
  }



   Future<void> handleDefaultNavApp(String appName, String packageName, icon, String link) async {
    await widget.keyValueStorage.upsertValue(key: 'defaultNavAppIcon', value: String.fromCharCodes(icon));
    await widget.keyValueStorage.upsertValue(key: 'defaultNavAppName', value: appName);
    await widget.keyValueStorage.upsertValue(key: 'defaultNavAppPackageName', value: packageName);
    await widget.keyValueStorage.upsertValue(key: 'defaultNavLink', value: link);
    _defaultNavAppName = appName;
    _defaultNavLink = link;
    _defaultNavAppIcon = await getDefaultNavAppIcon();
    //_wazeLink = await widget.keyValueStorage.getValue(key: 'wazeLink', type: String);
    setState(() {
    });
    // appResources.appPreferences['defaultNavAppIcon'] = MemoryImage(icon);

    // await appResources.saveOnePreference('defaultNavAppIcon', String.fromCharCodes(icon));

  }



/*  handleOnWillPop() async {
    if(_nameController.text.isEmpty || _nameController.text == 'Name???'){
      final myVal = await AlertDialogModel(
        title: ('settings_name').tr(args: ['']),
        buttons: {
          ('ok').tr(): false,
        },)
          .present(context)
          .then((alertVal) => alertVal ?? false);
    } else {
      Navigator.of(context).pop();
    }
  }*/

  Future<bool> willPopCallback() async {
    if(_nameController.text.isEmpty || _nameController.text == 'Name???'){
      await AlertDialogModel(widget.navigatorKey,_appScaleFactor).showDialogModel(
        title: ('settings_name').tr(args: ['']),
        buttons: {
          ('ok').tr(): false,
        },);
      return false;
    } else {
      if(_appScaleFactorChanged){
        widget.cubit.emitState(NearbyReload(cubitState: widget.cubit.state, appScaleFactor: _appScaleFactor));
      }
      return true;

    }
     // return true if the route to be popped
  }

  _makeAlwaysAcceptedList(){
    List<Widget> recipientsListTiles = [];
    for (var name in _acceptedEndpointNames) {
      recipientsListTiles.add(
        ListTile(
          //dense: true,
          title: Text(
            name,
            style: const TextStyle(fontWeight: FontWeight.bold),
            //textScaleFactor: _textScaleFactor,
          ),
          trailing: IconButton(
              iconSize: 24 *_appScaleFactor,
              icon: const Icon(Icons.remove_circle_outline, color: AppTheme.myColor100,),
              onPressed: () async {
                _acceptedEndpointNames.remove(name);
                await widget.keyValueStorage.upsertValue(key: 'acceptedEndpointNames', value: _acceptedEndpointNames);
                setState(() {

                });
              }
          ),
        ),

      );
    }

    return recipientsListTiles;
  }



}





