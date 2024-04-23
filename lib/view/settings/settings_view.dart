import 'package:flutter/material.dart';
import 'package:league_of_legends_library/view/settings/language_settings/language_setting.dart';
import 'package:league_of_legends_library/view/settings/theme_settings/theme_setting.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum Settings {
  theme,
  language,
}

class SettingsView extends StatelessWidget {
  // TODO Add an ink effect when settings are tapped
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)?.settingsLabel ?? "Settings"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: ListView.separated(
            itemCount: Settings.values.length,
            separatorBuilder: (context, index) =>
                const Padding(padding: EdgeInsets.only(top: 15)),
            itemBuilder: ((context, index) => switch (Settings.values[index]) {
                  Settings.theme => const ThemeSetting(),
                  Settings.language => const LanguageSetting(),
                })),
      ),
    );
  }
}
