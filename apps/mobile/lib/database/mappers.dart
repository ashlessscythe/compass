import 'dart:convert';

import 'package:compass/core/domain/entities/metadata.dart';

String encodeMetadata(Metadata metadata) {
  return jsonEncode(metadata.toJson());
}

Metadata decodeMetadata(String raw) {
  if (raw.isEmpty) {
    return Metadata.empty;
  }
  final decoded = jsonDecode(raw);
  if (decoded is Map<String, dynamic>) {
    return Metadata.fromJson(decoded);
  }
  return Metadata.empty;
}
