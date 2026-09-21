import '../core/paychangu_client.dart';
import '../models/common.dart';
import '../models/connect_virtual.dart';

/// PayChangu Connect OAuth-style APIs.
class ConnectApi {
  final PayChanguClient _client;

  /// Creates a [ConnectApi] bound to the shared HTTP client.

  ConnectApi(this._client);

  /// `POST /connect/authorize-link`
  Future<ConnectAuthorizeResponse> createAuthorizeLink(
    ConnectAuthorizeRequest request,
  ) async {
    final json = await _client.post(
      '/connect/authorize-link',
      query: request.toQuery(),
    );
    return ConnectAuthorizeResponse.fromJson(json);
  }

  /// `GET /connect/user`
  Future<ConnectUserResponse> getUser({String? accessToken}) async {
    final json = await _client.get(
      '/connect/user',
      query: accessToken == null ? null : {'access_token': accessToken},
    );
    return ConnectUserResponse.fromJson(json);
  }

  /// Revoke a Connect access token.
  ///
  /// Official OpenAPI currently lists a placeholder path; this client uses
  /// `/connect/revoke` which matches the Connect API naming convention.
  Future<ApiResponse> revokeToken(String token) async {
    final json = await _client.post(
      '/connect/revoke',
      query: {'token': token},
      body: const {},
    );
    return ApiResponse.fromJson(json);
  }
}
