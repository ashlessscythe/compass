import 'package:compass/theme/app_spacing.dart';
import 'package:flutter/material.dart';

/// Renders Scryfall mana_cost strings like `{3}{W}` as compact colored pips.
class ManaCostRow extends StatelessWidget {
  const ManaCostRow(this.manaCost, {super.key, this.size = 22});

  /// Color / color-identity letters such as `['U', 'R']`.
  ManaCostRow.fromSymbols(
    List<String> symbols, {
    super.key,
    this.size = 18,
  }) : manaCost = symbols.map((s) => '{$s}').join();

  final String manaCost;
  final double size;

  static final _tokenPattern = RegExp(r'\{([^}]+)\}');

  @visibleForTesting
  static List<String> tokensOf(String manaCost) {
    return _tokenPattern
        .allMatches(manaCost)
        .map((match) => match.group(1)!)
        .toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    final tokens = tokensOf(manaCost);
    if (tokens.isEmpty) {
      return const SizedBox.shrink();
    }
    return Wrap(
      spacing: AppSpacing.xxs,
      runSpacing: AppSpacing.xxs,
      children: [
        for (final token in tokens) _ManaPip(symbol: token, size: size),
      ],
    );
  }
}

class _ManaPip extends StatelessWidget {
  const _ManaPip({required this.symbol, required this.size});

  final String symbol;
  final double size;

  @override
  Widget build(BuildContext context) {
    final style = _styleFor(symbol);
    final label = _labelFor(symbol);
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: style.background,
        border: Border.all(color: style.border, width: 1),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: size * (label.length > 2 ? 0.38 : 0.52),
          fontWeight: FontWeight.w700,
          height: 1,
          color: style.foreground,
        ),
      ),
    );
  }
}

class _PipStyle {
  const _PipStyle({
    required this.background,
    required this.foreground,
    required this.border,
  });

  final Color background;
  final Color foreground;
  final Color border;
}

_PipStyle _styleFor(String symbol) {
  final key = symbol.toUpperCase();
  // Hybrid / phyrexian: use first color letter when present.
  final colorLetter = RegExp(r'[WUBRGC]').firstMatch(key)?.group(0);
  return switch (colorLetter) {
    'W' => const _PipStyle(
        background: Color(0xFFF8F6D8),
        foreground: Color(0xFF1A1A1A),
        border: Color(0xFFC9C4A1),
      ),
    'U' => const _PipStyle(
        background: Color(0xFF0E68AB),
        foreground: Colors.white,
        border: Color(0xFF0A4F82),
      ),
    'B' => const _PipStyle(
        background: Color(0xFF2B2B2B),
        foreground: Colors.white,
        border: Color(0xFF111111),
      ),
    'R' => const _PipStyle(
        background: Color(0xFFD3202A),
        foreground: Colors.white,
        border: Color(0xFFA31820),
      ),
    'G' => const _PipStyle(
        background: Color(0xFF00733E),
        foreground: Colors.white,
        border: Color(0xFF00522C),
      ),
    _ => const _PipStyle(
        background: Color(0xFFCAC5C0),
        foreground: Color(0xFF1A1A1A),
        border: Color(0xFF9E9891),
      ),
  };
}

String _labelFor(String symbol) {
  final trimmed = symbol.trim();
  if (trimmed.contains('/')) {
    return trimmed.replaceAll('/', '');
  }
  if (trimmed.toUpperCase().endsWith('P') && trimmed.length > 1) {
    // Phyrexian e.g. WP → Wφ-ish; keep letter + P compact.
    return trimmed.toUpperCase();
  }
  return trimmed.toUpperCase();
}
