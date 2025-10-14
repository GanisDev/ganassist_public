import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import '../component_library.dart';

class ManagedProgressIndicator {
  const ManagedProgressIndicator();

  static Map<String, dynamic> progressIndicators = {};

  showMyProgressIndicator(BuildContext context, String action, String text, bool myBarrier, [isForced]) {
    try {
      if(progressIndicators.isEmpty || !progressIndicators.containsKey(action)){
        progressIndicators[action] = buildRoute(text, myBarrier);
        Navigator.push(context, progressIndicators[action]);
      }
    } catch (e, stackTrace) {
      //appResources.sendError('func030', e.toString(), stackTrace.toString());
      if (kDebugMode) {
        print(e.toString());
        print(stackTrace.toString());
      }
      rethrow;
    }
  }

  dismissMyProgressIndicator(BuildContext context, String? action){
    try {
      if(progressIndicators.isNotEmpty && action != null && progressIndicators.containsKey(action)){
        if(Navigator.of(context).canPop()){
          Navigator.removeRoute(context,progressIndicators[action]);
          progressIndicators.remove(action);
        }
      }
    } catch (e, stackTrace) {
      //appResources.sendError('func031', e.toString(), stackTrace.toString());
      if (kDebugMode) {
        print(e.toString());
        print(stackTrace.toString());
      }
      rethrow;
    }
  }

  buildRoute(text, myBarrier){
    return PageRouteBuilder(
        opaque: false,
        barrierDismissible: myBarrier,
        pageBuilder: (BuildContext context, _, __) {
          return WillPopScope(
            onWillPop: () {} as Future<bool> Function()?,
            child: AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: AppTheme.buttonBorderRadius),
              titlePadding: const EdgeInsets.only(left: 10.0, right: 5.0, top: 10.0,bottom: 10.0),
              title: AppCircularProgressWithText(text:text),
            ),
          );
        }
    );
   }
}