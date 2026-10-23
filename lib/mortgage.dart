import 'dart:math';

/// Model: encapsulates a mortgage calculator (Dart port of the lab's
/// Mortgage class).
class Mortgage {
  double _amount = 100000.0;
  int _years = 30;
  double _rate = 0.035; // annual rate as a fraction (0.035 = 3.5%)

  Mortgage();

  double get amount => _amount;
  set amount(double newAmount) {
    if (newAmount >= 0) _amount = newAmount;
  }

  int get years => _years;
  set years(int newYears) {
    if (newYears >= 0) _years = newYears;
  }

  double get rate => _rate;
  set rate(double newRate) {
    if (newRate >= 0) _rate = newRate;
  }

  String get formattedAmount => formatMoney(_amount);

  /// Rate as a percent string, e.g. 0.035 -> "3.5%".
  String get formattedRate => '${_trimZeros(_rate * 100)}%';

  double monthlyPayment() {
    final n = _years * 12;
    if (n == 0) return 0;
    final mRate = _rate / 12; // monthly interest rate
    if (mRate == 0) return _amount / n;
    final temp = pow(1 / (1 + mRate), n);
    return _amount * mRate / (1 - temp);
  }

  String formattedMonthlyPayment() => formatMoney(monthlyPayment());

  double totalPayment() => monthlyPayment() * _years * 12;

  String formattedTotalPayment() => formatMoney(totalPayment());

  /// Formats a number like "$#,##0.00".
  static String formatMoney(double value) {
    final fixed = value.toStringAsFixed(2);
    final parts = fixed.split('.');
    final whole = parts[0];
    final buffer = StringBuffer();
    for (var i = 0; i < whole.length; i++) {
      if (i > 0 && (whole.length - i) % 3 == 0) buffer.write(',');
      buffer.write(whole[i]);
    }
    return '\$$buffer.${parts[1]}';
  }

  static String _trimZeros(double value) {
    var s = value.toStringAsFixed(2);
    s = s.replaceFirst(RegExp(r'0+$'), '');
    return s.replaceFirst(RegExp(r'\.$'), '');
  }
}
