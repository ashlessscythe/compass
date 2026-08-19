// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'external_identifier.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ExternalIdentifier {

 String get id; String get entityId; String get entityKind; String get source; String get externalId; DateTime get createdAt;
/// Create a copy of ExternalIdentifier
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExternalIdentifierCopyWith<ExternalIdentifier> get copyWith => _$ExternalIdentifierCopyWithImpl<ExternalIdentifier>(this as ExternalIdentifier, _$identity);

  /// Serializes this ExternalIdentifier to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExternalIdentifier&&(identical(other.id, id) || other.id == id)&&(identical(other.entityId, entityId) || other.entityId == entityId)&&(identical(other.entityKind, entityKind) || other.entityKind == entityKind)&&(identical(other.source, source) || other.source == source)&&(identical(other.externalId, externalId) || other.externalId == externalId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,entityId,entityKind,source,externalId,createdAt);

@override
String toString() {
  return 'ExternalIdentifier(id: $id, entityId: $entityId, entityKind: $entityKind, source: $source, externalId: $externalId, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $ExternalIdentifierCopyWith<$Res>  {
  factory $ExternalIdentifierCopyWith(ExternalIdentifier value, $Res Function(ExternalIdentifier) _then) = _$ExternalIdentifierCopyWithImpl;
@useResult
$Res call({
 String id, String entityId, String entityKind, String source, String externalId, DateTime createdAt
});




}
/// @nodoc
class _$ExternalIdentifierCopyWithImpl<$Res>
    implements $ExternalIdentifierCopyWith<$Res> {
  _$ExternalIdentifierCopyWithImpl(this._self, this._then);

  final ExternalIdentifier _self;
  final $Res Function(ExternalIdentifier) _then;

/// Create a copy of ExternalIdentifier
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? entityId = null,Object? entityKind = null,Object? source = null,Object? externalId = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,entityId: null == entityId ? _self.entityId : entityId // ignore: cast_nullable_to_non_nullable
as String,entityKind: null == entityKind ? _self.entityKind : entityKind // ignore: cast_nullable_to_non_nullable
as String,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,externalId: null == externalId ? _self.externalId : externalId // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [ExternalIdentifier].
extension ExternalIdentifierPatterns on ExternalIdentifier {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExternalIdentifier value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExternalIdentifier() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExternalIdentifier value)  $default,){
final _that = this;
switch (_that) {
case _ExternalIdentifier():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExternalIdentifier value)?  $default,){
final _that = this;
switch (_that) {
case _ExternalIdentifier() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String entityId,  String entityKind,  String source,  String externalId,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExternalIdentifier() when $default != null:
return $default(_that.id,_that.entityId,_that.entityKind,_that.source,_that.externalId,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String entityId,  String entityKind,  String source,  String externalId,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _ExternalIdentifier():
return $default(_that.id,_that.entityId,_that.entityKind,_that.source,_that.externalId,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String entityId,  String entityKind,  String source,  String externalId,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _ExternalIdentifier() when $default != null:
return $default(_that.id,_that.entityId,_that.entityKind,_that.source,_that.externalId,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ExternalIdentifier implements ExternalIdentifier {
  const _ExternalIdentifier({required this.id, required this.entityId, required this.entityKind, required this.source, required this.externalId, required this.createdAt});
  factory _ExternalIdentifier.fromJson(Map<String, dynamic> json) => _$ExternalIdentifierFromJson(json);

@override final  String id;
@override final  String entityId;
@override final  String entityKind;
@override final  String source;
@override final  String externalId;
@override final  DateTime createdAt;

/// Create a copy of ExternalIdentifier
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExternalIdentifierCopyWith<_ExternalIdentifier> get copyWith => __$ExternalIdentifierCopyWithImpl<_ExternalIdentifier>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExternalIdentifierToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExternalIdentifier&&(identical(other.id, id) || other.id == id)&&(identical(other.entityId, entityId) || other.entityId == entityId)&&(identical(other.entityKind, entityKind) || other.entityKind == entityKind)&&(identical(other.source, source) || other.source == source)&&(identical(other.externalId, externalId) || other.externalId == externalId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,entityId,entityKind,source,externalId,createdAt);

@override
String toString() {
  return 'ExternalIdentifier(id: $id, entityId: $entityId, entityKind: $entityKind, source: $source, externalId: $externalId, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$ExternalIdentifierCopyWith<$Res> implements $ExternalIdentifierCopyWith<$Res> {
  factory _$ExternalIdentifierCopyWith(_ExternalIdentifier value, $Res Function(_ExternalIdentifier) _then) = __$ExternalIdentifierCopyWithImpl;
@override @useResult
$Res call({
 String id, String entityId, String entityKind, String source, String externalId, DateTime createdAt
});




}
/// @nodoc
class __$ExternalIdentifierCopyWithImpl<$Res>
    implements _$ExternalIdentifierCopyWith<$Res> {
  __$ExternalIdentifierCopyWithImpl(this._self, this._then);

  final _ExternalIdentifier _self;
  final $Res Function(_ExternalIdentifier) _then;

/// Create a copy of ExternalIdentifier
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? entityId = null,Object? entityKind = null,Object? source = null,Object? externalId = null,Object? createdAt = null,}) {
  return _then(_ExternalIdentifier(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,entityId: null == entityId ? _self.entityId : entityId // ignore: cast_nullable_to_non_nullable
as String,entityKind: null == entityKind ? _self.entityKind : entityKind // ignore: cast_nullable_to_non_nullable
as String,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,externalId: null == externalId ? _self.externalId : externalId // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
