import 'dart:io';

import 'package:flutter/material.dart';
import 'package:league_of_legends_library/view/settings/theme_settings/theme_setting.dart';

enum Settings {
  theme,
  language,
}

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: ListView.separated(
            itemCount: Settings.values.length,
            separatorBuilder: (context, index) =>
                const Padding(padding: EdgeInsets.only(top: 15)),
            itemBuilder: ((context, index) => switch (Settings.values[index]) {
                  Settings.theme => const ThemeSetting(),
                  Settings.language => _buildLanguageSetting(context),
                })),
      ),
    );
  }

  Widget _buildLanguageSetting(BuildContext context) => Container(
        height: 65,
        decoration: BoxDecoration(
          border: Border.symmetric(
              horizontal: BorderSide(
                  color: Theme.of(context).colorScheme.onSurface, width: 2)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Language",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Text(
                  Platform.localeName,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            Icon(
              Icons.keyboard_arrow_right,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ],
        ),
      );
}
