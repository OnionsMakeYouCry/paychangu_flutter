import '../core/paychangu_client.dart';
import '../models/common.dart';
import '../models/connect_virtual.dart';

/// US virtual bank accounts + customers.
class VirtualAccountsApi {
  final PayChanguClient _client;

  /// Creates a [VirtualAccountsApi] bound to the shared HTTP client.

  VirtualAccountsApi(this._client);

  /// `POST /virtual-account/api/customers/create`
  Future<VirtualCustomerResponse> createCustomer(
    VirtualCustomerRequest request,
  ) async {
    final json = await _client.post(
      '/virtual-account/api/customers/create',
      body: request.toJson(),
    );
    return VirtualCustomerResponse.fromJson(json);
  }

  /// `GET /virtual-account/api/customers`
  Future<ApiResponse> listCustomers({int? page, int? perPage}) async {
    final query = <String, String>{};
    if (page != null) query['page'] = page.toString();
    if (perPage != null) query['per_page'] = perPage.toString();
    final json = await _client.get(
      '/virtual-account/api/customers',
      query: query.isEmpty ? null : query,
    );
    return ApiResponse.fromJson(json);
  }

  /// `GET /virtual-account/api/customers/{customerId}`
  Future<VirtualCustomerResponse> getCustomer(String customerId) async {
    final json =
        await _client.get('/virtual-account/api/customers/$customerId');
    return VirtualCustomerResponse.fromJson(json);
  }

  /// `PUT /virtual-account/api/customers/{customerId}`
  Future<VirtualCustomerResponse> updateCustomer(
    String customerId,
    VirtualCustomerRequest request,
  ) async {
    final json = await _client.put(
      '/virtual-account/api/customers/$customerId',
      body: request.toJson(),
    );
    return VirtualCustomerResponse.fromJson(json);
  }

  /// `DELETE /virtual-account/api/customers/{customerId}`
  Future<ApiResponse> deleteCustomer(String customerId) async {
    final json =
        await _client.delete('/virtual-account/api/customers/$customerId');
    return ApiResponse.fromJson(json);
  }

  /// `GET /virtual-account/api/customers/{customerId}/virtual-account`
  Future<ApiResponse> createUsAccount(String customerId) async {
    final json = await _client.get(
      '/virtual-account/api/customers/$customerId/virtual-account',
    );
    return ApiResponse.fromJson(json);
  }

  /// `GET .../virtual-account/deactivate`
  Future<ApiResponse> deactivateUsAccount(String customerId) async {
    final json = await _client.get(
      '/virtual-account/api/customers/$customerId/virtual-account/deactivate',
    );
    return ApiResponse.fromJson(json);
  }

  /// `POST .../virtual-account/reactivate`
  Future<ApiResponse> reactivateUsAccount(String customerId) async {
    final json = await _client.post(
      '/virtual-account/api/customers/$customerId/virtual-account/reactivate',
    );
    return ApiResponse.fromJson(json);
  }

  /// `GET .../virtual-account/activities`
  Future<ApiResponse> getUsAccountActivity(String customerId) async {
    final json = await _client.get(
      '/virtual-account/api/customers/$customerId/virtual-account/activities',
    );
    return ApiResponse.fromJson(json);
  }
}
