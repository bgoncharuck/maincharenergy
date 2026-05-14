import 'dart:math' show Random;

/// Random utility for anti-ban, delays, randomization.
class Randi {
  final Random _random = Random();

  int nextInt(int max) => _random.nextInt(max);
  double nextDouble() => _random.nextDouble();
}
