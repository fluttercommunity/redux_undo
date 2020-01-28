import 'package:flutter/material.dart';

@immutable
class DrawerView extends StatelessWidget {
  const DrawerView();

  @override
  Widget build(BuildContext context) {
    String _getCurrentRouteName() {
      String currentRouteName;

      Navigator.popUntil(context, (Route<dynamic> route) {
        currentRouteName = route.settings.name;
        return true;
      });

      return currentRouteName;
    }

    final String currentRoute = _getCurrentRouteName();

    Function() _getNavigation(String route) {
      if (route == currentRoute) return () => Navigator.pop(context);
      return () => Navigator.popAndPushNamed(context, route);
    }

    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          ListTile(
            leading: Icon(
              Icons.home,
              size: 24.0,
            ),
            title: const Text('Welcome'),
            selected: currentRoute == '/',
            onTap: _getNavigation('/'),
          ),
          ListTile(
            leading: Icon(
              Icons.add,
              size: 24.0,
            ),
            title: const Text('Simple Counter'),
            selected: currentRoute == 'simple_counter',
            onTap: _getNavigation('simple_counter'),
          ),
        ],
      ),
    );
  }
}
