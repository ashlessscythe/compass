import 'package:json_annotation/json_annotation.dart';

/// Supported attribute value kinds. Additional types can be added later.
enum AttributeValueType {
  string,
  integer,
  decimal,
  boolean,
  date,
  dateRange,
  @JsonValue('enum')
  enumeration,
  multiSelect,
  reference,
  measurement,
  currency,
  url,
  identifier,
}
