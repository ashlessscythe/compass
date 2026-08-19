// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'controlled_value.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ControlledValue {

 String get id; String get vocabularyKey;/// Stable id such as `material.gold.14k`.
 String get canonicalKey; String get label; String? get parentId; Metadata get metadata;
/// Create a copy of ControlledValue
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ControlledValueCopyWith<ControlledValue> get copyWith => _$ControlledValueCopyWithImpl<ControlledValue>(this as ControlledValue, _$identity);

  /// Serializes this ControlledValue to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ControlledValue&&(identical(other.id, id) || other.id == id)&&(identical(other.vocabularyKey, vocabularyKey) || other.vocabularyKey == vocabularyKey)&&(identical(other.canonicalKey, canonicalKey) || other.canonicalKey == canonicalKey)&&(identical(other.label, label) || other.label == label)&&(identical(other.parentId, parentId) || other.parentId == parentId)&&(identical(other.metadata, metadata) || other.metadata == metadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,vocabularyKey,canonicalKey,label,parentId,metadata);

@override
String toString() {
  return 'ControlledValue(id: $id, vocabularyKey: $vocabularyKey, canonicalKey: $canonicalKey, label: $label, parentId: $parentId, metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class $ControlledValueCopyWith<$Res>  {
  factory $ControlledValueCopyWith(ControlledValue value, $Res Function(ControlledValue) _then) = _$ControlledValueCopyWithImpl;
@useResult
$Res call({
 String id, String vocabularyKey, String canonicalKey, String label, String? parentId, Metadata metadata
});


$MetadataCopyWith<$Res> get metadata;

}
/// @nodoc
class _$ControlledValueCopyWithImpl<$Res>
    implements $ControlledValueCopyWith<$Res> {
  _$ControlledValueCopyWithImpl(this._self, this._then);

  final ControlledValue _self;
  final $Res Function(ControlledValue) _then;

/// Create a copy of ControlledValue
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? vocabularyKey = null,Object? canonicalKey = null,Object? label = null,Object? parentId = freezed,Object? metadata = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,vocabularyKey: null == vocabularyKey ? _self.vocabularyKey : vocabularyKey // ignore: cast_nullable_to_non_nullable
as String,canonicalKey: null == canonicalKey ? _self.canonicalKey : canonicalKey // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,parentId: freezed == parentId ? _self.parentId : parentId // ignore: cast_nullable_to_non_nullable
as String?,metadata: null == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as Metadata,
  ));
}
/// Create a copy of ControlledValue
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MetadataCopyWith<$Res> get metadata {
  
  return $MetadataCopyWith<$Res>(_self.metadata, (value) {
    return _then(_self.copyWith(metadata: value));
  });
}
}


/// Adds pattern-matching-related methods to [ControlledValue].
extension ControlledValuePatterns on ControlledValue {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ControlledValue value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ControlledValue() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ControlledValue value)  $default,){
final _that = this;
switch (_that) {
case _ControlledValue():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ControlledValue value)?  $default,){
final _that = this;
switch (_that) {
case _ControlledValue() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String vocabularyKey,  String canonicalKey,  String label,  String? parentId,  Metadata metadata)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ControlledValue() when $default != null:
return $default(_that.id,_that.vocabularyKey,_that.canonicalKey,_that.label,_that.parentId,_that.metadata);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String vocabularyKey,  String canonicalKey,  String label,  String? parentId,  Metadata metadata)  $default,) {final _that = this;
switch (_that) {
case _ControlledValue():
return $default(_that.id,_that.vocabularyKey,_that.canonicalKey,_that.label,_that.parentId,_that.metadata);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String vocabularyKey,  String canonicalKey,  String label,  String? parentId,  Metadata metadata)?  $default,) {final _that = this;
switch (_that) {
case _ControlledValue() when $default != null:
return $default(_that.id,_that.vocabularyKey,_that.canonicalKey,_that.label,_that.parentId,_that.metadata);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ControlledValue implements ControlledValue {
  const _ControlledValue({required this.id, required this.vocabularyKey, required this.canonicalKey, required this.label, this.parentId, this.metadata = Metadata.empty});
  factory _ControlledValue.fromJson(Map<String, dynamic> json) => _$ControlledValueFromJson(json);

@override final  String id;
@override final  String vocabularyKey;
/// Stable id such as `material.gold.14k`.
@override final  String canonicalKey;
@override final  String label;
@override final  String? parentId;
@override@JsonKey() final  Metadata metadata;

/// Create a copy of ControlledValue
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ControlledValueCopyWith<_ControlledValue> get copyWith => __$ControlledValueCopyWithImpl<_ControlledValue>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ControlledValueToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ControlledValue&&(identical(other.id, id) || other.id == id)&&(identical(other.vocabularyKey, vocabularyKey) || other.vocabularyKey == vocabularyKey)&&(identical(other.canonicalKey, canonicalKey) || other.canonicalKey == canonicalKey)&&(identical(other.label, label) || other.label == label)&&(identical(other.parentId, parentId) || other.parentId == parentId)&&(identical(other.metadata, metadata) || other.metadata == metadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,vocabularyKey,canonicalKey,label,parentId,metadata);

@override
String toString() {
  return 'ControlledValue(id: $id, vocabularyKey: $vocabularyKey, canonicalKey: $canonicalKey, label: $label, parentId: $parentId, metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class _$ControlledValueCopyWith<$Res> implements $ControlledValueCopyWith<$Res> {
  factory _$ControlledValueCopyWith(_ControlledValue value, $Res Function(_ControlledValue) _then) = __$ControlledValueCopyWithImpl;
@override @useResult
$Res call({
 String id, String vocabularyKey, String canonicalKey, String label, String? parentId, Metadata metadata
});


@override $MetadataCopyWith<$Res> get metadata;

}
/// @nodoc
class __$ControlledValueCopyWithImpl<$Res>
    implements _$ControlledValueCopyWith<$Res> {
  __$ControlledValueCopyWithImpl(this._self, this._then);

  final _ControlledValue _self;
  final $Res Function(_ControlledValue) _then;

/// Create a copy of ControlledValue
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? vocabularyKey = null,Object? canonicalKey = null,Object? label = null,Object? parentId = freezed,Object? metadata = null,}) {
  return _then(_ControlledValue(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,vocabularyKey: null == vocabularyKey ? _self.vocabularyKey : vocabularyKey // ignore: cast_nullable_to_non_nullable
as String,canonicalKey: null == canonicalKey ? _self.canonicalKey : canonicalKey // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,parentId: freezed == parentId ? _self.parentId : parentId // ignore: cast_nullable_to_non_nullable
as String?,metadata: null == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as Metadata,
  ));
}

/// Create a copy of ControlledValue
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
