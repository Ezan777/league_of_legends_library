import 'package:flutter/material.dart';
import 'package:league_of_legends_library/core/model/spell.dart';
import 'package:league_of_legends_library/core/repository/champion_repository.dart';

class SpellButton extends StatelessWidget {
  final Spell spell;
  final ValueNotifier<Spell> chosenSpell;

  const SpellButton(
      {super.key, required this.spell, required this.chosenSpell});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 120),
      child:
          _buildButton(isChosen: chosenSpell.value == spell, context: context),
    );
  }

  Widget _buildButton({required bool isChosen, required BuildContext context}) {
    if (isChosen) {
      return Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: GestureDetector(
              onTap: () {
                chosenSpell.value = spell;
              },
              child: Image.network(
                ChampionRepository.getSpellTileUrl(spellId: spell.id),
                height: 64,
                width: 64,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: SizedBox(
              height: 10,
              width: 10,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.tertiary,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      return ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: GestureDetector(
          onTap: () {
            chosenSpell.value = spell;
          },
          child: Image.network(
            ChampionRepository.getSpellTileUrl(spellId: spell.id),
            height: 64,
            width: 64,
          ),
        ),
      );
    }
  }
}
