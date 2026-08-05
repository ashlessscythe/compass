import 'package:uuid/uuid.dart';

/// Generates time-ordered unique identifiers for domain entities.
abstract final class IdGenerator {
  static const Uuid _uuid = Uuid();

  static String v4() => _uuid.v4();
}
