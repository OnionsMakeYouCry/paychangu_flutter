import '../core/paychangu_client.dart';
import '../models/mobile_money.dart';

/// Mobile money payout APIs.
class MobileMoneyPayoutApi {
  final PayChanguClient _client;

  /// Creates a [MobileMoneyPayoutApi] bound to the shared HTTP client.

  MobileMoneyPayoutApi(this._client);

  /// `POST /mobile-money/payouts/initialize`
  Future<MobileMoneyTransactionResponse> initialize(
    MobileMoneyPayoutRequest request,
  ) async {
    final json = await _client.post(
      '/mobile-money/payouts/initialize',
      body: request.toJson(),
    );
    return MobileMoneyTransactionResponse.fromJson(json);
  }

  /// `GET /mobile-money/payments/{chargeId}/details`
  Future<MobileMoneyTransactionResponse> getDetails(String chargeId) async {
    final json = await _client.get('/mobile-money/payments/$chargeId/details');
    return MobileMoneyTransactionResponse.fromJson(json);
  }
}
