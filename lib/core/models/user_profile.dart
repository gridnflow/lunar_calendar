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
