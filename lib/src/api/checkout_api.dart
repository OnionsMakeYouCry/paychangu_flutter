import '../core/paychangu_client.dart';
import '../models/checkout.dart';
import '../models/payment_request.dart';

/// Hosted checkout APIs.
class CheckoutApi {
  final PayChanguClient _client;

  /// Creates a [CheckoutApi] bound to the shared HTTP client.
  CheckoutApi(this._client);

  /// Initiates a hosted payment session (`POST /payment`).
  Future<PaymentSessionResponse> initiatePayment(PaymentRequest request) async {
    final json = await _client.post('/payment', body: request.toJson());
    return PaymentSessionResponse.fromJson(json);
  }

  /// Verifies a payment by transaction reference.
  Future<PaymentVerificationResponse> verifyTransaction(String txRef) async {
    final json = await _client.get('/verify-payment/$txRef');
    return PaymentVerificationResponse.fromJson(json);
  }

  /// Client-side sanity check after verification.
  bool validatePayment(
    PaymentVerificationResponse verification, {
    required String expectedTxRef,
    required String expectedCurrency,
    required num expectedAmount,
  }) {
    final data = verification.data;
    final amount = data.amount ?? 0;
    return data.status == 'success' &&
        data.txRef == expectedTxRef &&
        (data.currency?.toUpperCase() == expectedCurrency.toUpperCase() ||
            (expectedCurrency.toUpperCase() == 'MWK' &&
                data.currency?.toUpperCase() == 'MK')) &&
        amount >= expectedAmount;
  }
}
