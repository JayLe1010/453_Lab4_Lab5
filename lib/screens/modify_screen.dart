import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../mortgage_provider.dart';

/// Right screen: lets the user change years, amount, and interest rate.
class ModifyScreen extends StatefulWidget {
  const ModifyScreen({super.key});

  @override
  State<ModifyScreen> createState() => _ModifyScreenState();
}

class _ModifyScreenState extends State<ModifyScreen> {
  static const List<int> _yearOptions = [10, 15, 30];

  /// Interest rates from 2% to 15% in 0.25% steps.
  static final List<double> _rates = [
    for (var i = 0; i <= (15 - 2) * 4; i++) 2 + i * 0.25,
  ];

  late final TextEditingController _amountController;
  late int _years;
  late double _ratePercent;

  @override
  void initState() {
    super.initState();
    // Start from the shared data, which the Provider loaded from
    // SharedPreferences, so the last inputs are shown after a relaunch.
    final m = context.read<MortgageProvider>().mortgage;
    _amountController =
        TextEditingController(text: m.amount.toStringAsFixed(2));
    _years = _yearOptions.contains(m.years) ? m.years : 30;
    // Snap the stored rate to the nearest entry in the list.
    final percent = m.rate * 100;
    _ratePercent = _rates.reduce(
      (a, b) => (a - percent).abs() <= (b - percent).abs() ? a : b,
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  /// Done button: validate, update the shared data, and return to the left
  /// screen.
  void _done() {
    final amount = double.tryParse(_amountController.text.trim());
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount.')),
      );
      return;
    }
    // Update the shared data (main screen rebuilds) and save it.
    context.read<MortgageProvider>().update(
          amount: amount,
          years: _years,
          rate: _ratePercent / 100,
        );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('MortgageV0'),
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const SizedBox(
                  width: 110,
                  child: Text('Years', style: TextStyle(fontSize: 16)),
                ),
                Expanded(
                  child: RadioGroup<int>(
                    groupValue: _years,
                    onChanged: (value) {
                      if (value != null) setState(() => _years = value);
                    },
                    child: Wrap(
                      children: [
                        for (final y in _yearOptions)
                          InkWell(
                            onTap: () => setState(() => _years = y),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [Radio<int>(value: y), Text('$y')],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const SizedBox(
                  width: 110,
                  child: Text('Amount', style: TextStyle(fontSize: 16)),
                ),
                Expanded(
                  child: TextField(
                    controller: _amountController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Interest Rate: ${_formatPercent(_ratePercent)}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(color: scheme.outlineVariant),
                ),
                child: ListView.builder(
                  itemCount: _rates.length,
                  itemBuilder: (context, index) {
                    final rate = _rates[index];
                    return ListTile(
                      dense: true,
                      title: Text(_formatPercent(rate)),
                      selected: rate == _ratePercent,
                      selectedTileColor: scheme.primaryContainer,
                      trailing:
                          rate == _ratePercent ? const Icon(Icons.check) : null,
                      onTap: () => setState(() => _ratePercent = rate),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: _done,
                child: const Text('DONE'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _formatPercent(double value) =>
      '${value.toStringAsFixed(2)}%';
}
