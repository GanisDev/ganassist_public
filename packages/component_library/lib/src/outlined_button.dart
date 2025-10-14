import 'package:flutter/material.dart';

import '../component_library.dart';

class AppOutlinedButton extends StatelessWidget {
  const AppOutlinedButton({
    required this.buttonText,
    this.maximumWidth,
    this.onTap,
    Key? key,
  }) : super(key: key);

  final String buttonText;
  final double? maximumWidth;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(left: 5.0, right: 5.0),
        child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
          //textStyle: const TextStyle(color: AppTheme.myColor50),
          side: const BorderSide(width: 1.0,color: AppTheme.myColor100),
          shape: RoundedRectangleBorder(borderRadius: AppTheme.buttonBorderRadius),
          maximumSize:
            maximumWidth != null
            ? Size(maximumWidth!, double.infinity)
            : null,
        ),
        onPressed: onTap,
        child: Text(
            buttonText,
            textAlign: TextAlign.center,
            softWrap: true,
            maxLines: null,
            //style: AppTheme().defaultSmallStyle,
        ),
      ),
    );
  }
}

/*
class AppPlatformOutlinedButton extends StatelessWidget {
  const AppPlatformOutlinedButton({
    required this.buttonText,
    this.maximumWidth,
    this.onTap,
    Key? key,
  }) : super(key: key);

  final String buttonText;
  final double? maximumWidth;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return PlatformElevatedButton(
      padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 5.0, bottom: 5.0),
      onPressed: onTap,
      child: Text(
        buttonText,
        textAlign: TextAlign.center,
        softWrap: true,
        maxLines: null,
        //style: AppTheme().defaultSmallStyle,
      ),
        material: (_, __) => MaterialElevatedButtonData(
          style:OutlinedButton.styleFrom(
            padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 5.0, bottom: 5.0),
            //textStyle: const TextStyle(color: AppTheme.myColor50),
            side: const BorderSide(width: 1.0),
            shape: RoundedRectangleBorder(borderRadius: AppTheme.buttonBorderRadius),
            maximumSize:
            maximumWidth != null
                ? Size(maximumWidth!, double.infinity)
                : null,
          ),
        )
    );

  }
}*/
