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

class FamilyAnniversary {
  final String id;
  final String name;
  final String type; // AnniversaryType.jesa | .birthday | .other
  final int lunarMonth;
  final int lunarDay;
  final bool isLeap;

  const FamilyAnniversary({
    required this.id,
    required this.name,
    required this.type,
    required this.lunarMonth,
    required this.lunarDay,
    this.isLeap = false,
  });

  Map<String, dynamic> toFirestore() => {
        'name': name,
        'type': type,
        'lunarMonth': lunarMonth,
        'lunarDay': lunarDay,
        'isLeap': isLeap,
      };

  factory FamilyAnniversary.fromFirestore(String id, Map<String, dynamic> data) =>
      FamilyAnniversary(
        id: id,
        name: data['name'] as String,
        type: AnniversaryType.normalize(data['type'] as String? ?? 'other'),
        lunarMonth: data['lunarMonth'] as int,
        lunarDay: data['lunarDay'] as int,
        isLeap: data['isLeap'] as bool? ?? false,
      );
}
