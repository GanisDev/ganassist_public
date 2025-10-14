import 'package:firebase_core/firebase_core.dart';


export 'src/analytics_service.dart';
export 'src/error_reporting_service.dart';
export 'src/explicit_crash.dart';


Future<void> initializeMonitoringPackage() => Firebase.initializeApp();
