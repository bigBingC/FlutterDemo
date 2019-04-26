import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'testpage.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    ///注册路由
    FlutterBoost.singleton.registerPageBuilders({
      'sample://firstPage': (pageName, params, _) => FirstRouteWidget(),
      'sample://secondPage': (pageName, params, _) => SecondRouteWidget(),
    });

    ///query current top page and load it
    FlutterBoost.handleOnStartPage();
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
      title: 'Flutter Boost example',
      builder: FlutterBoost.init(), ///init container manager
      home: Container());
}