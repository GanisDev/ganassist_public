import 'package:flutter/material.dart';

import '../component_library.dart';


@immutable
class AlertDialogModel<T> {
  final GlobalKey<NavigatorState> navigatorKey;
  final double appScaleFactor;

  const AlertDialogModel(
    this.navigatorKey,
      this.appScaleFactor,
    );

  Future<dynamic> showDialogModel({required title, required Map<String,T> buttons}) =>
      showDialog(
        context: navigatorKey.currentState!.context,
        builder: (context) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor:appScaleFactor),
            child: WillPopScope(
              onWillPop: () async => false,
              child: AlertDialog(
                shape: RoundedRectangleBorder(borderRadius: AppTheme.rectangleBorderRadius),
                title:
                title is String
                ? Text(
                    title,
                    softWrap: true,
                    textAlign: TextAlign.center,
                    style: AppTheme().defaultSubheadStyle,
                  )
                : title,
                actions: buttons.entries.map(
                    (entry) {
                    return AppOutlinedButton(
                      buttonText: entry.key,
                      onTap: () {
                        if(Navigator.of(context).canPop()){
                          Navigator.pop(context, entry.value);
                        }
                      },
                    );
                  },
                ).toList(),
                actionsAlignment: MainAxisAlignment.center,
                actionsPadding: const EdgeInsets.only(bottom: 10.0,left: 5.0,right: 5.0, top: 5.0),
              ),
            ),
          );
        },
      );
}

/*extension Present<T> on AlertDialogModel<T> {
  Future<T?> present(BuildContext context) {
    return showDialog<T?>(
      context: context,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: AppTheme.rectangleBorderRadius),
            title:
            alertTitle is String
                ? Text(
              alertTitle,
                  softWrap: true,
                  textAlign: TextAlign.center,
                  style: AppTheme().defaultSubheadStyle,
            )
                : alertTitle is RichText ? alertTitle : const Text('unknown text'),
            actions: buttons.entries.map(
              (entry) {
                return AppOutlinedButton(
                  buttonText: entry.key,
                  onTap: () {
                    if(Navigator.of(context).canPop()){
                      Navigator.pop(context, entry.value);
                    }
                  },
                );
              },
            ).toList(),
            actionsAlignment: MainAxisAlignment.center,
            actionsPadding: const EdgeInsets.only(bottom: 10.0),
          ),
        );
      },
    );
  }
}*/
