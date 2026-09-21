import 'package:flutter/material.dart';
import 'package:paychangu_flutter/paychangu_flutter.dart';

/// Sandbox secret key from `--dart-define=PAYCHANGU_SECRET_KEY=...`.
const _secretKey = String.fromEnvironment('PAYCHANGU_SECRET_KEY');

void main() {
  runApp(const PayChanguExampleApp());
}

/// Minimal hosted-checkout demo for package consumers and pub.dev scoring.
class PayChanguExampleApp extends StatelessWidget {
  /// Creates the example application.
  const PayChanguExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PayChangu Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0B6E4F)),
        useMaterial3: true,
      ),
      home: const _HomePage(),
    );
  }
}

class _HomePage extends StatefulWidget {
  const _HomePage();

  @override
  State<_HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<_HomePage> {
  PayChangu? _sdk;
  String _status = 'Set PAYCHANGU_SECRET_KEY to try a live sandbox checkout.';

  @override
  void initState() {
    super.initState();
    if (_secretKey.isNotEmpty) {
      _sdk = PayChangu(
        PayChanguConfig(secretKey: _secretKey, isTestMode: true),
      );
      _status = 'SDK ready. Tap the button to open hosted checkout.';
    }
  }

  @override
  void dispose() {
    _sdk?.close();
    super.dispose();
  }

  void _launchCheckout() {
    final sdk = _sdk;
    if (sdk == null) {
      setState(() {
        _status =
            'Missing key. Run with:\nflutter run --dart-define=PAYCHANGU_SECRET_KEY=your_key';
      });
      return;
    }

    final request = PaymentRequest(
      txRef: 'example-${DateTime.now().millisecondsSinceEpoch}',
      firstName: 'Demo',
      lastName: 'User',
      email: 'demo@example.com',
      currency: Currency.MWK,
      amount: 1000,
      callbackUrl: 'https://example.com/callback',
      returnUrl: 'https://example.com/return',
      customization: const {
        'title': 'PayChangu Example',
        'description': 'Minimal package demo',
      },
    );

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => Scaffold(
          appBar: AppBar(title: const Text('Checkout')),
          body: sdk.launchPayment(
            request: request,
            autoVerify: true,
            onSuccess: (params) {
              setState(() => _status = 'Success: $params');
              Navigator.of(context).pop();
            },
            onError: (error) {
              setState(() => _status = 'Error: $error');
              Navigator.of(context).pop();
            },
            onCancel: () {
              setState(() => _status = 'Cancelled');
              Navigator.of(context).pop();
            },
            onVerified: (verification) {
              setState(() {
                _status =
                    'Verified ${verification.data.status} · ${verification.data.txRef}';
              });
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('paychangu_flutter example')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'This minimal example shows hosted checkout via '
              'PayChangu.launchPayment.',
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _launchCheckout,
              child: const Text('Launch hosted checkout'),
            ),
            const SizedBox(height: 24),
            Text(_status),
          ],
        ),
      ),
    );
  }
}
