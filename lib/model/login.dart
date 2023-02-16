part of 'lib.dart';

@HiveType(typeId: HIVE_ID.LOGIN)
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

  @override
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

class MLoginAdapter extends TypeAdapter<MLogin> {
  @override
  final typeId = HIVE_ID.LOGIN;

  @override
  MLogin read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MLogin(
      token: fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, MLogin obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.token);
  }
}
