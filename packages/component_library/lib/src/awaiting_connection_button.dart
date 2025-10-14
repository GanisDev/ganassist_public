import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../component_library.dart';

class AwaitingConnectionButton extends StatelessWidget {
  const AwaitingConnectionButton({
    required this.onTap,
    Key? key,
  }) : super(key: key);

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const CircularProgressIndicator(),
          const  SizedBox(width: 15.0,),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(('awaiting_connection').tr(), style: AppTheme().defaultSubheadStyle),
              Text(('tap_to_stop').tr(), style: AppTheme().defaultSmallStyle),
            ],
          )
        ],
      ),
    );
  }
}

