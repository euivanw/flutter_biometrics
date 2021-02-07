import 'dart:io';

import 'package:local_auth/local_auth.dart';

class Biometrics {
  /// Retorna se a biometria está ativa.
  static Future<bool> isActive() async {
    return LocalAuthentication().canCheckBiometrics;
  }

  /// Retorna um nome visual para o tipo de biometria que está ativa.
  static Future<String> getStringType() async {
    List<BiometricType> availableBiometrics =
        await LocalAuthentication().getAvailableBiometrics();

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

    return '';
  }

  /// Efetua a autenticação usando biometria.
  ///
  /// No caso dos dispositivos iOS com Face ID, será solicitado permissão ao
  /// usuário na primeira vez que autenticação for chamada. Caso o usuário não
  /// permita, será gerada uma exceção.
  static Future<bool> authenticate() {
    String message =
        'Aqui vai a sua mensagem explicando porque precisa de autenticação por biometria.';

    return LocalAuthentication().authenticateWithBiometrics(
      localizedReason: message,
      useErrorDialogs: true,
      stickyAuth: true,
    );
  }
}
