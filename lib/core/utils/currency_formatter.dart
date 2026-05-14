import 'package:intl/intl.dart';

/// Simple currency formatting for HRMS amounts.
abstract final class CurrencyFormatter {
  static String usd(num value) =>
      NumberFormat.currency(locale: 'en_US', symbol: r'$').format(value);
}
