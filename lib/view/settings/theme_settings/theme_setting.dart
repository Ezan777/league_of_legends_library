import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:league_of_legends_library/bloc/settings/theme_bloc/theme_bloc.dart';
import 'package:league_of_legends_library/bloc/settings/theme_bloc/theme_state.dart';
import 'package:league_of_legends_library/view/settings/theme_settings/theme_popup.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ThemeSetting extends StatelessWidget {
  const ThemeSetting({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) => state is ThemeLoaded
          ? GestureDetector(
              onTap: () async {
                await showDialog(
                    context: context,
                    builder: (context) =>
                        ThemeModeRadioList(themeMode: state.themeMode));
              },
              child: Container(
                height: 65,
                decoration: BoxDecoration(
                  border: Border.symmetric(
                      horizontal: BorderSide(
                          color: Theme.of(context).colorScheme.onSurface,
                          width: 2)),
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
                          AppLocalizations.of(context)?.themeSettingLabel ??
                              "Theme mode",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Text(
                          state.themeMode.localizedDisplayName(context),
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
              ),
            )
          : const Padding(
              padding: EdgeInsets.all(15),
              child: CircularProgressIndicator(),
            ),
    );
  }
}
