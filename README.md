# Lab 5 – Mortgage Calculator with Provider and SharedPreferences (Flutter)

Lab 4's two-screen mortgage calculator, reprogrammed to use:

- **Provider** – a `MortgageProvider` (`ChangeNotifier`) holds the mortgage
  data. Both screens read it from the Provider instead of passing data through
  the navigator. Pressing DONE updates it, and the main screen rebuilds.
- **SharedPreferences** – the loan amount, years, and interest rate are saved
  when the user presses DONE. On the next launch they are loaded back, so both
  screens show the data from the last launch.

## Features (from Lab 4)

- **Main screen** shows Amount, Years, Interest Rate, Monthly Payment and Total
  Payment, plus a **Terms and Conditions** checkbox. Checking it opens an
  `AlertDialog` that asks the user to accept the terms.
- **MODIFY DATA** opens the second screen, which starts from the current data.
- **Modify screen** has radio buttons for the number of years (10 / 15 / 30), a
  text field for the amount, and a `ListView` of interest rates from 2% to 15%
  in 0.25% steps.
- **DONE** saves the new data and returns to the main screen, which
  recalculates the payments.

## Files

- `lib/mortgage.dart` – the `Mortgage` model class (Dart port of the lab's Mortgage class)
- `lib/mortgage_provider.dart` – Provider (`ChangeNotifier`) that shares the data and saves it with SharedPreferences
- `lib/main.dart` – app entry point; loads SharedPreferences and creates the Provider
- `lib/screens/main_screen.dart` – main screen (left)
- `lib/screens/modify_screen.dart` – modify screen (right)
- `test/widget_test.dart` – unit and widget tests

## Run

```sh
flutter pub get
flutter run
flutter test
```
