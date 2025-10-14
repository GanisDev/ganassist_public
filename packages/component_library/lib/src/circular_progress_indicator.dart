import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../component_library.dart';

class AppCircularProgress extends StatelessWidget {
  const AppCircularProgress({
       Key? key,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        //const CircularProgressIndicator(color: AppTheme.myColor100),
        const CircularProgressIndicator(),
        const  SizedBox(width: 15.0,),
        Text(('awaiting').tr(), style: AppTheme().defaultSubheadStyle),
        //Text(('awaiting').tr(),),
      ],
    );
  }
}

class AppCircularProgressWithText extends StatelessWidget {
  const AppCircularProgressWithText({
        Key? key,
        required this.text
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return  Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const AppCircularProgress(),
        const SizedBox(width: 15.0, height: 50.0,),
        Expanded(
          child: Text(text,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            softWrap: true,
            maxLines: 2,
            style: appTheme.defaultSubheadStyle,
          ),
        ),
      ],
    );
  }
}