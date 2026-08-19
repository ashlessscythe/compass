// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'container.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Container {

 String get id; String get name; DateTime get createdAt; DateTime get updatedAt; String? get parentContainerId; String? get locationId; String? get nfcTagId; String? get notes; Metadata get metadata;
/// Create a copy of Container
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ContainerCopyWith<Container> get copyWith => _$ContainerCopyWithImpl<Container>(this as Container, _$identity);

  /// Serializes this Container to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Container&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.parentContainerId, parentContainerId) || other.parentContainerId == parentContainerId)&&(identical(other.locationId, locationId) || other.locationId == locationId)&&(identical(other.nfcTagId, nfcTagId) || other.nfcTagId == nfcTagId)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.metadata, metadata) || other.metadata == metadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,createdAt,updatedAt,parentContainerId,locationId,nfcTagId,notes,metadata);

@override
String toString() {
  return 'Container(id: $id, name: $name, createdAt: $createdAt, updatedAt: $updatedAt, parentContainerId: $parentContainerId, locationId: $locationId, nfcTagId: $nfcTagId, notes: $notes, metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class $ContainerCopyWith<$Res>  {
  factory $ContainerCopyWith(Container value, $Res Function(Container) _then) = _$ContainerCopyWithImpl;
@useResult
$Res call({
 String id, String name, DateTime createdAt, DateTime updatedAt, String? parentContainerId, String? locationId, String? nfcTagId, String? notes, Metadata metadata
});


$MetadataCopyWith<$Res> get metadata;

}
/// @nodoc
class _$ContainerCopyWithImpl<$Res>
    implements $ContainerCopyWith<$Res> {
  _$ContainerCopyWithImpl(this._self, this._then);

  final Container _self;
  final $Res Function(Container) _then;

/// Create a copy of Container
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? createdAt = null,Object? updatedAt = null,Object? parentContainerId = freezed,Object? locationId = freezed,Object? nfcTagId = freezed,Object? notes = freezed,Object? metadata = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,parentContainerId: freezed == parentContainerId ? _self.parentContainerId : parentContainerId // ignore: cast_nullable_to_non_nullable
as String?,locationId: freezed == locationId ? _self.locationId : locationId // ignore: cast_nullable_to_non_nullable
as String?,nfcTagId: freezed == nfcTagId ? _self.nfcTagId : nfcTagId // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,metadata: null == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as Metadata,
  ));
}
/// Create a copy of Container
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MetadataCopyWith<$Res> get metadata {
  
  return $MetadataCopyWith<$Res>(_self.metadata, (value) {
    return _then(_self.copyWith(metadata: value));
  });
}
}


/// Adds pattern-matching-related methods to [Container].
extension ContainerPatterns on Container {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Container value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Container() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Container value)  $default,){
final _that = this;
switch (_that) {
case _Container():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Container value)?  $default,){
final _that = this;
switch (_that) {
case _Container() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  DateTime createdAt,  DateTime updatedAt,  String? parentContainerId,  String? locationId,  String? nfcTagId,  String? notes,  Metadata metadata)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Container() when $default != null:
return $default(_that.id,_that.name,_that.createdAt,_that.updatedAt,_that.parentContainerId,_that.locationId,_that.nfcTagId,_that.notes,_that.metadata);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  DateTime createdAt,  DateTime updatedAt,  String? parentContainerId,  String? locationId,  String? nfcTagId,  String? notes,  Metadata metadata)  $default,) {final _that = this;
switch (_that) {
case _Container():
return $default(_that.id,_that.name,_that.createdAt,_that.updatedAt,_that.parentContainerId,_that.locationId,_that.nfcTagId,_that.notes,_that.metadata);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  DateTime createdAt,  DateTime updatedAt,  String? parentContainerId,  String? locationId,  String? nfcTagId,  String? notes,  Metadata metadata)?  $default,) {final _that = this;
switch (_that) {
case _Container() when $default != null:
return $default(_that.id,_that.name,_that.createdAt,_that.updatedAt,_that.parentContainerId,_that.locationId,_that.nfcTagId,_that.notes,_that.metadata);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Container implements Container {
  const _Container({required this.id, required this.name, required this.createdAt, required this.updatedAt, this.parentContainerId, this.locationId, this.nfcTagId, this.notes, this.metadata = Metadata.empty});
  factory _Container.fromJson(Map<String, dynamic> json) => _$ContainerFromJson(json);

@override final  String id;
@override final  String name;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override final  String? parentContainerId;
@override final  String? locationId;
@override final  String? nfcTagId;
@override final  String? notes;
@override@JsonKey() final  Metadata metadata;

/// Create a copy of Container
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ContainerCopyWith<_Container> get copyWith => __$ContainerCopyWithImpl<_Container>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ContainerToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Container&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.parentContainerId, parentContainerId) || other.parentContainerId == parentContainerId)&&(identical(other.locationId, locationId) || other.locationId == locationId)&&(identical(other.nfcTagId, nfcTagId) || other.nfcTagId == nfcTagId)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.metadata, metadata) || other.metadata == metadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,createdAt,updatedAt,parentContainerId,locationId,nfcTagId,notes,metadata);

@override
String toString() {
  return 'Container(id: $id, name: $name, createdAt: $createdAt, updatedAt: $updatedAt, parentContainerId: $parentContainerId, locationId: $locationId, nfcTagId: $nfcTagId, notes: $notes, metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class _$ContainerCopyWith<$Res> implements $ContainerCopyWith<$Res> {
  factory _$ContainerCopyWith(_Container value, $Res Function(_Container) _then) = __$ContainerCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, DateTime createdAt, DateTime updatedAt, String? parentContainerId, String? locationId, String? nfcTagId, String? notes, Metadata metadata
});


@override $MetadataCopyWith<$Res> get metadata;

}
/// @nodoc
class __$ContainerCopyWithImpl<$Res>
    implements _$ContainerCopyWith<$Res> {
  __$ContainerCopyWithImpl(this._self, this._then);

  final _Container _self;
  final $Res Function(_Container) _then;

/// Create a copy of Container
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? createdAt = null,Object? updatedAt = null,Object? parentContainerId = freezed,Object? locationId = freezed,Object? nfcTagId = freezed,Object? notes = freezed,Object? metadata = null,}) {
  return _then(_Container(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,parentContainerId: freezed == parentContainerId ? _self.parentContainerId : parentContainerId // ignore: cast_nullable_to_non_nullable
as String?,locationId: freezed == locationId ? _self.locationId : locationId // ignore: cast_nullable_to_non_nullable
as String?,nfcTagId: freezed == nfcTagId ? _self.nfcTagId : nfcTagId // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,metadata: null == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as Metadata,
  ));
}

/// Create a copy of Container
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
