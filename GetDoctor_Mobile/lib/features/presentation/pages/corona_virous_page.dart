import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class CoronaVirusPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      url: "https://covid.cdc.gov/",
      withZoom: true,
      withLocalStorage: true,
      hidden: true,
      initialChild: Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 20,),
          Text("Covid19 Tracker Data Loading..",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600),)
        ],
      )),
    );
  }
}
