/// Configuration for the PayChangu SDK.
class PayChanguConfig {
  /// Secret API key used as `Authorization: Bearer {secretKey}`.
  ///
  /// Prefer keeping this on your server for payouts, card charges, and bills.
  final String secretKey;

  /// When `true`, documents sandbox usage. Live vs sandbox is determined by the key.
  final bool isTestMode;

  /// API base URL. Override for mocking or proxies.
  final String baseUrl;

  /// HTTP request timeout.
  final Duration timeout;

  /// Creates SDK configuration.
  const PayChanguConfig({
    required this.secretKey,
    this.isTestMode = false,
    this.baseUrl = 'https://api.paychangu.com',
    this.timeout = const Duration(seconds: 30),
  });
}
