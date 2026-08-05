// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'relationship.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Relationship {

 String get id; String get sourceId; String get targetId; RelationshipKind get kind; DateTime get createdAt; String? get notes; Metadata get metadata;
/// Create a copy of Relationship
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RelationshipCopyWith<Relationship> get copyWith => _$RelationshipCopyWithImpl<Relationship>(this as Relationship, _$identity);

  /// Serializes this Relationship to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Relationship&&(identical(other.id, id) || other.id == id)&&(identical(other.sourceId, sourceId) || other.sourceId == sourceId)&&(identical(other.targetId, targetId) || other.targetId == targetId)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.metadata, metadata) || other.metadata == metadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,sourceId,targetId,kind,createdAt,notes,metadata);

@override
String toString() {
  return 'Relationship(id: $id, sourceId: $sourceId, targetId: $targetId, kind: $kind, createdAt: $createdAt, notes: $notes, metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class $RelationshipCopyWith<$Res>  {
  factory $RelationshipCopyWith(Relationship value, $Res Function(Relationship) _then) = _$RelationshipCopyWithImpl;
@useResult
$Res call({
 String id, String sourceId, String targetId, RelationshipKind kind, DateTime createdAt, String? notes, Metadata metadata
});


$MetadataCopyWith<$Res> get metadata;

}
/// @nodoc
class _$RelationshipCopyWithImpl<$Res>
    implements $RelationshipCopyWith<$Res> {
  _$RelationshipCopyWithImpl(this._self, this._then);

  final Relationship _self;
  final $Res Function(Relationship) _then;

/// Create a copy of Relationship
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? sourceId = null,Object? targetId = null,Object? kind = null,Object? createdAt = null,Object? notes = freezed,Object? metadata = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sourceId: null == sourceId ? _self.sourceId : sourceId // ignore: cast_nullable_to_non_nullable
as String,targetId: null == targetId ? _self.targetId : targetId // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as RelationshipKind,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,metadata: null == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as Metadata,
  ));
}
/// Create a copy of Relationship
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MetadataCopyWith<$Res> get metadata {
  
  return $MetadataCopyWith<$Res>(_self.metadata, (value) {
    return _then(_self.copyWith(metadata: value));
  });
}
}


/// Adds pattern-matching-related methods to [Relationship].
extension RelationshipPatterns on Relationship {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Relationship value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Relationship() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Relationship value)  $default,){
final _that = this;
switch (_that) {
case _Relationship():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Relationship value)?  $default,){
final _that = this;
switch (_that) {
case _Relationship() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String sourceId,  String targetId,  RelationshipKind kind,  DateTime createdAt,  String? notes,  Metadata metadata)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Relationship() when $default != null:
return $default(_that.id,_that.sourceId,_that.targetId,_that.kind,_that.createdAt,_that.notes,_that.metadata);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String sourceId,  String targetId,  RelationshipKind kind,  DateTime createdAt,  String? notes,  Metadata metadata)  $default,) {final _that = this;
switch (_that) {
case _Relationship():
return $default(_that.id,_that.sourceId,_that.targetId,_that.kind,_that.createdAt,_that.notes,_that.metadata);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String sourceId,  String targetId,  RelationshipKind kind,  DateTime createdAt,  String? notes,  Metadata metadata)?  $default,) {final _that = this;
switch (_that) {
case _Relationship() when $default != null:
return $default(_that.id,_that.sourceId,_that.targetId,_that.kind,_that.createdAt,_that.notes,_that.metadata);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Relationship implements Relationship {
  const _Relationship({required this.id, required this.sourceId, required this.targetId, required this.kind, required this.createdAt, this.notes, this.metadata = Metadata.empty});
  factory _Relationship.fromJson(Map<String, dynamic> json) => _$RelationshipFromJson(json);

@override final  String id;
@override final  String sourceId;
@override final  String targetId;
@override final  RelationshipKind kind;
@override final  DateTime createdAt;
@override final  String? notes;
@override@JsonKey() final  Metadata metadata;

/// Create a copy of Relationship
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RelationshipCopyWith<_Relationship> get copyWith => __$RelationshipCopyWithImpl<_Relationship>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RelationshipToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Relationship&&(identical(other.id, id) || other.id == id)&&(identical(other.sourceId, sourceId) || other.sourceId == sourceId)&&(identical(other.targetId, targetId) || other.targetId == targetId)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.metadata, metadata) || other.metadata == metadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,sourceId,targetId,kind,createdAt,notes,metadata);

@override
String toString() {
  return 'Relationship(id: $id, sourceId: $sourceId, targetId: $targetId, kind: $kind, createdAt: $createdAt, notes: $notes, metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class _$RelationshipCopyWith<$Res> implements $RelationshipCopyWith<$Res> {
  factory _$RelationshipCopyWith(_Relationship value, $Res Function(_Relationship) _then) = __$RelationshipCopyWithImpl;
@override @useResult
$Res call({
 String id, String sourceId, String targetId, RelationshipKind kind, DateTime createdAt, String? notes, Metadata metadata
});


@override $MetadataCopyWith<$Res> get metadata;

}
/// @nodoc
class __$RelationshipCopyWithImpl<$Res>
    implements _$RelationshipCopyWith<$Res> {
  __$RelationshipCopyWithImpl(this._self, this._then);

  final _Relationship _self;
  final $Res Function(_Relationship) _then;

/// Create a copy of Relationship
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? sourceId = null,Object? targetId = null,Object? kind = null,Object? createdAt = null,Object? notes = freezed,Object? metadata = null,}) {
  return _then(_Relationship(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sourceId: null == sourceId ? _self.sourceId : sourceId // ignore: cast_nullable_to_non_nullable
as String,targetId: null == targetId ? _self.targetId : targetId // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as RelationshipKind,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,metadata: null == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as Metadata,
  ));
}

/// Create a copy of Relationship
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MetadataCopyWith<$Res> get metadata {
  
  return $MetadataCopyWith<$Res>(_self.metadata, (value) {
    return _then(_self.copyWith(metadata: value));
  });
}
}

// dart format on
