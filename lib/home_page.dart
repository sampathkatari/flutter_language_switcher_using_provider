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
