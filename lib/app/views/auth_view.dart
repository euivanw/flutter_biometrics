import 'dart:io';

import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

import 'error_view.dart';
import 'home_view.dart';

class AuthView extends StatefulWidget {
  static const routeName = '/auth';

  @override
  _AuthViewState createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  final LocalAuthentication _auth = LocalAuthentication();
  bool _isBusy = true;
  bool _isActive = false;
  String _buttonLabel = 'Aguarde...';
  String _biometricType;

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
              _isActive ? _activeButton() : _inactive(),
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

  Widget _activeButton() {
    return ElevatedButton(
      child: Text(_buttonLabel),
      onPressed: _isBusy
          ? null
          : () {
              _auth.canCheckBiometrics.then(
                (bool result) {
                  if (result) {
                    _auth
                        .authenticateWithBiometrics(
                      localizedReason: _messages()[0],
                      useErrorDialogs: true,
                      stickyAuth: true,
                    )
                        .then(
                      (bool result) {
                        if (result) {
                          _goToHomeView();
                        } else {
                          _goToErrorView(_messages()[2]);
                        }
                      },
                    ).catchError(
                      (_) => _goToErrorView(_messages()[1]),
                    );
                  } else {
                    _goToErrorView(_messages()[3]);
                  }
                },
              ).catchError(
                (_) => _goToErrorView(_messages()[1]),
              );
            },
    );
  }

  Widget _space() {
    return SizedBox(
      height: 40.0,
    );
  }

  void _loadBiometricType() async {
    List<BiometricType> availableBiometrics =
        await _auth.getAvailableBiometrics();

    if (Platform.isIOS) {
      if (availableBiometrics.contains(BiometricType.face)) {
        _setBiometricType('Face ID');
      } else if (availableBiometrics.contains(BiometricType.fingerprint)) {
        _setBiometricType('Touch ID');
      }
    }
  }

  void _setBiometricType(String biometricType) {
    setState(() {
      _biometricType = biometricType;
      _buttonLabel = 'Autenticar usando $_biometricType';
      _isBusy = false;
      _isActive = true;
    });
  }

  List<String> _messages() {
    return [
      'Aqui vai a sua mensagem explicando porque precisa de autenticação por biometria.',
      'Ocorreu um erro ao identificar se seu aparelho possui biometria habilitada ou não.',
      'A autenticação falhou.',
      'A biometria não está disponível.'
    ];
  }

  void _goToHomeView() {
    Navigator.of(context).pushReplacementNamed(HomeView.routeName);
  }

  void _goToErrorView(String message) {
    Navigator.of(context).pushNamed(
      ErrorView.routeName,
      arguments: ErrorArgs(message),
    );
  }
}
