import 'package:get_it/get_it.dart';
import '../entitiy/args_data.dart';
import '../entitiy/login_data.dart';

void registerArgsData(ArgsData argsData) {
  GetIt.instance.registerSingleton(argsData);
}

ArgsData get argsData => GetIt.instance.get<ArgsData>();

void registerLoginData(LoginData loginData) {
  GetIt.instance.registerSingleton(loginData);
}

LoginData get loginData => GetIt.instance.get<LoginData>();
