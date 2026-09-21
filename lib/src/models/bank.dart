import '../core/json_utils.dart';
import 'common.dart';
import 'enums.dart';

/// Bank transfer charge request (`POST /direct-charge/payments/initialize`).
class BankTransferChargeRequest {
  /// Amount.
  final String amount;

  /// Currency.
  final Currency currency;

  /// Charge id.
  final String chargeId;

  /// Payment method.
  final String paymentMethod;

  /// Email.
  final String? email;

  /// First name.
  final String? firstName;

  /// Last name.
  final String? lastName;

  /// Mobile.
  final String? mobile;

  /// Create permanent account.
  final bool? createPermanentAccount;

  /// Creates a [BankTransferChargeRequest].
  const BankTransferChargeRequest({
    required this.amount,
    this.currency = Currency.MWK,
    required this.chargeId,
    this.paymentMethod = 'mobile_bank_transfer',
    this.email,
    this.firstName,
    this.lastName,
    this.mobile,
    this.createPermanentAccount,
  });

  /// To json.
  Map<String, dynamic> toJson() => {
        'amount': amount,
        'currency': currency.apiValue,
        'payment_method': paymentMethod,
        'charge_id': chargeId,
        if (email != null) 'email': email,
        if (firstName != null) 'first_name': firstName,
        if (lastName != null) 'last_name': lastName,
        if (mobile != null) 'mobile': mobile,
        if (createPermanentAccount != null)
          'create_permanent_account': createPermanentAccount,
      };
}

class PaymentAccountDetails {
  /// Bank name.
  final String? bankName;

  /// Account number.
  final String? accountNumber;

  /// Account name.
  final String? accountName;

  /// Account expiration timestamp.
  final int? accountExpirationTimestamp;

  /// Creates a [PaymentAccountDetails].
  const PaymentAccountDetails({
    this.bankName,
    this.accountNumber,
    this.accountName,
    this.accountExpirationTimestamp,
  });

  /// Parses a [PaymentAccountDetails] from JSON.
  factory PaymentAccountDetails.fromJson(Map<String, dynamic>? json) {
    final map = json ?? const {};
    return PaymentAccountDetails(
      bankName: JsonUtils.asString(map['bank_name']),
      accountNumber: JsonUtils.asString(map['account_number']),
      accountName: JsonUtils.asString(map['account_name']),
      accountExpirationTimestamp:
          JsonUtils.asInt(map['account_expiration_timestamp']),
    );
  }
}

class BankTransferTransaction {
  /// Charge id.
  final String? chargeId;

  /// Ref id.
  final String? refId;

  /// Trans id.
  final String? transId;

  /// Currency.
  final String? currency;

  /// Amount.
  final num? amount;

  /// First name.
  final String? firstName;

  /// Last name.
  final String? lastName;

  /// Email.
  final String? email;

  /// Type.
  final String? type;

  /// Trace id.
  final String? traceId;

  /// Status.
  final String? status;

  /// Mobile.
  final String? mobile;

  /// Attempts.
  final int? attempts;

  /// Mode.
  final String? mode;

  /// Created at.
  final String? createdAt;

  /// Completed at.
  final String? completedAt;

  /// Event type.
  final String? eventType;

  /// Transaction charges.
  final TransactionCharges? transactionCharges;

  /// Authorization.
  final AuthorizationData? authorization;

  /// Recipient account details.
  final RecipientAccountDetails? recipientAccountDetails;

  /// Logs.
  final List<LogEntry> logs;

  /// Creates a [BankTransferTransaction].
  const BankTransferTransaction({
    this.chargeId,
    this.refId,
    this.transId,
    this.currency,
    this.amount,
    this.firstName,
    this.lastName,
    this.email,
    this.type,
    this.traceId,
    this.status,
    this.mobile,
    this.attempts,
    this.mode,
    this.createdAt,
    this.completedAt,
    this.eventType,
    this.transactionCharges,
    this.authorization,
    this.recipientAccountDetails,
    this.logs = const [],
  });

  /// Parses a [BankTransferTransaction] from JSON.
  factory BankTransferTransaction.fromJson(Map<String, dynamic> json) {
    return BankTransferTransaction(
      chargeId: JsonUtils.asString(json['charge_id']),
      refId: JsonUtils.asString(json['ref_id']),
      transId: JsonUtils.asString(json['trans_id']),
      currency: JsonUtils.asString(json['currency']),
      amount:
          JsonUtils.asDouble(json['amount']) ?? JsonUtils.asInt(json['amount']),
      firstName: JsonUtils.asString(json['first_name']),
      lastName: JsonUtils.asString(json['last_name']),
      email: JsonUtils.asString(json['email']),
      type: JsonUtils.asString(json['type']),
      traceId: JsonUtils.asString(json['trace_id']),
      status: JsonUtils.asString(json['status']),
      mobile: JsonUtils.asString(json['mobile']),
      attempts: JsonUtils.asInt(json['attempts']),
      mode: JsonUtils.asString(json['mode']),
      createdAt: JsonUtils.asString(json['created_at']),
      completedAt: JsonUtils.asString(json['completed_at']),
      eventType: JsonUtils.asString(json['event_type']),
      transactionCharges: json['transaction_charges'] != null
          ? TransactionCharges.fromJson(
              JsonUtils.asMap(json['transaction_charges']),
            )
          : null,
      authorization: json['authorization'] != null
          ? AuthorizationData.fromJson(JsonUtils.asMap(json['authorization']))
          : null,
      recipientAccountDetails: json['recipient_account_details'] != null
          ? RecipientAccountDetails.fromJson(
              JsonUtils.asMap(json['recipient_account_details']),
            )
          : null,
      logs: JsonUtils.asList(json['logs'])
          .whereType<Map>()
          .map((e) => LogEntry.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
    );
  }
}

class RecipientAccountDetails {
  /// Bank uuid.
  final String? bankUuid;

  /// Bank name.
  final String? bankName;

  /// Account name.
  final String? accountName;

  /// Account number.
  final String? accountNumber;

  /// Creates a [RecipientAccountDetails].
  const RecipientAccountDetails({
    this.bankUuid,
    this.bankName,
    this.accountName,
    this.accountNumber,
  });

  /// Parses a [RecipientAccountDetails] from JSON.
  factory RecipientAccountDetails.fromJson(Map<String, dynamic>? json) {
    final map = json ?? const {};
    return RecipientAccountDetails(
      bankUuid: JsonUtils.asString(map['bank_uuid']),
      bankName: JsonUtils.asString(map['bank_name']),
      accountName: JsonUtils.asString(map['account_name']),
      accountNumber: JsonUtils.asString(map['account_number']),
    );
  }
}

class BankTransferInitResponse {
  /// Status.
  final String status;

  /// Message.
  final String message;

  /// Payment account details.
  final PaymentAccountDetails? paymentAccountDetails;

  /// Transaction.
  final BankTransferTransaction? transaction;

  /// Creates a [BankTransferInitResponse].
  const BankTransferInitResponse({
    required this.status,
    required this.message,
    this.paymentAccountDetails,
    this.transaction,
  });

  /// Parses a [BankTransferInitResponse] from JSON.
  factory BankTransferInitResponse.fromJson(Map<String, dynamic> json) {
    final data = JsonUtils.asMap(json['data']) ?? {};
    return BankTransferInitResponse(
      status: JsonUtils.asStringRequired(json['status']),
      message: JsonUtils.asStringRequired(json['message']),
      paymentAccountDetails: data['payment_account_details'] != null
          ? PaymentAccountDetails.fromJson(
              JsonUtils.asMap(data['payment_account_details']),
            )
          : null,
      transaction: data['transaction'] != null
          ? BankTransferTransaction.fromJson(
              JsonUtils.asMap(data['transaction']) ?? {},
            )
          : null,
    );
  }
}

class BankTransferDetailsResponse {
  /// Status.
  final String status;

  /// Message.
  final String message;

  /// Transaction.
  final BankTransferTransaction? transaction;

  /// Creates a [BankTransferDetailsResponse].
  const BankTransferDetailsResponse({
    required this.status,
    required this.message,
    this.transaction,
  });

  /// Parses a [BankTransferDetailsResponse] from JSON.
  factory BankTransferDetailsResponse.fromJson(Map<String, dynamic> json) {
    final data = JsonUtils.asMap(json['data']) ?? {};

    /// Data.
    final txMap = JsonUtils.asMap(data['transaction']) ?? data;
    return BankTransferDetailsResponse(
      status: JsonUtils.asStringRequired(json['status']),
      message: JsonUtils.asStringRequired(json['message']),
      transaction: BankTransferTransaction.fromJson(txMap),
    );
  }
}

/// Bank for payouts (`GET /direct-charge/payouts/supported-banks`).
class Bank {
  /// Uuid.
  final String? uuid;

  /// Name.
  final String? name;

  /// Creates a [Bank].
  const Bank({this.uuid, this.name});

  /// Parses a [Bank] from JSON.
  factory Bank.fromJson(Map<String, dynamic> json) {
    return Bank(
      uuid: JsonUtils.asString(json['uuid']),
      name: JsonUtils.asString(json['name']),
    );
  }
}

class BanksResponse {
  /// Status.
  final String status;

  /// Message.
  final String message;

  /// Data.
  final List<Bank> data;

  /// Creates a [BanksResponse].
  const BanksResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  /// Parses a [BanksResponse] from JSON.
  factory BanksResponse.fromJson(Map<String, dynamic> json) {
    return BanksResponse(
      status: JsonUtils.asStringRequired(json['status']),
      message: JsonUtils.asStringRequired(json['message']),
      data: JsonUtils.asList(json['data'])
          .whereType<Map>()
          .map((e) => Bank.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
    );
  }
}

/// Bank payout request (`POST /direct-charge/payouts/initialize`).
class BankPayoutRequest {
  /// Bank uuid.
  final String bankUuid;

  /// Amount.
  final String amount;

  /// Charge id.
  final String chargeId;

  /// Bank account name.
  final String bankAccountName;

  /// Bank account number.
  final String bankAccountNumber;

  /// Payout method.
  final String payoutMethod;

  /// Email.
  final String? email;

  /// First name.
  final String? firstName;

  /// Last name.
  final String? lastName;

  /// Creates a [BankPayoutRequest].
  const BankPayoutRequest({
    required this.bankUuid,
    required this.amount,
    required this.chargeId,
    required this.bankAccountName,
    required this.bankAccountNumber,
    this.payoutMethod = 'bank_transfer',
    this.email,
    this.firstName,
    this.lastName,
  });

  /// To json.
  Map<String, dynamic> toJson() => {
        'payout_method': payoutMethod,
        'bank_uuid': bankUuid,
        'amount': amount,
        'charge_id': chargeId,
        'bank_account_name': bankAccountName,
        'bank_account_number': bankAccountNumber,
        if (email != null) 'email': email,
        if (firstName != null) 'first_name': firstName,
        if (lastName != null) 'last_name': lastName,
      };
}

class BankPayoutResponse {
  /// Status.
  final String status;

  /// Message.
  final String message;

  /// Transaction.
  final BankTransferTransaction? transaction;

  /// Creates a [BankPayoutResponse].
  const BankPayoutResponse({
    required this.status,
    required this.message,
    this.transaction,
  });

  /// Parses a [BankPayoutResponse] from JSON.
  factory BankPayoutResponse.fromJson(Map<String, dynamic> json) {
    final data = JsonUtils.asMap(json['data']) ?? {};

    /// Data.
    final tx = JsonUtils.asMap(data['transaction']) ?? data;
    return BankPayoutResponse(
      status: JsonUtils.asStringRequired(json['status']),
      message: JsonUtils.asStringRequired(json['message']),
      transaction: BankTransferTransaction.fromJson(tx),
    );
  }
}

class BankPayoutListResponse {
  /// Status.
  final String status;

  /// Message.
  final String message;

  /// Current page.
  final int? currentPage;

  /// Total pages.
  final int? totalPages;

  /// Per page.
  final int? perPage;

  /// Next page url.
  final String? nextPageUrl;

  /// Transactions.
  final List<BankTransferTransaction> transactions;

  /// Creates a [BankPayoutListResponse].
  const BankPayoutListResponse({
    required this.status,
    required this.message,
    this.currentPage,
    this.totalPages,
    this.perPage,
    this.nextPageUrl,
    this.transactions = const [],
  });

  /// Parses a [BankPayoutListResponse] from JSON.
  factory BankPayoutListResponse.fromJson(Map<String, dynamic> json) {
    final data = JsonUtils.asMap(json['data']) ?? {};
    return BankPayoutListResponse(
      status: JsonUtils.asStringRequired(json['status']),
      message: JsonUtils.asStringRequired(json['message']),
      currentPage: JsonUtils.asInt(data['current_page']),
      totalPages: JsonUtils.asInt(data['total_pages']),
      perPage: JsonUtils.asInt(data['per_page']),
      nextPageUrl: JsonUtils.asString(data['next_page_url']),
      transactions: JsonUtils.asList(data['data'])
          .whereType<Map>()
          .map(
            (e) =>
                BankTransferTransaction.fromJson(Map<String, dynamic>.from(e)),
          )
          .toList(),
    );
  }
}
