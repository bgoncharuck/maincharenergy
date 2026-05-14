import '../entitiy/login_data.dart';
import '../service/get_it.dart';

Future<LoginData> getLoginData() async {
  final a = argsData;
  return LoginData(
    login: a.login ?? '',
    password: a.password ?? '',
    loginUrl: 'https://godvillegame.com/login',
    userAgent: 'Mozilla/5.0 (X11; Linux x86_64; rv:150.0) Gecko/20100101 Firefox/150.0',
  );
}
