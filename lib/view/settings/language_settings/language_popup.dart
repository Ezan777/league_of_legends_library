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

    return AlertDialog(
      title: const Text("Choose language"),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            context
                .read<LanguageBloc>()
                .add(ChangeLanguage(_chosenLanguage ?? widget.language));
            Navigator.pop(context);
          },
          child: const Text('Apply'),
        ),
      ],
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: AvailableLanguages.values.length,
          itemBuilder: (context, index) => RadioListTile<AvailableLanguages>(
            title: Text(AvailableLanguages.values[index].displayName()),
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
