import 'dart:math';

class Utils {
  static String generateRandomText(int length) {
    const String _chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random _random = Random();
    return String.fromCharCodes(Iterable.generate(length, (_) => _chars.codeUnitAt(_random.nextInt(_chars.length))));
  }
}
