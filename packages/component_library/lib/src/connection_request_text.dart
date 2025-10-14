import 'package:flutter/cupertino.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../component_library.dart';

class ConnectionRequestText extends StatelessWidget{
  const ConnectionRequestText({
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
          TextSpan(text: ('connection_request').tr(), style: AppTheme().defaultSubheadStyle),
          TextSpan(text: '\n\n$endpointName', style: AppTheme().defaultTitleStyle),
        ],
      ),
    );
  }
}

