// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'asset_type.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AssetType {

 String get id; String get name; String get moduleId; DateTime get createdAt; DateTime get updatedAt; String? get description; Metadata get metadata;
/// Create a copy of AssetType
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AssetTypeCopyWith<AssetType> get copyWith => _$AssetTypeCopyWithImpl<AssetType>(this as AssetType, _$identity);

  /// Serializes this AssetType to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AssetType&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.moduleId, moduleId) || other.moduleId == moduleId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.description, description) || other.description == description)&&(identical(other.metadata, metadata) || other.metadata == metadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,moduleId,createdAt,updatedAt,description,metadata);

@override
String toString() {
  return 'AssetType(id: $id, name: $name, moduleId: $moduleId, createdAt: $createdAt, updatedAt: $updatedAt, description: $description, metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class $AssetTypeCopyWith<$Res>  {
  factory $AssetTypeCopyWith(AssetType value, $Res Function(AssetType) _then) = _$AssetTypeCopyWithImpl;
@useResult
$Res call({
 String id, String name, String moduleId, DateTime createdAt, DateTime updatedAt, String? description, Metadata metadata
});


$MetadataCopyWith<$Res> get metadata;

}
/// @nodoc
class _$AssetTypeCopyWithImpl<$Res>
    implements $AssetTypeCopyWith<$Res> {
  _$AssetTypeCopyWithImpl(this._self, this._then);

  final AssetType _self;
  final $Res Function(AssetType) _then;

/// Create a copy of AssetType
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? moduleId = null,Object? createdAt = null,Object? updatedAt = null,Object? description = freezed,Object? metadata = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,moduleId: null == moduleId ? _self.moduleId : moduleId // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,metadata: null == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as Metadata,
  ));
}
/// Create a copy of AssetType
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MetadataCopyWith<$Res> get metadata {
  
  return $MetadataCopyWith<$Res>(_self.metadata, (value) {
    return _then(_self.copyWith(metadata: value));
  });
}
}


/// Adds pattern-matching-related methods to [AssetType].
extension AssetTypePatterns on AssetType {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AssetType value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AssetType() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AssetType value)  $default,){
final _that = this;
switch (_that) {
case _AssetType():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AssetType value)?  $default,){
final _that = this;
switch (_that) {
case _AssetType() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String moduleId,  DateTime createdAt,  DateTime updatedAt,  String? description,  Metadata metadata)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AssetType() when $default != null:
return $default(_that.id,_that.name,_that.moduleId,_that.createdAt,_that.updatedAt,_that.description,_that.metadata);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String moduleId,  DateTime createdAt,  DateTime updatedAt,  String? description,  Metadata metadata)  $default,) {final _that = this;
switch (_that) {
case _AssetType():
return $default(_that.id,_that.name,_that.moduleId,_that.createdAt,_that.updatedAt,_that.description,_that.metadata);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String moduleId,  DateTime createdAt,  DateTime updatedAt,  String? description,  Metadata metadata)?  $default,) {final _that = this;
switch (_that) {
case _AssetType() when $default != null:
return $default(_that.id,_that.name,_that.moduleId,_that.createdAt,_that.updatedAt,_that.description,_that.metadata);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AssetType implements AssetType {
  const _AssetType({required this.id, required this.name, required this.moduleId, required this.createdAt, required this.updatedAt, this.description, this.metadata = Metadata.empty});
  factory _AssetType.fromJson(Map<String, dynamic> json) => _$AssetTypeFromJson(json);

@override final  String id;
@override final  String name;
@override final  String moduleId;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override final  String? description;
@override@JsonKey() final  Metadata metadata;

/// Create a copy of AssetType
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AssetTypeCopyWith<_AssetType> get copyWith => __$AssetTypeCopyWithImpl<_AssetType>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AssetTypeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AssetType&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.moduleId, moduleId) || other.moduleId == moduleId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.description, description) || other.description == description)&&(identical(other.metadata, metadata) || other.metadata == metadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,moduleId,createdAt,updatedAt,description,metadata);

@override
String toString() {
  return 'AssetType(id: $id, name: $name, moduleId: $moduleId, createdAt: $createdAt, updatedAt: $updatedAt, description: $description, metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class _$AssetTypeCopyWith<$Res> implements $AssetTypeCopyWith<$Res> {
  factory _$AssetTypeCopyWith(_AssetType value, $Res Function(_AssetType) _then) = __$AssetTypeCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String moduleId, DateTime createdAt, DateTime updatedAt, String? description, Metadata metadata
});


@override $MetadataCopyWith<$Res> get metadata;

}
/// @nodoc
class __$AssetTypeCopyWithImpl<$Res>
    implements _$AssetTypeCopyWith<$Res> {
  __$AssetTypeCopyWithImpl(this._self, this._then);

  final _AssetType _self;
  final $Res Function(_AssetType) _then;

/// Create a copy of AssetType
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? moduleId = null,Object? createdAt = null,Object? updatedAt = null,Object? description = freezed,Object? metadata = null,}) {
  return _then(_AssetType(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,moduleId: null == moduleId ? _self.moduleId : moduleId // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,metadata: null == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as Metadata,
  ));
}

/// Create a copy of AssetType
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
