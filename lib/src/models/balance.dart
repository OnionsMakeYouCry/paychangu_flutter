import '../core/json_utils.dart';
import 'enums.dart';

/// Wallet balance response (`GET /wallet-balance`).
class WalletBalanceResponse {
  /// Status.
  final String status;

  /// Message.
  final String message;

  /// Data.
  final WalletBalanceData data;

  /// Creates a [WalletBalanceResponse].
  const WalletBalanceResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  /// Parses a [WalletBalanceResponse] from JSON.
  factory WalletBalanceResponse.fromJson(Map<String, dynamic> json) {
    return WalletBalanceResponse(
      status: JsonUtils.asStringRequired(json['status']),
      message: JsonUtils.asStringRequired(json['message']),
      data: WalletBalanceData.fromJson(JsonUtils.asMap(json['data']) ?? {}),
    );
  }
}

class WalletBalanceData {
  /// Environment.
  final String? environment;

  /// Currency.
  final String? currency;

  /// Main balance.
  final String? mainBalance;

  /// Collection balance.
  final num? collectionBalance;

  /// Creates a [WalletBalanceData].
  const WalletBalanceData({
    this.environment,
    this.currency,
    this.mainBalance,
    this.collectionBalance,
  });

  /// Parses a [WalletBalanceData] from JSON.
  factory WalletBalanceData.fromJson(Map<String, dynamic> json) {
    return WalletBalanceData(
      environment: JsonUtils.asString(json['environment']),
      currency: JsonUtils.asString(json['currency']),
      mainBalance: JsonUtils.asString(json['main_balance']),
      collectionBalance: JsonUtils.asDouble(json['collection_balance']) ??
          JsonUtils.asInt(json['collection_balance']),
    );
  }
}

/// Convenience request helper for balance lookups.
class BalanceQuery {
  /// Currency.
  final Currency currency;

  /// Creates a [BalanceQuery].
  const BalanceQuery({this.currency = Currency.MWK});
}
