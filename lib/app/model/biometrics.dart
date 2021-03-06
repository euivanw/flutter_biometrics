import 'dart:io';

import 'package:local_auth/local_auth.dart';

class Biometrics {
  /// Retorna se a biometria está ativa, caso a plataforma seja Android ou iOS.
  static Future<bool> isActive() async {
    try {
      if (Platform.isIOS || Platform.isAndroid) {
        return LocalAuthentication().canCheckBiometrics;
      }
    } catch (error) {}

    return Future.value(false);
  }

  /// Retorna um nome visual para o tipo de biometria que está ativa, caso a plataforma seja Android ou iOS.
  static Future<String> getStringType() async {
    try {
      if (Platform.isIOS || Platform.isAndroid) {
        final availableBiometrics = await LocalAuthentication().getAvailableBiometrics();

        if (Platform.isIOS) {
          if (availableBiometrics.contains(BiometricType.face)) {
            return 'Face ID';
          } else if (availableBiometrics.contains(BiometricType.fingerprint)) {
            return 'Touch ID';
          }
        } else if (Platform.isAndroid) {
          if (availableBiometrics.contains(BiometricType.face)) {
            return 'Reconhecimento Facial';
          } else if (availableBiometrics.contains(BiometricType.fingerprint)) {
            return 'Impressão Digital';
          } else if (availableBiometrics.contains(BiometricType.iris)) {
            return 'Iris';
          }
        }
      }
    } catch (error) {}

    return '';
  }

  /// Efetua a autenticação usando biometria caso as plataformas sejam Android ou iOS.
  ///
  /// No caso dos dispositivos iOS com Face ID, será solicitado permissão ao
  /// usuário na primeira vez que autenticação for chamada. Caso o usuário não
  /// permita, será gerada uma exceção.
  static Future<bool> authenticate() {
    if (Platform.isIOS || Platform.isAndroid) {
      final message = 'Aqui vai a sua mensagem explicando porque precisa de autenticação por biometria.';

      return LocalAuthentication().authenticate(
        biometricOnly: true,
        localizedReason: message,
        useErrorDialogs: true,
        stickyAuth: true,
      );
    }

    return Future.value(false);
  }
}
