import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'mortgage.dart';

/// Shares one [Mortgage] between both screens (Provider) and saves the
/// user's inputs with SharedPreferences so they survive an app relaunch.
class MortgageProvider extends ChangeNotifier {
  static const String _amountKey = 'amount';
  static const String _yearsKey = 'years';
  static const String _rateKey = 'rate';

  MortgageProvider(this._prefs) {
    _load();
  }

  final SharedPreferences _prefs;
  final Mortgage _mortgage = Mortgage();

  Mortgage get mortgage => _mortgage;

  /// Restores the inputs saved in the last launch, if any.
  void _load() {
    final amount = _prefs.getDouble(_amountKey);
    final years = _prefs.getInt(_yearsKey);
    final rate = _prefs.getDouble(_rateKey);
    if (amount != null) _mortgage.amount = amount;
    if (years != null) _mortgage.years = years;
    if (rate != null) _mortgage.rate = rate;
  }

  /// Updates the mortgage, tells listening screens to rebuild, and saves
  /// the new inputs.
  Future<void> update({
    required double amount,
    required int years,
    required double rate,
  }) async {
    _mortgage
      ..amount = amount
      ..years = years
      ..rate = rate;
    notifyListeners();
    await _prefs.setDouble(_amountKey, _mortgage.amount);
    await _prefs.setInt(_yearsKey, _mortgage.years);
    await _prefs.setDouble(_rateKey, _mortgage.rate);
  }
}
