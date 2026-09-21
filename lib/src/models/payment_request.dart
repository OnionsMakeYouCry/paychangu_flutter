import 'enums.dart';

/// Hosted checkout payment request (`POST /payment`).
class PaymentRequest {
  /// Merchant transaction reference (must be unique when provided).
  final String? txRef;

  /// Customer first name.
  final String? firstName;

  /// Customer last name.
  final String? lastName;

  /// Customer email for receipts.
  final String? email;

  /// Charge currency.
  final Currency currency;

  /// Amount to charge.
  final num amount;

  /// Success / IPN redirect URL.
  final String callbackUrl;

  /// Cancel / failure return URL.
  final String returnUrl;

  /// Optional checkout title/description customization.
  final Map<String, String>? customization;

  /// Optional merchant metadata.
  final dynamic meta;

  /// Optional UUID passthrough.
  final String? uuid;

  /// Creates a hosted checkout request.
  PaymentRequest({
    this.txRef,
    this.firstName,
    this.lastName,
    this.email,
    required this.currency,
    required this.amount,
    required this.callbackUrl,
    required this.returnUrl,
    this.customization,
    this.meta,
    this.uuid,
  });

  /// Serializes the request for `POST /payment`.
  Map<String, dynamic> toJson() {
    return {
      'amount': amount.toString(),
      'currency': currency.apiValue,
      'callback_url': callbackUrl,
      'return_url': returnUrl,
      if (txRef != null) 'tx_ref': txRef,
      if (firstName != null) 'first_name': firstName,
      if (lastName != null) 'last_name': lastName,
      if (email != null) 'email': email,
      if (customization != null) 'customization': customization,
      if (meta != null) 'meta': meta,
      if (uuid != null) 'uuid': uuid,
    };
  }
}
