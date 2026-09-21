/// Shared JSON parsing helpers for resilient API models.
class JsonUtils {
  static String? asString(dynamic value) {
    if (value == null) return null;
    return value.toString();
  }

  static String asStringRequired(dynamic value, [String fallback = '']) {
    if (value == null) return fallback;
    return value.toString();
  }

  static int? asInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is double) return value.toInt();
    return int.tryParse(value.toString());
  }

  static int asIntRequired(dynamic value, [int fallback = 0]) {
    return asInt(value) ?? fallback;
  }

  static double? asDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return double.tryParse(value.toString());
  }

  static double asDoubleRequired(dynamic value, [double fallback = 0]) {
    return asDouble(value) ?? fallback;
  }

  static bool? asBool(dynamic value) {
    if (value == null) return null;
    if (value is bool) return value;
    final text = value.toString().toLowerCase();
    if (text == 'true' || text == '1') return true;
    if (text == 'false' || text == '0') return false;
    return null;
  }

  static Map<String, dynamic>? asMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return null;
  }

  static List<dynamic> asList(dynamic value) {
    if (value is List) return value;
    return const [];
  }
}
