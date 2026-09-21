import '../core/paychangu_client.dart';
import '../models/bank.dart';
import '../models/enums.dart';

/// Bank transfer collection APIs.
class BankTransferApi {
  final PayChanguClient _client;

  /// Creates a [BankTransferApi] bound to the shared HTTP client.

  BankTransferApi(this._client);

  /// `POST /direct-charge/payments/initialize`
  Future<BankTransferInitResponse> initialize(
    BankTransferChargeRequest request,
  ) async {
    final json = await _client.post(
      '/direct-charge/payments/initialize',
      body: request.toJson(),
    );
    return BankTransferInitResponse.fromJson(json);
  }

  /// `GET /direct-charge/transactions/{charge_id}/details`
  Future<BankTransferDetailsResponse> getDetails(String chargeId) async {
    final json =
        await _client.get('/direct-charge/transactions/$chargeId/details');
    return BankTransferDetailsResponse.fromJson(json);
  }
}

/// Bank + MoMo payout APIs.
class PayoutsApi {
  final PayChanguClient _client;

  /// Creates a [PayoutsApi] bound to the shared HTTP client.

  PayoutsApi(this._client);

  /// `GET /direct-charge/payouts/supported-banks`
  Future<BanksResponse> getBanks({Currency currency = Currency.MWK}) async {
    final json = await _client.get(
      '/direct-charge/payouts/supported-banks',
      query: {'currency': currency.apiValue},
    );
    return BanksResponse.fromJson(json);
  }

  /// `POST /direct-charge/payouts/initialize`
  Future<BankPayoutResponse> initializeBankPayout(
    BankPayoutRequest request,
  ) async {
    final json = await _client.post(
      '/direct-charge/payouts/initialize',
      body: request.toJson(),
    );
    return BankPayoutResponse.fromJson(json);
  }

  /// `GET /direct-charge/payouts/{charge_id}/details`
  Future<BankPayoutResponse> getBankPayoutDetails(String chargeId) async {
    final json = await _client.get('/direct-charge/payouts/$chargeId/details');
    return BankPayoutResponse.fromJson(json);
  }

  /// `GET /direct-charge/payouts`
  Future<BankPayoutListResponse> listBankPayouts() async {
    final json = await _client.get('/direct-charge/payouts');
    return BankPayoutListResponse.fromJson(json);
  }
}
