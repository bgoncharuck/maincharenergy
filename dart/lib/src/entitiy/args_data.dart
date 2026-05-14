import 'dart:convert';

/// Exception thrown for invalid CLI input.
class CliException implements Exception {
  final String message;
  const CliException(this.message);

  @override
  String toString() => message;
}

class ArgsData {
  final String command;
  final String? login;
  final String? password;
  final int? criticalValue;
  final int? cooldown;
  final bool logs;

  const ArgsData({
    required this.command,
    this.login,
    this.password,
    this.criticalValue,
    this.cooldown,
    this.logs = false,
  });

  factory ArgsData.fromJson(Map<String, dynamic> json) => ArgsData(
    command: json['command'] as String,
    login: json['login'] as String?,
    password: json['password'] as String?,
    criticalValue: json['critical_value'] as int?,
    cooldown: json['cooldown'] as int?,
    logs: json['logs'] as bool? ?? false,
  );

  Map<String, dynamic> toJson() => {
    'command': command,
    if (login != null) 'login': login,
    if (password != null) 'password': password,
    if (criticalValue != null) 'critical_value': criticalValue,
    if (cooldown != null) 'cooldown': cooldown,
    'logs': logs,
  };

  String toJsonString() => jsonEncode(toJson());

  void cliPrint() {
    print('Command: $command');
    if (login != null) print('Login: $login');
    if (criticalValue != null) print('Critical HP: $criticalValue');
    if (cooldown != null) print('Cooldown: ${cooldown}s');
    if (logs) print('Logging: enabled');
  }

  /// Returns full help text for the CLI.
  static String helpText() {
    return '''
maincharenergy - Godville superhero daemon

Usage:
  maincharenergy <command> [arguments]

Commands:
  start LOGIN PASSWORD CRITICALVALUE COOLDOWN [--logs]
                            Start daemon in background
  status                    Show daemon status
  stop                      Stop daemon gracefully
  logs                      Show daemon logs
  help                      Show this help message

Options:
  --help, -h  Show this help message
  --logs      Enable logging (only valid with start)

Arguments:
  LOGIN           Godville login
  PASSWORD        Godville password
  CRITICALVALUE   HP threshold (non-negative integer)
  COOLDOWN        Check interval in seconds (minimum: 20)

Examples:
  maincharenergy start mylogin mypassword 111 40 --logs
  maincharenergy status
  maincharenergy stop
  maincharenergy --help''';
  }
}
