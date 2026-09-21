import '../core/json_utils.dart';

/// Connect authorize-link request parameters.
class ConnectAuthorizeRequest {
  /// Client id.
  final String clientId;

  /// Redirect uri.
  final String redirectUri;

  /// Mode.
  final String mode;

  /// Scope.
  final String? scope;

  /// Webhook url.
  final String? webhookUrl;

  /// Webhook secret.
  final String? webhookSecret;

  /// Creates a [ConnectAuthorizeRequest].
  const ConnectAuthorizeRequest({
    required this.clientId,
    required this.redirectUri,
    required this.mode,
    this.scope,
    this.webhookUrl,
    this.webhookSecret,
  });

  /// To query.
  Map<String, String> toQuery() => {
        'client_id': clientId,
        'redirect_uri': redirectUri,
        'mode': mode,
        if (scope != null) 'scope': scope!,
        if (webhookUrl != null) 'wh_url': webhookUrl!,
        if (webhookSecret != null) 'wh_secret': webhookSecret!,
      };
}

class ConnectAuthorizeResponse {
  /// Authorize url.
  final String? authorizeUrl;

  /// Raw.
  final Map<String, dynamic> raw;

  /// Creates a [ConnectAuthorizeResponse].
  const ConnectAuthorizeResponse({this.authorizeUrl, required this.raw});

  /// Parses a [ConnectAuthorizeResponse] from JSON.
  factory ConnectAuthorizeResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    String? url;
    if (data is String) {
      url = data;
    } else if (data is Map) {
      url = data['url']?.toString() ??
          data['authorize_url']?.toString() ??
          data['link']?.toString();
    }
    url ??= json['url']?.toString() ??
        json['authorize_url']?.toString() ??
        json['link']?.toString();

    return ConnectAuthorizeResponse(authorizeUrl: url, raw: json);
  }
}

class ConnectUserResponse {
  /// Raw.
  final Map<String, dynamic> raw;

  /// Status.
  final String? status;

  /// Message.
  final String? message;

  /// Data.
  final dynamic data;

  /// Creates a [ConnectUserResponse].
  const ConnectUserResponse({
    required this.raw,
    this.status,
    this.message,
    this.data,
  });

  /// Parses a [ConnectUserResponse] from JSON.
  factory ConnectUserResponse.fromJson(Map<String, dynamic> json) {
    return ConnectUserResponse(
      raw: json,
      status: JsonUtils.asString(json['status']),
      message: JsonUtils.asString(json['message']),
      data: json['data'] ?? json,
    );
  }
}

/// Virtual account customer create/update body.
class VirtualCustomerRequest {
  /// Email.
  final String email;

  /// First name.
  final String firstName;

  /// Last name.
  final String lastName;

  /// Creates a [VirtualCustomerRequest].
  const VirtualCustomerRequest({
    required this.email,
    required this.firstName,
    required this.lastName,
  });

  /// To json.
  Map<String, dynamic> toJson() => {
        'email': email,
        'first_name': firstName,
        'last_name': lastName,
      };
}

class VirtualCustomerResponse {
  /// Status.
  final String? status;

  /// Message.
  final String? message;

  /// Data.
  final Map<String, dynamic> data;

  /// Raw.
  final Map<String, dynamic> raw;

  /// Creates a [VirtualCustomerResponse].
  const VirtualCustomerResponse({
    this.status,
    this.message,
    required this.data,
    required this.raw,
  });

  /// Parses a [VirtualCustomerResponse] from JSON.
  factory VirtualCustomerResponse.fromJson(Map<String, dynamic> json) {
    return VirtualCustomerResponse(
      status: JsonUtils.asString(json['status']),
      message: JsonUtils.asString(json['message']),
      data: JsonUtils.asMap(json['data']) ?? json,
      raw: json,
    );
  }

  String? get id =>
      JsonUtils.asString(data['id']) ?? JsonUtils.asString(data['customer_id']);
}
