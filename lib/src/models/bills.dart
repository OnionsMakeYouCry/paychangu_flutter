import '../core/json_utils.dart';
import 'common.dart';

/// Bill payment / airtime request models and resilient responses.

class ValidateBillRequest {
  /// Biller.
  final String biller;

  /// Account.
  final String account;

  /// Account type.
  final String? accountType;

  /// Amount.
  final String? amount;

  /// Creates a [ValidateBillRequest].
  const ValidateBillRequest({
    required this.biller,
    required this.account,
    this.accountType,
    this.amount,
  });

  /// To json.
  Map<String, dynamic> toJson() => {
        'biller': biller,
        'account': account,
        if (accountType != null) 'account_type': accountType,
        if (amount != null) 'amount': amount,
      };
}

class PayBillRequest {
  /// Biller.
  final String biller;

  /// Account.
  final String account;

  /// Amount.
  final String? amount;

  /// Customer name.
  final String? customerName;

  /// Account type.
  final String? accountType;

  /// Reference.
  final String? reference;

  /// Creates a [PayBillRequest].
  const PayBillRequest({
    required this.biller,
    required this.account,
    this.amount,
    this.customerName,
    this.accountType,
    this.reference,
  });

  /// To json.
  Map<String, dynamic> toJson() => {
        'biller': biller,
        'account': account,
        if (amount != null) 'amount': amount,
        if (customerName != null) 'customer_name': customerName,
        if (accountType != null) 'account_type': accountType,
        if (reference != null) 'reference': reference,
      };
}

class AirtimeRechargeRequest {
  /// Phone.
  final String phone;

  /// Amount.
  final String amount;

  /// Reference.
  final String? reference;

  /// Creates a [AirtimeRechargeRequest].
  const AirtimeRechargeRequest({
    required this.phone,
    required this.amount,
    this.reference,
  });

  /// To json.
  Map<String, dynamic> toJson() => {
        'phone': phone,
        'amount': amount,
        if (reference != null) 'reference': reference,
      };
}

/// Generic bills envelope — official schemas are sparse.
class BillsApiResponse {
  /// Status.
  final String status;

  /// Message.
  final String message;

  /// Data.
  final dynamic data;

  /// Raw.
  final Map<String, dynamic> raw;

  /// Creates a [BillsApiResponse].
  const BillsApiResponse({
    required this.status,
    required this.message,
    this.data,
    required this.raw,
  });

  /// Parses a [BillsApiResponse] from JSON.
  factory BillsApiResponse.fromJson(Map<String, dynamic> json) {
    return BillsApiResponse(
      status: JsonUtils.asStringRequired(json['status'], 'success'),
      message: JsonUtils.asStringRequired(json['message']),
      data: json['data'] ?? json,
      raw: json,
    );
  }

  Map<String, dynamic>? get dataAsMap => JsonUtils.asMap(data);

  List<dynamic> get dataAsList => JsonUtils.asList(data);
}

/// Re-export helper for consumers that only import bills models.
typedef GenericApiResponse = ApiResponse;
