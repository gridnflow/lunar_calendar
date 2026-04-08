class FamilyAnniversary {
  final String id;
  final String name;
  final String type; // '제사' | '생일' | '기타'
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
        type: data['type'] as String? ?? '기타',
        lunarMonth: data['lunarMonth'] as int,
        lunarDay: data['lunarDay'] as int,
        isLeap: data['isLeap'] as bool? ?? false,
      );
}
