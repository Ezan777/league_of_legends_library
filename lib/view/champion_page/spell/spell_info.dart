import 'package:flutter/material.dart';
import 'package:league_of_legends_library/core/model/spell.dart';

class SpellInfo extends StatelessWidget {
  final Spell spell;
  const SpellInfo({super.key, required this.spell});

  @override
  Widget build(BuildContext context) {
    // TODO: Text is formatted following DataDragon rules need to reformat it with values
    const double horizontalPadding = 30.0, verticalPadding = 22.0;

    return Container(
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
    );
  }
}
