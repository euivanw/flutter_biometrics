import 'package:flutter/material.dart';

import 'auth_view.dart';

class HomeView extends StatelessWidget {
  static const routeName = '/home';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(40.0),
        child: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _icon(),
              _space(),
              _text(),
              _space(),
              _button(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _icon() {
    return Icon(
      Icons.thumb_up_alt_rounded,
      color: Colors.green,
      size: 48.0,
    );
  }

  Widget _text() {
    return Text(
      'Parabéns, você está autenticado.',
      textAlign: TextAlign.center,
    );
  }

  Widget _button(context) {
    return ElevatedButton(
      child: Text('Sair'),
      onPressed: () {
        Navigator.of(context).pushReplacementNamed(
          AuthView.routeName,
        );
      },
    );
  }

  Widget _space() {
    return SizedBox(
      height: 40.0,
    );
  }
}
