import 'package:flutter/material.dart';
import 'package:redux_undo_example/components/drawer.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({
    @required this.title,
    @required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerView(),
      appBar: AppBar(
        title: Text(title),
      ),
      body: child,
    );
  }
}
