## 1.1.0

- Expanded README with usage examples for all supported APIs.
- Pub score readiness: metadata, MIT license recognition, minimal `example/`,
  public API docs, and analyzer cleanup (`Currency.MWK` / `USD` kept).

## 1.0.0

Breaking rewrite aligned with the current PayChangu API
([developer.paychangu.com](https://developer.paychangu.com)).

### Migration from 0.0.x

- `initiatePayment` now returns `PaymentSessionResponse` (not `Map`).
- MoMo payout request fields are `mobile`, `mobileMoneyOperatorRefId`, and
  `chargeId` (replacing `phoneNumber` / `provider` / `reference`).
- Prefer `initiateMobileMoneyPayout` / `getMobileMoneyPayoutDetails`; the old
  `initiateMobileMoneyTransfer` / `getTransferStatus` names remain as
  `@Deprecated` aliases.
- `Currency.MWK` / `Currency.USD` are unchanged; wire encoding uses `.apiValue`.

### Added

- Typed HTTP client with injectable `http.Client`, timeouts, and richer exceptions.
- Hosted checkout hardening: loading/error UI, failed return handling, optional auto-verify.
- Direct mobile money charge/verify/details and operators.
- Bank transfer collection; bank and MoMo payouts with current request models.
- Card charge / verify / refund and 3DS WebView helper.
- Wallet balance, bills/airtime, Connect, and US virtual account APIs.
- Webhook HMAC-SHA256 verification helper.
- Unit tests, CI workflow, and a minimal `example/` app.
- Pub.dev metadata fixes (homepage/repository, documented public API).

## 0.0.3

- Package bump on pub.dev.

## 0.0.2

- Package version bump (undocumented relative to 0.0.1).

## 0.0.1

- Initial hosted checkout + verify + early MoMo transfer helpers.
