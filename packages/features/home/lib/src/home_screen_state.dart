
part of 'home_screen_cubit.dart';



abstract class NearbyState extends Equatable{
  const NearbyState();
}

class NearbyInProgress extends NearbyState {
  const NearbyInProgress();

  @override
  List<Object?> get props => [];
}

class NearbyDisconnected extends NearbyState {
  const NearbyDisconnected();

  @override
  List<Object?> get props => [];
}

class NearbyAdvertising extends NearbyState {
  const NearbyAdvertising();

  @override
  List<Object?> get props => [];
}

class NearbyRequestConnection extends NearbyState {
  const NearbyRequestConnection({
    required this.connectionId,
    required this.endpointName
  });

  final String connectionId;
  final String endpointName;

  @override
  List<Object?> get props => [
    connectionId,
    endpointName
  ];
}

class NearbyFinalizingConnection extends NearbyState {
  const NearbyFinalizingConnection({
    required this.connectionId,
    required this.endpointName
  });

  final String connectionId;
  final String endpointName;

  @override
  List<Object?> get props => [
    connectionId,
    endpointName
  ];
}

class NearbyConnected extends NearbyState {
   const NearbyConnected({
     required this.connectionId,
     required this.endpointName,
     this.connectionStatus = ConnectionStatus.disabled
   });

   final String connectionId;
   final String endpointName;
   final ConnectionStatus connectionStatus;

  @override
  List<Object?> get props => [
    endpointName,
    connectionStatus
  ];
}

class ShowingSystemWindow extends NearbyState {
  const ShowingSystemWindow();

  @override
  List<Object?> get props => [];
}

class NotShowingSystemWindow extends NearbyState {
  const NotShowingSystemWindow();

  @override
  List<Object?> get props => [];
}

class NearbyCheckingRequirements extends NearbyState {
  const NearbyCheckingRequirements({
    required this.requestedRequirement,
  });

  final RequestedRequirement requestedRequirement;

  @override
  List<Object?> get props => [
    requestedRequirement,
  ];
}

class NearbyError extends NearbyState {
  const NearbyError({
    required this.errorText,
  });

  final String errorText;

  @override
  List<Object?> get props => [
    errorText,
  ];
}

class NearbyReload extends NearbyState {
  const NearbyReload({
    required this.cubitState,
    required this.appScaleFactor,
  });

  final NearbyState cubitState;
  final double appScaleFactor;

  @override
  List<Object?> get props => [
    cubitState,
  ];
}



enum ConnectionStatus {
  disabled,
  inProgress,
  advertising,
  connected
}

enum RequestedRequirement {
  defaultNavApp,
  name,
  locationPermission,
  enableLocation,
  locationNotEnabled,
  bluetoothPermission,
  noBluetoothPermission,
  disableBatteryOptimization,
  batteryOptimizationNotDisabled,
  backgroundSetting,
  downgradeGplay
}



/*class NearbyState extends Equatable{
  const NearbyState({
    this.connectionId = '',
    this.endpointName = '',
    this.connectionStatus = ConnectionStatus.disabled
  });

  final String connectionId;
  final String endpointName;
  final ConnectionStatus connectionStatus;

  NearbyState copyWith({
    required String connectionId,
    required String endpointName,
    required ConnectionStatus connectionStatus
  }){
    return NearbyState(
        connectionId: connectionId,
        endpointName: endpointName,
        connectionStatus: connectionStatus
    );
  }

  @override
  List<Object?> get props => [
    connectionId,
    endpointName,
    connectionStatus
  ];

}*/
/*
disabled
inProgress
isAdvertising
isConnected




*/
