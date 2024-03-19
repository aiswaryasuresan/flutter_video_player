import 'dart:math';

class Utils {
  static String generateRandomText(int length) {
    const String _chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random _random = Random();
    return String.fromCharCodes(Iterable.generate(length, (_) => _chars.codeUnitAt(_random.nextInt(_chars.length))));
  }

  static bool isValidEmail(String email) {
    final RegExp emailRegex = RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
      caseSensitive: false,
      multiLine: false,
    );
    return emailRegex.hasMatch(email);
  }
}
