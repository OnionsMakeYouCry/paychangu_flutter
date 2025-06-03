import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../config/paychangu_config.dart';
import '../models/payment_request.dart';
import '../models/verification_response.dart';
import '../exceptions/paychangu_exception.dart';
import '../widgets/paychangu_webview.dart';
import '../models/mobile_money_transfer.dart';

/// Main PayChangu SDK class
class PayChangu {
  static const String _baseUrl = 'https://api.paychangu.com';
  final PayChanguConfig _config;

  PayChangu(this._config);

  /// Initiates a payment transaction
  Future<Map<String, dynamic>> initiatePayment(PaymentRequest request) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/payment'),
        headers: {
          'Authorization': 'Bearer ${_config.secretKey}',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw PayChanguException(
          'Payment initiation failed with status: ${response.statusCode}',
          response.body,
        );
      }
    } catch (e) {
      throw PayChanguException('Payment initiation failed', e.toString());
    }
  }

  /// Launches payment WebView
  Widget launchPayment({
    required PaymentRequest request,
    required Function(Map<String, dynamic>) onSuccess,
    required Function(String) onError,
    required Function() onCancel,
  }) {
    return PayChanguWebView(
      request: request,
      config: _config,
      onSuccess: onSuccess,
      onError: onError,
      onCancel: onCancel,
    );
  }

  /// Verifies a transaction using the transaction reference
  Future<PaymentVerificationResponse> verifyTransaction(String txRef) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/verify-payment/$txRef'),
        headers: {
          'Authorization': 'Bearer ${_config.secretKey}',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = jsonDecode(response.body);
        return PaymentVerificationResponse.fromJson(jsonResponse);
      } else {
        throw PayChanguException(
          'Transaction verification failed with status: ${response.statusCode}',
          response.body,
        );
      }
    } catch (e) {
      throw PayChanguException('Transaction verification failed', e.toString());
    }
  }

  /// Validates payment verification response
  bool validatePayment(
    PaymentVerificationResponse verification, {
    required String expectedTxRef,
    required String expectedCurrency,
    required int expectedAmount,
  }) {
    final data = verification.data;

    return data.status == 'success' &&
        data.txRef == expectedTxRef &&
        data.currency == expectedCurrency &&
        data.amount >= expectedAmount;
  }

  /// Initiates a mobile money transfer
  Future<MobileMoneyTransferResponse> initiateMobileMoneyTransfer(
    MobileMoneyTransferRequest request,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/mobile-money/payouts/initialize'),
        headers: {
          'Authorization': 'Bearer ${_config.secretKey}',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = jsonDecode(response.body);
        return MobileMoneyTransferResponse.fromJson(jsonResponse);
      } else {
        throw PayChanguException(
          'Mobile money transfer failed with status: ${response.statusCode}',
          response.body,
        );
      }
    } catch (e) {
      throw PayChanguException('Mobile money transfer failed', e.toString());
    }
  }

  /// Fetch transfer status
  Future<MobileMoneyTransferResponse> getTransferStatus(
    String reference,
  ) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/mobile-money/payouts/$reference'),
        headers: {
          'Authorization': 'Bearer ${_config.secretKey}',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = jsonDecode(response.body);
        return MobileMoneyTransferResponse.fromJson(jsonResponse);
      } else {
        throw PayChanguException(
          'Failed to fetch transfer status: ${response.statusCode}',
          response.body,
        );
      }
    } catch (e) {
      throw PayChanguException('Failed to fetch transfer status', e.toString());
    }
  }
}
