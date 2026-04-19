// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'expense_head.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ExpenseHead {

 int get id; String get name; String get description; HeadType get headType; DateTime get createdAt;
/// Create a copy of ExpenseHead
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExpenseHeadCopyWith<ExpenseHead> get copyWith => _$ExpenseHeadCopyWithImpl<ExpenseHead>(this as ExpenseHead, _$identity);

  /// Serializes this ExpenseHead to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExpenseHead&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.headType, headType) || other.headType == headType)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,headType,createdAt);

@override
String toString() {
  return 'ExpenseHead(id: $id, name: $name, description: $description, headType: $headType, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $ExpenseHeadCopyWith<$Res>  {
  factory $ExpenseHeadCopyWith(ExpenseHead value, $Res Function(ExpenseHead) _then) = _$ExpenseHeadCopyWithImpl;
@useResult
$Res call({
 int id, String name, String description, HeadType headType, DateTime createdAt
});




}
/// @nodoc
class _$ExpenseHeadCopyWithImpl<$Res>
    implements $ExpenseHeadCopyWith<$Res> {
  _$ExpenseHeadCopyWithImpl(this._self, this._then);

  final ExpenseHead _self;
  final $Res Function(ExpenseHead) _then;

/// Create a copy of ExpenseHead
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? description = null,Object? headType = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,headType: null == headType ? _self.headType : headType // ignore: cast_nullable_to_non_nullable
as HeadType,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [ExpenseHead].
extension ExpenseHeadPatterns on ExpenseHead {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExpenseHead value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExpenseHead() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExpenseHead value)  $default,){
final _that = this;
switch (_that) {
case _ExpenseHead():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExpenseHead value)?  $default,){
final _that = this;
switch (_that) {
case _ExpenseHead() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String description,  HeadType headType,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExpenseHead() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.headType,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String description,  HeadType headType,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _ExpenseHead():
return $default(_that.id,_that.name,_that.description,_that.headType,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String description,  HeadType headType,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _ExpenseHead() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.headType,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ExpenseHead implements ExpenseHead {
  const _ExpenseHead({required this.id, required this.name, required this.description, required this.headType, required this.createdAt});
  factory _ExpenseHead.fromJson(Map<String, dynamic> json) => _$ExpenseHeadFromJson(json);

@override final  int id;
@override final  String name;
@override final  String description;
@override final  HeadType headType;
@override final  DateTime createdAt;

/// Create a copy of ExpenseHead
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExpenseHeadCopyWith<_ExpenseHead> get copyWith => __$ExpenseHeadCopyWithImpl<_ExpenseHead>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExpenseHeadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExpenseHead&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.headType, headType) || other.headType == headType)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,headType,createdAt);

@override
String toString() {
  return 'ExpenseHead(id: $id, name: $name, description: $description, headType: $headType, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$ExpenseHeadCopyWith<$Res> implements $ExpenseHeadCopyWith<$Res> {
  factory _$ExpenseHeadCopyWith(_ExpenseHead value, $Res Function(_ExpenseHead) _then) = __$ExpenseHeadCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String description, HeadType headType, DateTime createdAt
});




}
/// @nodoc
class __$ExpenseHeadCopyWithImpl<$Res>
    implements _$ExpenseHeadCopyWith<$Res> {
  __$ExpenseHeadCopyWithImpl(this._self, this._then);

  final _ExpenseHead _self;
  final $Res Function(_ExpenseHead) _then;

/// Create a copy of ExpenseHead
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? description = null,Object? headType = null,Object? createdAt = null,}) {
  return _then(_ExpenseHead(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,headType: null == headType ? _self.headType : headType // ignore: cast_nullable_to_non_nullable
as HeadType,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
