import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:key_value_storage/key_value_storage.dart';

import 'package:material_design_icons_flutter/material_design_icons_flutter.dart' show MdiIcons;
import 'package:others/others.dart';
import 'package:settings/settings.dart';

import 'app_drawer.dart';
import 'home_screen_cubit.dart';
import 'package:component_library/component_library.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.keyValueStorage, required this.navigatorKey, required this.appScaleFactor});

  final KeyValueStorage keyValueStorage;
  final GlobalKey<NavigatorState> navigatorKey;
  final double appScaleFactor;

  @override
  Widget build(BuildContext context) {

    return BlocProvider<NearbyCubit>(
        create: (_) => NearbyCubit(keyValueStorage: keyValueStorage, navigatorKey: navigatorKey, appScaleFactor: appScaleFactor),
        child: HomePage(keyValueStorage: keyValueStorage, navigatorKey: navigatorKey, appScaleFactor: appScaleFactor));

  }
}


class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.keyValueStorage, required this.navigatorKey,  required this.appScaleFactor});

  final KeyValueStorage keyValueStorage;
  final GlobalKey<NavigatorState> navigatorKey;
  final double appScaleFactor;

  @override
  State<HomePage> createState() => _HomePage();
}


class _HomePage extends State<HomePage> with WidgetsBindingObserver {
  late double _appScaleFactor = widget.appScaleFactor;
  AppLifecycleState? _appState;
  bool _isShowingSystemWindow = false;
  late AlertDialogModel _alertDialogModel;
  List listenedStates = [
    NearbyCheckingRequirements,
    ShowingSystemWindow,
    NotShowingSystemWindow,
    NearbyRequestConnection,
    NearbyError,
    NearbyReload
  ];

  @override
  void initState()  {
    //SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.top]);

    WidgetsBinding.instance.addObserver(this);
    _initialize();
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _dispose();
    super.dispose();
  }

  @override
  didChangeAppLifecycleState(AppLifecycleState state) async  {
    await _handleChangeAppLifecycleState(state);
  }

  _initialize() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _alertDialogModel = AlertDialogModel(widget.navigatorKey,_appScaleFactor);
/*      String name = await widget.keyValueStorage.getValue(key: 'name', type: String) ?? '';
      if(name.isEmpty && name == 'Name???'){
        if (mounted) {
          Navigator.of(context).push(platformPageRoute(
            context: context,
            builder: (context) => SettingsScreen(
              keyValueStorage: widget.keyValueStorage,
              navigatorKey: widget.navigatorKey,
              appScaleFactor: widget.appScaleFactor
            ),
          ));
        }
      }*/
    });

  }

  Future <double> getAppScaleFactor() async {

  return (await widget.keyValueStorage.getValue(key: 'textSize', type: int) ?? 14) /14;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NearbyCubit, NearbyState>(
        listenWhen: (oldState, newState) =>  oldState !=  newState && listenedStates.contains(newState.runtimeType),
        listener: handleCubitListener,
        buildWhen: (oldState, newState) => oldState !=  newState && !listenedStates.contains(newState.runtimeType) && newState is! NearbyFinalizingConnection,
        builder: (context, state) {
          final cubit = context.read<NearbyCubit>();
          final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor:_appScaleFactor),
            child: Scaffold(
              key: scaffoldKey,
              resizeToAvoidBottomInset: true,
              appBar: AppBar(
                centerTitle: true,
                titleSpacing: 0.0,
                leading: IconButton(
                    iconSize: 24 *_appScaleFactor,
                    icon: const Icon(Icons.dehaze),
                    onPressed: () async {
                      scaffoldKey.currentState!.openDrawer();
                    }
                ),
                title: const Text('GanAssist'),
                actions: [
                  IconButton(
                    iconSize: 24 * _appScaleFactor,
                    icon:  _buildNearByIcon(cubit),
                    onPressed: () async {
                      await _handleNearbyIconAction(cubit);
                    },
                  ),
                  const SizedBox(width: 7.0,)
                ], //_makeActionButtons(),
              ),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: _buildContent(cubit, _appScaleFactor),
                ),
              ),
              drawer:  AppDrawer(
                  keyValueStorage: widget.keyValueStorage,
                  navigatorKey: widget.navigatorKey,
                  cubit: cubit,
                  appScaleFactor: _appScaleFactor
              ),

              // This trailing comma makes auto-formatting nicer for build methods.
            ),
          );
          /**/
        }
    );

  }
  /*Widget build(BuildContext context) {
    return BlocConsumer<NearbyCubit, NearbyState>(
      listenWhen: (oldState, newState) =>  listenedStates.contains(newState.runtimeType),
      listener: handleCubitListener,
      buildWhen: (oldState, newState) => oldState !=  newState && !listenedStates.contains(newState.runtimeType) && newState is! NearbyFinalizingConnection,
      builder: (context, state) {
        final cubit = context.read<NearbyCubit>();
        return FutureBuilder<double>(
          future: getAppScaleFactor(),
          builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
            if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
              //print('snapshot.data: ${snapshot.data}');
              double appScaleFactor = snapshot.data ?? 1.0;
              final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaleFactor:_appScaleFactor),
                child: Scaffold(
                  key: _scaffoldKey,
                  resizeToAvoidBottomInset: true,
                  appBar: AppBar(
                    centerTitle: true,
                    titleSpacing: 0.0,
                    leading: IconButton(
                        iconSize: 24 *appScaleFactor,
                        icon: const Icon(Icons.dehaze),
                        onPressed: () async {
                          _scaffoldKey.currentState!.openDrawer();
                        }
                    ),
                    title: const Text('GanAssist'),
                    actions: [
                      IconButton(
                        iconSize: 24 * appScaleFactor,
                        icon:  _buildNearByIcon(cubit),
                        onPressed: () async {
                          await _handleNearbyIconAction(cubit);
                        },
                      ),
                    ], //_makeActionButtons(),
                  ),
                  body: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _buildContent(cubit, appScaleFactor),
                    ),
                  ),
                  drawer:  AppDrawer(
                    keyValueStorage: widget.keyValueStorage,
                    navigatorKey: widget.navigatorKey,
                    cubit: cubit,
                    appScaleFactor: appScaleFactor
                  ),
                  // This trailing comma makes auto-formatting nicer for build methods.
                ),
              );
            } else {
              return const Center(child: AppCircularProgress());
            }
          },
        );
        *//**//*
      }
    );

  }*/



  _dispose() async {
    final cubit = context.read<NearbyCubit>();
    final nearbyStatus = cubit.state;
    switch(nearbyStatus.runtimeType){
      case NearbyAdvertising:
        await cubit.stopAdvertising();
        //_nearbyStatus = 'disabled';
        break;

      case NearbyConnected:
        await cubit.stopAdvertising();
        await cubit.stopConnection();
        break;

      case NearbyDisconnected:
        // TODO: Handle this case.
        break;

      case NearbyInProgress:
        // TODO: Handle this case.
        break;
    }
  }

  Future<void> handleCubitListener(BuildContext cubitContext, NearbyState state) async{
    if(state is NearbyReload){
      final cubit = cubitContext.read<NearbyCubit>();
      _appScaleFactor = cubit.getReloadAppScaleFactor();
      _alertDialogModel = AlertDialogModel(widget.navigatorKey,_appScaleFactor);
      cubit.emitState(cubit.getReloadCurrentState());
      cubit.initAlertDialogModel(_appScaleFactor);
      return;
    }

    if(state is ShowingSystemWindow){
      _isShowingSystemWindow = true;
      return;
    }
    if(state is NotShowingSystemWindow){
      _isShowingSystemWindow = false;
      return;
    }

    if(state is NearbyCheckingRequirements){
      final cubit = cubitContext.read<NearbyCubit>();
      cubit.emitState(const NearbyDisconnected());
        if(state.requestedRequirement == RequestedRequirement.defaultNavApp){
          await _alertDialogModel.showDialogModel(
            title: ('select_preferred_nav').tr(),
            buttons: {
              ('ok').tr(): false,
            },);
          if(cubitContext.mounted){
            Navigator.push(cubitContext, MaterialPageRoute(builder: (_) => SettingsScreen(
              keyValueStorage: widget.keyValueStorage,
              navigatorKey: widget.navigatorKey,
              appScaleFactor: widget.appScaleFactor,
              cubit: cubit)
            ));
          }
          return;
        }
        if(state.requestedRequirement == RequestedRequirement.name){
          await _alertDialogModel.showDialogModel(
            title: ('settings_name').tr(args: [('next_window').tr()]),
            buttons: {
              ('ok').tr(): false,
            },);
          if(cubitContext.mounted){
            Navigator.push(cubitContext, MaterialPageRoute(builder: (_) => SettingsScreen(
              keyValueStorage: widget.keyValueStorage,
              navigatorKey: widget.navigatorKey,
              appScaleFactor: widget.appScaleFactor,
              cubit: cubit)
            ));
          }
          return;
        }

      if(state.requestedRequirement == RequestedRequirement.downgradeGplay){
        if(cubitContext.mounted){
          //Navigator.push(context, MaterialPageRoute(builder: (_) => OthersScreen(context, 'eula', 'EULA')));
          Navigator.push(cubitContext, MaterialPageRoute(builder: (_) => OthersScreen(context, 'downgrade', ('downgrade').tr())
          ));
        }
        return;
      }

    }

    if(state is NearbyRequestConnection){
      final String endpointName = state.endpointName;
      final String connectionId = state.connectionId;
      var myTitle = ConnectionRequestText(endpointName: endpointName);
      if (endpointName.isNotEmpty && connectionId.isNotEmpty) {
        final cubit = cubitContext.read<NearbyCubit>();
        int resp = await _alertDialogModel.showDialogModel(
          title: myTitle,
          buttons: {
            ('reject').tr(): 1,
            ('accept_always').tr(): 2,
            ('accept').tr(): 3,
          },);

        switch(resp) {
          case 1:
            cubit.rejectConnection(connectionId);

            break;

          case 2:
          //accept_always
            cubit.acceptConnection(connectionId, endpointName);
            List<String> acceptedEndpointNames =  await widget.keyValueStorage.getValue(key: 'acceptedEndpointNames', type: List);
            if(!acceptedEndpointNames.contains(endpointName)){
              acceptedEndpointNames.add(endpointName);
              await widget.keyValueStorage.upsertValue(key:'acceptedEndpointNames', value: acceptedEndpointNames);
            }
            break;
          case 3:
            cubit.acceptConnection(connectionId, endpointName);
            break;
        }
      }
      return;
    }

    if(state is NearbyError){
      ScaffoldMessenger.of(cubitContext)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: Text(
            state.errorText,
            maxLines: null,
            textAlign: TextAlign.center,
          ),
          duration: const Duration(seconds: 5),
          backgroundColor: AppTheme.myColor50,
        ));
    }
  }


  Icon _buildNearByIcon(NearbyCubit cubit){
    Icon  nearbyIcon = const Icon(Icons.nearby_off);

    switch(cubit.state.runtimeType){

      case NearbyAdvertising:
      case NearbyInProgress:
      case NearbyRequestConnection:
        nearbyIcon = const Icon(Icons.nearby_error);
        break;

      case NearbyConnected:
        nearbyIcon = Icon(MdiIcons.googleNearby);
        break;

      default:
    }
    return nearbyIcon;
  }


  List<Widget> _buildContent(NearbyCubit cubit, double? appScaleFactor) {
    List<Widget>myRet = [];
    String endpointName = cubit.getEndpointName();

    switch(cubit.state.runtimeType){

      case NearbyDisconnected:

        Text buttonText = Text(
          textScaleFactor: appScaleFactor!*1.5,
            ('start_nearby').tr(),
          textAlign: TextAlign.center);

        myRet = <Widget>[
          AppPlatformElevatedButton(
            buttonText: buttonText,
            //maximumWidth: 100.0,
            onTap: () async {
              await cubit.handleStartAdvertising();
            },
          ),
          const SizedBox(height: 10.0),
          ];
        break;

      case NearbyInProgress:
        myRet = <Widget>[
          const AppCircularProgress(),
        ];
        break;

      case NearbyAdvertising:
        myRet = <Widget>[
          AwaitingConnectionButton(
            onTap: () async {
              await cubit.stopAdvertising();
            },
          ),
          ];
        break;

      case NearbyConnected:
        myRet = <Widget>[
          ConnectedWithButton(
            appScaleFactor: appScaleFactor!,
            endpointName: endpointName,
            onTap: () async {
              await _handleDisconnect(cubit);
            },
          ),
        ];
        break;

    }
    return myRet;
  }


  _handleNearbyIconAction(NearbyCubit cubit) async {

    switch(cubit.state.runtimeType){
      case NearbyDisconnected:
        await cubit.handleStartAdvertising();
        break;

      case NearbyAdvertising:
      case NearbyInProgress:
        await cubit.stopAdvertising();
        break;

      case NearbyConnected:
        await _handleDisconnect(cubit);
        break;
    }

  }


  _handleDisconnect(NearbyCubit cubit) async {
     String endpointName = cubit.getEndpointName();

      final shouldDisconnect = await _alertDialogModel.showDialogModel(
      title: DisconnectFromText(
        endpointName: endpointName,
      ),
      buttons: {
        ('no').tr(): false,
        ('yes').tr(): true,
      },);

    if(shouldDisconnect){
      await cubit.handleDisconnect();
    }
  }



  _handleChangeAppLifecycleState(AppLifecycleState state) async {
    //todo handle appResources.isAppClosing
    if(state == AppLifecycleState.detached){ // a fost && appResources.isAppClosing
        await _dispose();
    } else {
      if ((state == AppLifecycleState.paused || state == AppLifecycleState.resumed || state == AppLifecycleState.inactive) &&
          (_appState == null || _appState != state) && !_isShowingSystemWindow) {
        _appState = state;

        switch (state) {
        //PAUSED
          case AppLifecycleState.paused:

            break;

        //RESUMED
          case AppLifecycleState.resumed:
            final cubit = context.read<NearbyCubit>();
            if(cubit.isAwaiting){
                cubit.handleIsAwaiting();
            } else {
              await cubit.handleAppResumed();
            }

            break;
          case AppLifecycleState.inactive:
          // TODO: Handle this case.
            break;
          case AppLifecycleState.detached:
          // TODO: Handle this case.
            break;
        }
      }
    }

  }

}

/*
AppBar(
        leadingWidth: 100,
        centerTitle: true,
        titleSpacing: 0.0,
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.language),
                onPressed: () async{
                  Locale currentLocale = context.locale;
                  showDialog(
                      context: context,
                      builder: (_) => SelectLangDialog(languageCode: currentLocale.languageCode,)).then((newLocale){
                        if (newLocale != null && newLocale != currentLocale){
                          context.setLocale(newLocale!);
                        }
                       });
                }
            ),
            IconButton(
                icon: _navAppIcon ?? const Icon(Icons.navigation),
                onPressed: () async{
                  AppSupportedNavs appSupportedNavs = AppSupportedNavs();
                  await appSupportedNavs.getApp(context);
                  _setNavAppIcon();
                  setState(() {

                  });
                }
            ),
          ],
        ),
        title: const Text('GanAssist'),
        actions: [
          IconButton(
            icon:  nearbyIcon,
            //color: _myColor,
            onPressed: () async {
              await _handleNearbyIconAction();
              },
          ),
        ],
           )

*/
