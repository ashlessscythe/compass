// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'movement.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Movement {

 String get id; String get subjectId; MovementSubjectKind get subjectKind; DateTime get movedAt; String? get fromLocationId; String? get toLocationId; String? get fromContainerId; String? get toContainerId; String? get notes; Metadata get metadata;
/// Create a copy of Movement
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MovementCopyWith<Movement> get copyWith => _$MovementCopyWithImpl<Movement>(this as Movement, _$identity);

  /// Serializes this Movement to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Movement&&(identical(other.id, id) || other.id == id)&&(identical(other.subjectId, subjectId) || other.subjectId == subjectId)&&(identical(other.subjectKind, subjectKind) || other.subjectKind == subjectKind)&&(identical(other.movedAt, movedAt) || other.movedAt == movedAt)&&(identical(other.fromLocationId, fromLocationId) || other.fromLocationId == fromLocationId)&&(identical(other.toLocationId, toLocationId) || other.toLocationId == toLocationId)&&(identical(other.fromContainerId, fromContainerId) || other.fromContainerId == fromContainerId)&&(identical(other.toContainerId, toContainerId) || other.toContainerId == toContainerId)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.metadata, metadata) || other.metadata == metadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,subjectId,subjectKind,movedAt,fromLocationId,toLocationId,fromContainerId,toContainerId,notes,metadata);

@override
String toString() {
  return 'Movement(id: $id, subjectId: $subjectId, subjectKind: $subjectKind, movedAt: $movedAt, fromLocationId: $fromLocationId, toLocationId: $toLocationId, fromContainerId: $fromContainerId, toContainerId: $toContainerId, notes: $notes, metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class $MovementCopyWith<$Res>  {
  factory $MovementCopyWith(Movement value, $Res Function(Movement) _then) = _$MovementCopyWithImpl;
@useResult
$Res call({
 String id, String subjectId, MovementSubjectKind subjectKind, DateTime movedAt, String? fromLocationId, String? toLocationId, String? fromContainerId, String? toContainerId, String? notes, Metadata metadata
});


$MetadataCopyWith<$Res> get metadata;

}
/// @nodoc
class _$MovementCopyWithImpl<$Res>
    implements $MovementCopyWith<$Res> {
  _$MovementCopyWithImpl(this._self, this._then);

  final Movement _self;
  final $Res Function(Movement) _then;

/// Create a copy of Movement
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? subjectId = null,Object? subjectKind = null,Object? movedAt = null,Object? fromLocationId = freezed,Object? toLocationId = freezed,Object? fromContainerId = freezed,Object? toContainerId = freezed,Object? notes = freezed,Object? metadata = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,subjectId: null == subjectId ? _self.subjectId : subjectId // ignore: cast_nullable_to_non_nullable
as String,subjectKind: null == subjectKind ? _self.subjectKind : subjectKind // ignore: cast_nullable_to_non_nullable
as MovementSubjectKind,movedAt: null == movedAt ? _self.movedAt : movedAt // ignore: cast_nullable_to_non_nullable
as DateTime,fromLocationId: freezed == fromLocationId ? _self.fromLocationId : fromLocationId // ignore: cast_nullable_to_non_nullable
as String?,toLocationId: freezed == toLocationId ? _self.toLocationId : toLocationId // ignore: cast_nullable_to_non_nullable
as String?,fromContainerId: freezed == fromContainerId ? _self.fromContainerId : fromContainerId // ignore: cast_nullable_to_non_nullable
as String?,toContainerId: freezed == toContainerId ? _self.toContainerId : toContainerId // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,metadata: null == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as Metadata,
  ));
}
/// Create a copy of Movement
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MetadataCopyWith<$Res> get metadata {
  
  return $MetadataCopyWith<$Res>(_self.metadata, (value) {
    return _then(_self.copyWith(metadata: value));
  });
}
}


/// Adds pattern-matching-related methods to [Movement].
extension MovementPatterns on Movement {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Movement value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Movement() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Movement value)  $default,){
final _that = this;
switch (_that) {
case _Movement():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Movement value)?  $default,){
final _that = this;
switch (_that) {
case _Movement() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String subjectId,  MovementSubjectKind subjectKind,  DateTime movedAt,  String? fromLocationId,  String? toLocationId,  String? fromContainerId,  String? toContainerId,  String? notes,  Metadata metadata)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Movement() when $default != null:
return $default(_that.id,_that.subjectId,_that.subjectKind,_that.movedAt,_that.fromLocationId,_that.toLocationId,_that.fromContainerId,_that.toContainerId,_that.notes,_that.metadata);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String subjectId,  MovementSubjectKind subjectKind,  DateTime movedAt,  String? fromLocationId,  String? toLocationId,  String? fromContainerId,  String? toContainerId,  String? notes,  Metadata metadata)  $default,) {final _that = this;
switch (_that) {
case _Movement():
return $default(_that.id,_that.subjectId,_that.subjectKind,_that.movedAt,_that.fromLocationId,_that.toLocationId,_that.fromContainerId,_that.toContainerId,_that.notes,_that.metadata);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String subjectId,  MovementSubjectKind subjectKind,  DateTime movedAt,  String? fromLocationId,  String? toLocationId,  String? fromContainerId,  String? toContainerId,  String? notes,  Metadata metadata)?  $default,) {final _that = this;
switch (_that) {
case _Movement() when $default != null:
return $default(_that.id,_that.subjectId,_that.subjectKind,_that.movedAt,_that.fromLocationId,_that.toLocationId,_that.fromContainerId,_that.toContainerId,_that.notes,_that.metadata);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Movement implements Movement {
  const _Movement({required this.id, required this.subjectId, required this.subjectKind, required this.movedAt, this.fromLocationId, this.toLocationId, this.fromContainerId, this.toContainerId, this.notes, this.metadata = Metadata.empty});
  factory _Movement.fromJson(Map<String, dynamic> json) => _$MovementFromJson(json);

@override final  String id;
@override final  String subjectId;
@override final  MovementSubjectKind subjectKind;
@override final  DateTime movedAt;
@override final  String? fromLocationId;
@override final  String? toLocationId;
@override final  String? fromContainerId;
@override final  String? toContainerId;
@override final  String? notes;
@override@JsonKey() final  Metadata metadata;

/// Create a copy of Movement
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MovementCopyWith<_Movement> get copyWith => __$MovementCopyWithImpl<_Movement>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MovementToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Movement&&(identical(other.id, id) || other.id == id)&&(identical(other.subjectId, subjectId) || other.subjectId == subjectId)&&(identical(other.subjectKind, subjectKind) || other.subjectKind == subjectKind)&&(identical(other.movedAt, movedAt) || other.movedAt == movedAt)&&(identical(other.fromLocationId, fromLocationId) || other.fromLocationId == fromLocationId)&&(identical(other.toLocationId, toLocationId) || other.toLocationId == toLocationId)&&(identical(other.fromContainerId, fromContainerId) || other.fromContainerId == fromContainerId)&&(identical(other.toContainerId, toContainerId) || other.toContainerId == toContainerId)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.metadata, metadata) || other.metadata == metadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,subjectId,subjectKind,movedAt,fromLocationId,toLocationId,fromContainerId,toContainerId,notes,metadata);

@override
String toString() {
  return 'Movement(id: $id, subjectId: $subjectId, subjectKind: $subjectKind, movedAt: $movedAt, fromLocationId: $fromLocationId, toLocationId: $toLocationId, fromContainerId: $fromContainerId, toContainerId: $toContainerId, notes: $notes, metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class _$MovementCopyWith<$Res> implements $MovementCopyWith<$Res> {
  factory _$MovementCopyWith(_Movement value, $Res Function(_Movement) _then) = __$MovementCopyWithImpl;
@override @useResult
$Res call({
 String id, String subjectId, MovementSubjectKind subjectKind, DateTime movedAt, String? fromLocationId, String? toLocationId, String? fromContainerId, String? toContainerId, String? notes, Metadata metadata
});


@override $MetadataCopyWith<$Res> get metadata;

}
/// @nodoc
class __$MovementCopyWithImpl<$Res>
    implements _$MovementCopyWith<$Res> {
  __$MovementCopyWithImpl(this._self, this._then);

  final _Movement _self;
  final $Res Function(_Movement) _then;

/// Create a copy of Movement
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? subjectId = null,Object? subjectKind = null,Object? movedAt = null,Object? fromLocationId = freezed,Object? toLocationId = freezed,Object? fromContainerId = freezed,Object? toContainerId = freezed,Object? notes = freezed,Object? metadata = null,}) {
  return _then(_Movement(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,subjectId: null == subjectId ? _self.subjectId : subjectId // ignore: cast_nullable_to_non_nullable
as String,subjectKind: null == subjectKind ? _self.subjectKind : subjectKind // ignore: cast_nullable_to_non_nullable
as MovementSubjectKind,movedAt: null == movedAt ? _self.movedAt : movedAt // ignore: cast_nullable_to_non_nullable
as DateTime,fromLocationId: freezed == fromLocationId ? _self.fromLocationId : fromLocationId // ignore: cast_nullable_to_non_nullable
as String?,toLocationId: freezed == toLocationId ? _self.toLocationId : toLocationId // ignore: cast_nullable_to_non_nullable
as String?,fromContainerId: freezed == fromContainerId ? _self.fromContainerId : fromContainerId // ignore: cast_nullable_to_non_nullable
as String?,toContainerId: freezed == toContainerId ? _self.toContainerId : toContainerId // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,metadata: null == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as Metadata,
  ));
}

/// Create a copy of Movement
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
