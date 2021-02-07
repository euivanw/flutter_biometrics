import 'package:flutter/material.dart';

import 'auth_view.dart';
import 'error_view.dart';
import 'home_view.dart';

class AppView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AuthView.routeName,
      routes: {
        AuthView.routeName: (context) => AuthView(),
        HomeView.routeName: (context) => HomeView(),
        ErrorView.routeName: (context) => ErrorView(),
      },
    );
  }
}
