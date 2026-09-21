/// Exception thrown when a PayChangu API call fails.
class PayChanguException implements Exception {
  /// Human-readable error summary.
  final String message;

  /// Optional raw response body or extra context.
  final String? details;

  /// HTTP status code when the failure came from an HTTP response.
  final int? statusCode;

  /// Underlying error (timeout, socket, JSON, etc.).
  final Object? cause;

  /// Creates a PayChangu exception.
  PayChanguException(
    this.message, {
    this.details,
    this.statusCode,
    this.cause,
  });

  @override
  String toString() {
    final buffer = StringBuffer('PayChanguException: $message');
    if (statusCode != null) buffer.write(' (HTTP $statusCode)');
    if (details != null && details!.isNotEmpty) {
      buffer.write('\nDetails: $details');
    }
    if (cause != null) {
      buffer.write('\nCause: $cause');
    }
    return buffer.toString();
  }
}
