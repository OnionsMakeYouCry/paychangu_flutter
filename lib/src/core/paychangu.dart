import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

import '../api/bank_transfer_api.dart';
import '../api/bills_api.dart';
import '../api/card_api.dart';
import '../api/checkout_api.dart';
import '../api/connect_api.dart';
import '../api/mobile_money_api.dart';
import '../api/payouts_api.dart';
import '../api/virtual_accounts_api.dart';
import '../config/paychangu_config.dart';
import '../models/balance.dart';
import '../models/bank.dart';
import '../models/card.dart';
import '../models/checkout.dart';
import '../models/common.dart';
import '../models/connect_virtual.dart';
import '../models/enums.dart';
import '../models/mobile_money.dart';
import '../models/payment_request.dart';
import '../models/bills.dart';
import '../widgets/paychangu_webview.dart';
import 'paychangu_client.dart';

/// Main PayChangu SDK facade.
///
/// Domain APIs are also available as properties (`checkout`, `mobileMoney`, …)
/// for clearer namespacing.
class PayChangu {
  /// Active SDK configuration.
  final PayChanguConfig config;
  late final PayChanguClient _client;

  /// Hosted checkout domain API.
  late final CheckoutApi checkout;

  /// Mobile money collection domain API.
  late final MobileMoneyApi mobileMoney;

  /// Bank transfer collection domain API.
  late final BankTransferApi bankTransfer;

  /// Card charge domain API.
  late final CardApi card;

  /// Mobile money payout domain API.
  late final MobileMoneyPayoutApi mobileMoneyPayouts;

  /// Bank payout domain API.
  late final PayoutsApi bankPayouts;

  /// Bills and airtime domain API.
  late final BillsApi bills;

  /// PayChangu Connect domain API.
  late final ConnectApi connect;

  /// US virtual accounts domain API.
  late final VirtualAccountsApi virtualAccounts;

  PayChangu(
    this.config, {
    http.Client? httpClient,
  }) {
    _client = PayChanguClient(config: config, httpClient: httpClient);
    checkout = CheckoutApi(_client);
    mobileMoney = MobileMoneyApi(_client);
    bankTransfer = BankTransferApi(_client);
    card = CardApi(_client);
    mobileMoneyPayouts = MobileMoneyPayoutApi(_client);
    bankPayouts = PayoutsApi(_client);
    bills = BillsApi(_client);
    connect = ConnectApi(_client);
    virtualAccounts = VirtualAccountsApi(_client);
  }

  // --- Checkout convenience methods ---

  /// Initiate payment.
  Future<PaymentSessionResponse> initiatePayment(PaymentRequest request) =>
      checkout.initiatePayment(request);

  /// Verify transaction.
  Future<PaymentVerificationResponse> verifyTransaction(String txRef) =>
      checkout.verifyTransaction(txRef);

  /// Validate payment.
  bool validatePayment(
    PaymentVerificationResponse verification, {
    required String expectedTxRef,
    required String expectedCurrency,
    required num expectedAmount,
  }) =>
      checkout.validatePayment(
        verification,
        expectedTxRef: expectedTxRef,
        expectedCurrency: expectedCurrency,
        expectedAmount: expectedAmount,
      );

  /// Hosted checkout WebView widget.
  Widget launchPayment({
    required PaymentRequest request,
    required void Function(Map<String, dynamic> params) onSuccess,
    required void Function(String error) onError,
    required void Function() onCancel,
    bool autoVerify = false,
    void Function(PaymentVerificationResponse verification)? onVerified,
  }) {
    return PayChanguWebView(
      request: request,
      paychangu: this,
      onSuccess: onSuccess,
      onError: onError,
      onCancel: onCancel,
      autoVerify: autoVerify,
      onVerified: onVerified,
    );
  }

  /// 3DS authentication WebView for card charges that require it.
  Widget launch3dsAuth({
    required String authUrl,
    required String redirectUrl,
    required void Function(Map<String, dynamic> params) onComplete,
    required void Function(String error) onError,
  }) {
    return PayChangu3dsWebView(
      authUrl: authUrl,
      redirectUrl: redirectUrl,
      onComplete: onComplete,
      onError: onError,
    );
  }

  // --- Mobile money ---

  /// Get mobile money operators.
  Future<MobileMoneyOperatorsResponse> getMobileMoneyOperators() =>
      mobileMoney.getOperators();

  /// Charge mobile money.
  Future<MobileMoneyTransactionResponse> chargeMobileMoney(
    MobileMoneyChargeRequest request,
  ) =>
      mobileMoney.charge(request);

  /// Verify mobile money charge.
  Future<MobileMoneyTransactionResponse> verifyMobileMoneyCharge(
    String chargeId,
  ) =>
      mobileMoney.verifyCharge(chargeId);

  /// Get mobile money charge details.
  Future<MobileMoneyTransactionResponse> getMobileMoneyChargeDetails(
    String chargeId,
  ) =>
      mobileMoney.getChargeDetails(chargeId);

  /// Get balance.
  Future<WalletBalanceResponse> getBalance(
          {Currency currency = Currency.MWK}) =>
      mobileMoney.getBalance(currency: currency);

  // --- Bank transfer ---

  /// Initialize bank transfer.
  Future<BankTransferInitResponse> initializeBankTransfer(
    BankTransferChargeRequest request,
  ) =>
      bankTransfer.initialize(request);

  /// Get bank transfer details.
  Future<BankTransferDetailsResponse> getBankTransferDetails(String chargeId) =>
      bankTransfer.getDetails(chargeId);

  // --- Card ---

  /// Charge card.
  Future<CardChargeResponse> chargeCard(CardChargeRequest request) =>
      card.charge(request);

  /// Verify card charge.
  Future<ApiResponse> verifyCardCharge(String chargeId) =>
      card.verify(chargeId);

  /// Refund card charge.
  Future<ApiResponse> refundCardCharge(String chargeId) =>
      card.refund(chargeId);

  // --- MoMo payouts ---

  /// Initiate mobile money payout.
  Future<MobileMoneyTransactionResponse> initiateMobileMoneyPayout(
    MobileMoneyPayoutRequest request,
  ) =>
      mobileMoneyPayouts.initialize(request);

  /// Deprecated alias for [initiateMobileMoneyPayout].
  @Deprecated('Use initiateMobileMoneyPayout')
  Future<MobileMoneyTransactionResponse> initiateMobileMoneyTransfer(
    MobileMoneyPayoutRequest request,
  ) =>
      initiateMobileMoneyPayout(request);

  /// Get mobile money payout details.
  Future<MobileMoneyTransactionResponse> getMobileMoneyPayoutDetails(
    String chargeId,
  ) =>
      mobileMoneyPayouts.getDetails(chargeId);

  /// Deprecated alias for [getMobileMoneyPayoutDetails].
  @Deprecated('Use getMobileMoneyPayoutDetails')
  Future<MobileMoneyTransactionResponse> getTransferStatus(String chargeId) =>
      getMobileMoneyPayoutDetails(chargeId);

  // --- Bank payouts ---

  /// Get banks.
  Future<BanksResponse> getBanks({Currency currency = Currency.MWK}) =>
      bankPayouts.getBanks(currency: currency);

  /// Initiate bank payout.
  Future<BankPayoutResponse> initiateBankPayout(BankPayoutRequest request) =>
      bankPayouts.initializeBankPayout(request);

  /// Get bank payout details.
  Future<BankPayoutResponse> getBankPayoutDetails(String chargeId) =>
      bankPayouts.getBankPayoutDetails(chargeId);

  /// List bank payouts.
  Future<BankPayoutListResponse> listBankPayouts() =>
      bankPayouts.listBankPayouts();

  // --- Bills ---

  /// Get billers.
  Future<BillsApiResponse> getBillers() => bills.getBillers();

  /// Get biller details.
  Future<BillsApiResponse> getBillerDetails(String billerId) =>
      bills.getBillerDetails(billerId);

  /// Validate bill.
  Future<BillsApiResponse> validateBill(ValidateBillRequest request) =>
      bills.validateBill(request);

  /// Pay bill.
  Future<BillsApiResponse> payBill(PayBillRequest request) =>
      bills.payBill(request);

  /// Buy airtime.
  Future<BillsApiResponse> buyAirtime(AirtimeRechargeRequest request) =>
      bills.buyAirtime(request);

  /// Get bill transaction.
  Future<BillsApiResponse> getBillTransaction(String reference) =>
      bills.getBillTransaction(reference);

  /// Get bill statistics.
  Future<BillsApiResponse> getBillStatistics() => bills.getStatistics();

  // --- Connect ---

  /// Create connect link.
  Future<ConnectAuthorizeResponse> createConnectLink(
    ConnectAuthorizeRequest request,
  ) =>
      connect.createAuthorizeLink(request);

  /// Get connect user.
  Future<ConnectUserResponse> getConnectUser({String? accessToken}) =>
      connect.getUser(accessToken: accessToken);

  /// Revoke connect token.
  Future<ApiResponse> revokeConnectToken(String token) =>
      connect.revokeToken(token);

  // --- Virtual accounts ---

  /// Create virtual customer.
  Future<VirtualCustomerResponse> createVirtualCustomer(
    VirtualCustomerRequest request,
  ) =>
      virtualAccounts.createCustomer(request);

  /// List virtual customers.
  Future<ApiResponse> listVirtualCustomers({int? page, int? perPage}) =>
      virtualAccounts.listCustomers(page: page, perPage: perPage);

  /// Get virtual customer.
  Future<VirtualCustomerResponse> getVirtualCustomer(String customerId) =>
      virtualAccounts.getCustomer(customerId);

  /// Update virtual customer.
  Future<VirtualCustomerResponse> updateVirtualCustomer(
    String customerId,
    VirtualCustomerRequest request,
  ) =>
      virtualAccounts.updateCustomer(customerId, request);

  /// Delete virtual customer.
  Future<ApiResponse> deleteVirtualCustomer(String customerId) =>
      virtualAccounts.deleteCustomer(customerId);

  /// Create us account.
  Future<ApiResponse> createUsAccount(String customerId) =>
      virtualAccounts.createUsAccount(customerId);

  /// Deactivate us account.
  Future<ApiResponse> deactivateUsAccount(String customerId) =>
      virtualAccounts.deactivateUsAccount(customerId);

  /// Reactivate us account.
  Future<ApiResponse> reactivateUsAccount(String customerId) =>
      virtualAccounts.reactivateUsAccount(customerId);

  /// Get us account activity.
  Future<ApiResponse> getUsAccountActivity(String customerId) =>
      virtualAccounts.getUsAccountActivity(customerId);

  /// Closes the underlying HTTP client.
  void close() => _client.close();
}
