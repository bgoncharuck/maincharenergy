import '../entitiy/args_data.dart';

/// Checks whether [raw] is a help request (--help, -h, help).
bool _isHelp(String raw) =>
    raw == '--help' || raw == '-h' || raw == 'help';

/// Validates CLI arguments and returns [ArgsData] or throws [CliException].
ArgsData validateArgs(List<String> args) {
  if (args.isEmpty || _isHelp(args[0])) {
    return const ArgsData(command: 'help');
  }

  final command = args[0];

  switch (command) {
    case 'start':
      return _validateStart(args);
    case 'status':
    case 'stop':
    case 'logs':
      return ArgsData(command: command);
    default:
      throw CliException(
        "Unknown command: $command. Use '--help' for usage.",
      );
  }
}

ArgsData _validateStart(List<String> args) {
  if (args.length < 5) {
    throw const CliException(
      'Usage: maincharenergy start LOGIN PASSWORD CRITICALVALUE COOLDOWN [--logs]',
    );
  }

  final login = args[1];
  final password = args[2];
  final criticalValue = int.tryParse(args[3]);
  final cooldown = int.tryParse(args[4]);
  final logs = args.contains('--logs');

  if (criticalValue == null || criticalValue < 0) {
    throw const CliException('CRITICALVALUE must be a non-negative integer');
  }

  if (cooldown == null || cooldown < 20) {
    throw const CliException('COOLDOWN minimum is 20 seconds');
  }

  return ArgsData(
    command: 'start',
    login: login,
    password: password,
    criticalValue: criticalValue,
    cooldown: cooldown,
    logs: logs,
  );
}
