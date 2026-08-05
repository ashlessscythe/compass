import 'package:compass/services/app_logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appLoggerProvider = Provider<AppLogger>((ref) {
  return const ConsoleAppLogger();
});
