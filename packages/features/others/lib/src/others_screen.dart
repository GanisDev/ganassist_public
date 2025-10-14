import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:component_library/component_library.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:android_intent_plus/android_intent.dart';



class OthersScreen extends StatefulWidget {
  //final Function? notifyParent;
  final BuildContext myContext;
  final String othersType;
  final String appBarTitle;
  const OthersScreen(this.myContext, this.othersType, this.appBarTitle,{Key? key,}) : super(key: key);

  @override
  _OthersScreenState createState() => _OthersScreenState();
}

class _OthersScreenState extends State<OthersScreen> {
  bool contentLoaded = false;
  var bodyContent;
  //final _subjectController = TextEditingController();
  //final _bodyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _myInit();
  }

  @override
  void dispose() {

    super.dispose();
  }

  _myInit(){
    _getBodyContent();
  }

  @override
  Widget build(BuildContext context) {
    try {
      return WillPopScope(
        onWillPop: _willPopCallback,
        child: Scaffold(
          appBar: AppBar(
              centerTitle: true,
              title: Text(widget.appBarTitle),
              leading: IconButton(
                  icon: const Icon(Icons.keyboard_backspace),
                  onPressed: () async {
                    bool myRet = await _willPopCallback();
                    if(myRet){
                      Navigator.of(context).pop();
                    }
                  }
              )
          ),
          body: contentLoaded
            ? bodyContent
            : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const CircularProgressIndicator(color: AppTheme.myColor100),
                    const SizedBox(width: 15.0,),
                    Text(('loading').tr()),
                  ],
                ),
                const SizedBox(height: 30.0,)
              ],
            ),
        ),
      );

    } catch (e, stackTrace) {
      //appResources.sendError('func022', e.toString(), stackTrace.toString());

      if (kDebugMode) {
        print(e.toString());
        print(stackTrace.toString());
      }
      rethrow;
      return Container();
    }
  }

  _getBodyContent(){
    try {
      bodyContent = null;
      switch (widget.othersType){

        case "eula":
          _loadEula();
          break;

        case "privacy":
          _loadPrivacy();
          break;

        case "licenses":
          _loadLicenses();
          break;

        case "changelog":
          _loadChangelog();
          break;

        case "error":
          //_sendEmail('error');
          break;

        case "feedback":
          //_sendEmail('feedback');
          break;

        case "downgrade":
          _loadDowngrade();
          break;

      }
    } catch (e, stackTrace) {
        //appResources.sendError('func023', e.toString(), stackTrace.toString());
      rethrow;
    }
  }

  _loadEula() async{
    try {
      String myJsonContent = await rootBundle.loadString("packages/features/others/assets/eula.json");
      var fullContent =  json.decode(myJsonContent);
      if(fullContent != null && fullContent.isNotEmpty){
        var myContent = fullContent[widget.myContext.locale.languageCode];

        bodyContent = SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.only(left: 10.0, right: 5.0),
            child:  Column(
              children: <Widget>[
                RichText(
                  textAlign: TextAlign.start,
                  text: TextSpan(
                    children: _makeEulaContent(myContent),
                  ),
                )
              ],
            ),
          ),
        );
      } else {
        bodyContent = SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.only(left: 10.0, right: 5.0),
            child:  Column(
              children: const <Widget>[
                Text('Error...')
              ],
            ),
          ),
        );
      }

      setState(() {
        contentLoaded = true;
      });
    } catch (e, stackTrace) {
        //appResources.sendError('func024', e.toString(), stackTrace.toString());
      setState(() {
        contentLoaded = false;
      });
      rethrow;
    }
  }

  _loadPrivacy() async{
    try {
      String myJsonContent = await rootBundle.loadString("assets/privacy.json");
      var fullContent =  json.decode(myJsonContent);
      var myContent = fullContent[widget.myContext.locale.languageCode];

      bodyContent = SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(left: 10.0, right: 5.0),
          child:  Column(
            children: <Widget>[
              RichText(
                textAlign: TextAlign.start,
                text: TextSpan(
                  children: _makeEulaContent(myContent),
                ),
              )
            ],
          ),
        ),
      );
      setState(() {
        contentLoaded = true;
      });
    } catch (e, stackTrace) {
        //appResources.sendError('func025', e.toString(), stackTrace.toString());
      rethrow;
    }


  }


  _loadLicenses() async{
    try {
      String myJsonContent = await rootBundle.loadString("packages/features/others/assets/packages.json");
      var myContent =  json.decode(myJsonContent);

      bodyContent = SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(left: 10.0, right: 5.0),
          child:  Column(
            crossAxisAlignment:  CrossAxisAlignment.start,
            children: _makePackagesContent(myContent),
          ),
        ),
      );
      setState(() {
        contentLoaded = true;
      });
    } catch (e, stackTrace) {
       // appResources.sendError('func026', e.toString(), stackTrace.toString());
      rethrow;
    }
  }

  _loadChangelog() async{
    try {
      String myJsonContent = await rootBundle.loadString("packages/features/others/assets/changelog.json");
      var myContent =  json.decode(myJsonContent);

      bodyContent = SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(left: 10.0, right: 5.0),
          child:  Column(
            children: <Widget>[
              RichText(
                textAlign: TextAlign.start,
                text: TextSpan(
                  children: _makeLogContent(myContent),
                ),
              )
            ],
          ),
        ),
      );
      setState(() {
        contentLoaded = true;
      });
    } catch (e, stackTrace) {
        //appResources.sendError('func027', e.toString(), stackTrace.toString());
      rethrow;
    }
  }

  _loadDowngrade() async{
    try {
      String myJsonContent = await rootBundle.loadString("packages/features/others/assets/downgrade_gplay.json");
      var fullContent =  json.decode(myJsonContent);
      if(fullContent != null && fullContent.isNotEmpty){
        var myContent = fullContent[widget.myContext.locale.languageCode];

        bodyContent = SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.only(left: 10.0, right: 5.0),
            child:  Column(
              crossAxisAlignment:  CrossAxisAlignment.start,
              children: _makeDowngradeGplayContent(myContent),
            ),
          ),
        );
      } else {
        bodyContent = SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.only(left: 10.0, right: 5.0),
            child:  Column(
              children: const <Widget>[
                Text('Error...')
              ],
            ),
          ),
        );
      }

      setState(() {
        contentLoaded = true;
      });
    } catch (e, stackTrace) {
      //appResources.sendError('func024', e.toString(), stackTrace.toString());
      setState(() {
        contentLoaded = false;
      });
      rethrow;
    }
  }


  List<InlineSpan> _makeEulaContent(content){
    List<InlineSpan> returnedContent = [];
    for(int i = 0; i < content.length; i++){
      returnedContent.add(
          TextSpan(text: '\n' , style: AppTheme().defaultLineStyle)
      );
      returnedContent.add(
          TextSpan(text: content[i]['title'] +'\n', style: AppTheme().defaultSubheadStyle)
      );
      returnedContent.add(
          TextSpan(text: '\n' , style: AppTheme().defaultLineStyle)
      );
      for(int j = 0; j < content[i]['content'].length; j++){
        returnedContent.add(
            TextSpan(text: content[i]['content'][j]  , style: AppTheme().defaultLineStyle)
        );
        returnedContent.add(
            TextSpan(text: '\n\n' , style: AppTheme().defaultLineStyle)
        );
      }
    }
    return returnedContent;
  }

  List<Widget> _makePackagesContent(content){
    List<Widget> returnedContent = [];
    returnedContent.add(
      const SizedBox(height: 5.0,),
    );
    for(int i = 0; i < content.length; i++){
      returnedContent.add(
          Text(content[i]['title'],style: appTheme.defaultTitleStyle,)
      );
      returnedContent.add(
        const SizedBox(height: 5.0,),
      );
      returnedContent.add(
          InkWell(
            child: Text(
              content[i]['link'],
              style: const TextStyle(
                  fontSize: 16.0,
                  color: Colors.blue,
                  decoration:TextDecoration.underline
              ),
            ),
            onTap: (){
              launchURL(content[i]['link']);
            },
          )
      );
      returnedContent.add(
        const SizedBox(height: 20.0,),
      );
    }
    return returnedContent;
  }


  List<Widget> _makeDowngradeGplayContent(content){
    List<Widget> returnedContent = [];
    for(int i = 0; i < content.length; i++){

      //title
      returnedContent.add(
        const SizedBox(height: 20.0,),
      );
      if(content[i]['title'] != null){
        returnedContent.add(
            RichText(
              //textAlign: TextAlign.center,
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(text: content[i]['title'] +'\n', style: AppTheme().defaultSubheadStyle)
                ],
              ),
            )
        );
/*        returnedContent.add(
          const SizedBox(height: 10.0,),
        );*/
      }

      for(int j = 0; j < content[i]['content'].length; j++){
        returnedContent.add(
            RichText(
              //textAlign: TextAlign.center,
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(text: content[i]['content'][j]  , style: AppTheme().defaultLineStyle)
                ],
              ),
            )
        );
        returnedContent.add(
          const SizedBox(height: 10.0,),
        );
      }

      //button
      if(content[i]['button_text'] != null){
        returnedContent.add(
            Row(
              mainAxisAlignment:MainAxisAlignment.center,
              children: [
/*                AppElevatedButton(
                  buttonText: content[i]['button_text'],
                  onTap: ()  {
                    launchButton(content[i]['package_for_intent']);
                  },
                ),*/
                AppOutlinedButton(
                  buttonText: content[i]['button_text'],
                  onTap: () {
                    launchButton(content[i]['package_for_intent']);
                  },
                ),
              ],
            )
        );
        returnedContent.add(
          const SizedBox(height: 10.0,),
        );
      }

      //link
      if(content[i]['link'] != null){
        returnedContent.add(
            InkWell(
              child: Text(
                content[i]['link_text'],
                style: const TextStyle(
                    fontSize: 16.0,
                    color: Colors.blue,
                    decoration:TextDecoration.underline
                ),
              ),
              onTap: (){
                launchURL(content[i]['link']);
              },
            )
        );
        returnedContent.add(
          const SizedBox(height: 10.0,),
        );
      }
    }
    return returnedContent;
  }

  launchButton(String packageName) async{
    if (Platform.isAndroid) {
      AndroidIntent intent =   AndroidIntent(
          action: 'action_application_details_settings',
          data: 'package:$packageName'
      );
      bool? canResolveActivity= await intent.canResolveActivity();
      if(canResolveActivity != null && canResolveActivity){
        await intent.launch();
      } else {
        throw '!!!sendTo, unable to launch intent: ${intent.toString()}!!!';
      }
    } else if (Platform.isIOS) {
      //todo iOS
/*    if (await canLaunchUrlString(link)) {
      await launchUrlString(link);
    } else {
      throw '!!!sendTo, unable to launch intent!!!, link:$link';
    }*/
    }
  }

  Future<void> launchURL(dynamic url) async {
    if (url.runtimeType == String){
      url = Uri.parse(url);
    }
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

/*
  _sendEmail(type) async {
    try {
      String headText = '';
      String myPlatform = 'Android';
      if(defaultTargetPlatform == TargetPlatform.iOS){
        myPlatform = 'iOS"';
      }
      _subjectController.text = 'GanAssist v. ${AppResources.appVersionNumber} $myPlatform ${AppResources.osVer} (${widget.myContext.locale.languageCode})';

      if(type == 'feedback'){
        _subjectController.text += ' feedback';
      }

      if(type == 'error'){
        _subjectController.text += ' error';
        if(appResources.appError.isNotEmpty){
          _bodyController.text = 'Function: ${appResources.appError['function']}\n\nError: ${appResources.appError['error']}'
              '\n\nStackTrace:\n${appResources.appError['stackTrace']}' ;
        } else {
          _bodyController.text = 'Error!';
        }
      }

      if(type == 'feedback' || (_bodyController.text.isNotEmpty)){
        bodyContent = SingleChildScrollView(
          child: Column(
            crossAxisAlignment:  CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              headText.isNotEmpty
                  ? const SizedBox(height: 15.0,)
                  : const SizedBox(),
              headText.isNotEmpty
                  ? Text(headText, style: defaultTitleStyle,textAlign: TextAlign.center)
                  : const SizedBox(),
              const SizedBox(height: 10.0,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  enabled: false,
                  controller: _subjectController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Subject:',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  textAlign: TextAlign.start,
                  enabled: !['error', 'fcm_error', 'share_logs'].contains(type),
                  controller: _bodyController,
                  maxLines: headText.isNotEmpty  ?12 : 14,
                  decoration: const InputDecoration(
                      labelText: 'Body:', border: OutlineInputBorder()),
                ),
              ),
              const SizedBox(height: 15.0,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      textStyle: const TextStyle(color: myColor50),
                      side: const BorderSide(width: 1.0, color: myColor100),
                      shape: RoundedRectangleBorder(borderRadius:     buttonBorderRadius),
                    ),
                    onPressed: () async {
                      if (Navigator.of(context).canPop()) Navigator.of(context).pop();
                    },
                    child: Text(('cancel').tr()),
                  ),
                  const SizedBox(width: 15.0,),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      textStyle: const TextStyle(color: myColor50),
                      side: const BorderSide(width: 1.0, color: myColor100),
                      shape: RoundedRectangleBorder(borderRadius:     buttonBorderRadius),
                    ),
                    onPressed: () async {
                      if (_bodyController.text.isNotEmpty){
                          await appResources.sendEmailWithLocal(_subjectController.text, _bodyController.text);
                          if (type == 'feedback' ){
                            await AlertDialogModel(
                              title: ('thanks_feedback').tr(),
                              buttons: {
                                ('close').tr(): true,
                              },)
                                .present(widget.myContext);
                          }
                      } else {
                        await AlertDialogModel(
                          title: 'No body content...',
                          buttons: {
                            ('close').tr(): true,
                          },)
                            .present(widget.myContext);
                      }
                      if (Navigator.of(context).canPop()) Navigator.of(context).pop();
                    },
                    child: Text(('ok').tr()),
                  ),
                ],
              ),
              const SizedBox(height: 15.0,),
            ],
          ),
        );

        setState(() {
          contentLoaded = true;
        });
      } else {
        setState(() {
          contentLoaded = false;
        });
      }

    } catch (e, stackTrace) {
      //appResources.sendError('func028', e.toString(), stackTrace.toString());
      if (kDebugMode) {
        print(e.toString());
        print(stackTrace.toString());
      }
      rethrow;
    }
  }*/

  _makeLogContent(content){
    List<InlineSpan>returnedContent = [];

    content.forEach((ver, changes){
      returnedContent.add(
          TextSpan(text: '\n' , style: appTheme.defaultLineStyle)
      );
      returnedContent.add(
          TextSpan(text: ver +'\n', style: appTheme.defaultTitleStyle)
      );

      returnedContent.add(
          TextSpan(text: '\n' , style: appTheme.defaultLineStyle)
      );

      for(int i = 0; i < changes.length; i++){
        returnedContent.add(
            TextSpan(text: '* ' +changes[i]  , style: appTheme.defaultLineStyle)
        );
        returnedContent.add(
            TextSpan(text: '\n\n' , style: appTheme.defaultLineStyle)
        );
      }

    });
    return returnedContent;
  }

  Future<bool> _willPopCallback() async {
    return true;
/*    if(_nameController.text.isEmpty || _nameController.text == 'Name???'){
      final myVal = await AlertDialogModel(
        title: ('settings_name').tr(args: ['']),
        buttons: {
          ('ok').tr(): false,
        },)
          .present(context)
          .then((alertVal) => alertVal ?? false);
      return false;
    } else {
      return true;
      //Navigator.of(context).pop();
    }*/
    // return true if the route to be popped
  }

}

