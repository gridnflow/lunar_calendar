// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$UserProfile {

 String get uid; String get email; String get displayName;/// Birth info for fortune calculation
 int get birthYear; int get birthMonth; int get birthDay;/// optional (시)
 int? get birthHour;/// is birth date in lunar calendar
 bool get isLunarBirth;
/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserProfileCopyWith<UserProfile> get copyWith => _$UserProfileCopyWithImpl<UserProfile>(this as UserProfile, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserProfile&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.email, email) || other.email == email)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.birthYear, birthYear) || other.birthYear == birthYear)&&(identical(other.birthMonth, birthMonth) || other.birthMonth == birthMonth)&&(identical(other.birthDay, birthDay) || other.birthDay == birthDay)&&(identical(other.birthHour, birthHour) || other.birthHour == birthHour)&&(identical(other.isLunarBirth, isLunarBirth) || other.isLunarBirth == isLunarBirth));
}


@override
int get hashCode => Object.hash(runtimeType,uid,email,displayName,birthYear,birthMonth,birthDay,birthHour,isLunarBirth);

@override
String toString() {
  return 'UserProfile(uid: $uid, email: $email, displayName: $displayName, birthYear: $birthYear, birthMonth: $birthMonth, birthDay: $birthDay, birthHour: $birthHour, isLunarBirth: $isLunarBirth)';
}


}

/// @nodoc
abstract mixin class $UserProfileCopyWith<$Res>  {
  factory $UserProfileCopyWith(UserProfile value, $Res Function(UserProfile) _then) = _$UserProfileCopyWithImpl;
@useResult
$Res call({
 String uid, String email, String displayName, int birthYear, int birthMonth, int birthDay, int? birthHour, bool isLunarBirth
});




}
/// @nodoc
class _$UserProfileCopyWithImpl<$Res>
    implements $UserProfileCopyWith<$Res> {
  _$UserProfileCopyWithImpl(this._self, this._then);

  final UserProfile _self;
  final $Res Function(UserProfile) _then;

/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? uid = null,Object? email = null,Object? displayName = null,Object? birthYear = null,Object? birthMonth = null,Object? birthDay = null,Object? birthHour = freezed,Object? isLunarBirth = null,}) {
  return _then(_self.copyWith(
uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,birthYear: null == birthYear ? _self.birthYear : birthYear // ignore: cast_nullable_to_non_nullable
as int,birthMonth: null == birthMonth ? _self.birthMonth : birthMonth // ignore: cast_nullable_to_non_nullable
as int,birthDay: null == birthDay ? _self.birthDay : birthDay // ignore: cast_nullable_to_non_nullable
as int,birthHour: freezed == birthHour ? _self.birthHour : birthHour // ignore: cast_nullable_to_non_nullable
as int?,isLunarBirth: null == isLunarBirth ? _self.isLunarBirth : isLunarBirth // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [UserProfile].
extension UserProfilePatterns on UserProfile {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserProfile value)  $default,){
final _that = this;
switch (_that) {
case _UserProfile():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserProfile value)?  $default,){
final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String uid,  String email,  String displayName,  int birthYear,  int birthMonth,  int birthDay,  int? birthHour,  bool isLunarBirth)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
return $default(_that.uid,_that.email,_that.displayName,_that.birthYear,_that.birthMonth,_that.birthDay,_that.birthHour,_that.isLunarBirth);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String uid,  String email,  String displayName,  int birthYear,  int birthMonth,  int birthDay,  int? birthHour,  bool isLunarBirth)  $default,) {final _that = this;
switch (_that) {
case _UserProfile():
return $default(_that.uid,_that.email,_that.displayName,_that.birthYear,_that.birthMonth,_that.birthDay,_that.birthHour,_that.isLunarBirth);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String uid,  String email,  String displayName,  int birthYear,  int birthMonth,  int birthDay,  int? birthHour,  bool isLunarBirth)?  $default,) {final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
return $default(_that.uid,_that.email,_that.displayName,_that.birthYear,_that.birthMonth,_that.birthDay,_that.birthHour,_that.isLunarBirth);case _:
  return null;

}
}

}

/// @nodoc


class _UserProfile extends UserProfile {
  const _UserProfile({required this.uid, required this.email, required this.displayName, required this.birthYear, required this.birthMonth, required this.birthDay, this.birthHour, this.isLunarBirth = false}): super._();
  

@override final  String uid;
@override final  String email;
@override final  String displayName;
/// Birth info for fortune calculation
@override final  int birthYear;
@override final  int birthMonth;
@override final  int birthDay;
/// optional (시)
@override final  int? birthHour;
/// is birth date in lunar calendar
@override@JsonKey() final  bool isLunarBirth;

/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserProfileCopyWith<_UserProfile> get copyWith => __$UserProfileCopyWithImpl<_UserProfile>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserProfile&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.email, email) || other.email == email)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.birthYear, birthYear) || other.birthYear == birthYear)&&(identical(other.birthMonth, birthMonth) || other.birthMonth == birthMonth)&&(identical(other.birthDay, birthDay) || other.birthDay == birthDay)&&(identical(other.birthHour, birthHour) || other.birthHour == birthHour)&&(identical(other.isLunarBirth, isLunarBirth) || other.isLunarBirth == isLunarBirth));
}


@override
int get hashCode => Object.hash(runtimeType,uid,email,displayName,birthYear,birthMonth,birthDay,birthHour,isLunarBirth);

@override
String toString() {
  return 'UserProfile(uid: $uid, email: $email, displayName: $displayName, birthYear: $birthYear, birthMonth: $birthMonth, birthDay: $birthDay, birthHour: $birthHour, isLunarBirth: $isLunarBirth)';
}


}

/// @nodoc
abstract mixin class _$UserProfileCopyWith<$Res> implements $UserProfileCopyWith<$Res> {
  factory _$UserProfileCopyWith(_UserProfile value, $Res Function(_UserProfile) _then) = __$UserProfileCopyWithImpl;
@override @useResult
$Res call({
 String uid, String email, String displayName, int birthYear, int birthMonth, int birthDay, int? birthHour, bool isLunarBirth
});




}
/// @nodoc
class __$UserProfileCopyWithImpl<$Res>
    implements _$UserProfileCopyWith<$Res> {
  __$UserProfileCopyWithImpl(this._self, this._then);

  final _UserProfile _self;
  final $Res Function(_UserProfile) _then;

/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? uid = null,Object? email = null,Object? displayName = null,Object? birthYear = null,Object? birthMonth = null,Object? birthDay = null,Object? birthHour = freezed,Object? isLunarBirth = null,}) {
  return _then(_UserProfile(
uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,birthYear: null == birthYear ? _self.birthYear : birthYear // ignore: cast_nullable_to_non_nullable
as int,birthMonth: null == birthMonth ? _self.birthMonth : birthMonth // ignore: cast_nullable_to_non_nullable
as int,birthDay: null == birthDay ? _self.birthDay : birthDay // ignore: cast_nullable_to_non_nullable
as int,birthHour: freezed == birthHour ? _self.birthHour : birthHour // ignore: cast_nullable_to_non_nullable
as int?,isLunarBirth: null == isLunarBirth ? _self.isLunarBirth : isLunarBirth // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
