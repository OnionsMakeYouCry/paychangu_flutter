import '../core/paychangu_client.dart';
import '../models/balance.dart';
import '../models/enums.dart';
import '../models/mobile_money.dart';

/// Mobile money collection + operators + wallet balance.
class MobileMoneyApi {
  final PayChanguClient _client;

  /// Creates a [MobileMoneyApi] bound to the shared HTTP client.

  MobileMoneyApi(this._client);

  /// `GET /mobile-money`
  Future<MobileMoneyOperatorsResponse> getOperators() async {
    final json = await _client.get('/mobile-money');
    return MobileMoneyOperatorsResponse.fromJson(json);
  }

  /// `POST /mobile-money/payments/initialize`
  Future<MobileMoneyTransactionResponse> charge(
    MobileMoneyChargeRequest request,
  ) async {
    final json = await _client.post(
      '/mobile-money/payments/initialize',
      body: request.toJson(),
    );
    return MobileMoneyTransactionResponse.fromJson(json);
  }

  /// `GET /mobile-money/payments/{chargeId}/verify`
  Future<MobileMoneyTransactionResponse> verifyCharge(String chargeId) async {
    final json = await _client.get('/mobile-money/payments/$chargeId/verify');
    return MobileMoneyTransactionResponse.fromJson(json);
  }

  /// `GET /mobile-money/payments/{chargeId}/details`
  Future<MobileMoneyTransactionResponse> getChargeDetails(
    String chargeId,
  ) async {
    final json = await _client.get('/mobile-money/payments/$chargeId/details');
    return MobileMoneyTransactionResponse.fromJson(json);
  }

  /// `GET /wallet-balance`
  Future<WalletBalanceResponse> getBalance({
    Currency currency = Currency.MWK,
  }) async {
    final json = await _client.get(
      '/wallet-balance',
      query: {'currency': currency.apiValue},
    );
    return WalletBalanceResponse.fromJson(json);
  }
}
