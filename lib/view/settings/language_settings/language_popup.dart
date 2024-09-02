import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:league_of_legends_library/bloc/settings/language_bloc/language_bloc.dart';
import 'package:league_of_legends_library/bloc/settings/language_bloc/language_event.dart';
import 'package:league_of_legends_library/view/settings/language_settings/available_languages.dart';

class LanguageRadioList extends StatefulWidget {
  final AvailableLanguages language;

  const LanguageRadioList({super.key, required this.language});

  @override
  State<LanguageRadioList> createState() => _LanguageRadioListState();
}

class _LanguageRadioListState extends State<LanguageRadioList> {
  AvailableLanguages? _chosenLanguage;

  @override
  Widget build(BuildContext context) {
    _chosenLanguage ??= widget.language;

    return AlertDialog.adaptive(
      title: const Text.rich(
          TextSpan(text: "Choose a language", locale: Locale('en'))),
      actions: [
        TextButton(
          onPressed: () {
            context
                .read<LanguageBloc>()
                .add(ChangeLanguage(_chosenLanguage ?? widget.language));
            Navigator.pop(context);
          },
          child: const Text.rich(TextSpan(text: "Apply", locale: Locale('en'))),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child:
              const Text.rich(TextSpan(text: "Cancel", locale: Locale('en'))),
        ),
      ],
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: AvailableLanguages.values.length,
          itemBuilder: (context, index) => RadioListTile<AvailableLanguages>(
            title: Text.rich(TextSpan(
                text: AvailableLanguages.values[index].displayName(),
                locale: Locale(
                    AvailableLanguages.values[index].getLanguageCode()))),
            value: AvailableLanguages.values[index],
            groupValue: _chosenLanguage,
            onChanged: (_) {
              setState(() {
                _chosenLanguage = AvailableLanguages.values[index];
              });
            },
          ),
        ),
      ),
    );
  }
}
