import 'dart:convert';

class LoginData {
  final String login;
  final String password;

  const LoginData({
    required this.login,
    required this.password,
  });

  factory LoginData.fromJson(Map<String, dynamic> json) => LoginData(
    login: json['login'] as String,
    password: json['password'] as String,
  );

  Map<String, dynamic> toJson() => {
    'login': login,
    'password': password,
  };

  String toJsonString() => jsonEncode(toJson());

  void cliPrint() {
    print('Login: $login');
    print('Password: ${'*' * password.length}');
  }
}
