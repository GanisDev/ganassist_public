import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:google_api_availability/google_api_availability.dart';
import 'package:appcheck/appcheck.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:component_library/component_library.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:optimize_battery/optimize_battery.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:app_settings/app_settings.dart';
import 'package:android_intent_plus/android_intent.dart';

import 'package:key_value_storage/src/key_value_storage.dart';
import 'package:url_launcher/url_launcher_string.dart';


part 'home_screen_state.dart';
part 'check_requirements.dart';


class NearbyCubit extends Cubit<NearbyState> {
  NearbyCubit({
    required this.keyValueStorage,
    required this.navigatorKey,
    required this.appScaleFactor
  }) : super (const NearbyInProgress()) {
    init();
  }

  final KeyValueStorage keyValueStorage;
  final GlobalKey<NavigatorState> navigatorKey;
  final double appScaleFactor;

  bool isFirstConnection = false;
  String connectionAction = '';
  bool awaitingSending = false;
  bool dataWasSent = false;
  bool isAwaiting = false;
  final AudioCache? player = AudioCache(
      respectSilence: true,
      prefix: 'packages/features/home/assets/'
  );
  late double soundVolume;
  late AlertDialogModel alertDialogModel;

  init() async{
    //player!.loadAll(["boing.mp3", "bell.mp3", "success.mp3", "nav.mp3"]);
    initAlertDialogModel(appScaleFactor);
    keyValueStorage.getValue(key: 'soundVolume', type: double).then((value) => soundVolume = value.toDouble());
    String endpointName = await keyValueStorage.getValue(key: 'endpointName', type: String) ?? '';
    if(endpointName.isNotEmpty){
/*      bool nearbyEnabled = await enableAdvertising();
      if(nearbyEnabled) {
        emitConnected(endpointName);
      }*/
    } else {
      emit(const NearbyDisconnected());
    }
  }

  initAlertDialogModel(appScaleFactor){
    alertDialogModel = AlertDialogModel(navigatorKey, appScaleFactor);
  }

  Future<void> handleStartAdvertising() async {
    try {
      emit(const NearbyInProgress());
      bool requirementsSatisfied = await checkRequirements(this);
      if (requirementsSatisfied) {
        bool  advertisingStarted = await startAdvertising();
        if (advertisingStarted) {
          emit(const NearbyAdvertising());
        } else {
          emit(const NearbyDisconnected());
        }
      } else {
        emit(const NearbyDisconnected());
      }
    } catch (e, stackTrace) {
      emit(const NearbyDisconnected());
      rethrow;
    }
  }

  Future<bool> startAdvertising() async {
    bool isAdvertising = false;
    try {
      isAdvertising = await Nearby().startAdvertising(
        await keyValueStorage.getValue(key: 'name', type: String),
        Strategy.P2P_POINT_TO_POINT,
        serviceId: 'com.ganisdev.ganassist',
        onConnectionInitiated: (id, connectionInfo) {
          onConnectionInit(id, connectionInfo);
        },
        onConnectionResult: (id, status) {
          onConnectionResult(id, status);
        },
        onDisconnected: (id) async {
          await onDisconnected(id);
        },
      );

    } catch (exception) {
      if (exception.toString().contains('8001: STATUS_ALREADY_ADVERTISING')) {
        await stopAdvertising();
        await startAdvertising();
        isAdvertising = true;
      } else {
        if (exception.toString().contains('Nearby.CONNECTIONS_API is not available')) {
          String currentGoogleServicesVer = await checkPlayServicesApp();
          if(currentGoogleServicesVer.isNotEmpty && isNewerVersion(currentGoogleServicesVer, '23.33.16')){
            bool myVal = await alertDialogModel.showDialogModel(
              title: ('downgrade_google').tr(), //
              buttons: {
                ('cancel').tr(): false,
                ('ok').tr(): true,
              },);
            if(myVal){
              //await launchURL('https://dex100c0der.github.io/android-ios-support/dowgrade-gpservices.html');
              emit(const NearbyCheckingRequirements(requestedRequirement: RequestedRequirement.downgradeGplay));
            }
          } else {
            emit(const NearbyError(errorText: 'Nearby.CONNECTIONS_API is not available'));
          }
        } else {
          emit(NearbyError(errorText: exception.toString()));
        }
        rethrow;
      }
      if (kDebugMode) {
        print(exception.toString());
        //print(stackTrace.toString());
      }
    }
    return isAdvertising;
  }

  void onConnectionInit(String id, ConnectionInfo connectionInfo) async {
    try {
      isFirstConnection = false;

      final lastState = state;
      // e conexiune noua cu expeditorul deja concectat
      if (lastState is NearbyConnected) {
        if (lastState.endpointName == connectionInfo.endpointName) {
          await acceptConnection(id, connectionInfo.endpointName);
          return;
        }
      } else if (lastState is NearbyAdvertising) {
        isFirstConnection = true;
        List<String> acceptedEndpointNames = await keyValueStorage.getValue(key: 'acceptedEndpointNames', type: List);
        // e conexiune cu un expeditor din lista acceptata
        if (acceptedEndpointNames.contains(connectionInfo.endpointName)) {
          await acceptConnection(id, connectionInfo.endpointName);
          return;
        } else {
          // e conexiune noua noua si ar trebui sa afisez alertDialog
          emit(
              NearbyRequestConnection(
                  connectionId: id,
                  endpointName: connectionInfo.endpointName
              )
          );
        }
      } else {
        await rejectConnection(id);
      }
    } catch (e, stackTrace) {
      if (!e.toString().contains('8011: STATUS_ENDPOINT_UNKNOWN')) {
        emit(NearbyError(errorText: e.toString()));
        rethrow;
      }
    }
  }

  Future<void> acceptConnection(String id, String endpointName) async {
    try {
      emit(
          NearbyFinalizingConnection(
            connectionId: id, endpointName: endpointName,
          )
      );
      await Nearby().acceptConnection(
          id,
          onPayLoadRecieved: (endId, payload) async {
            final lastState = state;
            if (lastState is NearbyConnected && endId == lastState.connectionId) {
              if (payload.type == PayloadType.BYTES) {
                String str = String.fromCharCodes(payload.bytes!);

                //disconnect
                if (str.contains('disconnect')) {
                  connectionAction = 'disconnect';
                }

                //remotelyPaused
                if (str.contains('paused')) {
                  connectionAction = 'remotelyPaused';
                }

                //point received
                if (str.contains('point:')) {
                  connectionAction = 'remotelyPaused';

                  await player!.play("nav.mp3", volume: soundVolume / 10 );
                  List coordinatesList = str.replaceFirst('point:', '').split(',');
                  String defaultNavAppPackageName = await keyValueStorage.getValue(key: 'defaultNavAppPackageName', type: String) ?? '';
                  String defaultNavLink = await keyValueStorage.getValue(key: 'defaultNavLink', type: String) ?? '';
                  if (defaultNavAppPackageName.isNotEmpty && defaultNavLink.isNotEmpty){
                    await sendTo(coordinatesList[0], coordinatesList[1], defaultNavAppPackageName, defaultNavLink);
                  }
                }
              }
            }
          },
          onPayloadTransferUpdate: (endId, payloadTransferUpdate) async {
            if (payloadTransferUpdate.status == PayloadStatus.FAILURE) {
              awaitingSending = false;
              await player!.play("boing.mp3", volume: soundVolume/ 10);

            } else if (payloadTransferUpdate.status == PayloadStatus.SUCCESS) {
              awaitingSending = false;
              dataWasSent = true;
            }
          }
      );
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print(e.toString());
        print(stackTrace.toString());
      }
      emit(NearbyError(errorText: e.toString()));
        rethrow;
    }


  }

  Future<void> rejectConnection(String id) async {
    await Nearby().rejectConnection(id);
  }


  onConnectionResult(id, status) async {
    try {
      final NearbyState lastState = state;
      if (lastState is NearbyFinalizingConnection && id == lastState.connectionId) {
        switch (status) {
          case Status.CONNECTED:
            connectionAction = 'connected';
            //isConnected = true;
            if (isFirstConnection) {
              await player!.play("success.mp3", volume: soundVolume /10);
            }
            emit(
                NearbyConnected(
                  connectionId: id,
                  endpointName: lastState.endpointName,
                )
            );
            break;

          case Status.REJECTED:
            connectionAction = '';
            emit(const NearbyDisconnected());
            break;

          case Status.ERROR:
            connectionAction = '';
            emit(const NearbyDisconnected());
            break;
        }
      }
    } catch (e, stackTrace) {
      rethrow;
      //appResources.sendError('func006', e.toString(), stackTrace.toString());
    }
  }


  onDisconnected(id) async {
    try {
      final lastState = state;
      if (lastState is NearbyConnected && id == lastState.connectionId) {
        switch (connectionAction) {
          case 'disconnect':
          //s-a deconectat din buton
            await stopAdvertising();
            await player!.play("boing.mp3", volume: soundVolume /10);
            await keyValueStorage.upsertValue(key: 'endpointName', value: '');
            emit(const NearbyDisconnected());
            connectionAction = '';
            break;

          case '':
          //a iesit din raza de actiune
            break;

          case 'remotelyPaused':
            connectionAction = '';
            break;
        }
      }
    } catch (e, stackTrace) {
      //appResources.sendError('func008', e.toString(), stackTrace.toString());
      rethrow;
    }
  }

  Future<bool> cubitCheckRequirements() async {
    return await checkRequirements(this);
  }

/*  Future<bool> enableAdvertising() async {
    bool myRet = false;
    myRet = await checkRequirements(this);
*//*    if (myRet) {
      myRet = await startAdvertising();
    }*//*
    return myRet;
  }*/

  Future<void> stopAdvertising() async {
    await Nearby().stopAdvertising();
    emit(const NearbyDisconnected());
  }

  Future<void> stopConnection() async {
    await Nearby().stopAllEndpoints();
  }


  Future<bool> sendData(connectionId, data) async {
    dataWasSent = false;
    try {
      awaitingSending = true;
      Timer myTimer = Timer(const Duration(seconds: 10), () async {
        awaitingSending = false;
        dataWasSent = false;
        return;
      });
      await Nearby().sendBytesPayload(connectionId, Uint8List.fromList(data.codeUnits));
      while (awaitingSending) {
        await Future.delayed(const Duration(milliseconds: 500));
      }
      myTimer.cancel();
    } catch (e, stackTrace) {
      // appResources.sendError('func008', e.toString(), stackTrace.toString());
      rethrow;
    }
    return dataWasSent;
  }

handleDisconnect() async{
  final lastState = state;
  emitInProgress();
  if (connectionAction != 'remotelyPaused' && lastState is NearbyConnected && lastState.connectionId.isNotEmpty) {
    await sendData(lastState.connectionId, 'disconnect');
  }
  connectionAction = '';
  await stopConnection();
  await stopAdvertising();
  emitDisconnected();
  await keyValueStorage.upsertValue(key: 'endpointName', value: '');
}

  void emitConnected(endpointName) {
    emit(NearbyConnected(connectionId: '', endpointName: endpointName));
  }

  void emitInProgress() {
    emit(const NearbyInProgress());
  }

  void emitDisconnected() {
    emit(const NearbyDisconnected());
  }

  String getEndpointName() {
    final currentState = state;
    if (currentState is NearbyConnected) {
      return currentState.endpointName;
    } else {
      return '';
    }
  }

  NearbyState getReloadCurrentState() {
    final currentState = state;
    if (currentState is NearbyReload) {
      return currentState.cubitState;
    } else {
      return const NearbyDisconnected();
    }
  }

  double getReloadAppScaleFactor() {
    final currentState = state;
    if (currentState is NearbyReload) {
      return currentState.appScaleFactor;
    } else {
      return 1.0;
    }
  }

  String getConnectionId() {
    final currentState = state;
    if (currentState is NearbyConnected) {
      return currentState.connectionId;
    } else {
      return '';
    }
  }

  handleAppResumed() async {
    String endpointName = getEndpointName();
    if(endpointName.isNotEmpty){
      String connectionId = getConnectionId();
      emit(const NearbyInProgress());
      bool hasRequirements = await cubitCheckRequirements();
      if(!hasRequirements) {
        emitDisconnected();
      } else {
        emit(
            NearbyConnected(
              connectionId: connectionId,
              endpointName: endpointName,
            )
        );
      }
    }
  }


  cubitBackgroundSettings({String? level, String? type}) async{
    return await handleBackgroundSettings(
        level: level,
        type: type,
        cubit: this);
  }

  playSound() async{
    await player!.play("boing.mp3", volume: soundVolume /10);
  }

  emitState(NearbyState state){
    emit(state);
  }

  handleIsAwaiting(){
    isAwaiting = false;
  }

  sendTo(String latitude, String longitude, package, String link) async{
    try {
      if(link.isNotEmpty){
        link  = link.replaceFirst('{lat}', latitude).replaceFirst('{long}', longitude);
        try{
          if (Platform.isAndroid) {
            final AndroidIntent intent = AndroidIntent(
              action: 'action_view',
              //data: Uri.encodeFull(link),
              data: link,
              //package: package
            );

            bool? canResolveActivity= await intent.canResolveActivity();
            if(canResolveActivity != null && canResolveActivity){
              //await writeLogs(origin, 'origin: $origin, sendTo, sending point..., link: $link');
              await intent.launch();
            } else {
              throw '!!!sendTo, unable to launch intent!!!, link:$link';
            }
          } else if (Platform.isIOS) {
            if (await canLaunchUrlString(link)) {
              await launchUrlString(link);
            } else {
              throw '!!!sendTo, unable to launch intent!!!, link:$link';
            }
          }
        } catch (e, stackTrace) {
          //print(e);
          //print(stackTrace);
          //appResources.sendError('func020', e.toString(), stackTrace.toString());
          rethrow;
        }
      }
    } catch (e, stackTrace) {
      //appResources.sendError('func021', e.toString(), stackTrace.toString());
      rethrow;
    }
  }

  isNewerVersion(String newVersion, String currentVersion){
    List<String> currentV = currentVersion.split(".");
    List<String> newV = newVersion.split(".");
    bool a = false;
    for (var i = 0 ; i <= 2; i++){
      a = int.parse(newV[i]) > int.parse(currentV[i]);
      if(int.parse(newV[i]) != int.parse(currentV[i])) break;
    }
    return a;
  }

  Future<void> launchURL(dynamic url) async {
    if (url.runtimeType == String){
      url = Uri.parse(url);
    }
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }
}
