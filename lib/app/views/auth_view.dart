import 'package:flutter/material.dart';

import '../model/biometrics.dart';
import 'error_view.dart';
import 'home_view.dart';

class AuthView extends StatefulWidget {
  static const routeName = '/auth';

  @override
  _AuthViewState createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  bool _isBusy = true;
  bool _isActive = false;
  String _buttonLabel = 'Aguarde...';

  @override
  void initState() {
    _loadBiometricType();
    super.initState();
  }

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
              !_isBusy
                  ? _isActive
                      ? _button()
                      : _inactive()
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _icon() {
    return Icon(
      Icons.fingerprint,
      color: _isActive ? Colors.blue : Colors.red,
      size: 64.0,
    );
  }

  Widget _inactive() {
    return Text(
      'A biometria está inativa.',
      style: TextStyle(
        color: Colors.red,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _button() {
    return ElevatedButton(
      child: Text(_buttonLabel),
      onPressed: _isBusy ? null : _dealAuthentication,
    );
  }

  Widget _space() {
    return SizedBox(
      height: 40.0,
    );
  }

  void _loadBiometricType() {
    Biometrics.isActive().then((active) {
      setState(() {
        _isActive = active;
      });
    });

    Biometrics.getStringType().then((type) {
      setState(() {
        _buttonLabel = 'Autenticar usando $type';
        _isBusy = false;
      });
    });
  }

  void _dealAuthentication() {
    Biometrics.authenticate().then((success) {
      if (success) {
        Navigator.of(context).pushReplacementNamed(
          HomeView.routeName,
        );
      } else {
        Navigator.of(context).pushNamed(
          ErrorView.routeName,
          arguments: ErrorArgs('A autenticação falhou.'),
        );
      }
    }).catchError((_) {
      setState(() {
        _isActive = false;
      });
    });
  }
}
