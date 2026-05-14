import 'dart:io';
import 'package:maincharenergy/maincharenergy.dart';

void main(List<String> a) {
  try {
    final args = validateArgs(a);

    if (args.command == 'help') {
      print(ArgsData.helpText());
      exit(0);
    }

    args.cliPrint();
    exit(0);
  } on CliException catch (e) {
    print('Error: ${e.message}');
    print('');
    print(ArgsData.helpText());
    exit(1);
  }
}
