import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../component_library.dart';

class AppElevatedButton extends StatelessWidget {
  const AppElevatedButton({
    required this.buttonText,
    this.onTap,
    Key? key,
  }) : super(key: key);

  final String buttonText;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: OutlinedButton.styleFrom(
        textStyle: const TextStyle(color: Colors.white),
        backgroundColor: AppTheme.myColor100,
        minimumSize: const Size(50.0, 50.0),
        side: const BorderSide(width: 1.0, color: AppTheme.myColor100),
        shape: RoundedRectangleBorder(borderRadius: AppTheme.buttonBorderRadius),
        alignment:Alignment.center,
        padding: const EdgeInsets.all(10.0),
      ),
      onPressed: onTap,
      child: Text(
            buttonText,
            textAlign: TextAlign.center,
            style: AppTheme().defaultTitleStyleWhite,
        ),
    );
  }
}

class AppPlatformElevatedButton extends StatelessWidget {
  const AppPlatformElevatedButton({
    required this.buttonText,
    this.onTap,
    Key? key,
  }) : super(key: key);

  final  Text buttonText;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return PlatformElevatedButton(
      padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 5.0, bottom: 5.0),
      onPressed: onTap,
      child: buttonText,
      material: (_, __) => MaterialElevatedButtonData(
        style:OutlinedButton.styleFrom(
          side: const BorderSide(width: 1.0,),
          minimumSize: const Size(50.0, 50.0),
          shape: RoundedRectangleBorder(borderRadius: AppTheme.buttonBorderRadius),
          alignment:Alignment.center,
          padding: const EdgeInsets.all(10.0),
        ),
      ),
    );
  }
}