part of '/common.dart';

class MLogin {
  late String token;

  MLogin({
    required this.token,
  });

  factory MLogin.fromJson(Map<String, dynamic> json) {
    String token = json['token'] ?? '';
    return MLogin(token: token);
  }

  @override
  Map<String, dynamic> get map => {
        'token ': token,
      };

  MLogin copyWith({
    String? token,
  }) =>
      MLogin(
        token: token ?? this.token,
      );
}
