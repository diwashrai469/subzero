import 'package:intl/intl.dart';

class AmountFormatHelper {
  AmountFormatHelper._();

  /// Examples:
  /// 4000.00  -> 4,000
  /// 4000.50  -> 4,000.5
  /// 4000.55  -> 4,000.55
  /// 0.00     -> 0
  static String format(double amount) {
    if (!amount.isFinite) return '0';

    return NumberFormat('#,##0.##').format(amount);
  }

  /// Formats the amount together with its currency symbol.
  ///
  /// Example:
  /// formatCurrency(4000, 'AUD')    -> $4,000
  /// formatCurrency(4000.50, 'AUD') -> $4,000.5
  static String formatCurrency(
    double amount,
    String currency, {
    bool includeSpace = false,
  }) {
    final symbol = currencySymbol(currency);
    final formattedAmount = format(amount);
    final separator = includeSpace ? ' ' : '';

    return '$symbol$separator$formattedAmount';
  }

  static String currencySymbol(String currency) {
    switch (currency.trim().toUpperCase()) {
      case 'AUD':
      case 'USD':
      case 'CAD':
      case 'NZD':
      case 'SGD':
      case 'HKD':
        return r'$';

      case 'INR':
        return '₹';

      case 'NPR':
        return 'रू';

      case 'EUR':
        return '€';

      case 'GBP':
        return '£';

      case 'JPY':
      case 'CNY':
        return '¥';

      case 'KRW':
        return '₩';

      case 'PHP':
        return '₱';

      case 'THB':
        return '฿';

      case 'RUB':
        return '₽';

      case 'TRY':
        return '₺';

      case 'NGN':
        return '₦';

      case 'VND':
        return '₫';

      case 'BRL':
        return r'R$';

      default:
        // Supports values that are already currency symbols.
        return currency;
    }
  }
}
