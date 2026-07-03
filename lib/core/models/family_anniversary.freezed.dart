// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'family_anniversary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FamilyAnniversary {

 String get id; String get name;/// AnniversaryType.jesa | .birthday | .other
 String get type; int get lunarMonth; int get lunarDay; bool get isLeap;
/// Create a copy of FamilyAnniversary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FamilyAnniversaryCopyWith<FamilyAnniversary> get copyWith => _$FamilyAnniversaryCopyWithImpl<FamilyAnniversary>(this as FamilyAnniversary, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FamilyAnniversary&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.lunarMonth, lunarMonth) || other.lunarMonth == lunarMonth)&&(identical(other.lunarDay, lunarDay) || other.lunarDay == lunarDay)&&(identical(other.isLeap, isLeap) || other.isLeap == isLeap));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,type,lunarMonth,lunarDay,isLeap);

@override
String toString() {
  return 'FamilyAnniversary(id: $id, name: $name, type: $type, lunarMonth: $lunarMonth, lunarDay: $lunarDay, isLeap: $isLeap)';
}


}

/// @nodoc
abstract mixin class $FamilyAnniversaryCopyWith<$Res>  {
  factory $FamilyAnniversaryCopyWith(FamilyAnniversary value, $Res Function(FamilyAnniversary) _then) = _$FamilyAnniversaryCopyWithImpl;
@useResult
$Res call({
 String id, String name, String type, int lunarMonth, int lunarDay, bool isLeap
});




}
/// @nodoc
class _$FamilyAnniversaryCopyWithImpl<$Res>
    implements $FamilyAnniversaryCopyWith<$Res> {
  _$FamilyAnniversaryCopyWithImpl(this._self, this._then);

  final FamilyAnniversary _self;
  final $Res Function(FamilyAnniversary) _then;

/// Create a copy of FamilyAnniversary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? type = null,Object? lunarMonth = null,Object? lunarDay = null,Object? isLeap = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,lunarMonth: null == lunarMonth ? _self.lunarMonth : lunarMonth // ignore: cast_nullable_to_non_nullable
as int,lunarDay: null == lunarDay ? _self.lunarDay : lunarDay // ignore: cast_nullable_to_non_nullable
as int,isLeap: null == isLeap ? _self.isLeap : isLeap // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [FamilyAnniversary].
extension FamilyAnniversaryPatterns on FamilyAnniversary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FamilyAnniversary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FamilyAnniversary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FamilyAnniversary value)  $default,){
final _that = this;
switch (_that) {
case _FamilyAnniversary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FamilyAnniversary value)?  $default,){
final _that = this;
switch (_that) {
case _FamilyAnniversary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String type,  int lunarMonth,  int lunarDay,  bool isLeap)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FamilyAnniversary() when $default != null:
return $default(_that.id,_that.name,_that.type,_that.lunarMonth,_that.lunarDay,_that.isLeap);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String type,  int lunarMonth,  int lunarDay,  bool isLeap)  $default,) {final _that = this;
switch (_that) {
case _FamilyAnniversary():
return $default(_that.id,_that.name,_that.type,_that.lunarMonth,_that.lunarDay,_that.isLeap);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String type,  int lunarMonth,  int lunarDay,  bool isLeap)?  $default,) {final _that = this;
switch (_that) {
case _FamilyAnniversary() when $default != null:
return $default(_that.id,_that.name,_that.type,_that.lunarMonth,_that.lunarDay,_that.isLeap);case _:
  return null;

}
}

}

/// @nodoc


class _FamilyAnniversary extends FamilyAnniversary {
  const _FamilyAnniversary({required this.id, required this.name, required this.type, required this.lunarMonth, required this.lunarDay, this.isLeap = false}): super._();
  

@override final  String id;
@override final  String name;
/// AnniversaryType.jesa | .birthday | .other
@override final  String type;
@override final  int lunarMonth;
@override final  int lunarDay;
@override@JsonKey() final  bool isLeap;

/// Create a copy of FamilyAnniversary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FamilyAnniversaryCopyWith<_FamilyAnniversary> get copyWith => __$FamilyAnniversaryCopyWithImpl<_FamilyAnniversary>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FamilyAnniversary&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.lunarMonth, lunarMonth) || other.lunarMonth == lunarMonth)&&(identical(other.lunarDay, lunarDay) || other.lunarDay == lunarDay)&&(identical(other.isLeap, isLeap) || other.isLeap == isLeap));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,type,lunarMonth,lunarDay,isLeap);

@override
String toString() {
  return 'FamilyAnniversary(id: $id, name: $name, type: $type, lunarMonth: $lunarMonth, lunarDay: $lunarDay, isLeap: $isLeap)';
}


}

/// @nodoc
abstract mixin class _$FamilyAnniversaryCopyWith<$Res> implements $FamilyAnniversaryCopyWith<$Res> {
  factory _$FamilyAnniversaryCopyWith(_FamilyAnniversary value, $Res Function(_FamilyAnniversary) _then) = __$FamilyAnniversaryCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String type, int lunarMonth, int lunarDay, bool isLeap
});




}
/// @nodoc
class __$FamilyAnniversaryCopyWithImpl<$Res>
    implements _$FamilyAnniversaryCopyWith<$Res> {
  __$FamilyAnniversaryCopyWithImpl(this._self, this._then);

  final _FamilyAnniversary _self;
  final $Res Function(_FamilyAnniversary) _then;

/// Create a copy of FamilyAnniversary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? type = null,Object? lunarMonth = null,Object? lunarDay = null,Object? isLeap = null,}) {
  return _then(_FamilyAnniversary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,lunarMonth: null == lunarMonth ? _self.lunarMonth : lunarMonth // ignore: cast_nullable_to_non_nullable
as int,lunarDay: null == lunarDay ? _self.lunarDay : lunarDay // ignore: cast_nullable_to_non_nullable
as int,isLeap: null == isLeap ? _self.isLeap : isLeap // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
