const _sentinel = Object();

class UserProfile {
  final String uid;
  final String email;
  final String displayName;

  // Birth info for fortune calculation
  final int birthYear;
  final int birthMonth;
  final int birthDay;
  final int? birthHour; // optional (시)
  final bool isLunarBirth; // is birth date in lunar calendar

  const UserProfile({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.birthYear,
    required this.birthMonth,
    required this.birthDay,
    this.birthHour,
    this.isLunarBirth = false,
  });

  Map<String, dynamic> toFirestore() => {
        'uid': uid,
        'email': email,
        'displayName': displayName,
        'birthYear': birthYear,
        'birthMonth': birthMonth,
        'birthDay': birthDay,
        'birthHour': birthHour,
        'isLunarBirth': isLunarBirth,
      };

  UserProfile copyWith({
    String? uid,
    String? email,
    String? displayName,
    int? birthYear,
    int? birthMonth,
    int? birthDay,
    Object? birthHour = _sentinel,
    bool? isLunarBirth,
  }) {
    return UserProfile(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      birthYear: birthYear ?? this.birthYear,
      birthMonth: birthMonth ?? this.birthMonth,
      birthDay: birthDay ?? this.birthDay,
      birthHour: birthHour == _sentinel ? this.birthHour : birthHour as int?,
      isLunarBirth: isLunarBirth ?? this.isLunarBirth,
    );
  }

  factory UserProfile.fromFirestore(Map<String, dynamic> data) => UserProfile(
        uid: data['uid'] as String,
        email: data['email'] as String,
        displayName: data['displayName'] as String,
        birthYear: data['birthYear'] as int,
        birthMonth: data['birthMonth'] as int,
        birthDay: data['birthDay'] as int,
        birthHour: data['birthHour'] as int?,
        isLunarBirth: data['isLunarBirth'] as bool? ?? false,
      );
}
