part of 'lib.dart';

class MMainCategory {
  // final String general;
  final String ko;
  final String math;
  final String social;
  final String science;
  final String en;
  final String music;
  final String art;
  final String ethics;
  final String physicalEdu;
  final String practical;
  MMainCategory._internal({
    // required this.general,
    required this.ko,
    required this.math,
    required this.social,
    required this.science,
    required this.en,
    required this.music,
    required this.art,
    required this.ethics,
    required this.physicalEdu,
    required this.practical,
  });

  @override
  Map<String, dynamic> get map => {
        // 'general': general,
        'ko': ko,
        'math': math,
        'social': social,
        'science': science,
        'en': en,
        'music': music,
        'art': art,
        'ethics': ethics,
        'physicalEdu': physicalEdu,
        'practical': practical,
      };

  factory MMainCategory.fromMap(Map item) {
    // String general = item['general'] ?? '';
    String ko = item['ko'] ?? '';
    String math = item['math'] ?? '';
    String social = item['social'] ?? '';
    String science = item['science'] ?? '';
    String en = item['en'] ?? '';
    String music = item['music'] ?? '';
    String art = item['art'] ?? '';
    String ethics = item['ethics'] ?? '';
    String physicalEdu = item['physicalEdu'] ?? '';
    String practical = item['practical'] ?? '';
    return MMainCategory._internal(
      // general: general,
      ko: ko,
      math: math,
      social: social,
      science: science,
      en: en,
      music: music,
      art: art,
      ethics: ethics,
      physicalEdu: physicalEdu,
      practical: practical,
    );
  }
}
