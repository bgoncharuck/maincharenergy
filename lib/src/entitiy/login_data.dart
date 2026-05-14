import 'dart:convert';

class LoginData {
  final String login;
  final String password;
  final String loginUrl;

  final String userAgent;

  const LoginData({
    required this.login,
    required this.password,
    required this.loginUrl,
    required this.userAgent,
  });

  factory LoginData.fromJson(Map<String, dynamic> json) => LoginData(
    login: json['login'] as String,
    password: json['password'] as String,
    loginUrl: json['login_url'] as String,
    userAgent: json['user_agent'] as String? ?? 'Mozilla/5.0 (X11; Linux x86_64; rv:150.0) Gecko/20100101 Firefox/150.0',
  );

  Map<String, dynamic> toJson() => {
    'login': login,
    'password': password,
    'login_url': loginUrl,
    'user_agent': userAgent,
  };

  String toJsonString() => jsonEncode(toJson());

  void cliPrint() {
    print('Login: $login');
    print('Password: ${'*' * password.length}');
    print('Login URL: $loginUrl');
    print('User-Agent: $userAgent');
  }
}
