import 'dart:convert';

class HeroData {
  final int health;
  final int maxHealth;
  final int godpowerPercent;
  final int accumulatorCharges;

  const HeroData({
    required this.health,
    required this.maxHealth,
    required this.godpowerPercent,
    required this.accumulatorCharges,
  });

  factory HeroData.fromJson(Map<String, dynamic> json) => HeroData(
    health: json['health'] as int,
    maxHealth: json['max_health'] as int,
    godpowerPercent: json['godpower_percent'] as int,
    accumulatorCharges: json['accumulator_charges'] as int,
  );

  Map<String, dynamic> toJson() => {
    'health': health,
    'max_health': maxHealth,
    'godpower_percent': godpowerPercent,
    'accumulator_charges': accumulatorCharges,
  };

  String toJsonString() => jsonEncode(toJson());

  void cliPrint() {
    print('HP: $health/$maxHealth');
    print('Godpower: $godpowerPercent%');
    print('Accumulator charges: $accumulatorCharges');
  }
}
