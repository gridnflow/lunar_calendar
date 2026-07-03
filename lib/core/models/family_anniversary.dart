import 'package:freezed_annotation/freezed_annotation.dart';

part 'family_anniversary.freezed.dart';

class AnniversaryType {
  static const jesa = 'jesa';
  static const birthday = 'birthday';
  static const other = 'other';

  /// Normalize legacy localized strings to internal keys.
  static String normalize(String raw) {
    switch (raw) {
      // Korean
      case '제사': case '기제사': return jesa;
      case '생일': return birthday;
      // Japanese
      case '法事': case '祭祀': return jesa;
      case '誕生日': return birthday;
      // Chinese
      case '祭礼': return jesa;
      case '生日': return birthday;
      // English
      case 'Memorial': case 'Jesa': return jesa;
      case 'Birthday': return birthday;
      // ARB keys (just in case)
      case 'jesa': return jesa;
      case 'birthday': return birthday;
      case 'other': return other;
      default: return other;
    }
  }
}

@freezed
abstract class FamilyAnniversary with _$FamilyAnniversary {
  const FamilyAnniversary._();

  const factory FamilyAnniversary({
    required String id,
    required String name,

    /// AnniversaryType.jesa | .birthday | .other
    required String type,
    required int lunarMonth,
    required int lunarDay,
    @Default(false) bool isLeap,
  }) = _FamilyAnniversary;

  factory FamilyAnniversary.fromFirestore(
          String id, Map<String, dynamic> data) =>
      FamilyAnniversary(
        id: id,
        name: data['name'] as String,
        type: AnniversaryType.normalize(data['type'] as String? ?? 'other'),
        lunarMonth: data['lunarMonth'] as int,
        lunarDay: data['lunarDay'] as int,
        isLeap: data['isLeap'] as bool? ?? false,
      );

  Map<String, dynamic> toFirestore() => {
        'name': name,
        'type': type,
        'lunarMonth': lunarMonth,
        'lunarDay': lunarDay,
        'isLeap': isLeap,
      };
}
