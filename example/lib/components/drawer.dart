import 'package:flutter/material.dart';
import 'package:redux_undo_example/utils/utils.dart';

@immutable
class DrawerView extends StatelessWidget {
  const DrawerView();

  @override
  Widget build(BuildContext context) {
    final String currentRoute = getCurrentRouteName(context);

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
            onTap: getNavigationForDrawer(context, '/'),
          ),
          ListTile(
            leading: Icon(
              Icons.add,
              size: 24.0,
            ),
            title: const Text('Simple Counter'),
            selected: currentRoute == 'simple_counter',
            onTap: getNavigationForDrawer(context, 'simple_counter'),
          ),
        ],
      ),
    );
  }
}
