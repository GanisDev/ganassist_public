import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../component_library.dart';

class ConnectedWithButton extends StatelessWidget {
  const ConnectedWithButton({
    required this.endpointName,
    required this.onTap,
    required this.appScaleFactor,
    Key? key,
  }) : super(key: key);

  final String endpointName;
  final VoidCallback onTap;
  final double appScaleFactor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(text: ('connected_with').tr(), style: AppTheme().defaultSubheadStyle),
              TextSpan(text: '\n$endpointName', style: AppTheme().defaultLargeStyle),
            ],
          ),
        ),
        const SizedBox(height: 30.0,),
        AppPlatformElevatedButton(//AppElevatedButton(
          buttonText: Text(
              ('disconnect').tr(),
              textScaleFactor: appScaleFactor,
            ),
          onTap: onTap,
        ),
      ],
    );
  }
}

