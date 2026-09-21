import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../core/paychangu.dart';
import '../models/checkout.dart';
import '../models/payment_request.dart';

/// WebView widget for hosted PayChangu checkout.
class PayChanguWebView extends StatefulWidget {
  /// Request.
  final PaymentRequest request;

  /// Paychangu.
  final PayChangu paychangu;

  /// On success.
  final void Function(Map<String, dynamic> params) onSuccess;

  /// On error.
  final void Function(String error) onError;

  /// On cancel.
  final void Function() onCancel;

  /// Auto verify.
  final bool autoVerify;

  /// On verified.
  final void Function(PaymentVerificationResponse verification)? onVerified;

  /// Creates a [PayChanguWebView].
  const PayChanguWebView({
    super.key,
    required this.request,
    required this.paychangu,
    required this.onSuccess,
    required this.onError,
    required this.onCancel,
    this.autoVerify = false,
    this.onVerified,
  });

  @override
  State<PayChanguWebView> createState() => _PayChanguWebViewState();
}

class _PayChanguWebViewState extends State<PayChanguWebView> {
  late final WebViewController _controller;
  var _loading = true;
  String? _error;

  @override

  /// Init state.
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: _handleNavigationRequest,
          onPageFinished: (_) {
            if (mounted) setState(() => _loading = false);
          },
          onWebResourceError: (error) {
            if (mounted) {
              setState(() {
                _loading = false;
                _error = error.description;
              });
            }
          },
        ),
      );
    _initializePayment();
  }

  NavigationDecision _handleNavigationRequest(NavigationRequest request) {
    final url = request.url;
    if (url.startsWith(widget.request.callbackUrl)) {
      _handleCallback(url);
      return NavigationDecision.prevent;
    }
    if (url.startsWith(widget.request.returnUrl)) {
      _handleReturn(url);
      return NavigationDecision.prevent;
    }
    return NavigationDecision.navigate;
  }

  Future<void> _initializePayment() async {
    try {
      final response = await widget.paychangu.initiatePayment(widget.request);
      await _controller.loadRequest(Uri.parse(response.data.checkoutUrl));
    } catch (e) {
      if (mounted) {
        setState(() {
          _loading = false;
          _error = e.toString();
        });
      }
      widget.onError(e.toString());
    }
  }

  Future<void> _handleCallback(String url) async {
    final params = Uri.parse(url).queryParameters;
    final status = params['status']?.toLowerCase();

    if (status == 'success') {
      widget.onSuccess(Map<String, dynamic>.from(params));
      if (widget.autoVerify) {
        final txRef = params['tx_ref'] ?? widget.request.txRef;
        if (txRef != null && widget.onVerified != null) {
          try {
            final verification =
                await widget.paychangu.verifyTransaction(txRef);
            widget.onVerified!(verification);
          } catch (e) {
            widget.onError('Verification failed: $e');
          }
        }
      }
    } else {
      widget.onError(
        'Payment failed: ${params['message'] ?? status ?? 'Unknown error'}',
      );
    }
  }

  void _handleReturn(String url) {
    final params = Uri.parse(url).queryParameters;
    final status = params['status']?.toLowerCase();
    if (status == 'failed') {
      widget.onError(
        'Payment failed: ${params['message'] ?? 'Transaction failed'}',
      );
      return;
    }
    widget.onCancel();
  }

  @override

  /// Build.
  Widget build(BuildContext context) {
    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            _error!,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Stack(
      children: [
        WebViewWidget(controller: _controller),
        if (_loading) const Center(child: CircularProgressIndicator()),
      ],
    );
  }
}

/// WebView for card 3DS authentication.
class PayChangu3dsWebView extends StatefulWidget {
  /// Auth url.
  final String authUrl;

  /// Redirect url.
  final String redirectUrl;

  /// On complete.
  final void Function(Map<String, dynamic> params) onComplete;

  /// On error.
  final void Function(String error) onError;

  /// Creates a [PayChangu3dsWebView].
  const PayChangu3dsWebView({
    super.key,
    required this.authUrl,
    required this.redirectUrl,
    required this.onComplete,
    required this.onError,
  });

  @override
  State<PayChangu3dsWebView> createState() => _PayChangu3dsWebViewState();
}

class _PayChangu3dsWebViewState extends State<PayChangu3dsWebView> {
  late final WebViewController _controller;
  var _loading = true;

  @override

  /// Init state.
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) {
            if (request.url.startsWith(widget.redirectUrl)) {
              widget.onComplete(
                Map<String, dynamic>.from(
                    Uri.parse(request.url).queryParameters),
              );
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
          onPageFinished: (_) {
            if (mounted) setState(() => _loading = false);
          },
          onWebResourceError: (error) => widget.onError(error.description),
        ),
      )
      ..loadRequest(Uri.parse(widget.authUrl));
  }

  @override

  /// Build.
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WebViewWidget(controller: _controller),
        if (_loading) const Center(child: CircularProgressIndicator()),
      ],
    );
  }
}
