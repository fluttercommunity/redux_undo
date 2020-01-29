import 'package:flutter/material.dart';
import 'package:redux_undo_example/components/wrapper.dart';
import 'package:redux_undo_example/utils/utils.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Welcome to the redux_undo example App',
            style: Theme.of(context).textTheme.title
          ),
          Text(
            'Below you can find a list of examples which showcase the different use-cases',
            style: Theme.of(context).textTheme.body1,
          ),
          RaisedButton(
            child: const Text('Simple Counter'),
            onPressed: getNavigation(context, 'simple_counter'),
          ),
        ],
      ),
    );
  }
}

class HomeScreenView extends StatelessWidget {
  const HomeScreenView({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Wrapper(title: title, child: const HomeScreen());
  }
}
