import 'dart:convert';

class LoginData {
  final String login;
  final String password;
  final String loginUrl;

  const LoginData({
    required this.login,
    required this.password,
    required this.loginUrl,
  });

  factory LoginData.fromJson(Map<String, dynamic> json) => LoginData(
    login: json['login'] as String,
    password: json['password'] as String,
    loginUrl: json['login_url'] as String,
  );

  Map<String, dynamic> toJson() => {
    'login': login,
    'password': password,
    'login_url': loginUrl,
  };

  String toJsonString() => jsonEncode(toJson());

  void cliPrint() {
    print('Login: $login');
    print('Password: ${'*' * password.length}');
    print('Login URL: $loginUrl');
  }
}
