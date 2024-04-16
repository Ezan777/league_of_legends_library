import 'package:flutter/material.dart';
import 'package:league_of_legends_library/core/model/spell.dart';

class SpellInfo extends StatelessWidget {
  final Spell spell;
  const SpellInfo({super.key, required this.spell});

  @override
  Widget build(BuildContext context) {
    const double horizontalPadding = 30.0, verticalPadding = 22.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 15, left: 15),
          child: Text(
            spell.name,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.tertiaryContainer,
              shape: BoxShape.rectangle,
              borderRadius: const BorderRadius.all(Radius.circular(20))),
          padding: const EdgeInsets.symmetric(
            vertical: verticalPadding,
            horizontal: horizontalPadding,
          ),
          child: Text(
            spell.description,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onTertiaryContainer,
                ),
          ),
        ),
      ],
    );
  }
}
