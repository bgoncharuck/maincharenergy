abstract class Action {
  /// must be snake_case
  String get name;
}

class RestoreGodPower extends Action {
  @override
  final String name = 'restore_godpower';
}

class Encourage extends Action {
  @override
  final String name = 'encourage';
}
