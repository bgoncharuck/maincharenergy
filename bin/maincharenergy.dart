import 'dart:io';
import 'package:maincharenergy/maincharenergy.dart';

Future<void> main(List<String> a) async {
  try {
    final args = validateArgs(a);

    if (args.command == 'help') {
      print(ArgsData.helpText());
      exit(0);
    }
    registerArgsData(args);

    if (args.command == 'start') {
      registerLoginData(await getLoginData());
      loginData.cliPrint();
      await testPuppeteer();
      exit(0);
    }
    exit(1);
  } on CliException catch (e) {
    print('Error: ${e.message}. Use --help for usage.');
    print('');
    exit(1);
  }
}
