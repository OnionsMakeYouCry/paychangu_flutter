# PayChangu Flutter SDK

Flutter/Dart client for the [PayChangu API](https://developer.paychangu.com/reference/introduction).
Accept payments in Malawi via hosted checkout, direct mobile money, bank transfer,
and cards; send payouts; pay bills; use Connect and US virtual accounts.

[![pub package](https://img.shields.io/pub/v/paychangu_flutter.svg)](https://pub.dev/packages/paychangu_flutter)
[![pub points](https://img.shields.io/pub/points/paychangu_flutter)](https://pub.dev/packages/paychangu_flutter/score)
[![pub likes](https://img.shields.io/pub/likes/paychangu_flutter)](https://pub.dev/packages/paychangu_flutter/score)
[![popularity](https://img.shields.io/pub/popularity/paychangu_flutter)](https://pub.dev/packages/paychangu_flutter/score)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![style: flutter_lints](https://img.shields.io/badge/style-flutter__lints-40c4ff.svg)](https://pub.dev/packages/flutter_lints)

## Features

- Hosted checkout WebView with callback / return handling and optional auto-verify
- Typed clients for the full PayChangu REST surface
- Injectable HTTP client for tests and proxies
- Webhook HMAC-SHA256 verification helper
- Direct MoMo charge, operators, and wallet balance
- Bank transfer collection and bank / MoMo payouts
- Card charge with 3DS WebView helper

## Installation

```yaml
dependencies:
  paychangu_flutter: ^1.1.0
```

```bash
flutter pub get
```

```dart
import 'package:paychangu_flutter/paychangu_flutter.dart';
```

## Security

- Hosted checkout may use a secret key from the app for `POST /payment`.
- **Do not** ship secret keys in production apps for payouts, card PAN charges,
  or bill payments — call those from your backend.
- Always re-verify successful payments with `verifyTransaction` (or your server)
  before fulfilling orders.
- Verify webhooks with `PayChanguWebhooks.verify`.

## Setup

```dart
final paychangu = PayChangu(
  PayChanguConfig(
    secretKey: 'your_secret_key',
    isTestMode: true,
  ),
);
```

You can use the facade methods below, or the namespaced APIs:
`paychangu.checkout`, `.mobileMoney`, `.bankTransfer`, `.card`,
`.mobileMoneyPayouts`, `.bankPayouts`, `.bills`, `.connect`, `.virtualAccounts`.

## Hosted checkout

```dart
final request = PaymentRequest(
  txRef: 'unique-tx-ref',
  firstName: 'John',
  lastName: 'Doe',
  email: 'john@example.com',
  currency: Currency.MWK,
  amount: 1000,
  callbackUrl: 'https://your-domain.com/callback',
  returnUrl: 'https://your-domain.com/return',
);

// Option A — WebView widget
paychangu.launchPayment(
  request: request,
  autoVerify: true,
  onSuccess: (params) {},
  onError: (error) {},
  onCancel: () {},
  onVerified: (verification) {},
);

// Option B — session only (open checkoutUrl yourself)
final session = await paychangu.initiatePayment(request);
print(session.data.checkoutUrl);
```

### Verify a transaction

```dart
final verification = await paychangu.verifyTransaction('unique-tx-ref');
final ok = paychangu.validatePayment(
  verification,
  expectedTxRef: 'unique-tx-ref',
  expectedCurrency: 'MWK',
  expectedAmount: 1000,
);
```

## Wallet balance

```dart
final balance = await paychangu.getBalance(currency: Currency.MWK);
```

## Mobile money (collection)

```dart
final operators = await paychangu.getMobileMoneyOperators();

final charge = await paychangu.chargeMobileMoney(
  MobileMoneyChargeRequest(
    mobile: '26599XXXXXXX',
    mobileMoneyOperatorRefId: 'operator-ref-id',
    amount: '1000',
    chargeId: 'unique-charge-id',
    email: 'john@example.com',
    firstName: 'John',
    lastName: 'Doe',
  ),
);

final status = await paychangu.verifyMobileMoneyCharge(charge.data.chargeId!);
// or: await paychangu.getMobileMoneyChargeDetails(chargeId);
```

## Bank transfer (collection)

```dart
final transfer = await paychangu.initializeBankTransfer(
  BankTransferChargeRequest(
    amount: '5000',
    currency: Currency.MWK,
    chargeId: 'unique-charge-id',
    email: 'john@example.com',
    firstName: 'John',
    lastName: 'Doe',
  ),
);

final details =
    await paychangu.getBankTransferDetails(transfer.transaction!.chargeId!);
```

## Card charges

Prefer calling card endpoints from your backend (PCI). The SDK includes
helpers for local/dev use and 3DS WebView completion.

```dart
final card = await paychangu.chargeCard(
  CardChargeRequest(
    cardNumber: '4111111111111111',
    expiry: '12/28',
    cvv: '123',
    cardholderName: 'John Doe',
    amount: '1000',
    currency: Currency.MWK,
    chargeId: 'unique-charge-id',
    redirectUrl: 'https://your-domain.com/3ds-return',
    email: 'john@example.com',
  ),
);

if (card.requires3dsAuth && card.threeDsAuthLink != null) {
  paychangu.launch3dsAuth(
    authUrl: card.threeDsAuthLink!,
    redirectUrl: 'https://your-domain.com/3ds-return',
    onComplete: (params) {},
    onError: (error) {},
  );
}

await paychangu.verifyCardCharge('unique-charge-id');
await paychangu.refundCardCharge('unique-charge-id');
```

## Mobile money payouts

```dart
final payout = await paychangu.initiateMobileMoneyPayout(
  MobileMoneyPayoutRequest(
    mobile: '26599XXXXXXX',
    mobileMoneyOperatorRefId: 'operator-ref-id',
    amount: '1000',
    chargeId: 'unique-payout-id',
    email: 'john@example.com',
    firstName: 'John',
    lastName: 'Doe',
  ),
);

final details =
    await paychangu.getMobileMoneyPayoutDetails(payout.data.chargeId!);
```

## Bank payouts

```dart
final banks = await paychangu.getBanks(currency: Currency.MWK);

final bankPayout = await paychangu.initiateBankPayout(
  BankPayoutRequest(
    bankUuid: banks.data.first.uuid!,
    amount: '5000',
    chargeId: 'unique-payout-id',
    bankAccountName: 'John Doe',
    bankAccountNumber: '1234567890',
  ),
);

await paychangu.getBankPayoutDetails(bankPayout.transaction!.chargeId!);
await paychangu.listBankPayouts();
```

## Bills & airtime

```dart
final billers = await paychangu.getBillers();
await paychangu.getBillerDetails('biller-id');

await paychangu.validateBill(
  ValidateBillRequest(
    biller: 'ESCOM',
    account: '123456',
    amount: '1000',
  ),
);

await paychangu.payBill(
  PayBillRequest(
    biller: 'ESCOM',
    account: '123456',
    amount: '1000',
    reference: 'bill-ref-1',
  ),
);

await paychangu.buyAirtime(
  AirtimeRechargeRequest(
    phone: '26599XXXXXXX',
    amount: '500',
    reference: 'airtime-ref-1',
  ),
);

await paychangu.getBillTransaction('bill-ref-1');
await paychangu.getBillStatistics();
```

## Connect

```dart
final link = await paychangu.createConnectLink(
  ConnectAuthorizeRequest(
    clientId: 'your-client-id',
    redirectUri: 'https://your-domain.com/connect/callback',
    mode: 'live', // or 'sandbox'
  ),
);
print(link.authorizeUrl);

final user = await paychangu.getConnectUser(accessToken: 'user-access-token');
await paychangu.revokeConnectToken('user-access-token');
```

## US virtual accounts

```dart
final customer = await paychangu.createVirtualCustomer(
  VirtualCustomerRequest(
    email: 'john@example.com',
    firstName: 'John',
    lastName: 'Doe',
  ),
);

final customerId = customer.data['id']?.toString() ?? '';

await paychangu.listVirtualCustomers();
await paychangu.getVirtualCustomer(customerId);
await paychangu.updateVirtualCustomer(
  customerId,
  VirtualCustomerRequest(
    email: 'john@example.com',
    firstName: 'John',
    lastName: 'Doe',
  ),
);

await paychangu.createUsAccount(customerId);
await paychangu.getUsAccountActivity(customerId);
await paychangu.deactivateUsAccount(customerId);
await paychangu.reactivateUsAccount(customerId);
await paychangu.deleteVirtualCustomer(customerId);
```

## Webhooks

```dart
final valid = PayChanguWebhooks.verify(
  rawBody: requestBody,
  signatureHeader: signatureFromHeader,
  webhookSecret: 'your_webhook_secret',
);
```

## API overview

| Area | Entry points |
|------|----------------|
| Checkout | `initiatePayment`, `verifyTransaction`, `launchPayment` |
| Balance | `getBalance` |
| Mobile money | `getMobileMoneyOperators`, `chargeMobileMoney`, `verifyMobileMoneyCharge` |
| Bank transfer | `initializeBankTransfer`, `getBankTransferDetails` |
| Card | `chargeCard`, `verifyCardCharge`, `refundCardCharge`, `launch3dsAuth` |
| MoMo payout | `initiateMobileMoneyPayout`, `getMobileMoneyPayoutDetails` |
| Bank payout | `getBanks`, `initiateBankPayout`, `getBankPayoutDetails`, `listBankPayouts` |
| Bills | `getBillers`, `validateBill`, `payBill`, `buyAirtime`, … |
| Connect | `createConnectLink`, `getConnectUser`, `revokeConnectToken` |
| Virtual accounts | `createVirtualCustomer`, `createUsAccount`, … |
| Webhooks | `PayChanguWebhooks.verify` |

## Example

A minimal demo lives in [`example/`](example/):

```bash
cd example
flutter run --dart-define=PAYCHANGU_SECRET_KEY=your_sandbox_secret
```

## Migration from 0.0.x

- Version **1.0.0** is breaking.
- `initiatePayment` returns `PaymentSessionResponse` instead of `Map`.
- MoMo payout fields: `mobile`, `mobileMoneyOperatorRefId`, `chargeId`.
- Prefer `initiateMobileMoneyPayout` over deprecated `initiateMobileMoneyTransfer`.

## Documentation

- [API reference](https://developer.paychangu.com/reference/introduction)
- [Standard checkout](https://developer.paychangu.com/docs/standard-checkout)
- [Webhooks](https://developer.paychangu.com/docs/webhooks)
- [Errors](https://developer.paychangu.com/docs/paychangu-errors)

## License

MIT
