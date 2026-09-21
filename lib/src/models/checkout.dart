import '../core/json_utils.dart';
import 'common.dart';

/// Response from `POST /payment`.
class PaymentSessionResponse {
  /// Top-level API status.
  final String status;

  /// Top-level API message.
  final String message;

  /// Session payload including checkout URL.
  final PaymentSessionData data;

  /// Creates a payment session response.
  const PaymentSessionResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  /// Parses a payment session response from JSON.
  factory PaymentSessionResponse.fromJson(Map<String, dynamic> json) {
    return PaymentSessionResponse(
      status: JsonUtils.asStringRequired(json['status']),
      message: JsonUtils.asStringRequired(json['message']),
      data: PaymentSessionData.fromJson(JsonUtils.asMap(json['data']) ?? {}),
    );
  }
}

/// Nested session data from payment initiation.
class PaymentSessionData {
  /// Session event name when present.
  final String? event;

  /// Hosted checkout URL to open in a WebView or browser.
  final String checkoutUrl;

  /// Nested pending transaction details.
  final PaymentSessionDetails? details;

  /// Creates payment session data.
  const PaymentSessionData({
    this.event,
    required this.checkoutUrl,
    this.details,
  });

  /// Parses payment session data from JSON.
  factory PaymentSessionData.fromJson(Map<String, dynamic> json) {
    return PaymentSessionData(
      event: JsonUtils.asString(json['event']),
      checkoutUrl: JsonUtils.asStringRequired(json['checkout_url']),
      details: json['data'] != null
          ? PaymentSessionDetails.fromJson(JsonUtils.asMap(json['data']) ?? {})
          : null,
    );
  }
}

/// Pending transaction details inside a created checkout session.
class PaymentSessionDetails {
  /// Transaction reference.
  final String? txRef;

  /// Currency code.
  final String? currency;

  /// Amount.
  final num? amount;

  /// `sandbox` or `live`.
  final String? mode;

  /// Pending/session status.
  final String? status;

  /// Creates payment session details.
  const PaymentSessionDetails({
    this.txRef,
    this.currency,
    this.amount,
    this.mode,
    this.status,
  });

  /// Parses payment session details from JSON.
  factory PaymentSessionDetails.fromJson(Map<String, dynamic> json) {
    return PaymentSessionDetails(
      txRef: JsonUtils.asString(json['tx_ref']),
      currency: JsonUtils.asString(json['currency']),
      amount:
          JsonUtils.asDouble(json['amount']) ?? JsonUtils.asInt(json['amount']),
      mode: JsonUtils.asString(json['mode']),
      status: JsonUtils.asString(json['status']),
    );
  }
}

/// Response from `GET /verify-payment/{tx_ref}`.
class PaymentVerificationResponse {
  /// Top-level API status.
  final String status;

  /// Top-level API message.
  final String message;

  /// Verified payment details.
  final VerificationData data;

  /// Creates a verification response.
  const PaymentVerificationResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  /// Parses a verification response from JSON.
  factory PaymentVerificationResponse.fromJson(Map<String, dynamic> json) {
    return PaymentVerificationResponse(
      status: JsonUtils.asStringRequired(json['status']),
      message: JsonUtils.asStringRequired(json['message']),
      data: VerificationData.fromJson(JsonUtils.asMap(json['data']) ?? {}),
    );
  }
}

/// Verified payment payload.
class VerificationData {
  /// Event type string.
  final String? eventType;

  /// Merchant transaction reference.
  final String? txRef;

  /// `live` or `sandbox`/`test`.
  final String? mode;

  /// Payment type description.
  final String? type;

  /// Payment status (`success`, `failed`, …).
  final String? status;

  /// Number of payment attempts.
  final int? numberOfAttempts;

  /// PayChangu reference.
  final String? reference;

  /// Currency code.
  final String? currency;

  /// Charged amount.
  final num? amount;

  /// Fees/charges.
  final num? charges;

  /// Checkout customization snapshot.
  final CustomizationData? customization;

  /// Merchant metadata.
  final dynamic meta;

  /// Authorization details.
  final AuthorizationData? authorization;

  /// Customer snapshot.
  final CustomerData? customer;

  /// Processing logs.
  final List<LogEntry> logs;

  /// Created timestamp.
  final String? createdAt;

  /// Updated timestamp.
  final String? updatedAt;

  /// Creates verification data.
  const VerificationData({
    this.eventType,
    this.txRef,
    this.mode,
    this.type,
    this.status,
    this.numberOfAttempts,
    this.reference,
    this.currency,
    this.amount,
    this.charges,
    this.customization,
    this.meta,
    this.authorization,
    this.customer,
    this.logs = const [],
    this.createdAt,
    this.updatedAt,
  });

  /// Parses verification data from JSON.
  factory VerificationData.fromJson(Map<String, dynamic> json) {
    return VerificationData(
      eventType: JsonUtils.asString(json['event_type']),
      txRef: JsonUtils.asString(json['tx_ref']),
      mode: JsonUtils.asString(json['mode']),
      type: JsonUtils.asString(json['type']),
      status: JsonUtils.asString(json['status']),
      numberOfAttempts: JsonUtils.asInt(json['number_of_attempts']),
      reference: JsonUtils.asString(json['reference']),
      currency: JsonUtils.asString(json['currency']),
      amount:
          JsonUtils.asDouble(json['amount']) ?? JsonUtils.asInt(json['amount']),
      charges: JsonUtils.asDouble(json['charges']) ??
          JsonUtils.asInt(json['charges']),
      customization: json['customization'] != null
          ? CustomizationData.fromJson(JsonUtils.asMap(json['customization']))
          : null,
      meta: json['meta'],
      authorization: json['authorization'] != null
          ? AuthorizationData.fromJson(JsonUtils.asMap(json['authorization']))
          : null,
      customer: json['customer'] != null
          ? CustomerData.fromJson(JsonUtils.asMap(json['customer']))
          : null,
      logs: JsonUtils.asList(json['logs'])
          .whereType<Map>()
          .map((e) => LogEntry.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
      createdAt: JsonUtils.asString(json['created_at']),
      updatedAt: JsonUtils.asString(json['updated_at']),
    );
  }
}
