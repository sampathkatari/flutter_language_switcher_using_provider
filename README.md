# Flutter State Management with Provider

## A Practical Guide to Building a Language Switcher

Learn how to add dynamic language switching (i18n) to your Flutter app using Provider—the right way to manage global state for multilingual apps.

---

## Why Localization Matters

As Flutter apps reach global users, supporting multiple languages becomes essential. Flutter's built-in localization (`intl`) is powerful, but managing the language change in real time, without restarting the app, requires state management. That's where Provider fits in perfectly.

---

## What We'll Build

A Language Switcher App where:
- The app supports English and Spanish (you can add more).
- Users can toggle the language at runtime.
- All UI text updates are made instantly using Provider.

---

## Getting Started

> **Note:** Make sure you have a Flutter app set up. If not, create one with `flutter create <your_app_name>`.

### Add Dependencies

```sh
flutter pub add flutter_localizations --sdk=flutter provider intl
```

We have added three dependencies:
- `provider`
- `intl`
- `flutter_localizations`

---

## Create Localization Files

Let's create the localization files for English and Spanish. These files should be placed in a folder named `I10n` adjacent to your `lib` directory.

**I10n/en.json**
```json
{
  "title": "Language Switcher",
  "message": "Hello! Welcome to our app."
}
```

**I10n/es.json**
```json
{
  "title": "Cambiador de idioma",
  "message": "¡Hola! Bienvenido a nuestra aplicación."
}
```

---

## Create a Localization Helper

Now we will create a Localization Helper to load our language files.

```dart
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;
  late Map<String, String> _localizedStrings;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  Future<bool> load() async {
    final jsonString = await rootBundle.loadString(
      'I10n/[${locale.languageCode}.json',
    );
    Map<String, dynamic> jsonMap = json.decode(jsonString);
    _localizedStrings = jsonMap.map((k, v) => MapEntry(k, v.toString()));
    return true;
  }

  String translate(String key) => _localizedStrings[key] ?? key;
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'es'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    final localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate old) => false;
}
```

---

## Create a Provider Class

Now that we have loaded the languages, we shall create a provider class:

```dart
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
```

---

## Wrap Your App with Provider

Update your `main.dart` to wrap your application with the Provider:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'language_provider.dart';
import 'app_localizations.dart';
import 'home_page.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => LanguageProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: languageProvider.locale,
      supportedLocales: const [Locale('en'), Locale('es')],
      localizationsDelegates: const [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const HomePage(),
    );
  }
}
```

---

## Build the UI to Toggle Language

Let's build the UI screen to toggle the language and verify if the provider is actually working the way it should:

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'language_provider.dart';
import 'app_localizations.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text(localizations.translate('title'))),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              localizations.translate('message'),
              style: const TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => languageProvider.setLocale(const Locale('en')),
                child: const Text('English'),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: () => languageProvider.setLocale(const Locale('es')),
                child: const Text('Español'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
```

---

## Run the App

Run the app now and you should be able to see the output like this:
<div style="display: flex; justify-content: space-between">
  <img src="https://cdn-images-1.medium.com/v2/resize:fit:1200/1*WkOK41z8QJP9xRiUOmtYPQ.png" width="49%" />
  <img src="https://cdn-images-1.medium.com/v2/resize:fit:1200/1*9o_LsbEfnTtbjQdi1NRA3A.png" width="49%" />
</div>


---

## How It Works

- The `LanguageProvider` holds the current `Locale`.
- The app watches this locale via Provider and updates the `MaterialApp.locale`.
- `AppLocalizations` loads the correct JSON file at runtime.
- The `HomePage` uses the `.translate()` method to show the correct language strings.

---

This is also available in Medium: [Flutter State Management with Provider](https://medium.com/@sampath.katari/flutter-state-management-with-provider-a-practical-guide-on-building-a-language-switcher-1bb2aabf32ba)