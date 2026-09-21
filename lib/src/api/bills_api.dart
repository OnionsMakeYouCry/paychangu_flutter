import '../core/paychangu_client.dart';
import '../models/bills.dart';

/// Bill payments and airtime.
class BillsApi {
  final PayChanguClient _client;

  /// Creates a [BillsApi] bound to the shared HTTP client.

  BillsApi(this._client);

  /// `GET /bills/getBillers`
  Future<BillsApiResponse> getBillers() async {
    final json = await _client.get('/bills/getBillers');
    return BillsApiResponse.fromJson(json);
  }

  /// `GET /bills/getBillers/{biller_id}`
  Future<BillsApiResponse> getBillerDetails(String billerId) async {
    final json = await _client.get('/bills/getBillers/$billerId');
    return BillsApiResponse.fromJson(json);
  }

  /// `POST /bills/validate`
  Future<BillsApiResponse> validateBill(ValidateBillRequest request) async {
    final json = await _client.post('/bills/validate', body: request.toJson());
    return BillsApiResponse.fromJson(json);
  }

  /// `POST /bills/pay`
  Future<BillsApiResponse> payBill(PayBillRequest request) async {
    final json = await _client.post('/bills/pay', body: request.toJson());
    return BillsApiResponse.fromJson(json);
  }

  /// `POST /bills/buy-airtime`
  Future<BillsApiResponse> buyAirtime(AirtimeRechargeRequest request) async {
    final json =
        await _client.post('/bills/buy-airtime', body: request.toJson());
    return BillsApiResponse.fromJson(json);
  }

  /// `GET /bills/getTransactions/{reference}`
  Future<BillsApiResponse> getBillTransaction(String reference) async {
    final json = await _client.get('/bills/getTransactions/$reference');
    return BillsApiResponse.fromJson(json);
  }

  /// `GET /bills/getStatistics`
  Future<BillsApiResponse> getStatistics() async {
    final json = await _client.get('/bills/getStatistics');
    return BillsApiResponse.fromJson(json);
  }
}
