import 'dart:convert';

import 'package:crypto/crypto.dart';

/// Helpers for authenticating PayChangu webhook requests.
class PayChanguWebhooks {
  const PayChanguWebhooks._();

  /// Returns true when [signatureHeader] matches HMAC-SHA256 of [rawBody]
  /// using [webhookSecret] (from the merchant dashboard).
  static bool verify({
    required String rawBody,
    required String signatureHeader,
    required String webhookSecret,
  }) {
    final digest =
        Hmac(sha256, utf8.encode(webhookSecret)).convert(utf8.encode(rawBody));
    final computed = digest.toString();
    return _constantTimeEquals(computed, signatureHeader.trim());
  }

  static bool _constantTimeEquals(String a, String b) {
    if (a.length != b.length) return false;
    var result = 0;
    for (var i = 0; i < a.length; i++) {
      result |= a.codeUnitAt(i) ^ b.codeUnitAt(i);
    }
    return result == 0;
  }
}
