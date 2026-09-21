import '../core/json_utils.dart';
import 'enums.dart';

/// Card charge request (`POST /charge-card/payments`).
///
/// Prefer calling this from your server — card PAN data is PCI-sensitive.
class CardChargeRequest {
  /// Card number.
  final String cardNumber;

  /// Expiry.
  final String expiry;

  /// Cvv.
  final String cvv;

  /// Cardholder name.
  final String cardholderName;

  /// Amount.
  final String amount;

  /// Currency.
  final Currency currency;

  /// Charge id.
  final String chargeId;

  /// Redirect url.
  final String redirectUrl;

  /// Email.
  final String? email;

  /// Creates a [CardChargeRequest].
  const CardChargeRequest({
    required this.cardNumber,
    required this.expiry,
    required this.cvv,
    required this.cardholderName,
    required this.amount,
    required this.currency,
    required this.chargeId,
    required this.redirectUrl,
    this.email,
  });

  /// To json.
  Map<String, dynamic> toJson() => {
        'card_number': cardNumber,
        'expiry': expiry,
        'cvv': cvv,
        'cardholder_name': cardholderName,
        'amount': amount,
        'currency': currency.apiValue,
        'charge_id': chargeId,
        'redirect_url': redirectUrl,
        if (email != null) 'email': email,
      };
}

class CardChargeResponse {
  /// Success.
  final bool success;

  /// Requires3ds auth.
  final bool requires3dsAuth;

  /// Order reference.
  final String? orderReference;

  /// Three ds auth link.
  final String? threeDsAuthLink;

  /// Raw.
  final Map<String, dynamic> raw;

  /// Creates a [CardChargeResponse].
  const CardChargeResponse({
    required this.success,
    required this.requires3dsAuth,
    this.orderReference,
    this.threeDsAuthLink,
    required this.raw,
  });

  /// Parses a [CardChargeResponse] from JSON.
  factory CardChargeResponse.fromJson(Map<String, dynamic> json) {
    return CardChargeResponse(
      success: JsonUtils.asBool(json['success']) ??
          json['status']?.toString().toLowerCase() == 'success',
      requires3dsAuth: JsonUtils.asBool(json['requires_3ds_auth']) ?? false,
      orderReference: JsonUtils.asString(json['orderReference']) ??
          JsonUtils.asString(json['order_reference']),
      threeDsAuthLink: JsonUtils.asString(json['3ds_auth_link']) ??
          JsonUtils.asString(json['three_ds_auth_link']),
      raw: json,
    );
  }
}
