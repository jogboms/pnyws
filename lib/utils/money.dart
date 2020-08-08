import 'package:intl/intl.dart';

const String _symbol = "₦";

class Money {
  Money(this.money, {bool isLong = false})
      : _format = isLong
            ? NumberFormat.simpleCurrency(name: _symbol, decimalDigits: 2)
            : NumberFormat.compactSimpleCurrency(name: _symbol, decimalDigits: 2);

  num money;
  final NumberFormat _format;

  String get formatted {
    try {
      return _format.format(money ?? 0);
    } catch (e) {
      return "${_symbol}0.0";
    }
  }
}
