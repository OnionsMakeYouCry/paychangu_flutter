import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/paychangu_config.dart';
import '../exceptions/paychangu_exception.dart';

/// Low-level HTTP client for PayChangu REST APIs.
class PayChanguClient {
  /// Active SDK configuration (base URL, key, timeout).
  final PayChanguConfig config;
  final http.Client _httpClient;
  final bool _ownsClient;

  /// Creates a client. Pass [httpClient] to inject mocks in tests.
  PayChanguClient({
    required this.config,
    http.Client? httpClient,
  })  : _httpClient = httpClient ?? http.Client(),
        _ownsClient = httpClient == null;

  Map<String, String> get _headers => {
        'Authorization': 'Bearer ${config.secretKey}',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      };

  Uri _uri(String path, [Map<String, String>? query]) {
    final normalized = path.startsWith('/') ? path : '/$path';
    return Uri.parse('${config.baseUrl}$normalized').replace(
      queryParameters: query == null || query.isEmpty ? null : query,
    );
  }

  /// Performs an authenticated GET and returns decoded JSON.
  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, String>? query,
  }) {
    return _send(() => _httpClient.get(_uri(path, query), headers: _headers));
  }

  /// Performs an authenticated POST and returns decoded JSON.
  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? body,
    Map<String, String>? query,
  }) {
    return _send(
      () => _httpClient.post(
        _uri(path, query),
        headers: _headers,
        body: body == null ? null : jsonEncode(body),
      ),
    );
  }

  /// Performs an authenticated PUT and returns decoded JSON.
  Future<Map<String, dynamic>> put(
    String path, {
    Map<String, dynamic>? body,
    Map<String, String>? query,
  }) {
    return _send(
      () => _httpClient.put(
        _uri(path, query),
        headers: _headers,
        body: body == null ? null : jsonEncode(body),
      ),
    );
  }

  /// Performs an authenticated DELETE and returns decoded JSON.
  Future<Map<String, dynamic>> delete(
    String path, {
    Map<String, String>? query,
  }) {
    return _send(
      () => _httpClient.delete(_uri(path, query), headers: _headers),
    );
  }

  Future<Map<String, dynamic>> _send(
    Future<http.Response> Function() request,
  ) async {
    try {
      final response = await request().timeout(config.timeout);
      return _parseResponse(response);
    } on PayChanguException {
      rethrow;
    } on TimeoutException catch (e) {
      throw PayChanguException(
        'Request timed out after ${config.timeout.inSeconds}s',
        cause: e,
      );
    } catch (e) {
      throw PayChanguException('Network request failed', cause: e);
    }
  }

  Map<String, dynamic> _parseResponse(http.Response response) {
    final body = response.body;
    Map<String, dynamic>? json;
    if (body.isNotEmpty) {
      try {
        final decoded = jsonDecode(body);
        if (decoded is Map<String, dynamic>) {
          json = decoded;
        } else if (decoded is Map) {
          json = Map<String, dynamic>.from(decoded);
        }
      } catch (_) {
        // Non-JSON body handled below.
      }
    }

    final statusOk = response.statusCode >= 200 && response.statusCode < 300;
    final apiStatus = json?['status']?.toString().toLowerCase();
    final apiFailed = apiStatus == 'failed' || apiStatus == 'error';

    if (!statusOk || apiFailed) {
      final message = json?['message']?.toString() ??
          'Request failed with status: ${response.statusCode}';
      throw PayChanguException(
        message,
        details: body.isEmpty ? null : body,
        statusCode: response.statusCode,
      );
    }

    return json ?? <String, dynamic>{};
  }

  /// Closes the underlying HTTP client when this instance owns it.
  void close() {
    if (_ownsClient) {
      _httpClient.close();
    }
  }
}
