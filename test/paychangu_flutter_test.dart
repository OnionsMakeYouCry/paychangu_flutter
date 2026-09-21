import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:paychangu_flutter/paychangu_flutter.dart';

void main() {
  group('PaymentRequest', () {
    test('serializes required and optional fields', () {
      final request = PaymentRequest(
        txRef: 'tx-1',
        firstName: 'Ada',
        lastName: 'Lovelace',
        email: 'ada@example.com',
        currency: Currency.MWK,
        amount: 1500,
        callbackUrl: 'https://example.com/callback',
        returnUrl: 'https://example.com/return',
        customization: {'title': 'Order'},
      );

      final json = request.toJson();
      expect(json['amount'], '1500');
      expect(json['currency'], 'MWK');
      expect(json['tx_ref'], 'tx-1');
      expect(json['customization'], {'title': 'Order'});
    });
  });

  group('MobileMoneyPayoutRequest', () {
    test('matches current API field names', () {
      final request = const MobileMoneyPayoutRequest(
        mobile: '+265999000111',
        mobileMoneyOperatorRefId: '20be6c20-adeb-4b5b-a7ba-0769820df4fb',
        amount: '500',
        chargeId: 'payout-1',
        transactionStatus: 'successful',
      );

      final json = request.toJson();
      expect(json.containsKey('phone_number'), isFalse);
      expect(json.containsKey('provider'), isFalse);
      expect(json['mobile'], '+265999000111');
      expect(
        json['mobile_money_operator_ref_id'],
        '20be6c20-adeb-4b5b-a7ba-0769820df4fb',
      );
      expect(json['charge_id'], 'payout-1');
    });
  });

  group('PaymentSessionResponse', () {
    test('parses nested checkout session', () {
      final response = PaymentSessionResponse.fromJson({
        'status': 'success',
        'message': 'Hosted payment session generated successfully.',
        'data': {
          'event': 'checkout.session:created',
          'checkout_url': 'https://test-checkout.paychangu.com/123',
          'data': {
            'tx_ref': 'ref-1',
            'currency': 'MWK',
            'amount': 1000,
            'mode': 'sandbox',
            'status': 'pending',
          },
        },
      });

      expect(
        response.data.checkoutUrl,
        'https://test-checkout.paychangu.com/123',
      );
      expect(response.data.details?.txRef, 'ref-1');
      expect(response.data.details?.amount, 1000);
    });
  });

  group('CheckoutApi validatePayment', () {
    test('accepts successful matching verification', () {
      final sdk = PayChangu(
        PayChanguConfig(secretKey: 'test'),
        httpClient: MockClient((_) async => http.Response('{}', 500)),
      );

      final verification = PaymentVerificationResponse.fromJson({
        'status': 'success',
        'message': 'ok',
        'data': {
          'event_type': 'checkout.payment',
          'tx_ref': 'PA1',
          'mode': 'live',
          'type': 'API Payment (Checkout)',
          'status': 'success',
          'number_of_attempts': 1,
          'reference': 'r1',
          'currency': 'MWK',
          'amount': 1000,
          'charges': 40,
          'authorization': {'channel': 'Card'},
          'customer': {
            'email': 'a@b.com',
            'first_name': 'A',
            'last_name': 'B',
          },
          'logs': [],
          'created_at': '2024-01-01',
          'updated_at': '2024-01-01',
        },
      });

      expect(
        sdk.validatePayment(
          verification,
          expectedTxRef: 'PA1',
          expectedCurrency: 'MWK',
          expectedAmount: 1000,
        ),
        isTrue,
      );
      sdk.close();
    });
  });

  group('PayChangu HTTP APIs', () {
    test('posts payment and returns typed session', () async {
      final mock = MockClient((request) async {
        expect(request.url.path, '/payment');
        expect(request.headers['Authorization'], 'Bearer sk_test');
        return http.Response(
          jsonEncode({
            'status': 'success',
            'message': 'ok',
            'data': {
              'checkout_url': 'https://checkout.example/1',
              'data': {'tx_ref': 't1', 'amount': 100, 'currency': 'MWK'},
            },
          }),
          200,
        );
      });

      final sdk = PayChangu(
        PayChanguConfig(secretKey: 'sk_test'),
        httpClient: mock,
      );

      final session = await sdk.initiatePayment(
        PaymentRequest(
          currency: Currency.MWK,
          amount: 100,
          callbackUrl: 'https://cb',
          returnUrl: 'https://ret',
        ),
      );

      expect(session.data.checkoutUrl, 'https://checkout.example/1');
      sdk.close();
    });

    test('throws PayChanguException on API failure', () async {
      final mock = MockClient(
        (_) async => http.Response(
          jsonEncode({
            'status': 'failed',
            'message': 'currency is required',
            'data': null,
          }),
          400,
        ),
      );

      final sdk = PayChangu(
        PayChanguConfig(secretKey: 'sk_test'),
        httpClient: mock,
      );

      expect(
        () => sdk.initiatePayment(
          PaymentRequest(
            currency: Currency.MWK,
            amount: 100,
            callbackUrl: 'https://cb',
            returnUrl: 'https://ret',
          ),
        ),
        throwsA(
          isA<PayChanguException>().having(
            (e) => e.message,
            'message',
            contains('currency is required'),
          ),
        ),
      );
      sdk.close();
    });

    test('charges mobile money via initialize path', () async {
      final mock = MockClient((request) async {
        expect(request.url.path, '/mobile-money/payments/initialize');
        final body = jsonDecode(request.body) as Map<String, dynamic>;
        expect(body['mobile'], '+265991234567');
        expect(body['charge_id'], 'c1');
        return http.Response(
          jsonEncode({
            'status': 'success',
            'message': 'Payment initiated successfully.',
            'data': {
              'amount': 50,
              'charge_id': 'c1',
              'status': 'pending',
              'mobile': '+265991234567',
              'currency': 'MWK',
            },
          }),
          200,
        );
      });

      final sdk = PayChangu(
        PayChanguConfig(secretKey: 'sk_test'),
        httpClient: mock,
      );

      final result = await sdk.chargeMobileMoney(
        const MobileMoneyChargeRequest(
          mobile: '+265991234567',
          mobileMoneyOperatorRefId: 'op-1',
          amount: '50',
          chargeId: 'c1',
        ),
      );

      expect(result.data.chargeId, 'c1');
      expect(result.data.status, 'pending');
      sdk.close();
    });

    test('initializes momo payout with correct body', () async {
      final mock = MockClient((request) async {
        expect(request.url.path, '/mobile-money/payouts/initialize');
        final body = jsonDecode(request.body) as Map<String, dynamic>;
        expect(body['mobile_money_operator_ref_id'], 'op-1');
        return http.Response(
          jsonEncode({
            'status': 'success',
            'message': 'Payout processed successfully.',
            'data': {
              'amount': 100,
              'charge_id': 'p1',
              'status': 'success',
              'mobile': '+265991234567',
            },
          }),
          200,
        );
      });

      final sdk = PayChangu(
        PayChanguConfig(secretKey: 'sk_test'),
        httpClient: mock,
      );

      final result = await sdk.initiateMobileMoneyPayout(
        const MobileMoneyPayoutRequest(
          mobile: '+265991234567',
          mobileMoneyOperatorRefId: 'op-1',
          amount: '100',
          chargeId: 'p1',
        ),
      );

      expect(result.data.status, 'success');
      sdk.close();
    });

    test('gets wallet balance', () async {
      final mock = MockClient((request) async {
        expect(request.url.path, '/wallet-balance');
        expect(request.url.queryParameters['currency'], 'MWK');
        return http.Response(
          jsonEncode({
            'status': 'success',
            'message': 'Wallet balances retrieved successfully',
            'data': {
              'environment': 'live',
              'currency': 'MWK',
              'main_balance': '953037.95',
              'collection_balance': 0,
            },
          }),
          200,
        );
      });

      final sdk = PayChangu(
        PayChanguConfig(secretKey: 'sk_test'),
        httpClient: mock,
      );

      final balance = await sdk.getBalance();
      expect(balance.data.mainBalance, '953037.95');
      sdk.close();
    });
  });

  group('PayChanguWebhooks', () {
    test('verifies valid HMAC-SHA256 signature', () {
      const body = '{"status":"success"}';
      const secret = 'whsec_test';
      final signature = Hmac(sha256, utf8.encode(secret))
          .convert(utf8.encode(body))
          .toString();

      expect(
        PayChanguWebhooks.verify(
          rawBody: body,
          signatureHeader: signature,
          webhookSecret: secret,
        ),
        isTrue,
      );
      expect(
        PayChanguWebhooks.verify(
          rawBody: body,
          signatureHeader: 'invalid',
          webhookSecret: secret,
        ),
        isFalse,
      );
    });
  });
}
