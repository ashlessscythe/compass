import 'package:compass/core/errors/failures.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'result.freezed.dart';

/// Functional result type for application use cases.
@freezed
sealed class Result<T> with _$Result<T> {
  const factory Result.success(T value) = Success<T>;
  const factory Result.failure(Failure failure) = Err<T>;
}

extension ResultX<T> on Result<T> {
  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Err<T>;

  T? get valueOrNull => switch (this) {
    Success(:final value) => value,
    Err() => null,
  };

  Failure? get failureOrNull => switch (this) {
    Success() => null,
    Err(:final failure) => failure,
  };
}
