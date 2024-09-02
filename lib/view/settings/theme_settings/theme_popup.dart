import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:league_of_legends_library/bloc/settings/theme_bloc/theme_bloc.dart';
import 'package:league_of_legends_library/bloc/settings/theme_bloc/theme_event.dart';
import 'package:league_of_legends_library/bloc/settings/theme_bloc/theme_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ThemeModeRadioList extends StatefulWidget {
  final AppThemeMode themeMode;

  const ThemeModeRadioList({super.key, required this.themeMode});

  @override
  State<ThemeModeRadioList> createState() => _ThemeModeRadioListState();
}

class _ThemeModeRadioListState extends State<ThemeModeRadioList> {
  AppThemeMode? _chosenThemeMode;

  @override
  Widget build(BuildContext context) {
    _chosenThemeMode ??= widget.themeMode;
    return AlertDialog.adaptive(
      title: Text(AppLocalizations.of(context)?.themeModePopupTitle ??
          "Choose theme mode"),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(AppLocalizations.of(context)?.cancel ?? 'Cancel'),
        ),
        TextButton(
          onPressed: () {
            context
                .read<ThemeBloc>()
                .add(ChangeThemeMode(_chosenThemeMode ?? widget.themeMode));
            Navigator.pop(context);
          },
          child: Text(AppLocalizations.of(context)?.apply ?? 'Apply'),
        ),
      ],
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: AppThemeMode.values.length,
          itemBuilder: (context, index) => RadioListTile<AppThemeMode>(
            title:
                Text(AppThemeMode.values[index].localizedDisplayName(context)),
            value: AppThemeMode.values[index],
            groupValue: _chosenThemeMode,
            onChanged: (_) {
              setState(() {
                _chosenThemeMode = AppThemeMode.values[index];
              });
            },
          ),
        ),
      ),
    );
  }
}
