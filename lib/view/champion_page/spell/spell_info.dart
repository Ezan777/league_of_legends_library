import 'package:flutter/material.dart';
import 'package:league_of_legends_library/core/model/passive.dart';
import 'package:league_of_legends_library/core/model/spell.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SpellInfo extends StatelessWidget {
  final Passive ability;
  final Function()? onSwipeRight, onSwipeLeft;
  double? startX;
  SpellInfo(
      {super.key, required this.ability, this.onSwipeRight, this.onSwipeLeft});

  @override
  Widget build(BuildContext context) {
    const double horizontalPadding = 30.0, verticalPadding = 22.0;

    return GestureDetector(
      onHorizontalDragStart: (details) {
        startX = details.localPosition.dx;
      },
      onHorizontalDragCancel: () {
        startX = null;
      },
      onHorizontalDragEnd: (details) {
        final startX = this.startX;
        if (startX != null) {
          double endX = details.localPosition.dx;
          int acceptableSwipeConstraint = 45;

          if (endX < startX &&
              onSwipeRight != null &&
              startX - endX >= acceptableSwipeConstraint) {
            onSwipeRight!();
          }

          if (endX > startX &&
              onSwipeLeft != null &&
              endX - startX >= acceptableSwipeConstraint) {
            onSwipeLeft!();
          }
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Spell name
          Padding(
            padding: const EdgeInsets.only(bottom: 2, left: 15),
            child: Text(
              ability.name,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold),
            ),
          ),
          // Spell cooldowns
          Padding(
            padding: const EdgeInsets.only(bottom: 13, left: 18),
            child: _buildCooldownLabel(context: context),
          ),
          // Spell description
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
              ability.description,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onTertiaryContainer,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget? _buildCooldownLabel({required BuildContext context}) {
    if (ability is Spell) {
      Spell spell = ability as Spell;
      return (spell.cooldowns != "")
          ? Text(
              AppLocalizations.of(context)?.cooldown(spell.cooldowns) ??
                  "Cooldown: ${spell.cooldowns}",
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Theme.of(context).colorScheme.primary),
            )
          : null;
    } else {
      return Text(
        AppLocalizations.of(context)?.passive ?? "Passive",
        style: Theme.of(context)
            .textTheme
            .bodySmall
            ?.copyWith(color: Theme.of(context).colorScheme.primary),
      );
    }
  }
}
