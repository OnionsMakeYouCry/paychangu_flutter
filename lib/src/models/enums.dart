/// Supported charge currencies.
///
/// ISO-style names (`MWK`, `USD`) match the PayChangu API wire format.
enum Currency {
  /// Malawian Kwacha.
  MWK,

  /// US Dollar.
  USD;

  /// API wire value (`MWK`, `USD`).
  String get apiValue => name;

  /// Parses an API currency string (`MWK`, `MK`, `USD`).
  static Currency fromApi(String? value) {
    switch (value?.toUpperCase()) {
      case 'USD':
        return Currency.USD;
      case 'MWK':
      case 'MK':
      default:
        return Currency.MWK;
    }
  }
}

/// Common payment status values returned across PayChangu APIs.
enum PaymentStatus {
  /// Payment has been created but not completed.
  pending,

  /// Payment completed successfully.
  success,

  /// Payment failed.
  failed,

  /// Payment was cancelled by the customer.
  cancelled,
}
