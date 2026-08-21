import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _enabledKey = 'mtg.scryfall.enabled';

/// Whether MTG catalog network enrichment is enabled (default on).
final catalogEnabledProvider =
    NotifierProvider<CatalogEnabledController, bool>(
  CatalogEnabledController.new,
);

class CatalogEnabledController extends Notifier<bool> {
  @override
  bool build() {
    _load();
    return true;
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getBool(_enabledKey) ?? true;
  }

  Future<void> setEnabled(bool value) async {
    state = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_enabledKey, value);
  }
}
