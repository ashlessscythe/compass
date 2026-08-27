import 'package:compass/features/domains/domain/domain_pack_version.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('compare semver segments', () {
    expect(DomainPackVersion.compare('1.0.0', '1.0.0'), 0);
    expect(DomainPackVersion.compare('1.0.1', '1.0.0'), greaterThan(0));
    expect(DomainPackVersion.compare('2.0.0', '1.9.9'), greaterThan(0));
    expect(DomainPackVersion.isNewer('1.1.0', '1.0.0'), isTrue);
    expect(DomainPackVersion.isNewer('1.0.0', '1.0.0'), isFalse);
  });
}
