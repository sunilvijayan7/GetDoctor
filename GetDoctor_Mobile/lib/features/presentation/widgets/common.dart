import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

void snackBar({String msg, GlobalKey<ScaffoldState> scaffoldState}) {
  scaffoldState.currentState.showSnackBar(
    SnackBar(
      duration: Duration(seconds: 3),
      content: Text(msg),
    ),
  );
}
void pushPageTransition(
    {BuildContext context,
    Widget widget,
    PageTransitionType transitionType = PageTransitionType.fade}) {
  Navigator.push(context, PageTransition(child: widget, type: transitionType));
}
