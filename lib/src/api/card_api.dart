import '../core/paychangu_client.dart';
import '../models/card.dart';
import '../models/common.dart';

/// Direct card charge APIs (PCI-sensitive — prefer server-side use).
class CardApi {
  final PayChanguClient _client;

  /// Creates a [CardApi] bound to the shared HTTP client.

  CardApi(this._client);

  /// `POST /charge-card/payments`
  Future<CardChargeResponse> charge(CardChargeRequest request) async {
    final json =
        await _client.post('/charge-card/payments', body: request.toJson());
    return CardChargeResponse.fromJson(json);
  }

  /// `GET /charge-card/verify/{charge_id}`
  Future<ApiResponse> verify(String chargeId) async {
    final json = await _client.get('/charge-card/verify/$chargeId');
    return ApiResponse.fromJson(json);
  }

  /// `POST /charge-card/refund/{charge_id}`
  Future<ApiResponse> refund(String chargeId) async {
    final json = await _client.post('/charge-card/refund/$chargeId');
    return ApiResponse.fromJson(json);
  }
}
