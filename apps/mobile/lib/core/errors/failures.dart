import 'package:freezed_annotation/freezed_annotation.dart';

part 'failures.freezed.dart';

/// Typed failure values for the application layer.
@freezed
sealed class Failure with _$Failure {
  const factory Failure.unexpected({
    required String message,
    Object? cause,
  }) = UnexpectedFailure;

  const factory Failure.notFound({
    required String entity,
    required String id,
  }) = NotFoundFailure;

  const factory Failure.validation({
    required String message,
  }) = ValidationFailure;

  const factory Failure.database({
    required String message,
    Object? cause,
  }) = DatabaseFailure;
}
