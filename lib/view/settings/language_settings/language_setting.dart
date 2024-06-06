import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:league_of_legends_library/bloc/settings/language_bloc/language_bloc.dart';
import 'package:league_of_legends_library/bloc/settings/language_bloc/language_state.dart';
import 'package:league_of_legends_library/view/settings/language_settings/language_popup.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LanguageSetting extends StatelessWidget {
  const LanguageSetting({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageBloc, LanguageState>(
      builder: (context, state) => state is LanguageLoaded
          ? Semantics(
              button: true,
              tooltip:
                  AppLocalizations.of(context)?.changeLanguageSettingTooltip ??
                      "Change language",
              child: InkWell(
                onTap: () async {
                  await showDialog(
                    context: context,
                    builder: (context) =>
                        LanguageRadioList(language: state.language),
                  );
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
                          Text.rich(
                            const TextSpan(
                                text: "Language",
                                locale: Locale(
                                    'en')), // I will keep this string in English in order to avoid miss-understanding if someone set the wrong one.
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          Text(
                            state.language.displayName(),
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
              ),
            )
          : const Center(
              child: Padding(
                padding: EdgeInsets.all(30),
                child: CircularProgressIndicator(),
              ),
            ),
    );
  }
}
