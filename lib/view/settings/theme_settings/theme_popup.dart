import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:league_of_legends_library/bloc/settings/theme_bloc/theme_bloc.dart';
import 'package:league_of_legends_library/bloc/settings/theme_bloc/theme_event.dart';
import 'package:league_of_legends_library/bloc/settings/theme_bloc/theme_state.dart';

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
    return AlertDialog(
      title: const Text("Choose theme mode"),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            context
                .read<ThemeBloc>()
                .add(ChangeThemeMode(_chosenThemeMode ?? widget.themeMode));
            Navigator.pop(context);
          },
          child: const Text('Apply'),
        ),
      ],
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: AppThemeMode.values.length,
          itemBuilder: (context, index) => RadioListTile<AppThemeMode>(
            title: Text(AppThemeMode.values[index].displayName()),
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
