import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile.freezed.dart';

@freezed
abstract class UserProfile with _$UserProfile {
  const UserProfile._();

  const factory UserProfile({
    required String uid,
    required String email,
    required String displayName,

    /// Birth info for fortune calculation
    required int birthYear,
    required int birthMonth,
    required int birthDay,

    /// optional (시)
    int? birthHour,

    /// is birth date in lunar calendar
    @Default(false) bool isLunarBirth,
  }) = _UserProfile;

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
}
