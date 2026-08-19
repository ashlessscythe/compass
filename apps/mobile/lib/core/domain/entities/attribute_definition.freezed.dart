// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'attribute_definition.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AttributeDefinition {

 String get id; String get key; AttributeValueType get valueType; String? get assetTypeId; String? get moduleId; String? get displayName; String? get unit; String? get vocabularyKey; bool get isRequired;
/// Create a copy of AttributeDefinition
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AttributeDefinitionCopyWith<AttributeDefinition> get copyWith => _$AttributeDefinitionCopyWithImpl<AttributeDefinition>(this as AttributeDefinition, _$identity);

  /// Serializes this AttributeDefinition to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AttributeDefinition&&(identical(other.id, id) || other.id == id)&&(identical(other.key, key) || other.key == key)&&(identical(other.valueType, valueType) || other.valueType == valueType)&&(identical(other.assetTypeId, assetTypeId) || other.assetTypeId == assetTypeId)&&(identical(other.moduleId, moduleId) || other.moduleId == moduleId)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.vocabularyKey, vocabularyKey) || other.vocabularyKey == vocabularyKey)&&(identical(other.isRequired, isRequired) || other.isRequired == isRequired));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,key,valueType,assetTypeId,moduleId,displayName,unit,vocabularyKey,isRequired);

@override
String toString() {
  return 'AttributeDefinition(id: $id, key: $key, valueType: $valueType, assetTypeId: $assetTypeId, moduleId: $moduleId, displayName: $displayName, unit: $unit, vocabularyKey: $vocabularyKey, isRequired: $isRequired)';
}


}

/// @nodoc
abstract mixin class $AttributeDefinitionCopyWith<$Res>  {
  factory $AttributeDefinitionCopyWith(AttributeDefinition value, $Res Function(AttributeDefinition) _then) = _$AttributeDefinitionCopyWithImpl;
@useResult
$Res call({
 String id, String key, AttributeValueType valueType, String? assetTypeId, String? moduleId, String? displayName, String? unit, String? vocabularyKey, bool isRequired
});




}
/// @nodoc
class _$AttributeDefinitionCopyWithImpl<$Res>
    implements $AttributeDefinitionCopyWith<$Res> {
  _$AttributeDefinitionCopyWithImpl(this._self, this._then);

  final AttributeDefinition _self;
  final $Res Function(AttributeDefinition) _then;

/// Create a copy of AttributeDefinition
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? key = null,Object? valueType = null,Object? assetTypeId = freezed,Object? moduleId = freezed,Object? displayName = freezed,Object? unit = freezed,Object? vocabularyKey = freezed,Object? isRequired = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,valueType: null == valueType ? _self.valueType : valueType // ignore: cast_nullable_to_non_nullable
as AttributeValueType,assetTypeId: freezed == assetTypeId ? _self.assetTypeId : assetTypeId // ignore: cast_nullable_to_non_nullable
as String?,moduleId: freezed == moduleId ? _self.moduleId : moduleId // ignore: cast_nullable_to_non_nullable
as String?,displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,unit: freezed == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String?,vocabularyKey: freezed == vocabularyKey ? _self.vocabularyKey : vocabularyKey // ignore: cast_nullable_to_non_nullable
as String?,isRequired: null == isRequired ? _self.isRequired : isRequired // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [AttributeDefinition].
extension AttributeDefinitionPatterns on AttributeDefinition {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AttributeDefinition value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AttributeDefinition() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AttributeDefinition value)  $default,){
final _that = this;
switch (_that) {
case _AttributeDefinition():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AttributeDefinition value)?  $default,){
final _that = this;
switch (_that) {
case _AttributeDefinition() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String key,  AttributeValueType valueType,  String? assetTypeId,  String? moduleId,  String? displayName,  String? unit,  String? vocabularyKey,  bool isRequired)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AttributeDefinition() when $default != null:
return $default(_that.id,_that.key,_that.valueType,_that.assetTypeId,_that.moduleId,_that.displayName,_that.unit,_that.vocabularyKey,_that.isRequired);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String key,  AttributeValueType valueType,  String? assetTypeId,  String? moduleId,  String? displayName,  String? unit,  String? vocabularyKey,  bool isRequired)  $default,) {final _that = this;
switch (_that) {
case _AttributeDefinition():
return $default(_that.id,_that.key,_that.valueType,_that.assetTypeId,_that.moduleId,_that.displayName,_that.unit,_that.vocabularyKey,_that.isRequired);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String key,  AttributeValueType valueType,  String? assetTypeId,  String? moduleId,  String? displayName,  String? unit,  String? vocabularyKey,  bool isRequired)?  $default,) {final _that = this;
switch (_that) {
case _AttributeDefinition() when $default != null:
return $default(_that.id,_that.key,_that.valueType,_that.assetTypeId,_that.moduleId,_that.displayName,_that.unit,_that.vocabularyKey,_that.isRequired);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AttributeDefinition implements AttributeDefinition {
  const _AttributeDefinition({required this.id, required this.key, required this.valueType, this.assetTypeId, this.moduleId, this.displayName, this.unit, this.vocabularyKey, this.isRequired = false});
  factory _AttributeDefinition.fromJson(Map<String, dynamic> json) => _$AttributeDefinitionFromJson(json);

@override final  String id;
@override final  String key;
@override final  AttributeValueType valueType;
@override final  String? assetTypeId;
@override final  String? moduleId;
@override final  String? displayName;
@override final  String? unit;
@override final  String? vocabularyKey;
@override@JsonKey() final  bool isRequired;

/// Create a copy of AttributeDefinition
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AttributeDefinitionCopyWith<_AttributeDefinition> get copyWith => __$AttributeDefinitionCopyWithImpl<_AttributeDefinition>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AttributeDefinitionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AttributeDefinition&&(identical(other.id, id) || other.id == id)&&(identical(other.key, key) || other.key == key)&&(identical(other.valueType, valueType) || other.valueType == valueType)&&(identical(other.assetTypeId, assetTypeId) || other.assetTypeId == assetTypeId)&&(identical(other.moduleId, moduleId) || other.moduleId == moduleId)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.vocabularyKey, vocabularyKey) || other.vocabularyKey == vocabularyKey)&&(identical(other.isRequired, isRequired) || other.isRequired == isRequired));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,key,valueType,assetTypeId,moduleId,displayName,unit,vocabularyKey,isRequired);

@override
String toString() {
  return 'AttributeDefinition(id: $id, key: $key, valueType: $valueType, assetTypeId: $assetTypeId, moduleId: $moduleId, displayName: $displayName, unit: $unit, vocabularyKey: $vocabularyKey, isRequired: $isRequired)';
}


}

/// @nodoc
abstract mixin class _$AttributeDefinitionCopyWith<$Res> implements $AttributeDefinitionCopyWith<$Res> {
  factory _$AttributeDefinitionCopyWith(_AttributeDefinition value, $Res Function(_AttributeDefinition) _then) = __$AttributeDefinitionCopyWithImpl;
@override @useResult
$Res call({
 String id, String key, AttributeValueType valueType, String? assetTypeId, String? moduleId, String? displayName, String? unit, String? vocabularyKey, bool isRequired
});




}
/// @nodoc
class __$AttributeDefinitionCopyWithImpl<$Res>
    implements _$AttributeDefinitionCopyWith<$Res> {
  __$AttributeDefinitionCopyWithImpl(this._self, this._then);

  final _AttributeDefinition _self;
  final $Res Function(_AttributeDefinition) _then;

/// Create a copy of AttributeDefinition
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? key = null,Object? valueType = null,Object? assetTypeId = freezed,Object? moduleId = freezed,Object? displayName = freezed,Object? unit = freezed,Object? vocabularyKey = freezed,Object? isRequired = null,}) {
  return _then(_AttributeDefinition(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,valueType: null == valueType ? _self.valueType : valueType // ignore: cast_nullable_to_non_nullable
as AttributeValueType,assetTypeId: freezed == assetTypeId ? _self.assetTypeId : assetTypeId // ignore: cast_nullable_to_non_nullable
as String?,moduleId: freezed == moduleId ? _self.moduleId : moduleId // ignore: cast_nullable_to_non_nullable
as String?,displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,unit: freezed == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String?,vocabularyKey: freezed == vocabularyKey ? _self.vocabularyKey : vocabularyKey // ignore: cast_nullable_to_non_nullable
as String?,isRequired: null == isRequired ? _self.isRequired : isRequired // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
