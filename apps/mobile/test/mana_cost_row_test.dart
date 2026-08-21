import 'package:compass/widgets/mana_cost_row.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('tokensOf splits Scryfall mana_cost braces', () {
    expect(ManaCostRow.tokensOf('{3}{W}'), ['3', 'W']);
    expect(ManaCostRow.tokensOf('{2}{U}{U}'), ['2', 'U', 'U']);
    expect(ManaCostRow.tokensOf('{W/U}{P}'), ['W/U', 'P']);
    expect(ManaCostRow.tokensOf(''), isEmpty);
  });
}
