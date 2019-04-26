import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';

class FirstRouteWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('flutter页面'),
      ),
      body: Center(
        child: RaisedButton(
          child: Text('跳转第二个页面'),
          onPressed: () {
            FlutterBoost.singleton.openPage("sample://secondPage", {}, animated: true);
          },
        ),
      ),
    );
  }
}


class SecondRouteWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter第二个页面"),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            FlutterBoost.singleton.closePageForContext(context);
          },
          child: Text('Go back!'),
        ),
      ),
    );
  }
}

