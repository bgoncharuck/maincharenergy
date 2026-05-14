import '../entitiy/login_data.dart';
import '../service/get_it.dart';

Future<LoginData> getLoginData() async {
  final a = argsData;
  return LoginData(
    login: a.login ?? '',
    password: a.password ?? '',
    loginUrl: 'https://godvillegame.com/login',
  );
}
