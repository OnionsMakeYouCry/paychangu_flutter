import '../core/json_utils.dart';

/// Shared authorization block returned by many PayChangu endpoints.
class AuthorizationData {
  /// Payment channel (for example `Card` or `Mobile Money`).
  final String? channel;

  /// Masked card number when paid by card.
  final String? cardNumber;

  /// Card expiry when applicable.
  final String? expiry;

  /// Card brand when applicable.
  final String? brand;

  /// Provider name (for example a mobile-money operator).
  final String? provider;

  /// Mobile number used for authorization.
  final String? mobileNumber;

  /// Payer bank UUID for bank-transfer payments.
  final String? payerBankUuid;

  /// Payer bank name for bank-transfer payments.
  final String? payerBank;

  /// Payer account number for bank-transfer payments.
  final String? payerAccountNumber;

  /// Payer account name for bank-transfer payments.
  final String? payerAccountName;

  /// Completion timestamp.
  final String? completedAt;

  /// Creates authorization data.
  const AuthorizationData({
    this.channel,
    this.cardNumber,
    this.expiry,
    this.brand,
    this.provider,
    this.mobileNumber,
    this.payerBankUuid,
    this.payerBank,
    this.payerAccountNumber,
    this.payerAccountName,
    this.completedAt,
  });

  /// Parses authorization data from JSON.
  factory AuthorizationData.fromJson(Map<String, dynamic>? json) {
    final map = json ?? const {};
    return AuthorizationData(
      channel: JsonUtils.asString(map['channel']),
      cardNumber: JsonUtils.asString(map['card_number']),
      expiry: JsonUtils.asString(map['expiry']),
      brand: JsonUtils.asString(map['brand']),
      provider: JsonUtils.asString(map['provider']),
      mobileNumber: JsonUtils.asString(map['mobile_number']),
      payerBankUuid: JsonUtils.asString(map['payer_bank_uuid']),
      payerBank: JsonUtils.asString(map['payer_bank']),
      payerAccountNumber: JsonUtils.asString(map['payer_account_number']),
      payerAccountName: JsonUtils.asString(map['payer_account_name']),
      completedAt: JsonUtils.asString(map['completed_at']),
    );
  }
}

/// Mobile money operator summary nested in charge/payout responses.
class MobileMoneyInfo {
  /// Operator display name.
  final String? name;

  /// Operator reference id.
  final String? refId;

  /// Supported country name.
  final String? country;

  /// Creates mobile-money info.
  const MobileMoneyInfo({this.name, this.refId, this.country});

  /// Parses mobile-money info from JSON.
  factory MobileMoneyInfo.fromJson(Map<String, dynamic>? json) {
    final map = json ?? const {};
    return MobileMoneyInfo(
      name: JsonUtils.asString(map['name']),
      refId: JsonUtils.asString(map['ref_id']),
      country: JsonUtils.asString(map['country']),
    );
  }
}

/// Fee / charge amount block.
class TransactionCharges {
  /// Charge currency code.
  final String? currency;

  /// Charge amount as returned by the API.
  final String? amount;

  /// Creates transaction charges.
  const TransactionCharges({this.currency, this.amount});

  /// Parses transaction charges from JSON.
  factory TransactionCharges.fromJson(Map<String, dynamic>? json) {
    final map = json ?? const {};
    return TransactionCharges(
      currency: JsonUtils.asString(map['currency']),
      amount: JsonUtils.asString(map['amount']),
    );
  }
}

/// Log entry from payment/payout responses.
class LogEntry {
  /// Log type.
  final String? type;

  /// Log message.
  final String? message;

  /// Creation timestamp.
  final String? createdAt;

  /// Creates a log entry.
  const LogEntry({this.type, this.message, this.createdAt});

  /// Parses a log entry from JSON.
  factory LogEntry.fromJson(Map<String, dynamic> json) {
    return LogEntry(
      type: JsonUtils.asString(json['type']),
      message: JsonUtils.asString(json['message']),
      createdAt: JsonUtils.asString(json['created_at']),
    );
  }
}

/// Customer block on checkout verification.
class CustomerData {
  /// Customer email.
  final String? email;

  /// Customer first name.
  final String? firstName;

  /// Customer last name.
  final String? lastName;

  /// Creates customer data.
  const CustomerData({this.email, this.firstName, this.lastName});

  /// Parses customer data from JSON.
  factory CustomerData.fromJson(Map<String, dynamic>? json) {
    final map = json ?? const {};
    return CustomerData(
      email: JsonUtils.asString(map['email']),
      firstName: JsonUtils.asString(map['first_name']),
      lastName: JsonUtils.asString(map['last_name']),
    );
  }
}

/// Checkout customization block.
class CustomizationData {
  /// Checkout title.
  final String? title;

  /// Checkout description.
  final String? description;

  /// Optional logo URL.
  final String? logo;

  /// Creates customization data.
  const CustomizationData({this.title, this.description, this.logo});

  /// Parses customization data from JSON.
  factory CustomizationData.fromJson(Map<String, dynamic>? json) {
    final map = json ?? const {};
    return CustomizationData(
      title: JsonUtils.asString(map['title']),
      description: JsonUtils.asString(map['description']),
      logo: JsonUtils.asString(map['logo']),
    );
  }
}

/// Generic API envelope when data shape varies.
class ApiResponse {
  /// API status string (for example `success`).
  final String status;

  /// Human-readable message.
  final String message;

  /// Response payload (map, list, or scalar).
  final dynamic data;

  /// Full decoded JSON body.
  final Map<String, dynamic> raw;

  /// Creates an API response envelope.
  const ApiResponse({
    required this.status,
    required this.message,
    this.data,
    required this.raw,
  });

  /// Parses a generic API response from JSON.
  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      status: JsonUtils.asStringRequired(json['status']),
      message: JsonUtils.asStringRequired(json['message']),
      data: json['data'],
      raw: json,
    );
  }

  /// [data] cast to a map when possible.
  Map<String, dynamic>? get dataAsMap => JsonUtils.asMap(data);

  /// [data] cast to a list when possible.
  List<dynamic> get dataAsList => JsonUtils.asList(data);
}
