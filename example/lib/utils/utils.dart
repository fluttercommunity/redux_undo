import 'package:flutter/material.dart';

String getCurrentRouteName(BuildContext context) {
  String currentRouteName;

  Navigator.popUntil(context, (Route<dynamic> route) {
    currentRouteName = route.settings.name;
    return true;
  });

  return currentRouteName;
}

Function() getNavigation(BuildContext context, String route) {
  final String currentRoute = getCurrentRouteName(context);
  if (route == currentRoute) return () => Navigator.pop(context);
  return () => Navigator.popAndPushNamed(context, route);
}
