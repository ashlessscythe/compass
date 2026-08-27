import 'package:compass/core/utils/result.dart';
import 'package:compass/features/domains/infrastructure/domain_pack_remote_loader.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final loader = DomainPackRemoteLoader();

  test('accepts compass domain pack URLs', () {
    final result = loader.parseInstallUrl(
      'https://getcompass.space/api/domains/jewelry',
    );
    expect(result.isSuccess, isTrue);
    expect(result.valueOrNull?.path, '/api/domains/jewelry');
  });

  test('rejects non-compass hosts', () {
    final result = loader.parseInstallUrl(
      'https://example.com/api/domains/jewelry',
    );
    expect(result.isFailure, isTrue);
  });

  test('rejects invalid paths', () {
    final result = loader.parseInstallUrl(
      'https://getcompass.space/docs/domains/jewelry',
    );
    expect(result.isFailure, isTrue);
  });

  test('rejects http URLs', () {
    final result = loader.parseInstallUrl(
      'http://getcompass.space/api/domains/jewelry',
    );
    expect(result.isFailure, isTrue);
  });
}
