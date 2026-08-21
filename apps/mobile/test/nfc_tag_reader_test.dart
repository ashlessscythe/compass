import 'package:compass/features/nfc/infrastructure/nfc_tag_reader.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nfc_manager/nfc_manager.dart';

void main() {
  test('formatUid is uppercase hex without separators', () {
    expect(NfcTagReader.formatUid(const [0x04, 0x0a, 0xb2, 0xc3]), '040AB2C3');
  });

  test('uidFromTag returns null for invalid tag payload', () {
    const tag = NfcTag(data: Object());
    expect(NfcTagReader.uidFromTag(tag), isNull);
  });
}
