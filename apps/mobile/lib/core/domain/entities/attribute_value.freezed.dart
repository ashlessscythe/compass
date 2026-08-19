// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'attribute_value.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AttributeValue {

 String get id; String get assetId; String get definitionId;/// JSON-compatible payload: string, number, bool, list, or map.
 Object get value; String? get unit; String? get controlledValueId;
/// Create a copy of AttributeValue
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AttributeValueCopyWith<AttributeValue> get copyWith => _$AttributeValueCopyWithImpl<AttributeValue>(this as AttributeValue, _$identity);

  /// Serializes this AttributeValue to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AttributeValue&&(identical(other.id, id) || other.id == id)&&(identical(other.assetId, assetId) || other.assetId == assetId)&&(identical(other.definitionId, definitionId) || other.definitionId == definitionId)&&const DeepCollectionEquality().equals(other.value, value)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.controlledValueId, controlledValueId) || other.controlledValueId == controlledValueId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,assetId,definitionId,const DeepCollectionEquality().hash(value),unit,controlledValueId);

@override
String toString() {
  return 'AttributeValue(id: $id, assetId: $assetId, definitionId: $definitionId, value: $value, unit: $unit, controlledValueId: $controlledValueId)';
}


}

/// @nodoc
abstract mixin class $AttributeValueCopyWith<$Res>  {
  factory $AttributeValueCopyWith(AttributeValue value, $Res Function(AttributeValue) _then) = _$AttributeValueCopyWithImpl;
@useResult
$Res call({
 String id, String assetId, String definitionId, Object value, String? unit, String? controlledValueId
});




}
/// @nodoc
class _$AttributeValueCopyWithImpl<$Res>
    implements $AttributeValueCopyWith<$Res> {
  _$AttributeValueCopyWithImpl(this._self, this._then);

  final AttributeValue _self;
  final $Res Function(AttributeValue) _then;

/// Create a copy of AttributeValue
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? assetId = null,Object? definitionId = null,Object? value = null,Object? unit = freezed,Object? controlledValueId = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,assetId: null == assetId ? _self.assetId : assetId // ignore: cast_nullable_to_non_nullable
as String,definitionId: null == definitionId ? _self.definitionId : definitionId // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value ,unit: freezed == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String?,controlledValueId: freezed == controlledValueId ? _self.controlledValueId : controlledValueId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AttributeValue].
extension AttributeValuePatterns on AttributeValue {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AttributeValue value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AttributeValue() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AttributeValue value)  $default,){
final _that = this;
switch (_that) {
case _AttributeValue():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AttributeValue value)?  $default,){
final _that = this;
switch (_that) {
case _AttributeValue() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String assetId,  String definitionId,  Object value,  String? unit,  String? controlledValueId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AttributeValue() when $default != null:
return $default(_that.id,_that.assetId,_that.definitionId,_that.value,_that.unit,_that.controlledValueId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String assetId,  String definitionId,  Object value,  String? unit,  String? controlledValueId)  $default,) {final _that = this;
switch (_that) {
case _AttributeValue():
return $default(_that.id,_that.assetId,_that.definitionId,_that.value,_that.unit,_that.controlledValueId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String assetId,  String definitionId,  Object value,  String? unit,  String? controlledValueId)?  $default,) {final _that = this;
switch (_that) {
case _AttributeValue() when $default != null:
return $default(_that.id,_that.assetId,_that.definitionId,_that.value,_that.unit,_that.controlledValueId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AttributeValue implements AttributeValue {
  const _AttributeValue({required this.id, required this.assetId, required this.definitionId, required this.value, this.unit, this.controlledValueId});
  factory _AttributeValue.fromJson(Map<String, dynamic> json) => _$AttributeValueFromJson(json);

@override final  String id;
@override final  String assetId;
@override final  String definitionId;
/// JSON-compatible payload: string, number, bool, list, or map.
@override final  Object value;
@override final  String? unit;
@override final  String? controlledValueId;

/// Create a copy of AttributeValue
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AttributeValueCopyWith<_AttributeValue> get copyWith => __$AttributeValueCopyWithImpl<_AttributeValue>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AttributeValueToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AttributeValue&&(identical(other.id, id) || other.id == id)&&(identical(other.assetId, assetId) || other.assetId == assetId)&&(identical(other.definitionId, definitionId) || other.definitionId == definitionId)&&const DeepCollectionEquality().equals(other.value, value)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.controlledValueId, controlledValueId) || other.controlledValueId == controlledValueId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,assetId,definitionId,const DeepCollectionEquality().hash(value),unit,controlledValueId);

@override
String toString() {
  return 'AttributeValue(id: $id, assetId: $assetId, definitionId: $definitionId, value: $value, unit: $unit, controlledValueId: $controlledValueId)';
}


}

/// @nodoc
abstract mixin class _$AttributeValueCopyWith<$Res> implements $AttributeValueCopyWith<$Res> {
  factory _$AttributeValueCopyWith(_AttributeValue value, $Res Function(_AttributeValue) _then) = __$AttributeValueCopyWithImpl;
@override @useResult
$Res call({
 String id, String assetId, String definitionId, Object value, String? unit, String? controlledValueId
});




}
/// @nodoc
class __$AttributeValueCopyWithImpl<$Res>
    implements _$AttributeValueCopyWith<$Res> {
  __$AttributeValueCopyWithImpl(this._self, this._then);

  final _AttributeValue _self;
  final $Res Function(_AttributeValue) _then;

/// Create a copy of AttributeValue
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? assetId = null,Object? definitionId = null,Object? value = null,Object? unit = freezed,Object? controlledValueId = freezed,}) {
  return _then(_AttributeValue(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,assetId: null == assetId ? _self.assetId : assetId // ignore: cast_nullable_to_non_nullable
as String,definitionId: null == definitionId ? _self.definitionId : definitionId // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value ,unit: freezed == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String?,controlledValueId: freezed == controlledValueId ? _self.controlledValueId : controlledValueId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
