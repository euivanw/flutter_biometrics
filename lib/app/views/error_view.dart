import 'package:flutter/material.dart';

class ErrorArgs {
  final String message;

  ErrorArgs(this.message);
}

class ErrorView extends StatelessWidget {
  static const routeName = '/error';

  @override
  Widget build(BuildContext context) {
    final ErrorArgs args = ModalRoute.of(context).settings.arguments;

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
              _text(args.message),
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
      Icons.thumb_down_alt_rounded,
      color: Colors.red,
      size: 48.0,
    );
  }

  Widget _text(String message) {
    return Text(
      message,
      textAlign: TextAlign.center,
    );
  }

  Widget _button(context) {
    return ElevatedButton(
      child: Text('Voltar'),
      onPressed: () => Navigator.of(context).pop(),
    );
  }

  Widget _space() {
    return SizedBox(
      height: 40.0,
    );
  }
}
