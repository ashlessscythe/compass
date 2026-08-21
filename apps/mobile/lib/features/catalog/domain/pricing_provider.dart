/// Separate from [CardMetadataProvider] so TCGplayer / Cardmarket can land later.
abstract interface class PricingProvider {
  /// Returns a display price string if known, otherwise null.
  Future<String?> priceFor({
    required String scryfallId,
    String currency = 'USD',
  });
}

/// v1 stub — no network, no storage.
class NoopPricingProvider implements PricingProvider {
  @override
  Future<String?> priceFor({
    required String scryfallId,
    String currency = 'USD',
  }) async {
    return null;
  }
}
