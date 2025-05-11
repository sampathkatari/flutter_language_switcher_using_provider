import 'package:flutter/material.dart';

class LanguageProvider with ChangeNotifier {
  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  void setLocale(Locale newLocale) {
    if (!['en', 'es'].contains(newLocale.languageCode)) return;
    _locale = newLocale;
    notifyListeners();
  }
}
