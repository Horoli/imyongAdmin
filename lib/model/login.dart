part of 'lib.dart';

class MLogin {
  late String token;
  late int expireAt;

  MLogin({
    required this.token,
  });

  factory MLogin.fromMap(Map<String, dynamic> item) {
    String token = item['token'] ?? '';
    return MLogin(token: token);
  }

  Map<String, dynamic> get map => {
        'token': token,
      };

  MLogin copyWith({
    String? token,
  }) =>
      MLogin(
        token: token ?? this.token,
      );
}
