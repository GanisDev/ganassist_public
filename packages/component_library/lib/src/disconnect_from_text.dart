import 'package:flutter/cupertino.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../component_library.dart';

class DisconnectFromText extends StatelessWidget{
  const DisconnectFromText({
    Key? key,
    required this.endpointName
  }) : super (key:key);

  final String? endpointName;

  @override
  Widget build(BuildContext context){
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(text: ('disconnect_from').tr(), style: AppTheme().defaultSubheadStyle),
          TextSpan(text: '\n\n$endpointName', style: AppTheme().defaultTitleStyle),
          TextSpan(text: '?', style: AppTheme().defaultSubheadStyle),
        ],
      ),
    );
  }
}

